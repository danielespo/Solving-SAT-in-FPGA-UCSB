# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "NUM_CLAUSES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_CLAUSES_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_ROWS" -parent ${Page_0}


}

proc update_PARAM_VALUE.NUM_CLAUSES { PARAM_VALUE.NUM_CLAUSES } {
	# Procedure called to update NUM_CLAUSES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_CLAUSES { PARAM_VALUE.NUM_CLAUSES } {
	# Procedure called to validate NUM_CLAUSES
	return true
}

proc update_PARAM_VALUE.NUM_CLAUSES_BITS { PARAM_VALUE.NUM_CLAUSES_BITS } {
	# Procedure called to update NUM_CLAUSES_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_CLAUSES_BITS { PARAM_VALUE.NUM_CLAUSES_BITS } {
	# Procedure called to validate NUM_CLAUSES_BITS
	return true
}

proc update_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to update NUM_ROWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to validate NUM_ROWS
	return true
}


proc update_MODELPARAM_VALUE.NUM_CLAUSES { MODELPARAM_VALUE.NUM_CLAUSES PARAM_VALUE.NUM_CLAUSES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_CLAUSES}] ${MODELPARAM_VALUE.NUM_CLAUSES}
}

proc update_MODELPARAM_VALUE.NUM_ROWS { MODELPARAM_VALUE.NUM_ROWS PARAM_VALUE.NUM_ROWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_ROWS}] ${MODELPARAM_VALUE.NUM_ROWS}
}

proc update_MODELPARAM_VALUE.NUM_CLAUSES_BITS { MODELPARAM_VALUE.NUM_CLAUSES_BITS PARAM_VALUE.NUM_CLAUSES_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_CLAUSES_BITS}] ${MODELPARAM_VALUE.NUM_CLAUSES_BITS}
}

