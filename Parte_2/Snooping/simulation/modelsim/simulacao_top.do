onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Snooping
add wave -noupdate /Snooping/clear
add wave -noupdate /Snooping/clock
add wave -noupdate /Snooping/instrucao
add wave -noupdate /Snooping/passo
add wave -noupdate /Snooping/inst
add wave -noupdate /Snooping/pc
add wave -noupdate /Snooping/shared
add wave -noupdate -divider BUS
add wave -noupdate /Snooping/bus
add wave -noupdate /Snooping/hab_bus
add wave -noupdate -divider ControleCPU
add wave -noupdate /Snooping/controleP1
add wave -noupdate /Snooping/controleP2
add wave -noupdate /Snooping/controleP3
add wave -noupdate /Snooping/hab_cpu1
add wave -noupdate /Snooping/hab_cpu2
add wave -noupdate /Snooping/hab_cpu3
add wave -noupdate -divider Cpu1
add wave -noupdate /Snooping/cpu1/habilita
add wave -noupdate /Snooping/cpu1/bus_in
add wave -noupdate -expand /Snooping/cpu1/cache
add wave -noupdate /Snooping/cpu1/acao
add wave -noupdate /Snooping/cpu1/controleP
add wave -noupdate /Snooping/cpu1/passo
add wave -noupdate /Snooping/cpu1/shared_in
add wave -noupdate /Snooping/cpu1/shared_out
add wave -noupdate /Snooping/cpu1/pos
add wave -noupdate /Snooping/cpu1/bus_out
add wave -noupdate /Snooping/cpu1/m_e/est_fut
add wave -noupdate /Snooping/cpu1/m_e/Bus_out
add wave -noupdate /Snooping/cpu1/out
add wave -noupdate -divider Cpu2
add wave -noupdate /Snooping/cpu2/habilita
add wave -noupdate /Snooping/cpu2/bus_in
add wave -noupdate /Snooping/cpu2/cache
add wave -noupdate /Snooping/cpu2/acao
add wave -noupdate /Snooping/cpu2/controleP
add wave -noupdate /Snooping/cpu2/passo
add wave -noupdate /Snooping/cpu2/shared_in
add wave -noupdate /Snooping/cpu2/shared_out
add wave -noupdate /Snooping/cpu2/pos
add wave -noupdate /Snooping/cpu2/bus_out
add wave -noupdate /Snooping/cpu2/m_e/est_at
add wave -noupdate /Snooping/cpu2/m_e/est_fut
add wave -noupdate -divider Cpu3
add wave -noupdate /Snooping/cpu3/habilita
add wave -noupdate /Snooping/cpu3/bus_in
add wave -noupdate /Snooping/cpu3/cache
add wave -noupdate /Snooping/cpu3/acao
add wave -noupdate /Snooping/cpu3/controleP
add wave -noupdate /Snooping/cpu3/passo
add wave -noupdate /Snooping/cpu3/shared_in
add wave -noupdate /Snooping/cpu3/shared_out
add wave -noupdate /Snooping/cpu3/pos
add wave -noupdate /Snooping/cpu3/bus_out
add wave -noupdate /Snooping/cpu3/m_e/est_at
add wave -noupdate /Snooping/cpu3/m_e/est_fut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {775 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
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
WaveRestoreZoom {88 ps} {1074 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/CPU/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/CPU/clear 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/CPU/controleP 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/CPU/habilita 
wave create -driver freeze -pattern constant -value 00000000 -range 7 0 -starttime 0ps -endtime 1000ps sim:/CPU/instr 
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/Snooping/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/Snooping/clear 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10ps Edit:/Snooping/clear 
WaveCollapseAll -1
wave clipboard restore
