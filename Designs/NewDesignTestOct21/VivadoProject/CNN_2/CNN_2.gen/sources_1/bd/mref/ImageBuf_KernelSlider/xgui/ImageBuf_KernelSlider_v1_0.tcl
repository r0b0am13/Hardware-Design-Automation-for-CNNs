# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "COLUMN_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KERNEL_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ROW_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STRIDE" -parent ${Page_0}


}

proc update_PARAM_VALUE.COLUMN_NUM { PARAM_VALUE.COLUMN_NUM } {
	# Procedure called to update COLUMN_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COLUMN_NUM { PARAM_VALUE.COLUMN_NUM } {
	# Procedure called to validate COLUMN_NUM
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to update KERNEL_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KERNEL_SIZE { PARAM_VALUE.KERNEL_SIZE } {
	# Procedure called to validate KERNEL_SIZE
	return true
}

proc update_PARAM_VALUE.ROW_NUM { PARAM_VALUE.ROW_NUM } {
	# Procedure called to update ROW_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROW_NUM { PARAM_VALUE.ROW_NUM } {
	# Procedure called to validate ROW_NUM
	return true
}

proc update_PARAM_VALUE.STRIDE { PARAM_VALUE.STRIDE } {
	# Procedure called to update STRIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STRIDE { PARAM_VALUE.STRIDE } {
	# Procedure called to validate STRIDE
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

proc update_MODELPARAM_VALUE.COLUMN_NUM { MODELPARAM_VALUE.COLUMN_NUM PARAM_VALUE.COLUMN_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COLUMN_NUM}] ${MODELPARAM_VALUE.COLUMN_NUM}
}

proc update_MODELPARAM_VALUE.ROW_NUM { MODELPARAM_VALUE.ROW_NUM PARAM_VALUE.ROW_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROW_NUM}] ${MODELPARAM_VALUE.ROW_NUM}
}

proc update_MODELPARAM_VALUE.STRIDE { MODELPARAM_VALUE.STRIDE PARAM_VALUE.STRIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STRIDE}] ${MODELPARAM_VALUE.STRIDE}
}

