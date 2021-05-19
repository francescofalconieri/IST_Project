#----------------------------------------------------------------------#
#- Plotting IdVd
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vd (lin) curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V1_ID_VDS.plt]
set mydata2 [load_file V2.1_ID_VDS.plt]

# Create new empty xy plot
set myplot1 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVdCurve1 [create_curve -plot $myplot1 -dataset $mydata1 \
-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"]
set IdVdCurve2 [create_curve -plot $myplot1 -dataset $mydata2 \
-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"]

# Customize the curve
set_curve_prop $IdVdCurve1 -plot $myplot1 -show_markers -markers_size 4 \
-color red -label "VGS = VDD, V1"


set_curve_prop $IdVdCurve2 -plot $myplot1 -show_markers -markers_size 4 \
-color blue -label "VGS = VDD, V2.1"

# Assign axis labels and set range.
set_axis_prop -plot $myplot1 -axis x -title "VDS (V)"
set_axis_prop -plot $myplot1 -axis y -title "IDS (A/um)" 

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

#Change font size
set_axis_prop -plot $myplot1 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot1 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot1 -location bottom_right -label_font_size 15

# Export plot into PNG file.
export_view "Comp1vs2.1_IDS_VDS.png" -plots $myplot1 -resolution 1000x800 -format PNG \
-overwrite

#----------------------------------------------------------------------#
#- Plotting IdVg
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vg-Vdd curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V1_ID_VG.plt]
set mydata2 [load_file V2.1_ID_VG.plt]

# Create new empty xy plot
set myplot2 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVgCurve1 [create_curve -plot $myplot2 -dataset $mydata1 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]
set IdVgCurve2 [create_curve -plot $myplot2 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

# Customize the curve
set_curve_prop $IdVgCurve1 -plot $myplot2 -show_markers -markers_size 4 \
-color red -label "VDS = VDD, V1"


set_curve_prop $IdVgCurve2 -plot $myplot2 -show_markers -markers_size 4 \
-color blue -label "VDS = VDD, V2.1"

# Assign axis labels and set range.
set_axis_prop -plot $myplot2 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot2 -axis y -title "IDS (A/um)" 

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

#Change font size
set_axis_prop -plot $myplot2 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot2 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot2 -location top_left -label_font_size 15

# Export plot into PNG file.
export_view "Comp1vs2.1_IDS_VGS.png" -plots $myplot2 -resolution 1000x800 -format PNG \
-overwrite


#----------------------------------------------------------------------#
#- Plotting IdVg
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Ig-Vg-Vdd curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V1_ID_VG.plt]
set mydata2 [load_file V2.1_ID_VG.plt]

# Create new empty xy plot
set myplot3 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IgVgCurve1 [create_curve -plot $myplot3 -dataset $mydata1 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]
set IgVgCurve2 [create_curve -plot $myplot3 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

# Customize the curve
set_curve_prop $IgVgCurve1 -plot $myplot3 -show_markers -markers_size 4 \
-color red -label "VDS = VDD, V1"


set_curve_prop $IgVgCurve2 -plot $myplot3 -show_markers -markers_size 4 \
-color blue -label "VDS = VDD, V2.1"

# Assign axis labels and set range.
set_axis_prop -plot $myplot3 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot3 -axis y -title "IG (A/um)" 

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

#Change font size
set_axis_prop -plot $myplot3 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot3 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot3 -location top_left -label_font_size 15

# Export plot into PNG file.
export_view "Comp1vs2.1_IG_VGS.png" -plots $myplot3 -resolution 1000x800 -format PNG \
-overwrite

#----------------------------------------------------------------------#
#- Plotting IdVg log
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vg-Vdd log curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V1_ID_VG.plt]
set mydata2 [load_file V2.1_ID_VG.plt]

# Create new empty xy plot
set myplot2 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IdVgCurve1 [create_curve -plot $myplot2 -dataset $mydata1 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]
set IdVgCurve2 [create_curve -plot $myplot2 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"]

# Customize the curve
set_curve_prop $IdVgCurve1 -plot $myplot2 -show_markers -markers_size 4 \
-color red -label "VDS = VDD, V1"


set_curve_prop $IdVgCurve2 -plot $myplot2 -show_markers -markers_size 4 \
-color blue -label "VDS = VDD, V2.1"

# Assign axis labels and set range.
set_axis_prop -plot $myplot2 -axis x -title "VGS (V)" 
set_axis_prop -plot $myplot2 -axis y -title "IDS (A/um)" -type log -min 1e-11 

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

#Change font size
set_axis_prop -plot $myplot2 -axis y -scale_font_size 15 -title_font_size 15
set_axis_prop -plot $myplot2 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot2 -location bottom_right -label_font_size 15

# Export plot into PNG file.
export_view "Comp1vs2.1_IDS_VGS_log.png" -plots $myplot2 -resolution 1000x800 -format PNG \
-overwrite


#----------------------------------------------------------------------#
#- Plotting IdVg log
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Ig-Vg-Vdd curve"
echo "#########################################"
# LOAD PLT data file
set mydata1 [load_file V1_ID_VG.plt]
set mydata2 [load_file V2.1_ID_VG.plt]

# Create new empty xy plot
set myplot3 [create_plot -1d]

# Create Id-Vd curve using loaded dataset and display on new xy plot
set IgVgCurve1 [create_curve -plot $myplot3 -dataset $mydata1 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]
set IgVgCurve2 [create_curve -plot $myplot3 -dataset $mydata2 \
-axisX "gate OuterVoltage" -axisY "gate TotalCurrent"]

# Customize the curve
set_curve_prop $IgVgCurve1 -plot $myplot3 -show_markers -markers_size 4 \
-color red -label "VDS = VDD, V1"


set_curve_prop $IgVgCurve2 -plot $myplot3 -show_markers -markers_size 4 \
-color blue -label "VDS = VDD, V2.1"

# Assign axis labels and set range.
set_axis_prop -plot $myplot3 -axis x -title "VGS (V)"
set_axis_prop -plot $myplot3 -axis y -title "IG (A/um)" 

# Display grid and set grid properties
set_plot_prop -show_grid
set_grid_prop -show_minor_lines \
-line1_style dash -line1_color #a0a0a4 \
-line2_style dot -line2_color #c0c0c0

#Change font size
set_axis_prop -plot $myplot3 -axis y -scale_font_size 15 -title_font_size 15 -type log -min 1e-22
set_axis_prop -plot $myplot3 -axis x -scale_font_size 15 -title_font_size 15

set_legend_prop -plot $myplot3 -location bottom_right -label_font_size 15

# Export plot into PNG file.
export_view "Comp1vs2.1_IG_VGS_log.png" -plots $myplot3 -resolution 1000x800 -format PNG \
-overwrite


