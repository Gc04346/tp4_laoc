onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {In Cpu}
add wave -noupdate /CPU/clock
add wave -noupdate /CPU/clear
add wave -noupdate /CPU/controleP
add wave -noupdate /CPU/habilita
add wave -noupdate /CPU/instr
add wave -noupdate -divider Out_cpu
add wave -noupdate /CPU/bus_out
add wave -noupdate /CPU/shared_out
add wave -noupdate /CPU/out
add wave -noupdate /CPU/cache
add wave -noupdate /CPU/passo
add wave -noupdate /CPU/pos
add wave -noupdate /CPU/acao
add wave -noupdate -divider Maq_Est
add wave -noupdate /CPU/Bus_out
add wave -noupdate /CPU/Mem_out
add wave -noupdate /CPU/est_fut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/CPU/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/CPU/clear 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10ps Edit:/CPU/clear 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/CPU/controleP 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/CPU/habilita 
wave create -driver freeze -pattern constant -value 00000000 -range 7 0 -starttime 0ps -endtime 1000ps sim:/CPU/instr 
WaveExpandAll -1
WaveCollapseAll -1
wave clipboard restore
