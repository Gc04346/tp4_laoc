view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/mem_instr/clear 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10ps Edit:/mem_instr/clear 
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/mem_instr/clock 
wave create -driver freeze -pattern counter -startvalue 00000 -endvalue 11111 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 1000ps sim:/mem_instr/pc 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -range 9 0 -starttime 0ps -endtime 1000ps sim:/mem_instr/dado 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/mem_instr/hab_escr 
WaveCollapseAll -1
wave clipboard restore
