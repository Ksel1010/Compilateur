set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports CLK]
create_clock -period 10.000 -name sysclk_pin -waveform {0.000 5.000} -add [get_ports CLK]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports RST]


set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[0]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[1]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[2]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[3]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[4]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[5]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[6]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {OUTPUT[7]}]

#set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets {pipeline/mem_instr/internal_clock}]

set_property ALLOW_COMBINATORIAL_LOOPS true [get_nets internal_clock]
