#---------------------------------------------------------------------------#
fset Ymin 0.0
fset Ymax 0.4<um>
puts "Y domain: $Ymin $Ymax"
#---------------------------------------------------------------------------#
#rem #---------------------------------------------------------------------#
#rem #   PARAMETERS
#rem #---------------------------------------------------------------------#
fset f 1.0
fset Lsp   0.0088
fset SOI_depth  0.006			
fset Lg2        0.016/2.0
fset Yspacer [expr ($Lg2+$Lsp)]
fset epi_thick  0.016
fset epi_temp   740
fset NiSi_thick 0.019
fset HGate 40 <nm>
fset THF 0.6 <nm>
#------------------------------------------------------------------------
math coord.ucs
line x location= 0.0 spacing= 1.0<nm> tag= SiTop
line x location= 50.0<nm> spacing= 10.0<nm>
line x location= 0.5<um> spacing= 50.0<nm> 
line x location= 2.0<um> spacing= 0.2<um> tag= SiBottom
line y location= 0.0 spacing= 50.0<nm> tag= Mid
line y location= 0.40<um> spacing=50.0<nm> tag= Right
#-------------------------------------------------------------------------
region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right
init concentration= 1.0e+16<cm-3> field= Boron
AdvancedCalibration
struct tdr = 0_Bulk;
# BOX
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7
diffuse temperature= 850<C> time= 1.0<min> O2
deposit Oxide type=isotropic thickness=20.0<nm>
diffuse temperature=900<C> time=40<min>
struct tdr = 1_BOX;
deposit Silicon type=isotropic thickness=7.0<nm> Boron concentration= 1.0e+16<cm-3>
struct tdr = 2_Thin_Silicon;
# BORON IMPLANTATION
implant Boron dose= 2.0e14<cm-2> energy= 100<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate.plx y=0.0 Silicon
implant Boron dose= 1.0e14<cm-2> energy= 20<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate1.plx y=0.0 Silicon
implant Boron dose= 2.3e13<cm-2> energy= 10<keV> tilt= 0 rotation= 0
SetPlxList {BTotal}
WritePlx n@node@_NMOS_substrate2.plx y=0.0 Silicon
struct tdr = 3_Channel_Doping;
# GATE OXIDE
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 0.5e-7
pdbSet Grid NativeLayerThickness 0.5e-7
diffuse temperature= 850<C> time= 0.5<min> O2
struct tdr = 4_Dummy_Gate_Oxide;
# --------- STI ------------------
# STI_width = 70nm
# STI_AR = 8
# halfActiveArea = 400nm
# STI_depth = STI_width*STI_AR = 200nm
deposit material = {Nitride} type = isotropic thickness = 50<nm>
struct tdr = 5_STI_Nitride;
mask name = STI_mask segments = {300<nm> (300+70)<nm>}
photo mask = STI_mask thickness = 150<nm>
struct tdr= 6_STI_Mask;
etch material = {Nitride Oxide} type = anisotropic time = 1 rate = {60<nm/min>}
etch material = all type = polygon polygon = {1<nm> 300<nm> 200<nm> 310<nm> 200<nm> 360<nm> 1<nm> 370<nm>}
struct tdr= 7_STI_Etching;
strip Photoresist
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7
diffuse temperature= 850<C> time= 10.0<min> O2
struct tdr = 8_STI_Reox
deposit material = Oxide type = isotropic time = 1 rate = {300<nm/min>}
struct tdr = 9_STI_Filled
etch type = cmp material = all coord = -30<nm>
struct tdr = 10_STI_CMP
etch type = isotropic material = Nitride time = 1 rate = {100<nm/min>}
struct tdr = 11_STI_Final
#---------------------------------------------------------------------
# POLY
deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.04}
mask name= gate_mask left=-1 right= 8<nm>
etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.05} \
mask= gate_mask
struct tdr= 12_DummyGate_Etching;
etch material= {Oxide} type= anisotropic time= 1 rate= {0.1}
struct tdr= 13_ExcessOx_Etching;
diffuse temperature= 900<C> time=5.0<min> O2
struct tdr= 14_PolyReox ; # Poly Reox
#------------------------------------------------------------------------------
# LLD Standard Here vvvv
#--- Nitride Spacer ----------------------------------------------------------#
deposit material= {Nitride} type= isotropic time= 1 rate= {$Lsp}
struct tdr= 15_SpacerDeposition;# Spacer deposition
etch material= {Nitride} type= anisotropic time = 1.2 rate= {$Lsp}
struct tdr= 16_SpacerEtching;# Spacer etch
#deposit material= {oxide} type = isotropic rate= 0.001 time= 1.0 selective.material= PolySilicon
#struct tdr= n@node@_NMOS6; #
mask name= PolyReox_mask negative left=-1 right= 13<nm>
photo mask= PolyReox_mask thickness= 150<nm>
etch material= {oxide} type= anisotropic time= 1 rate= {35<nm/min>} 
strip Photoresist
struct tdr= 16_2_OxEtching;# Spacer etch
#--- RSD Epitaxy -------------------------------------------------------------#
refinebox name= RSD \
  min= "-0.025 $Ymin" max= "$SOI_depth $Ymax" \
  xrefine= " 0.002*$f"  yrefine= " 0.002*$f " Silicon
  
