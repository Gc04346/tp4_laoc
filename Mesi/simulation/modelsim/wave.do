onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider entradas
add wave -noupdate /Mesi/Reset
add wave -noupdate /Mesi/clock
add wave -noupdate /Mesi/Bus_in
add wave -noupdate /Mesi/CPU
add wave -noupdate -divider saidas
add wave -noupdate /Mesi/Bus_out
add wave -noupdate /Mesi/Mem_out
add wave -noupdate /Mesi/estado_atual
add wave -noupdate /Mesi/maquina_estados
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 138
configure wave -valuecolwidth 38
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
WaveRestoreZoom {0 ps} {1134 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/Mesi/Reset 
wave modify -driver freeze -pattern constant -value 1 -starttime 10ps -endtime 1000ps Edit:/Mesi/Reset 
wave modify -driver freeze -pattern constant -value 0 -starttime 10ps -endtime 1000ps Edit:/Mesi/Reset 
wave modify -driver freeze -pattern constant -value 1 -starttime 10ps -endtime 1000ps Edit:/Mesi/Reset 
wave modify -driver freeze -pattern constant -value 0 -starttime 10ps -endtime 1000ps Edit:/Mesi/Reset 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/Mesi/clock 
wave create -driver freeze -pattern counter -startvalue 00 -endvalue 11 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 1 0 -starttime 0ps -endtime 1000ps sim:/Mesi/Bus_in 
WaveExpandAll -1
wave create -driver freeze -pattern counter -startvalue 0000 -endvalue 1111 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 3 0 -starttime 0ps -endtime 1000ps sim:/Mesi/CPU 
WaveExpandAll -1
WaveCollapseAll -1
wave clipboard restore
