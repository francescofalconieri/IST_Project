#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
#- Plotting IdVd
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vd (lin) curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V@Version@_ID_VDS.plt]
set mydata0 [load_file V@Version@_ID_VDS_off.plt]

# Create new empty xy plot
set myplot1 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVdCurve1 [create_curve -plot $myplot1 -dataset $mydata1 \
-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"]

set IdVdCurve2 [create_curve -plot $myplot1 -dataset $mydata0 \
-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"]

set Vds [get_variable_data "drain OuterVoltage" -dataset $mydata1]
set Ids [get_variable_data "drain TotalCurrent" -dataset $mydata1]

# Customize the curve
set_curve_prop $IdVdCurve1 -plot $myplot1 -show_markers -markers_size 4 \
-color red -label "VGS = VDD"

set_curve_prop $IdVdCurve2 -plot $myplot1 -show_markers -markers_size 4 \
-color blue -label "VGS = GND"

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

# Assign axis labels and set range.
set_axis_prop -plot $myplot1 -axis x -title "VDS (V)"
set_axis_prop -plot $myplot1 -axis y -title "IDS (A/um)" 
#set_axis_prop -plot $myplot1 -axis x -range {0 0.7}
#set_axis_prop -plot $myplot1 -axis y -range {0 0.001}

#Change font size
set_axis_prop -plot $myplot1 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot1 -axis x -scale_font_size 15 -title_font_size 15
set_legend_prop -plot $myplot1 -label_font_size 15

#set_best_look {$myplot1}

# Export plot into PNG file.
export_view "V@Version@_IDS_VDS.png" -plots $myplot1 -resolution 1000x800 -format PNG \
-overwrite

#- Extraction
#----------------------------------------------------------------------#
echo "#########################################"
echo "Extracting parameters from Id-Vd (lin) curve"
echo "#########################################"

#- Extraction
#----------------------------------------------------------------------#
ext::RemoveDuplicates -out XY -x $Vds -y $Ids
set Vdss $XY(X)
set Idss $XY(Y)

ext::ExtractRdiff -out Rout -name "Rout" -v $Vdss -i $Idss -vo 0.55
echo "Rout is [format %.3f $Rout] Ohm um"

ext::ExtractRdiff -out Ron -name "Ron" -v $Vdss -i $Idss -vo 0.02
echo "Ron is [format %.3f $Ron] Ohm um"

ext::ExtractEarlyV -out VEarly -v $Vdss -i $Idss -vo 0.55
echo "VEarly is [format %.3f $VEarly] V"

#--------------- PLOT IDS vs VGS ----------------------------------#

echo "#########################################"
echo "Plotting Id-Vg (Vds = Vdd, Vds = Vds,lin) curve"
echo "#########################################"
# LOAD PLT data file
set mydata2 [load_file V@Version@_ID_VG.plt]
set mydata3 [load_file V@Version@_ID_VG_Vdslin.plt]

# Create new empty xy plot
set myplot2 [create_plot -1d]

set_plot_prop -show_grid
set_grid_prop -show_minor_lines \


set myplot3 [create_plot -1d]

set_plot_prop -show_grid
set_grid_prop -show_minor_lines \

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVgCurve1 [create_curve -plot $myplot2 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

set IdVgCurve2 [create_curve -plot $myplot2 -dataset $mydata3 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

set IgVgCurve1 [create_curve -plot $myplot3 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

set IgVgCurve2 [create_curve -plot $myplot3 -dataset $mydata3 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

set Vgs1 [get_variable_data "gate OuterVoltage" -dataset $mydata2]
set Ids1 [get_variable_data "drain TotalCurrent" -dataset $mydata2]
set VDs1 [get_variable_data "drain OuterVoltage" -dataset $mydata2]
set Ig1  [get_variable_data "gate TotalCurrent" -dataset $mydata2]

set Vgs2 [get_variable_data "gate OuterVoltage" -dataset $mydata3]
set Ids2 [get_variable_data "drain TotalCurrent" -dataset $mydata3]
set Vds2 [get_variable_data "drain OuterVoltage" -dataset $mydata3]
set Ig2  [get_variable_data "gate TotalCurrent" -dataset $mydata2]

# Customize the curve
set_curve_prop $IdVgCurve1 -plot $myplot2 -show_markers -markers_size 4 \
-color red -label "VDS = VDD"

set_curve_prop $IdVgCurve2 -plot $myplot2 -show_markers -markers_size 4 \
-color blue -label "VDS = Vds,lin"



set_curve_prop $IgVgCurve1 -plot $myplot3 -show_markers -markers_size 4 \
-color red -label "VDS = VDD"

set_curve_prop $IgVgCurve2 -plot $myplot3 -show_markers -markers_size 4 \
-color blue -label "VDS = Vds,lin"

# Display grid and set grid properties

# Assign axis labels and set range.
set_axis_prop -plot $myplot2 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot2 -axis y -title "IDS (A/um)" 
set_axis_prop -plot $myplot3 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot3 -axis y -title "IG (A/um)" 
#set_axis_prop -plot $myplot2 -axis x -range {0 1}
#set_axis_prop -plot $myplot2 -axis y -min 1e-13

#Change font size
set_axis_prop -plot $myplot2 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot2 -axis x -scale_font_size 15 -title_font_size 15
set_legend_prop -plot $myplot2 -label_font_size 15

#Change font size
set_axis_prop -plot $myplot3 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot3 -axis x -scale_font_size 15 -title_font_size 15
set_legend_prop -plot $myplot3 -label_font_size 15

#set_best_look {$myplot2}

# Export plot into PNG file.
export_view "V@Version@_IDS_VGS.png" -plots $myplot2 -resolution 1000x800 -format PNG \
-overwrite

export_view "V@Version@_IG_VGS.png" -plots $myplot3 -resolution 1000x800 -format PNG \
-overwrite

#--------------- PLOT IDS vs VGS log ----------------------------------#

echo "#########################################"
echo "Plotting Id-Vg (Vds = Vdd, Vds = Vds,lin) curve"
echo "#########################################"
# LOAD PLT data file
set mydata2 [load_file V@Version@_ID_VG.plt]
set mydata3 [load_file V@Version@_ID_VG_Vdslin.plt]

# Create new empty xy plot
set myplot4 [create_plot -1d]

set_plot_prop -show_grid
set_grid_prop -show_minor_lines \

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVgCurve1 [create_curve -plot $myplot4 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

set_curve_prop $IgVgCurve1 -plot $myplot4 -show_markers -markers_size 4 \
-color red -label "VDS = VDD"

set IdVgCurve2 [create_curve -plot $myplot4 -dataset $mydata3 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

set_curve_prop $IgVgCurve2 -plot $myplot4 -show_markers -markers_size 4 \
-color blue -label "VDS = Vds,lin"

# Assign axis labels and set range.
set_axis_prop -plot $myplot4 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot4 -axis y -title "IDS (A/um)" 

#Turn on log scale on y axis
set_axis_prop -plot $myplot4 -axis y -type log -min 1e-13

#Change font size
set_axis_prop -plot $myplot4 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot4 -axis x -scale_font_size 15 -title_font_size 15
set_legend_prop -plot $myplot4 -location bottom_right -label_font_size 15

# Export plot into PNG file.
export_view "V@Version@_IDS_VGS_log.png" -plots $myplot4 -resolution 1000x800 -format PNG \
-overwrite


#--------------- PLOT IG vs VGS log ----------------------------------#

echo "#########################################"
echo "Plotting Ig-Vg (Vds = Vdd, Vds = Vds,lin) curve"
echo "#########################################"

# Create new empty xy plot
set myplot5 [create_plot -1d]

set_plot_prop -show_grid
set_grid_prop -show_minor_lines \

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IgVgCurve1 [create_curve -plot $myplot5 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

set_curve_prop $IgVgCurve1 -plot $myplot5 -show_markers -markers_size 4 \
-color red -label "VDS = VDD"

set IgVgCurve2 [create_curve -plot $myplot5 -dataset $mydata3 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

set_curve_prop $IgVgCurve2 -plot $myplot5 -show_markers -markers_size 4 \
-color blue -label "VDS = Vds,lin"

# Assign axis labels and set range.
set_axis_prop -plot $myplot5 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot5 -axis y -title "IG (A/um)" 

#Turn on log scale on y axis
set_axis_prop -plot $myplot5 -axis y -type log -min 1e-25

#Change font size
set_axis_prop -plot $myplot5 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot5 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot5 -location bottom_right -label_font_size 15

# Export plot into PNG file.
export_view "V@Version@_IGS_VGS_log.png" -plots $myplot5 -resolution 1000x800 -format PNG \
-overwrite


#- Extraction
#----------------------------------------------------------------------#
echo "#########################################"
echo "Extracting parameters from Id-Vgs curve"
echo "#########################################"

#- Extraction
#----------------------------------------------------------------------#
ext::RemoveDuplicates -out XY -x $Vgs1 -y $Ids1
set Vgss1 $XY(X)
set Idss1 $XY(Y)
echo "PARAMETERS FOR: VDS=VDD"

#ext::ExtractVti -out Vth_i -v $Vgs1 -i $Ids1 -io <r>

ext::ExtractVtgm -out Vth_gm -v $Vgss1 -i $Idss1
echo "-> Vth (gm method) is [format %.3f $Vth_gm] V"

ext::ExtractValue -out Ith_1 -x $Vgss1 -y $Idss1 -yLog 1 -xo $Vth_gm
echo "-> Ith (gm method, Vgs=Vth) is [format %.3f $Ith_1] A/um"

ext::ExtractGm -out gm -v $Vgss1 -i $Idss1
echo "-> gm is [format %.3f $gm] S/um"

ext::ExtractExtremum -out Ion1 -x $Vgss1 -y $Idss1 -type "max"
echo "-> Ion is [format %.3f  [expr $Ion1/1000000]] uA/um"

ext::ExtractExtremum -out Ig1 -x $Vgs1 -y $Ig1 -type "max"
echo "-> Ig is [format %.3f  [expr $Ion1/1000000]] uA/um"

ext::ExtractIoff -out Ioff1 -v $Vgss1 -i $Idss1 -vo 0.0001
echo "-> Ioff is [format %.6f  [expr $Ioff1/1000000000]] nA/um"

ext::ExtractSsub -out SSmax -v $Vgss1 -i $Idss1

echo "PARAMETERS FOR: VDS=VD,lin"

ext::RemoveDuplicates -out XY -x $Vgs2 -y $Ids2
set Vgss2 $XY(X)
set Idss2 $XY(Y)

ext::ExtractVti -out Vth_i -v $Vgss2 -i $Idss2 -io $Ith_1


echo "-> Vth (constant current method) is [format %.3f 0.7] V"
#set Vth_i 0.7

echo "SCE PARAMETERS EXTRACTION:"

set DIBL_coeff [expr (($Vth_gm-$Vth_i)/(0.7-0.02))*1000]
echo "-> DIBL linearized coefficient is [format %.3f $DIBL_coeff] mV/V"

echo "-> SS is [format %.3f $SSmax] V/dec"


# PARAMETER OUTPUT TO FILE
echo "###############################"
echo "##### WRITING OUTPUT FILE #####"
echo "###############################"

set outfile1 [open "V@Version@_Param_Extracted.txt" w]
puts $outfile1 "------------------ MOSFET PARAMETERS EXTRACTION V@Version@ -------------------"
puts $outfile1 "--> Rout = [format %.3f $Rout] Ohm/um"
puts $outfile1 "--> Ron = [format %.3f $Ron] Ohm/um"
puts $outfile1 "--> VEarly = [format %.3f $VEarly] V"
puts $outfile1 "--> Vth (gm method, Vds=Vdd) = [format %.3f $Vth_gm]"
puts $outfile1 "--> Ith (Ids @ Vgs=Vth) = [format %.3f [expr $Ith_1*1000000000]] nA/um"
puts $outfile1 "--> Gm = [format %.3f [expr $gm*1000000]] uS/um"
puts $outfile1 "--> Ion = [format %.3f  [expr $Ion1*1000000]] uA/um"
puts $outfile1 "--> Ioff = [format %.6f  [expr $Ioff1*1000000000]] nA/um"
puts $outfile1 "--> Ig = [format %.9f  [expr $Ig1*1000000000000]] pA/um"
puts $outfile1 "--> Vth (Ith method, Vds=Vds,lin) = [format %.3f $Vth_i]"
puts $outfile1 "--> DIBL = [format %.3f $DIBL_coeff] mV/V"
puts $outfile1 "--> SS = [format %.3f $SSmax] V/dec"
close $outfile1

exit

