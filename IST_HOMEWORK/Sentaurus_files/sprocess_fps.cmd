#---------------------------------------------------------------------------#
fset Ymin 0.0
fset Ymax 0.4<um>
puts "Y domain: $Ymin $Ymax"
#---------------------------------------------------------------------------#
#rem #---------------------------------------------------------------------#
#rem #   PARAMETERS
#rem #---------------------------------------------------------------------#
fset f 1.0
fset Tsi   @Tsi@
fset Tbox  @Tbox@	
fset ThinSiInitDoping @ThinSiInitDoping@
fset 1stBoronImplant @1stBoronImplant@	
fset 2ndBoronImplant @2ndBoronImplant@	
fset 3rdBoronImplant @3rdBoronImplant@	
fset Lsp   @Lsp@	
fset Lg2   @<lgate/2>@
fset Yspacer [expr ($Lg2+$Lsp)]
fset SOI_depth @Tsi@
fset epi_thick  @RSD_Epi@
fset epi_temp   740
fset RTA_Th @RTA_Th@
fset NiSi_thick @NiSi_thick@
fset HGate 40 <nm>
fset THF 0.6 <nm>
fset TTiN @TiN_thick@
fset EOT [expr {double(@EOT_Angstr@)/10}]
fset THfO2 [expr ((25/3.9)*($EOT-0.54))]
fset STI_width 40
fset STI_AR 8.6
fset halfActiveArea 100
fset STI_depth $STI_width*$STI_AR 
fset vertex1 -29
fset vertex2 [expr $STI_depth-29]
fset vertex3 [expr $STI_depth-29]
fset vertex4 [expr $halfActiveArea+$STI_width-10]
#------------------------------------------------------------------------
math coord.ucs
line x location= 0.0 spacing= 1.0<nm> tag= SiTop
line x location= 50.0<nm> spacing= 10.0<nm>
line x location= 0.5<um> spacing= 50.0<nm> 
line x location= 2.0<um> spacing= 0.2<um> tag= SiBottom
line y location= 0.0 spacing= 50.0<nm> tag= Mid
line y location= 0.20<um> spacing=50.0<nm> tag= Right
#-------------------------------------------------------------------------
region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right
init concentration= 1.0e+16<cm-3> field= Boron
AdvancedCalibration
photo thickness= 150<nm>
strip Photoresist 
struct tdr= V@Version@_0_Bulk;
# BOX
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7
diffuse temperature= 850<C> time= 1.0<min> O2
deposit Oxide type=isotropic thickness=@Tbox@
diffuse temperature=900<C> time=40<min>
struct tdr= V@Version@_1_BOX;
deposit Silicon type=isotropic thickness=@Tsi@ Boron concentration= $ThinSiInitDoping<cm-3>
struct tdr= V@Version@_2_Thin_Silicon;
# BORON IMPLANTATION
implant Boron dose= $1stBoronImplant<cm-2> energy= 100<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate.plx y=0.0 Silicon
implant Boron dose= $2ndBoronImplant<cm-2> energy= 20<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate1.plx y=0.0 Silicon
implant Boron dose= $3rdBoronImplant<cm-2> energy= 10<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate2.plx y=0.0 Silicon
struct tdr= V@Version@_3_Channel_Doping;
# GATE OXIDE
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 0.5e-7
pdbSet Grid NativeLayerThickness 0.5e-7
diffuse temperature= 850<C> time= 0.5<min> O2
struct tdr= V@Version@_4_Dummy_Gate_Oxide;
# --------- STI ------------------
deposit material = {Nitride} type = isotropic thickness = 50<nm>
struct tdr= V@Version@_5_STI_Nitride;
mask name = STI_mask segments = {$halfActiveArea<nm> ($halfActiveArea+$STI_width)<nm>}
photo mask = STI_mask thickness = 150<nm>
struct tdr= V@Version@_6_STI_Mask;
etch material = {Nitride} type= anisotropic rate = 55<nm/min> time = 1
etch material = all type = polygon polygon = {$vertex1<nm> $halfActiveArea<nm> $vertex2<nm> ($halfActiveArea+10)<nm> $vertex3<nm>  $vertex4<nm> $vertex1<nm> ($halfActiveArea+$STI_width)<nm>}
etch material = all type = isotropic rate = 1<nm/min> time = 6
struct tdr= V@Version@_7_STI_Etching;
strip Photoresist
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7
diffuse temperature= 850<C> time= 10.0<min> O2
struct tdr= V@Version@_8_STI_Reox
deposit material = Oxide type = isotropic time = 1 rate = {300<nm/min>}
struct tdr= V@Version@_9_STI_Filled
etch type = cmp material = all coord = -35<nm>
struct tdr= V@Version@_10_STI_CMP
#etch type = isotropic material = Nitride time = 1 rate = {100<nm/min>}
strip Nitride
struct tdr= V@Version@_11_STI_Final
#---------------------------------------------------------------------
# POLY
deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.04}
mask name= gate_mask left=-1 right= 8.7<nm>
etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.05} \
mask= gate_mask
struct tdr= V@Version@_12_DummyGate_Etching;
mask name=Active_Region_mask negative left = 90<nm> right=0.2
photo mask = Active_Region_mask thickness = 150<nm>
etch material= {Oxide} type= anisotropic time= 1 rate= {4<nm/min>}
strip Photoresist
struct tdr= V@Version@_13_ExcessOx_Etching;
diffuse temperature= 900<C> time=0.25<min> O2
struct tdr= V@Version@_14_PolyReox ; # Poly Reox
#------------------------------------------------------------------------------
#--- Nitride Spacer ----------------------------------------------------------#
deposit material= {Nitride} type= isotropic time= 1 rate= {$Lsp}
struct tdr= V@Version@_15_SpacerDeposition;# Spacer deposition
etch material= {Nitride} type= anisotropic time = 1.3 rate= {$Lsp}
struct tdr= V@Version@_16_SpacerEtching;# Spacer etch
#deposit material= {oxide} type = isotropic rate= 0.001 time= 1.0 selective.material= PolySilicon
#struct tdr= V@Version@_n@node@_NMOS6; #
mask name= PolyReox_mask negative left=-1 right= 13<nm>
photo mask= PolyReox_mask thickness= 150<nm>
etch material= {oxide} type= anisotropic time= 1 rate= {1.2<nm/min>} 
strip Photoresist
struct tdr= V@Version@_16_2_OxEtching;# Spacer etch
#--- RSD Epitaxy -------------------------------------------------------------#
refinebox name= RSD \
  min= "-0.04 $Ymin" max= "-0.021 $Ymax" \
  xrefine= " 0.002*$f"  yrefine= " 0.002*$f " Silicon
  
