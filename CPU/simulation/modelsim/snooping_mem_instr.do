onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Snooping/clock
add wave -noupdate /Snooping/clear
add wave -noupdate -radix unsigned /Snooping/inst
add wave -noupdate -radix unsigned /Snooping/instr_out
add wave -noupdate -radix unsigned /Snooping/passo
add wave -noupdate -radix unsigned /Snooping/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/Snooping/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/Snooping/clear 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10ps Edit:/Snooping/clear 
WaveCollapseAll -1
wave clipboard restore
