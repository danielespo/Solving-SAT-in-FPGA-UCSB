
################################################################
# This is a generated script based on design: clause_processor
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
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source clause_processor_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ClauseTable, BreakValueCounter, Clause_Evaluator, Heuristic_Selector, FIFO_tree, UNSAT_Clause_Buffer, Variable_Table, Clause_Register, Clause_Evaluator, Clause_Evaluator, lfsr_prng, Address_Translation_Table, Temporal_Buffer

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name clause_processor

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

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
ClauseTable\
BreakValueCounter\
Clause_Evaluator\
Heuristic_Selector\
FIFO_tree\
UNSAT_Clause_Buffer\
Variable_Table\
Clause_Register\
Clause_Evaluator\
Clause_Evaluator\
lfsr_prng\
Address_Translation_Table\
Temporal_Buffer\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
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
  set clause [ create_bd_port -dir O clause ]
  set var_table_address_o [ create_bd_port -dir O -from 439 -to 0 var_table_address_o ]

  # Create instance: ClauseTable_0, and set properties
  set block_name ClauseTable
  set block_cell_name ClauseTable_0
  if { [catch {set ClauseTable_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ClauseTable_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: BreakValueCounter_0, and set properties
  set block_name BreakValueCounter
  set block_cell_name BreakValueCounter_0
  if { [catch {set BreakValueCounter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $BreakValueCounter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Clause_Evaluator_1, and set properties
  set block_name Clause_Evaluator
  set block_cell_name Clause_Evaluator_1
  if { [catch {set Clause_Evaluator_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Clause_Evaluator_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]

  # Create instance: Heuristic_Selector_0, and set properties
  set block_name Heuristic_Selector
  set block_cell_name Heuristic_Selector_0
  if { [catch {set Heuristic_Selector_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Heuristic_Selector_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: FIFO_tree_0, and set properties
  set block_name FIFO_tree
  set block_cell_name FIFO_tree_0
  if { [catch {set FIFO_tree_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $FIFO_tree_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: UNSAT_Clause_Buffer_0, and set properties
  set block_name UNSAT_Clause_Buffer
  set block_cell_name UNSAT_Clause_Buffer_0
  if { [catch {set UNSAT_Clause_Buffer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $UNSAT_Clause_Buffer_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Variable_Table_0, and set properties
  set block_name Variable_Table
  set block_cell_name Variable_Table_0
  if { [catch {set Variable_Table_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Variable_Table_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Clause_Register_0, and set properties
  set block_name Clause_Register
  set block_cell_name Clause_Register_0
  if { [catch {set Clause_Register_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Clause_Register_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Clause_Evaluator_2, and set properties
  set block_name Clause_Evaluator
  set block_cell_name Clause_Evaluator_2
  if { [catch {set Clause_Evaluator_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Clause_Evaluator_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.MAX_CLAUSES_PER_VARIABLE {1} \
    CONFIG.NSAT {4} \
  ] $Clause_Evaluator_2


  # Create instance: Clause_Evaluator_3, and set properties
  set block_name Clause_Evaluator
  set block_cell_name Clause_Evaluator_3
  if { [catch {set Clause_Evaluator_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Clause_Evaluator_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.MAX_CLAUSES_PER_VARIABLE {1} \
    CONFIG.NSAT {4} \
  ] $Clause_Evaluator_3


  # Create instance: lfsr_prng_0, and set properties
  set block_name lfsr_prng
  set block_cell_name lfsr_prng_0
  if { [catch {set lfsr_prng_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $lfsr_prng_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Address_Translation_0, and set properties
  set block_name Address_Translation_Table
  set block_cell_name Address_Translation_0
  if { [catch {set Address_Translation_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Address_Translation_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {11} \
  ] $xlconcat_0


  # Create instance: Temporal_Buffer_0, and set properties
  set block_name Temporal_Buffer
  set block_cell_name Temporal_Buffer_0
  if { [catch {set Temporal_Buffer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Temporal_Buffer_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net Address_Translation_0_address_o [get_bd_pins Address_Translation_0/address_o] [get_bd_pins ClauseTable_0/address]
  connect_bd_net -net BreakValueCounter_0_break_value [get_bd_pins BreakValueCounter_0/break_value] [get_bd_pins Heuristic_Selector_0/break_value_i]
  connect_bd_net -net ClauseTable_0_clause [get_bd_pins ClauseTable_0/clause] [get_bd_pins Clause_Evaluator_1/clause_table_i]
  connect_bd_net -net Clause_Evaluator_0_isBroken [get_bd_pins Clause_Evaluator_1/isBroken] [get_bd_pins BreakValueCounter_0/clause] [get_bd_pins Temporal_Buffer_0/isBroken_i]
  connect_bd_net -net Clause_Evaluator_0_var_table_address_o [get_bd_pins Clause_Evaluator_1/var_table_address_o] [get_bd_ports var_table_address_o] [get_bd_pins Variable_Table_0/clause_evaluator_address_i]
  connect_bd_net -net Clause_Evaluator_2_var_table_address_o [get_bd_pins Clause_Evaluator_2/var_table_address_o] [get_bd_pins Variable_Table_0/clause_evaluator_2_i]
  connect_bd_net -net Clause_Evaluator_3_isBroken [get_bd_pins Clause_Evaluator_3/isBroken] [get_bd_pins Clause_Register_0/flush]
  connect_bd_net -net Clause_Evaluator_3_var_table_address_o [get_bd_pins Clause_Evaluator_3/var_table_address_o] [get_bd_pins Variable_Table_0/clause_evaluator_3_i]
  connect_bd_net -net Clause_Register_0_literal_address_out [get_bd_pins Clause_Register_0/literal_address_out] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net Clause_Register_0_literal_negation_bit_out [get_bd_pins Clause_Register_0/literal_negation_bit_out] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net FIFO_tree_0_clause_o [get_bd_pins FIFO_tree_0/clause_o] [get_bd_ports clause] [get_bd_pins UNSAT_Clause_Buffer_0/clause_i]
  connect_bd_net -net Heuristic_Selector_0_selected_flip_o [get_bd_pins Heuristic_Selector_0/selected_flip_o] [get_bd_pins Temporal_Buffer_0/heuristic_selection_i]
  connect_bd_net -net Net [get_bd_pins FIFO_tree_0/clk] [get_bd_pins Clause_Evaluator_1/clk]
  connect_bd_net -net Net1 [get_bd_pins FIFO_tree_0/reset] [get_bd_pins Clause_Evaluator_1/reset]
  connect_bd_net -net Temporal_Buffer_0_clause_o [get_bd_pins Temporal_Buffer_0/clause_o] [get_bd_pins FIFO_tree_0/clauses_i]
  connect_bd_net -net UNSAT_Clause_Buffer_0_clause_o [get_bd_pins UNSAT_Clause_Buffer_0/clause_o] [get_bd_pins Clause_Register_0/clause_i] [get_bd_pins Clause_Evaluator_2/clause_table_i]
  connect_bd_net -net Variable_Table_0_calause [get_bd_pins Variable_Table_0/clause] [get_bd_pins Clause_Evaluator_1/var_table_data_i]
  connect_bd_net -net Variable_Table_0_clause_evaluator_2_o [get_bd_pins Variable_Table_0/clause_evaluator_2_o] [get_bd_pins Clause_Evaluator_2/var_table_data_i]
  connect_bd_net -net Variable_Table_0_clause_evaluator_3_o [get_bd_pins Variable_Table_0/clause_evaluator_3_o] [get_bd_pins Clause_Evaluator_3/var_table_data_i]
  connect_bd_net -net clk_1 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins BreakValueCounter_0/clk] [get_bd_pins ClauseTable_0/clk] [get_bd_pins Heuristic_Selector_0/clk] [get_bd_pins UNSAT_Clause_Buffer_0/clk] [get_bd_pins Variable_Table_0/clk] [get_bd_pins Clause_Register_0/clk] [get_bd_pins lfsr_prng_0/clk] [get_bd_pins Address_Translation_0/clk] [get_bd_pins Temporal_Buffer_0/clk] [get_bd_pins Clause_Evaluator_2/clk] [get_bd_pins Clause_Evaluator_3/clk]
  connect_bd_net -net reset_0_1 [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins ClauseTable_0/reset] [get_bd_pins BreakValueCounter_0/reset] [get_bd_pins Heuristic_Selector_0/reset] [get_bd_pins UNSAT_Clause_Buffer_0/reset] [get_bd_pins Clause_Register_0/reset] [get_bd_pins lfsr_prng_0/reset] [get_bd_pins Address_Translation_0/reset] [get_bd_pins Temporal_Buffer_0/reset] [get_bd_pins Clause_Evaluator_2/reset] [get_bd_pins Clause_Evaluator_3/reset]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins Address_Translation_0/index_i]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