grid remesh
## ---------- in-situ P Doped Si RSD -----------------------------------
photo mask = Active_Region_mask thickness = 150<nm>
set EpiDoping_init  "Phosphorus= 5.5e20"
temp_ramp name= epi temperature= 550<C> t.final= $epi_temp<C> time= 1.0<min> Epi thick= $epi_thick<um>  \
epi.doping= $EpiDoping_init \
epi.layers= 10 epi.model= 1 
diffuse temp_ramp= epi
strip Photoresist
struct tdr= V@Version@_17_RSD_Epitaxy;# RSD Epi

fset Yr [expr $Yspacer+$epi_thick*0.9*cos(atan(1.0)*54.7/45.0)]
mask name= EpiT segments= {$Ymin $Yr}

deposit material= {Photoresist} type= anisotropic time= 1.0 rate= 0.05 mask= EpiT
struct tdr= V@Version@_18_FacetedRSD_Mask; #

etch material= {Silicon}  type= directional rate= {$epi_thick+0.001} time= 1 \
    direction= { sin(atan(1.0)*54.7/45.0) -1*cos(atan(1.0)*54.7/45.0) 0 }
strip Photoresist
struct tdr= V@Version@_19_FacetedRSD_Etch; #

## -------RTA-----------------
temp_ramp name= spike time= 1.0<s> temp= 600<C>  t.final= $RTA_Th<C>
temp_ramp name= spike time= 1.0<s> temp= $RTA_Th<C> ramprate= 0.0<C/s>
temp_ramp name= spike time= 1.5<s> temp= $RTA_Th t.final= 650<C>
diffuse temp_ramp= spike 
struct tdr= V@Version@_20_LDD_Implant; #

# -------------------------------------------------------------------- #
SetPlxList {PTotal BTotal NetActive}
WritePlx V@Version@_anneal_sde.plx y= 0.015 Silicon
SetPlxList {PTotal BTotal NetActive}
WritePlx V@Version@_anneal_sd.plx y= 0.06 Silicon
SetPlxList {BTotal NetActive}
WritePlx V@Version@_anneal_sub.plx y= 0.0 Silicon
# -------------------------------------------------------------------- #
## ---------- Silicidation -------------------------------------------
photo mask = Active_Region_mask thickness = 150<nm>
deposit Nickel type= isotropic thickness= $NiSi_thick selective.material= Silicon
struct tdr= V@Version@_21_NickelDepo; 

pdbSet NickelSilicide Grid perp.add.dist 0.001e-4
pdbSet Silicon Grid perp.add.dist 0.001e-4
pdbSet Silicon Grid Remove.Dist 0.0005e-4

pdbSet NickelSilicide Silicon Dstar { {[Arr 0.011  1.6]} }
pdbSet NickelSilicide_Silicon Silicon Expansion.Ratio 1.0
pdbSet Nickel_NickelSilicide  Silicon Expansion.Ratio 1.0

pdbSet NickelSilicide_Silicon SilicidationTripleFactor 0
pdbSet NickelSilicide_Silicon SilicidationTripleDistance 15e-7
pdbSet Nickel_NickelSilicide  SilicidationTripleDistance 15e-7

diffuse time= 1.25<s>  temperature= 500

