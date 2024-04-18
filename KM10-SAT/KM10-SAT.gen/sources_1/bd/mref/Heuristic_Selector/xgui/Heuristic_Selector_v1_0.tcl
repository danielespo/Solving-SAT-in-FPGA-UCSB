# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAX_CLAUSES_PER_VARIABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_CLAUSES_PER_VARIABLE_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NSAT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NSAT_BITS" -parent ${Page_0}


}

proc update_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to update MAX_CLAUSES_PER_VARIABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to validate MAX_CLAUSES_PER_VARIABLE
	return true
}

proc update_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS } {
	# Procedure called to update MAX_CLAUSES_PER_VARIABLE_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS } {
	# Procedure called to validate MAX_CLAUSES_PER_VARIABLE_BITS
	return true
}

proc update_PARAM_VALUE.NSAT { PARAM_VALUE.NSAT } {
	# Procedure called to update NSAT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NSAT { PARAM_VALUE.NSAT } {
	# Procedure called to validate NSAT
	return true
}

proc update_PARAM_VALUE.NSAT_BITS { PARAM_VALUE.NSAT_BITS } {
	# Procedure called to update NSAT_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NSAT_BITS { PARAM_VALUE.NSAT_BITS } {
	# Procedure called to validate NSAT_BITS
	return true
}


proc update_MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}] ${MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}
}

proc update_MODELPARAM_VALUE.NSAT { MODELPARAM_VALUE.NSAT PARAM_VALUE.NSAT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NSAT}] ${MODELPARAM_VALUE.NSAT}
}

proc update_MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS { MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS}] ${MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE_BITS}
}

proc update_MODELPARAM_VALUE.NSAT_BITS { MODELPARAM_VALUE.NSAT_BITS PARAM_VALUE.NSAT_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NSAT_BITS}] ${MODELPARAM_VALUE.NSAT_BITS}
}

