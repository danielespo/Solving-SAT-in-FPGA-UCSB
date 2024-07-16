# Solving-SAT-in-FPGA-UCSB
An HDL SAT solver design on the vivado platform.

## How to use
This repository contains the necessary source files to build a vivado project for the SAT solver. Use vivado 2023 or later to ensure successful rebuild.
The following is a detailed instruction on how to rebuild the project.

### `cd` into the <parent> directory in which you would like to build the project.
```sh
cd <parent>
```

### Clone the repository
> If the repository already exists, pull from main to get the latest updates
```sh
git clone https://github.com/danielespo/Solving-SAT-in-FPGA-UCSB.git
git checkout directory_restructuring
```

### `cd` into the repository and rebuild the project
Make sure there is not a generated project already. If so, remove the directory or save it somewhere else if you wish to keep the changes.
```sh
rm -r KMSAT-10-Z
```
Rebuild the project using `vivado -source`.
```sh
cd Solving-SAT-in-FPGA-UCSB
vivado -source rebuild_KMSAT.tcl 
```
> If `vivado` is not recognized by your shell, please add it to your `PATH` environment variable.
> Use the following link to a tutorial if you experience troubles. 
> https://docs.amd.com/r/en-US/ug892-vivado-design-flows-overview/Launching-the-Vivado-IDE-from-the-Command-Line-on-Windows-or-Linux

## Making Changes and Saving Source Controlled Files
The `rebuild_KMSAT.tcl` script **does not** automatically update when changes to the project organization are made. To update the `rebuild.tcl` script, you must run the following command in the Vivado tcl terminal:
```sh
write_project_tcl rebuild_KMSAT
```
> If the tcl terminal complains about a tcl script already existing, delete the script or override with the `-force` option for the `write_project_tcl` command.

Within the generated `rebuild_KMSAT.tcl` file, there is a header that specifies the files that need to be included in source control. Check (add / rm) only these files into git and do not include any generated files.

This command creates a new `rebuild.tcl` file and must be run after changes are made to the project, if you wish to have them saved:
- adding or removing sources from the project
- creating new block diagrams

The idea behind this method is to never have the bloated vivado project directory in the git repository at all. Instead, source files are saved in one of the three main directories:
- `/rtl/` : HDL sources such as verilog files, test benches, and memory files (`.v`,`.mem`)
- `/cons/` : Constraint files
- `/ip_repo/` : IP cores

If changes are only made to the source files (in the `rtl`, `cons`, `ip_repo`), then it is typically not *required* to perform any special actions. However, it is good practice to regenerate the rebuild script whenever the project is modified.



## Further Questions or Confusion Regarding Source Control
We have been following the instructions detailed by user jhallen.
Credit to:
https://github.com/jhallen/vivado_setup

### Common Issues
|               Issue                 |                 Solution                                |
|-------------------------------------|---------------------------------------------------------|
|.dcp file missing on project rebuild | Remove the checkpoint source file in vivado util sources|
