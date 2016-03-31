# SonejoBeatRepeater
Beat Repeater with Sidechain Beat Recognation and Midi-Clock Sync.

Very useful i.e to add musical diversity by looping short parts of the stream (i.e drums).

--

Features:
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

--
Demo: https://youtu.be/C38gep4vkm8?t=6m17s

--

Use the Faust Online Compiler to compile it as Standalone or Audio Plugin (LV2, VST, etc): http://faust.grame.fr/compiler/

-- 

Inputs/Outputs:
* Audio Outputs (L,R)
* Audio Inputs (L,R, Sidechain)
* Midi Input: for Midi-Clock and External Controllers
* Midi Output : for External Controller LED Lightning 

--

Midi Controls (on Midi Channel 1):
* REPEAT! [midi : ctrl 111] - with Midi LED Feedback on ctrl 111
* Use BPM Slider instead of SC/MC sync [midi : ctrl 39]
* BPM Slider [midi : ctrl 23]
* Loop Divider Selector [midi : ctrl 29]
* Set Loop Divider Value x3 [midi : ctrl 110] - with Midi LED Feedback on ctrl 110

To change the Midi Controls simply edit the source file and recompile.
This software was tested only with Linux JackQT Faust Compiler.
