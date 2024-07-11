
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/Module_Validation_Platform_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI Interface Settings}]
  set_property tooltip {AXI Interface Settings} ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}

  #Adding Page
  set IO_Byte_Address_Widths [ipgui::add_page $IPINST -name "IO Byte Address Widths"]
  ipgui::add_param $IPINST -name "READ_BUFFER_ADDR_WIDTH" -parent ${IO_Byte_Address_Widths}
  ipgui::add_param $IPINST -name "WRITE_BUFFER_ADDR_WIDTH" -parent ${IO_Byte_Address_Widths}

  #Adding Page
  set BRAM_Port_Settings [ipgui::add_page $IPINST -name "BRAM Port Settings"]
  ipgui::add_param $IPINST -name "BRAM_CTRL_ROUTE" -parent ${BRAM_Port_Settings}
  ipgui::add_param $IPINST -name "BRAM_ADDR_WIDTH" -parent ${BRAM_Port_Settings}


}

proc update_PARAM_VALUE.BRAM_ADDR_WIDTH { PARAM_VALUE.BRAM_ADDR_WIDTH PARAM_VALUE.BRAM_CTRL_ROUTE } {
	# Procedure called to update BRAM_ADDR_WIDTH when any of the dependent parameters in the arguments change
	
	set BRAM_ADDR_WIDTH ${PARAM_VALUE.BRAM_ADDR_WIDTH}
	set BRAM_CTRL_ROUTE ${PARAM_VALUE.BRAM_CTRL_ROUTE}
	set values(BRAM_CTRL_ROUTE) [get_property value $BRAM_CTRL_ROUTE]
	if { [gen_USERPARAMETER_BRAM_ADDR_WIDTH_ENABLEMENT $values(BRAM_CTRL_ROUTE)] } {
		set_property enabled true $BRAM_ADDR_WIDTH
	} else {
		set_property enabled false $BRAM_ADDR_WIDTH
	}
}

proc validate_PARAM_VALUE.BRAM_ADDR_WIDTH { PARAM_VALUE.BRAM_ADDR_WIDTH } {
	# Procedure called to validate BRAM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.BRAM_CTRL_ROUTE { PARAM_VALUE.BRAM_CTRL_ROUTE } {
	# Procedure called to update BRAM_CTRL_ROUTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_CTRL_ROUTE { PARAM_VALUE.BRAM_CTRL_ROUTE } {
	# Procedure called to validate BRAM_CTRL_ROUTE
	return true
}

proc update_PARAM_VALUE.READ_BUFFER_ADDR_WIDTH { PARAM_VALUE.READ_BUFFER_ADDR_WIDTH } {
	# Procedure called to update READ_BUFFER_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_BUFFER_ADDR_WIDTH { PARAM_VALUE.READ_BUFFER_ADDR_WIDTH } {
	# Procedure called to validate READ_BUFFER_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH { PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH } {
	# Procedure called to update WRITE_BUFFER_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH { PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH } {
	# Procedure called to validate WRITE_BUFFER_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.READ_BUFFER_ADDR_WIDTH { MODELPARAM_VALUE.READ_BUFFER_ADDR_WIDTH PARAM_VALUE.READ_BUFFER_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_BUFFER_ADDR_WIDTH}] ${MODELPARAM_VALUE.READ_BUFFER_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH { MODELPARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH}] ${MODELPARAM_VALUE.WRITE_BUFFER_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.BRAM_CTRL_ROUTE { MODELPARAM_VALUE.BRAM_CTRL_ROUTE PARAM_VALUE.BRAM_CTRL_ROUTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_CTRL_ROUTE}] ${MODELPARAM_VALUE.BRAM_CTRL_ROUTE}
}

proc update_MODELPARAM_VALUE.BRAM_ADDR_WIDTH { MODELPARAM_VALUE.BRAM_ADDR_WIDTH PARAM_VALUE.BRAM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_ADDR_WIDTH}] ${MODELPARAM_VALUE.BRAM_ADDR_WIDTH}
}

