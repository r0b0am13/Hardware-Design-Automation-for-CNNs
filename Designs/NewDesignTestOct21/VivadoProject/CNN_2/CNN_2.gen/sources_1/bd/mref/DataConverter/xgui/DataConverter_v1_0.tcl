# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "INPUT_DATAWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INPUT_FRACTION_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUTPUT_DATAWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUTPUT_FRACTION_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.INPUT_DATAWIDTH { PARAM_VALUE.INPUT_DATAWIDTH } {
	# Procedure called to update INPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_DATAWIDTH { PARAM_VALUE.INPUT_DATAWIDTH } {
	# Procedure called to validate INPUT_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.INPUT_FRACTION_WIDTH { PARAM_VALUE.INPUT_FRACTION_WIDTH } {
	# Procedure called to update INPUT_FRACTION_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_FRACTION_WIDTH { PARAM_VALUE.INPUT_FRACTION_WIDTH } {
	# Procedure called to validate INPUT_FRACTION_WIDTH
	return true
}

proc update_PARAM_VALUE.OUTPUT_DATAWIDTH { PARAM_VALUE.OUTPUT_DATAWIDTH } {
	# Procedure called to update OUTPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_DATAWIDTH { PARAM_VALUE.OUTPUT_DATAWIDTH } {
	# Procedure called to validate OUTPUT_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.OUTPUT_FRACTION_WIDTH { PARAM_VALUE.OUTPUT_FRACTION_WIDTH } {
	# Procedure called to update OUTPUT_FRACTION_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_FRACTION_WIDTH { PARAM_VALUE.OUTPUT_FRACTION_WIDTH } {
	# Procedure called to validate OUTPUT_FRACTION_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.INPUT_DATAWIDTH { MODELPARAM_VALUE.INPUT_DATAWIDTH PARAM_VALUE.INPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_DATAWIDTH}] ${MODELPARAM_VALUE.INPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.INPUT_FRACTION_WIDTH { MODELPARAM_VALUE.INPUT_FRACTION_WIDTH PARAM_VALUE.INPUT_FRACTION_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_FRACTION_WIDTH}] ${MODELPARAM_VALUE.INPUT_FRACTION_WIDTH}
}

proc update_MODELPARAM_VALUE.OUTPUT_DATAWIDTH { MODELPARAM_VALUE.OUTPUT_DATAWIDTH PARAM_VALUE.OUTPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_DATAWIDTH}] ${MODELPARAM_VALUE.OUTPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.OUTPUT_FRACTION_WIDTH { MODELPARAM_VALUE.OUTPUT_FRACTION_WIDTH PARAM_VALUE.OUTPUT_FRACTION_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_FRACTION_WIDTH}] ${MODELPARAM_VALUE.OUTPUT_FRACTION_WIDTH}
}

