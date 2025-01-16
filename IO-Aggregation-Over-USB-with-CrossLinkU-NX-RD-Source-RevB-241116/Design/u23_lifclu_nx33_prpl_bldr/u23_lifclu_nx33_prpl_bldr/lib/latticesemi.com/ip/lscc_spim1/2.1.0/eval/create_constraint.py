import os

def load_parameter(param_name):
    f_params = open('eval/dut_params.v', 'r')
    while f_params:
        line = f_params.readline()
        if (param_name in line):
            str_spl = line.split('=')
            param = str_spl[-1]
            val = str_spl[1]
            f_val = val.replace(";\n",'')
            f_val2 = f_val.replace("\"",'')
            f_val3 = f_val2.replace(" ",'')
            break
    f_params.close()
    return (f_val3)

f_pdc = open('eval/constraint.pdc', 'w')

clk_freq        = load_parameter("SYS_CLOCK_FREQ")

f_pdc.write("##================================================================================##\n")
f_pdc.write("## Copy these constraints to your top-level pdc and replace path with actual path \n")
f_pdc.write("##================================================================================##\n")

f_pdc.write("\n")
f_pdc.write("set CLK_PERIOD %0.1f\n" % (1000.0/float(clk_freq)))
f_pdc.write("create_clock -name {clk_i} -period $CLK_PERIOD [get_ports clk_i]\n")

f_pdc.close()