grid remesh
## ---------- in-situ P Doped Si RSD -----------------------------------
set EpiDoping_init  "Phosphorus= 5.5e20"
pdbSet Grid AnisotropicGrowth 1
temp_ramp name= epi temperature= 550<C> t.final= $epi_temp<C> time= 1.0<min> Epi thick= $epi_thick<um>  \
epi.doping= $EpiDoping_init \
epi.layers= 10 epi.model= 1 
diffuse temp_ramp= epi
struct tdr= 17_RSD_Epitaxy;# RSD Epi

fset Yr [expr $Yspacer+$epi_thick*0.9*cos(atan(1.0)*54.7/45.0)]
mask name= EpiT segments= {$Ymin $Yr}

deposit material= {Photoresist} type= anisotropic time= 1.0 rate= 0.05 mask= EpiT
struct tdr= 18_FacetedRSD_Mask; #

etch material= {Silicon}  type= directional rate= {$epi_thick+0.001} time= 1 \
     direction= { sin(atan(1.0)*54.7/45.0) -1*cos(atan(1.0)*54.7/45.0) 0 }
strip Photoresist
struct tdr= 19_FacetedRSD_Etch; #

##etch material= {Silicon} type= isotropic time= 1.0 rate= 0.0015
#struct tdr= n@node@_NMOS10; #


## -------RTA-----------------
temp_ramp name= spike time= 1.0<s> temp= 600  t.final= 1050<C>
temp_ramp name= spike time= 1.0<s> temp= 1050<C> ramprate= 0.0<C/s>
temp_ramp name= spike time= 1.5<s> temp= 1050 t.final= 650<C>
diffuse temp_ramp= spike 
struct tdr= 20_LDD_Implant; #
# -------------------------------------------------------------------- #
SetPlxList {PTotal}
WritePlx n@node@_anneal_sde.plx y= 0.01 Silicon
SetPlxList {PTotal}
WritePlx n@node@_anneal_sd.plx y= [expr 0.2-($Lg2-0.01)] Silicon
SetPlxList {BTotal}
WritePlx n@node@_anneal_sub.plx y= 0.0 Silicon
# -------------------------------------------------------------------- #

#-----------------------------------------------------------------------------------

#------------------- START GATE STACK ----------------------------------------------
# HIGH CONFORMING THIN OXIDE DRY OXIDATION FOR FOX GROWTH
grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5
pdbSet Oxide Grid perp.add.dist 1e-7
pdbSet Grid NativeLayerThickness 1e-7
diffuse temperature= 700<C> time= 1.0<min> O2 
struct tdr= 25_Planariz_Seed_Layer ; #
# OXIDE CVD FOR PLANARIZATION
deposit material= {Oxide} type= isotropic time= 1 rate= {0.2}
struct tdr= 26_Planariz_Depo; #
# PLANARIZATION CMP AND POLY EXPOSURE
etch type=cmp coord=-1*65<nm> material=all 
struct tdr= 27_Planariz_CMP; #
# DUMMY GATE REMOVAL
etch material= {PolySilicon} type= isotropic time= 2 rate= {0.1}
struct tdr= 28_Dummy_Gate_etch; #
# DUMMY GATE OXIDE REMOVAL
etch material= {Oxide} type= isotropic time= 1.5 rate= {4<nm/min>}
struct tdr= 29_DummyGateOxide_etch; #
# THIN GOX FOR HfO2 ALD
#grid set.min.normal.size= 0.1<nm> set.normal.growth.ratio.2d= 1
#mgoals accuracy= 0.1<nm>
pdbSet Oxide Grid perp.add.dist 1e-8
pdbSet Grid NativeLayerThickness 0
diffuse temperature= 800<C> time= 3<min> O2
struct tdr= 30_ThinGOX_deposition; #
# HfO2 ALD
deposit material= {HfO2} type= isotropic time= 0.6 rate= {1<nm/min>}
struct tdr= 31_HfO2_deposition; #
# METAL GATE RESIST MASK
mask name = metalgate_mask negative segments = {0.009 1}
photo mask = metalgate_mask thickness = 150<nm>
struct tdr= 32_MetalGate_mask; #
# TiN METAL GATE - LIFT OFF
deposit material= {TiN} type= anisotropic time= 11 rate= {10<nm/min>}
struct tdr= 33_TiN_deposition; #
strip Photoresist
struct tdr= 34_LiftOff; #
# SELF ALIGNING CONTACTS
deposit material= {Nitride} type= isotropic time= 1 rate= {0.2}
struct tdr= 35_SAC; #
# PLANARIZATION CMP
etch type=cmp coord=-0.05 material=all 
struct tdr= 36_CMP; #
# CONTACTS MASK AND ETCHING
mask name = contacts_mask segments = {0.05 0.35}
photo mask = contacts_mask thickness = 150<nm>
etch material= all type= anisotropic time= 1 rate= {0.1}
etch material= {Nitride} type= anisotropic time= 2 rate= {0.1}
struct tdr= 37_Contact_mask; #
etch material= {Oxide} type= anisotropic time= 3 rate= {0.2}
struct tdr= 38_Contact_etch; #
# CONTACT PLUGS
deposit material= {Tungsten} type= anisotropic time= 1 rate= {250<nm/min>}
struct tdr= 39_Plugs; #
strip Photoresist
struct tdr= 40_Plugs_LiftOff; #
# FINAL PLANARIZATION
etch type=cmp coord=-0.06 material=all 
struct tdr= 41_Final_CMP; #
transform reflect left
struct tdr = 42_FINAL


