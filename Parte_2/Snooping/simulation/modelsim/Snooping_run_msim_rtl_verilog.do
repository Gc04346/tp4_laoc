transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping {C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping/Snooping.v}
vlog -vlog01compat -work work +incdir+C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping {C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping/Mesi.v}
vlog -vlog01compat -work work +incdir+C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping {C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping/CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping {C:/Users/Isaqu/Desktop/TP4_Laoc/Parte_2/Snooping/Bus_arbiter.v}

