onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /digital_dimmer_tb/clk
add wave -noupdate -format Logic /digital_dimmer_tb/reset
add wave -noupdate -format Logic /digital_dimmer_tb/wave_pol
add wave -noupdate -format Logic /digital_dimmer_tb/digital_dimmer_1/zero_detect_1/zero_detect
add wave -noupdate -format Logic /digital_dimmer_tb/ir
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/ir_decoder_1/code
add wave -noupdate -format Logic /digital_dimmer_tb/digital_dimmer_1/ir_decoder_1/code_strobe
add wave -noupdate -format Logic /digital_dimmer_tb/simulation_done
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/target_0
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/update_delay_0
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/target_1
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/update_delay_1
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/target_2
add wave -noupdate -format Literal /digital_dimmer_tb/digital_dimmer_1/controller_1/update_delay_2
add wave -noupdate -format Literal -expand /digital_dimmer_tb/triac
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {46164111 ns}
