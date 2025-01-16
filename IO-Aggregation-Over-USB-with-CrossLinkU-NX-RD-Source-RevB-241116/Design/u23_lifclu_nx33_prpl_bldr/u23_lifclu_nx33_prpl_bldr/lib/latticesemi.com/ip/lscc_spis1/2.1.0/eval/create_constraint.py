import os

f_pdc = open('eval/constraint.pdc', 'w')

f_pdc.write("##================================================================================##\n")
f_pdc.write("## Copy these constraints to your top-level pdc and replace path with actual path \n")
f_pdc.write("##================================================================================##\n")

f_pdc.write("\n")
f_pdc.write("set CLK_PERIOD 20\n")
f_pdc.write("create_clock -name {clk_i} -period $CLK_PERIOD [get_ports clk_i]\n")

f_pdc.close()
