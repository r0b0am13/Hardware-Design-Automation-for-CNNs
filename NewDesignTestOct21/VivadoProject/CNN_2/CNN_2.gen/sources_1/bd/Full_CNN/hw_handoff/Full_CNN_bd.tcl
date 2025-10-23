
################################################################
# This is a generated script based on design: Full_CNN
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source Full_CNN_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ImageBuf_KernelSlider, ConvWeightBiasModule, Convolution, DataConverter, ImageBuf_KernelSlider, Maxpool, zyNet

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name Full_CNN

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set Conv_Debug [ create_bd_port -dir O -from 15 -to 0 Conv_Debug ]
  set Conv_valid_Debug [ create_bd_port -dir O Conv_valid_Debug ]
  set Maxpool_Debug [ create_bd_port -dir O -from 15 -to 0 Maxpool_Debug ]
  set Maxpool_valid_Debug [ create_bd_port -dir O Maxpool_valid_Debug ]
  set Pixel_In [ create_bd_port -dir I -from 7 -to 0 Pixel_In ]
  set clock [ create_bd_port -dir I -type clk clock ]
  set data_in_valid [ create_bd_port -dir I data_in_valid ]
  set o1_valid_d [ create_bd_port -dir O -from 63 -to 0 o1_valid_d ]
  set o2_valid_d [ create_bd_port -dir O -from 31 -to 0 o2_valid_d ]
  set o3_valid_d [ create_bd_port -dir O -from 9 -to 0 o3_valid_d ]
  set out_final [ create_bd_port -dir O -from 31 -to 0 out_final ]
  set out_valid_final [ create_bd_port -dir O out_valid_final ]
  set reset_n [ create_bd_port -dir I reset_n ]
  set x1_out_d [ create_bd_port -dir O -from 1023 -to 0 x1_out_d ]
  set x2_out_d [ create_bd_port -dir O -from 511 -to 0 x2_out_d ]
  set x3_out_d [ create_bd_port -dir O -from 159 -to 0 x3_out_d ]

  # Create instance: ConvSlider, and set properties
  set block_name ImageBuf_KernelSlider
  set block_cell_name ConvSlider
  if { [catch {set ConvSlider [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ConvSlider eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COLUMN_NUM {28} \
   CONFIG.DATA_WIDTH {16} \
   CONFIG.ROW_NUM {28} \
 ] $ConvSlider

  # Create instance: ConvWeightBiasModule_0, and set properties
  set block_name ConvWeightBiasModule
  set block_cell_name ConvWeightBiasModule_0
  if { [catch {set ConvWeightBiasModule_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ConvWeightBiasModule_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Convolution_0, and set properties
  set block_name Convolution
  set block_cell_name Convolution_0
  if { [catch {set Convolution_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Convolution_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ACTIVATION {1} \
 ] $Convolution_0

  # Create instance: DataConverter_0, and set properties
  set block_name DataConverter
  set block_cell_name DataConverter_0
  if { [catch {set DataConverter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DataConverter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: MaxSlider, and set properties
  set block_name ImageBuf_KernelSlider
  set block_cell_name MaxSlider
  if { [catch {set MaxSlider [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $MaxSlider eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COLUMN_NUM {26} \
   CONFIG.DATA_WIDTH {16} \
   CONFIG.KERNEL_SIZE {2} \
   CONFIG.ROW_NUM {26} \
   CONFIG.STRIDE {2} \
 ] $MaxSlider

  # Create instance: Maxpool_0, and set properties
  set block_name Maxpool
  set block_cell_name Maxpool_0
  if { [catch {set Maxpool_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Maxpool_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: zyNet_0, and set properties
  set block_name zyNet
  set block_cell_name zyNet_0
  if { [catch {set zyNet_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $zyNet_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net ConvSlider_kernel_out [get_bd_pins ConvSlider/kernel_out] [get_bd_pins Convolution_0/kernel_in]
  connect_bd_net -net ConvSlider_kernel_valid [get_bd_pins ConvSlider/kernel_valid] [get_bd_pins Convolution_0/data_valid]
  connect_bd_net -net ConvWeightBiasModule_0_Bias [get_bd_pins ConvWeightBiasModule_0/Bias] [get_bd_pins Convolution_0/bias]
  connect_bd_net -net ConvWeightBiasModule_0_Weights [get_bd_pins ConvWeightBiasModule_0/Weights] [get_bd_pins Convolution_0/weights]
  connect_bd_net -net Convolution_0_conv_out [get_bd_ports Conv_Debug] [get_bd_pins Convolution_0/conv_out] [get_bd_pins MaxSlider/data_in]
  connect_bd_net -net Convolution_0_conv_valid [get_bd_ports Conv_valid_Debug] [get_bd_pins Convolution_0/conv_valid] [get_bd_pins MaxSlider/data_valid]
  connect_bd_net -net DataConverter_0_out [get_bd_pins ConvSlider/data_in] [get_bd_pins DataConverter_0/data_out]
  connect_bd_net -net MaxSlider_kernel_out [get_bd_pins MaxSlider/kernel_out] [get_bd_pins Maxpool_0/kernel_in]
  connect_bd_net -net MaxSlider_kernel_valid [get_bd_pins MaxSlider/kernel_valid] [get_bd_pins Maxpool_0/data_valid]
  connect_bd_net -net Maxpool_0_maxp_out [get_bd_ports Maxpool_Debug] [get_bd_pins Maxpool_0/maxp_out] [get_bd_pins zyNet_0/axis_in_data]
  connect_bd_net -net Maxpool_0_maxp_valid [get_bd_ports Maxpool_valid_Debug] [get_bd_pins Maxpool_0/maxp_valid] [get_bd_pins zyNet_0/axis_in_data_valid]
  connect_bd_net -net clock_0_1 [get_bd_ports clock] [get_bd_pins ConvSlider/clock] [get_bd_pins Convolution_0/clock] [get_bd_pins MaxSlider/clock] [get_bd_pins Maxpool_0/clock] [get_bd_pins zyNet_0/s_axi_aclk]
  connect_bd_net -net data_valid_0_1 [get_bd_ports data_in_valid] [get_bd_pins ConvSlider/data_valid]
  connect_bd_net -net in_0_1 [get_bd_ports Pixel_In] [get_bd_pins DataConverter_0/data_in]
  connect_bd_net -net reset_n_1 [get_bd_ports reset_n] [get_bd_pins ConvSlider/sreset_n] [get_bd_pins Convolution_0/sreset_n] [get_bd_pins MaxSlider/sreset_n] [get_bd_pins Maxpool_0/sreset_n] [get_bd_pins zyNet_0/s_axi_aresetn]
  connect_bd_net -net zyNet_0_o1_valid_d [get_bd_ports o1_valid_d] [get_bd_pins zyNet_0/o1_valid_d]
  connect_bd_net -net zyNet_0_o2_valid_d [get_bd_ports o2_valid_d] [get_bd_pins zyNet_0/o2_valid_d]
  connect_bd_net -net zyNet_0_o3_valid_d [get_bd_ports o3_valid_d] [get_bd_pins zyNet_0/o3_valid_d]
  connect_bd_net -net zyNet_0_out_final [get_bd_ports out_final] [get_bd_pins zyNet_0/out_final]
  connect_bd_net -net zyNet_0_out_valid_final [get_bd_ports out_valid_final] [get_bd_pins zyNet_0/out_valid_final]
  connect_bd_net -net zyNet_0_x1_out_d [get_bd_ports x1_out_d] [get_bd_pins zyNet_0/x1_out_d]
  connect_bd_net -net zyNet_0_x2_out_d [get_bd_ports x2_out_d] [get_bd_pins zyNet_0/x2_out_d]
  connect_bd_net -net zyNet_0_x3_out_d [get_bd_ports x3_out_d] [get_bd_pins zyNet_0/x3_out_d]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


