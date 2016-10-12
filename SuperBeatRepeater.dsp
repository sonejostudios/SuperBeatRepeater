declare name        "SuperBeatRepeater";
declare version     "1.0";
declare author      "Vincent Rateau";
declare license     "GPL v3";
declare reference   "www.sonejo.net";
declare description	"Beat Repeater with Sidechain Beat Recognation and Midi-Clock Sync.";


import("analyzer.lib");
import("basic.lib");
import("signal.lib");
import("math.lib");
import("delay.lib");


//  Beat Repeater with Sidechain Beat Recognation and Midi-Clock Sync.


process = beatrepeaterstereo;


//BEAT REPEATER
////////////////////////////

beatrepeaterstereo(l,r,s) = (l, s : beatrepeater), (r, s : beatrepeater);

//beat repeater mono
beatrepeater = streamin, _ : loop
with{

	//beat repeater
	streamin = _ : *(1-but : result);
	loop(a,b) = a : + ~ ((_, b) : delaytime)*(but : result2);

	//gui
	but = checkbox("[09]REPEAT![midi : ctrl 111]") : 1-_ :vbargraph("[style: led][midi : ctrl 111]",0,1) : 1-_ : smooth(0.999);
	result = _ ; //vbargraph("stream", 0, 1);
	result2 = _; //vbargraph("loop", 0, 1);

	//maximum delay
	//maxdelay = 131072; //power of 2 (2^17) allows up to 2s delay at 44100
	maxdelay = 262144; ////power of 2 (2^18) allows up to 5s delay at 44100
	//maxdelay = 524288; ////power of 2 (2^19)

	//delaytime
	delaytime =delay(maxdelay,delaylength);
	delaylength = select2(SLBR, beatrecognizer, delayslider): _* 4 * amountofbars: _ * 1/(presetswitch) ;
	// select between beat recognizer and bpm slier, then *4 to get the whole 4 beats as loop, then multiply by the amount of bars 		wanted in loop

	// checkbox choice slider / beat recognizer
	SLBR = checkbox("[06]Use BPM Slider instead of SC/MC sync[midi : ctrl 39]");

	// BPM Slider
	delayslider = (60/(hslider("[07]BPM Slider[midi : ctrl 23]", 120, 30, 240, 1))) * SR : int  ;

	// Amount of Bars in Loop
	amountofbars = (nentry("[08]Amount of Bars in Loop", 1, 1, 2, 1)); //set the amount of bars

};



//BEAT RECOGNIZER
/////////////////////////
beatrecognizer = hgroup("[01]", vgroup("Sidechain (SC)", _*mute <: tap, _) :> signal :> _ <: (select2(SCMIDI, midiclock2beat, sampleholder ) : bpmgui : bpm2samples <:_), gui : attach)
with{

	//simple sidechain mute
	mute =1-checkbox("[04]Mute SC Input");

	//simple tap
	tap = button("[05]TAP into SC");

	//create 1 sample pulse for each input beat
	signal = amp_follower(0.01) : _ > 0.001 <: (_ > _@1) ; // 1 sample pulse based on the amp follower values

	// show "pulses" using amp follower (only for the gui)
	gui = amp_follower(0.5) : vbargraph("[1]SC Beat", 0, 1);

	//count samples between pulses (triggered by the 1 sample pulse)
	samplescounter = countup(88200,_) ; //: vbargraph("[2]samplescounter", 0, 88200);

	// if samplescounter == 0 then trigger SH on max number of samples (samplescounter@1), and add the 1 missing sample
	sampleholder = _ <: samplescounter == 0, samplescounter@1 : SH :_ +1 : s2bpm ; //: vbargraph("[3]sampleholder", 0, 88200);

	// selector between sidechain and midi clock
	SCMIDI = checkbox("Use MC / SC");

	//bargraph to show bpm value from sidechain or midi clock
	bpmgui = vbargraph("[4]BPM", 0, 240);

	//bpm 2 sample amount in one beat
	bpm2samples = _ / 60 : SR/_ ; //: vbargraph("samples after bpm", 0, 88200);

};



//GLOBAL FUNCTIONS
////////////////////////////////////

//Sample and Hold function
SH(trig,x) = (*(1 - trig) + x * trig) ~_;

//convert sampleholder to bpm
s2bpm = SR/_ : _*60 : int ;// : vbargraph("[4]bpm", 0, 240);





//MIDICLOCK to BEAT (AMOUNT OF SAMPLES IN 1 BEAT) to BPM
//////////////////////////////////
midiclock2beat = vgroup("MIDI Clock (MC)",((clocker, play)) : attach  : midi2count : s2bpm)
with{

	clocker   = checkbox("[3]Clock Signal[midi:clock]") ;  // create a square signal (1/0), changing state at each received clock
	play      = checkbox("[2]Start/Stop Signal[midi:start] [midi:stop]") ; // just to show start stop signal

	midi2count = _ <: _ != _@1 : countup(88200,_) : result1 <: _==0,_@1 : SH : result2 : _* 24;

	result1 = _ ; // : vbargraph("samplecount midi", 0, 88200);
	result2 = _ ; //: vbargraph("sampleholder midi", 0, 88200);


};


//BAR DIVIDER PRESET SELECTOR
///////////////////////////////////

presetswitch = p1, p2, p3, p4 :> _ * multis : resultp
with{
	//gui
	sliderp = hslider("[10]Loop Divider Selector[midi : ctrl 29]", 0, 0, 4, 0.1);
	resultp = vbargraph("[12]Loop Divider Value", 0, 32);

	//conditions
	p1 =  (sliderp >= 0) * (sliderp < 1)* 1 ;
	p2 =  (sliderp >= 1) * (sliderp < 2)* 2;
	p3 =  (sliderp >= 2) * (sliderp < 3)* 4;
	p4 =  (sliderp >= 3) * (sliderp <= 4)* 8;

	//bar divider multiplicator
	multi1 = 1-multigui * 1;
	multi3 = multigui * 3 ;
	multigui = checkbox("[1]Set Loop Divider Value x3[midi : ctrl 110]") : vbargraph("[style: led][midi : ctrl 110]", 0, 1);
	multis = multi1, multi3 :> _;
};
