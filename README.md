# Solving-SAT-in-FPGA-UCSB
Creating a hardware solver in Verilog and then uploading to FPGA and connecting to a PC to solve SAT problems.

# How to use
This repository only contains the files necessary to generate the project in Vivado, but not the Vivado project file itself. This is achieved through the use of the `rebuild.tcl` file which reconstructs the project from the source files.

To start from scratch in an empty directory (assuming you have vivado installed), run these commands:
```sh
git clone https://github.com/danielespo/Solving-SAT-in-FPGA-UCSB.git
git checkout directory_restructuring
cd Solving-SAT-in-FPGA-UCSB
vivado -source rebuild.tcl 
```

If you already have the git repository, navigate to the home directory and run the following command:
```sh
vivado -source rebuild.tcl
```

To rebuild the project using the tcl script, run the following commands:
```sh
rm -r KMSAT-10-Z
vivado -source rebuild.tcl
```

# Making Changes
The `rebuild.tcl` does not automatically update when changes to the project organization are made. To update the `rebuild.tcl` script, you must run the following command in the Vivado tcl terminal:
```sh
write_project_tcl rebuild
```
This command creates a new `rebuild.tcl` file (you may have to delete the old one), and must be run after any changes are made to the project organization:
- files being added or removed from the project directory
- adding or removing sources from the project
- creating new block diagrams

The idea behind this method is to never have the bloated vivado project directory in the git repository at all. Instead, source files are included one of the three main directories other than the project directory:
- `/rtl/` : Verilog modules, testbenches, or related files (`.v`,`.mem`) 
- `/cons/` : Constraint files 
- `/ip_repo/` : Any external or custom IP cores. 

Changes made to the source files (in the `rtl`, `cons`, `ip_repo`) do not *require* any special actions, but it is good practice to regenerate the rebuild script whenever the project is modified.

Within the `rebuild.tcl` file, there is a header that includes comments that detail which files need to be included in source control. 

# Further Questions or Confusion
I have been following the instructions detailed by user jhallen. 
https://github.com/jhallen/vivado_setup
