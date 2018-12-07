transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Cpu3.v}
vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Cpu2.v}
vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Cpu1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Snooping.v}
vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Mesi.v}
vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/Parte_2/Snooping/Bus_arbiter.v}

