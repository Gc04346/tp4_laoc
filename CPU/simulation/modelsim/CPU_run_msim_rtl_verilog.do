transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/CPU {C:/Users/Daniel.BATCOMPUTER/Desktop/Pratica4_DanielSantana_IsaqueFernando/CPU/CPU.v}

