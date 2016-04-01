# SonejoBeatRepeater
Beat Repeater with Sidechain Beat Recognation and Midi-Clock Sync.

Very useful i.e to add musical diversity by looping short parts of the stream (i.e drums).

--

__Features:__
* Repeat the last loop of the stream according to the beats.
* Beat recognition from Audio Sidechain Click track 
* Beat recognation from Midi-Clock
* BPM Slider to set the tempo manually
* Very simple Tap Tempo if needed (no average)
* Loop one or two bars
* Midi Controllable In/Out
* Loop divider Slider Control (to switch loop lenght during the loop)
* Loop x3 Mode for Triplets (with Midi LED Feedback)
* The REPEAT! checkbox is usable as Momentary or Toggle

Demo: https://youtu.be/C38gep4vkm8?t=6m17s


-- 

__Inputs/Outputs:__
* Audio Outputs (L,R)
* Audio Inputs (L,R, Sidechain)
* Midi Input: for Midi-Clock and External Controllers
* Midi Output : for External Controller LED Lightning 

--

__Midi Controls (on Midi Channel 1):__
* REPEAT! [midi : ctrl 111] - with Midi LED Feedback on ctrl 111
* Use BPM Slider instead of SC/MC sync [midi : ctrl 39]
* BPM Slider [midi : ctrl 23]
* Loop Divider Selector [midi : ctrl 29]
* Set Loop Divider Value x3 [midi : ctrl 110] - with Midi LED Feedback on ctrl 110

To change the Midi Controls simply edit the source file and recompile.

--

__Build/Install:__
* Use the Faust Online Compiler to compile it as Standalone or Audio Plugin (LV2, VST, etc): http://faust.grame.fr/compiler
* This software was tested only with Linux JackQT Faust Compiler.
* Or compile them simply with (you'll need to install the Faust Compiler): 
* $ faust2jaqt -midi SuperBeatRepeater.dsp
* $ faust2jaqt -midi SuperCutSequencer.dsp
* To Start:
* ./SuperBeatRepeater
* ./SuperCutSequencer

--

__Get Started with SuperBeatRepeater and SuperCutSequencer:__

* You'll need Jackd JackCtl.You will need to send Midi-Clock to SuperBeatRepeater & SuperCutSequencer. Use a Midi-Clock generator like jack_midi_clock (on Linux). You also need to set the Tempo to Jack Transport (whitch will be used by the Midi-Clock). Use any Jack-able Sequencer for that (Hydrogen, Ardour). If you want to use them with an Hardware Midi Controller you'll need to use the a2jmidid -e Bridge.

* $ qjackctl &
* Start the Jack Server
* $ jack_midi_clock &
* $ a2jmidid -e &
* Start SuperBeatRepeater & SuperCutSequencer from the build folder :
** $ ./SuperBeatRepeater
** $ ./SuperCutSequencer

* Launch the Sequencer (i.e Hydrogen) in Jack Transport Master mode

* Connect jack_midi_clock to SuperBeatRepeater & SuperCutSequencer (via Jack Midi). The song tempo of the Sequencer musst be displayed in QjackCtl.

* Connect the Audio outputs of the Sequencer (or whatever sound source) to SuperBeatRepeater and/or SuperCutSequencer. (For instance, The drums to SuperBeatRepeater and the bass to SuperCutSequencer.)

* Start Jack Transport (Play Button)

* If the «Midi-Clock » checkboxes in SuperBeatRepeater & SuperCutSequencer are blinking (recieving Midi-Clock signal) and the Start/Stop checkboxes are checkt automatically (by Midi-Clock Start/Stop messages), then everything should work fine.

* If you have a Midi Controller with LEDs (i.e LaunchControl XL, NanoKontrol,...), connect Midi Inputs and Outputs to SuperBeatRepeater & SuperCutSequencer (via Jack Midi / a2jmidid)

