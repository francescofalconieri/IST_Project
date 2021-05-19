### This directory is organized in two subdirectories containing all the necessary files used to design, fabricate and verify the transistor.
- [Sentaurus_files](https://github.com/francescofalconieri/IST_Project/tree/main/IST_HOMEWORK/Sentaurus_files) subdirectory contains:
	- Project file;
	- **gtree.dat** file that lists the variables used in the simulation flow and the scenarios created in the simulation tree;
	- **sprocess_fps.cmd** command file to fabricate the transistor using *Sentaurus Process*;
	- **sdevice_IDSvsVDS.cmd** command files to simulate the device either with V<sub>GS</sub>= V<sub>DD</sub> and V<sub>GS</sub> = 0 using *Sentaurus Device*;
	- **sdevice_IDSvsVGS.cmd** command files to simulate the device either with V<sub>DS</sub>= V<sub>DD</sub> and V<sub>DS</sub> = V<sub>DS,lin</sub> using *Sentaurus Device*;
	- **sdevice.par** file to set the parameters and models for the process simulation;
	
- [scripts](https://github.com/francescofalconieri/IST_Project/tree/main/IST_HOMEWORK/scripts) subdirectory contains:
	- *Matlab* script used during the Device Design phase;
	- *SVISUAL* tcl scripts to plot the output characteristics and extract the device's parameters;	
	
