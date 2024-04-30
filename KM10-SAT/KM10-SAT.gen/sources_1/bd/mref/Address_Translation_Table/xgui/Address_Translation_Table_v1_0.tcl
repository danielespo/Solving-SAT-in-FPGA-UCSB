# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AT_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LITERAL_ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_CLAUSES_PER_VARIABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Nv" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NvLog2" -parent ${Page_0}


}

proc update_PARAM_VALUE.AT_SIZE { PARAM_VALUE.AT_SIZE } {
	# Procedure called to update AT_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AT_SIZE { PARAM_VALUE.AT_SIZE } {
	# Procedure called to validate AT_SIZE
	return true
}

proc update_PARAM_VALUE.LITERAL_ADDRESS_WIDTH { PARAM_VALUE.LITERAL_ADDRESS_WIDTH } {
	# Procedure called to update LITERAL_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LITERAL_ADDRESS_WIDTH { PARAM_VALUE.LITERAL_ADDRESS_WIDTH } {
	# Procedure called to validate LITERAL_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to update MAX_CLAUSES_PER_VARIABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to validate MAX_CLAUSES_PER_VARIABLE
	return true
}

proc update_PARAM_VALUE.Nv { PARAM_VALUE.Nv } {
	# Procedure called to update Nv when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Nv { PARAM_VALUE.Nv } {
	# Procedure called to validate Nv
	return true
}

proc update_PARAM_VALUE.NvLog2 { PARAM_VALUE.NvLog2 } {
	# Procedure called to update NvLog2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NvLog2 { PARAM_VALUE.NvLog2 } {
	# Procedure called to validate NvLog2
	return true
}


proc update_MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}] ${MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}
}

proc update_MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH { MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH PARAM_VALUE.LITERAL_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LITERAL_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.Nv { MODELPARAM_VALUE.Nv PARAM_VALUE.Nv } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Nv}] ${MODELPARAM_VALUE.Nv}
}

proc update_MODELPARAM_VALUE.NvLog2 { MODELPARAM_VALUE.NvLog2 PARAM_VALUE.NvLog2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NvLog2}] ${MODELPARAM_VALUE.NvLog2}
}

proc update_MODELPARAM_VALUE.AT_SIZE { MODELPARAM_VALUE.AT_SIZE PARAM_VALUE.AT_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AT_SIZE}] ${MODELPARAM_VALUE.AT_SIZE}
}

