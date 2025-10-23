# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACTIVATION" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FRACTION_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "GUARD_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KERNEL_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIGNED" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACTIVATION { PARAM_VALUE.ACTIVATION } {
	# Procedure called to update ACTIVATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACTIVATION { PARAM_VALUE.ACTIVATION } {
	# Procedure called to validate ACTIVATION
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FRACTION_SIZE { PARAM_VALUE.FRACTION_SIZE } {
	# Procedure called to update FRACTION_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRACTION_SIZE { PARAM_VALUE.FRACTION_SIZE } {
	# Procedure called to validate FRACTION_SIZE
	return true
}

proc update_PARAM_VALUE.GUARD_TYPE { PARAM_VALUE.GUARD_TYPE } {
	# Procedure called to update GUARD_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GUARD_TYPE { PARAM_VALUE.GUARD_TYPE } {
	# Procedure called to validate GUARD_TYPE
	return true
}

proc update_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to update KERNEL_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to validate KERNEL_SIZE
	return true
}

proc update_PARAM_VALUE.SIGNED { PARAM_VALUE.SIGNED } {
	# Procedure called to update SIGNED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIGNED { PARAM_VALUE.SIGNED } {
	# Procedure called to validate SIGNED
	return true
}


proc update_MODELPARAM_VALUE.KERNEL_SIZE { MODELPARAM_VALUE.KERNEL_SIZE PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KERNEL_SIZE}] ${MODELPARAM_VALUE.KERNEL_SIZE}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.FRACTION_SIZE { MODELPARAM_VALUE.FRACTION_SIZE PARAM_VALUE.FRACTION_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRACTION_SIZE}] ${MODELPARAM_VALUE.FRACTION_SIZE}
}

proc update_MODELPARAM_VALUE.SIGNED { MODELPARAM_VALUE.SIGNED PARAM_VALUE.SIGNED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIGNED}] ${MODELPARAM_VALUE.SIGNED}
}

proc update_MODELPARAM_VALUE.ACTIVATION { MODELPARAM_VALUE.ACTIVATION PARAM_VALUE.ACTIVATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACTIVATION}] ${MODELPARAM_VALUE.ACTIVATION}
}

proc update_MODELPARAM_VALUE.GUARD_TYPE { MODELPARAM_VALUE.GUARD_TYPE PARAM_VALUE.GUARD_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GUARD_TYPE}] ${MODELPARAM_VALUE.GUARD_TYPE}
}