strip Nickel
strip Photoresist
struct tdr= V@Version@_22_Strip_Nickel ; #
#pdbSet Grid Adaptive 1
#refinebox !keep.lines ;
#-----------------------------------------------------------------------------------
#------------------- START GATE STACK ----------------------------------------------
# -----------HIGH CONFORMING THIN OXIDE DRY OXIDATION FOR FOX GROWTH
#grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
#mgoals accuracy= 1e-5
#pdbSet Oxide Grid perp.add.dist 1e-7
#pdbSet Grid NativeLayerThickness 1e-7
#diffuse temperature= 850<C> time= 10.0<min> O2 
#struct tdr= V@Version@_25_Planariz_Seed_Layer ; #
# -*---------OXIDE CVD FOR PLANARIZATION
deposit material= {Oxide} type= isotropic time= 1 rate= {0.2}
struct tdr= V@Version@_26_Planariz_Depo; #
# -----------PLANARIZATION CMP AND POLY EXPOSURE
etch type=cmp coord=-1*65<nm> material=all 
struct tdr= V@Version@_27_Planariz_CMP; #
# -----------DUMMY GATE REMOVAL
etch material= {PolySilicon} type= isotropic time= 2 rate= {0.1}
struct tdr= V@Version@_28_Dummy_Gate_etch; #
# -----------DUMMY GATE OXIDE REMOVAL
photo mask= gate_mask thickness= 150<nm>
etch material= {Oxide} type= anisotropic time= 1 rate= {3<nm/min>}
etch material= {Oxide} type= anisotropic time= 1 rate= {1<nm/min>}
struct tdr= V@Version@_29_DummyGateOxide_etch; #
strip Photoresist

# -----------THIN SiO2 GOX FOR HfO2 ALD
refinebox name= gate_stack \
  min= "-0.027192 0.00824718" max= "-0.0313565 0" \
  xrefine= " 0.002*$f"  yrefine= " 0.002*$f " all 
grid remesh
deposit material = {Oxide} type = isotropic time = 1 rate= {0.54<nm/min>}
struct tdr= V@Version@_30_ThinGOX_deposition; #

#------------ HfO2 ALD
deposit material= {HfO2} type= anisotropic time= 1 rate= {$THfO2<nm/min>}
struct tdr= V@Version@_31_HfO2_deposition; #

# ------------METAL GATE RESIST MASK
mask name = metalgate_mask negative segments = {0.009 1}
photo mask = metalgate_mask thickness = 150<nm>
struct tdr= V@Version@_32_MetalGate_mask; #

# ------------TiN METAL GATE - LIFT OFF
deposit material= {TiN} type= anisotropic time= (@TiN_thick@) rate= {1<nm/min>}
#if {@TiN_thick@ < 20}
deposit material= {Tungsten} type= anisotropic time=(20-@TiN_thick@) rate= {1<nm/min>}
#endif
struct tdr= V@Version@_33_TiN_deposition; #
strip Photoresist
struct tdr= V@Version@_34_LiftOff; #

# ------------SELF ALIGNING CONTACTS
#photo mask = metalgate_mask thickness = 150<nm>
deposit material= {Nitride} type= isotropic time= (20) rate= {1<nm/min>}
#strip Photoresist
struct tdr= V@Version@_35_SAC; #

# ------------PLANARIZATION CMP
etch type=cmp coord=-0.06 material=all 
struct tdr= V@Version@_36_CMP; #
deposit material= {Oxide} type= isotropic time= 1 rate= {0.05}
struct tdr= V@Version@_37_ILD

# ------------CONTACTS MASK AND ETCHING
mask name = contacts_mask segments = {0.05 0.08}
photo mask = contacts_mask thickness = 150<nm>
etch material= all type= anisotropic time= 1 rate= {0.1}
etch material= {Nitride} type= anisotropic time= 2 rate= {0.1}
struct tdr= V@Version@_38_Contact_mask; #
etch material= {Oxide} type= anisotropic time= 3 rate= {0.2}
struct tdr= V@Version@_39_Contact_etch; #

# ------------CONTACT PLUGS
deposit material= {Tungsten} type= anisotropic time= 1 rate= {100<nm/min>}
struct tdr= V@Version@_40_Plugs; #
strip Photoresist
struct tdr= V@Version@_41_Plugs_LiftOff; #

# ------------FINAL PLANARIZATION
etch type=cmp coord=-0.11 material=all 
struct tdr= V@Version@_42_Final_CMP; #
transform reflect left
struct tdr= V@Version@_43_FINAL

#-------------CONTACTS DEFINITION
contact bottom name = substrate Silicon
#if {@TiN_thick@ < 20}
contact name = gate x = -0.046 y = 0.0 Tungsten
#else
contact name = gate x = -0.046 y = 0.0 TiN
#endif
contact name = source x = -0.1 y = -0.065 Tungsten
contact name = drain x = -0.1 y = 0.065 Tungsten
struct tdr= V@Version@_44_Presimulation

