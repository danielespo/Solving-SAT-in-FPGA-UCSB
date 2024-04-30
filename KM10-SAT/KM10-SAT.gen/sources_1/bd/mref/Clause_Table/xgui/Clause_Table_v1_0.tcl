# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "LITERAL_ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_CLAUSES_PER_VARIABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NSAT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_ROWS" -parent ${Page_0}


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

proc update_PARAM_VALUE.NSAT { PARAM_VALUE.NSAT } {
	# Procedure called to update NSAT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NSAT { PARAM_VALUE.NSAT } {
	# Procedure called to validate NSAT
	return true
}

proc update_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to update NUM_ROWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to validate NUM_ROWS
	return true
}


proc update_MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}] ${MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}
}

proc update_MODELPARAM_VALUE.NUM_ROWS { MODELPARAM_VALUE.NUM_ROWS PARAM_VALUE.NUM_ROWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_ROWS}] ${MODELPARAM_VALUE.NUM_ROWS}
}

proc update_MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH { MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH PARAM_VALUE.LITERAL_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LITERAL_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.LITERAL_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.NSAT { MODELPARAM_VALUE.NSAT PARAM_VALUE.NSAT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NSAT}] ${MODELPARAM_VALUE.NSAT}
}

