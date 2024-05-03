# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BUFFER_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIRST_LEVEL_PARALLEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_CLAUSES_PER_VARIABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TREE_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TREE_LEAVES" -parent ${Page_0}


}

proc update_PARAM_VALUE.BUFFER_SIZE { PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to update BUFFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_SIZE { PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to validate BUFFER_SIZE
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FIRST_LEVEL_PARALLEL { PARAM_VALUE.FIRST_LEVEL_PARALLEL } {
	# Procedure called to update FIRST_LEVEL_PARALLEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIRST_LEVEL_PARALLEL { PARAM_VALUE.FIRST_LEVEL_PARALLEL } {
	# Procedure called to validate FIRST_LEVEL_PARALLEL
	return true
}

proc update_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to update MAX_CLAUSES_PER_VARIABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to validate MAX_CLAUSES_PER_VARIABLE
	return true
}

proc update_PARAM_VALUE.TREE_DEPTH { PARAM_VALUE.TREE_DEPTH } {
	# Procedure called to update TREE_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TREE_DEPTH { PARAM_VALUE.TREE_DEPTH } {
	# Procedure called to validate TREE_DEPTH
	return true
}

proc update_PARAM_VALUE.TREE_LEAVES { PARAM_VALUE.TREE_LEAVES } {
	# Procedure called to update TREE_LEAVES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TREE_LEAVES { PARAM_VALUE.TREE_LEAVES } {
	# Procedure called to validate TREE_LEAVES
	return true
}


proc update_MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE { MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}] ${MODELPARAM_VALUE.MAX_CLAUSES_PER_VARIABLE}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.BUFFER_SIZE { MODELPARAM_VALUE.BUFFER_SIZE PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_SIZE}] ${MODELPARAM_VALUE.BUFFER_SIZE}
}

proc update_MODELPARAM_VALUE.FIRST_LEVEL_PARALLEL { MODELPARAM_VALUE.FIRST_LEVEL_PARALLEL PARAM_VALUE.FIRST_LEVEL_PARALLEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIRST_LEVEL_PARALLEL}] ${MODELPARAM_VALUE.FIRST_LEVEL_PARALLEL}
}

proc update_MODELPARAM_VALUE.TREE_LEAVES { MODELPARAM_VALUE.TREE_LEAVES PARAM_VALUE.TREE_LEAVES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TREE_LEAVES}] ${MODELPARAM_VALUE.TREE_LEAVES}
}

proc update_MODELPARAM_VALUE.TREE_DEPTH { MODELPARAM_VALUE.TREE_DEPTH PARAM_VALUE.TREE_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TREE_DEPTH}] ${MODELPARAM_VALUE.TREE_DEPTH}
}

