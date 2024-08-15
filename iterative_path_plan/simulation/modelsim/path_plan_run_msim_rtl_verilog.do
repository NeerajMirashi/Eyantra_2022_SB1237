transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/github/iterative_path_plan {E:/github/iterative_path_plan/path_plan.v}

vlog -vlog01compat -work work +incdir+E:/github/iterative_path_plan/simulation/modelsim {E:/github/iterative_path_plan/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 10000 ns
