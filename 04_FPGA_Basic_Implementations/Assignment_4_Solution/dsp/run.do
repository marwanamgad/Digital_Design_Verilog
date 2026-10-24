vlib work
vlog dsp.v dsp_tb.v
vsim -voptargs=+acc work.dsp_tb
add wave *
run -all 