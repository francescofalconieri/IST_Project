File
{
*INPUT FILES
Grid ="V@Version@_44_Presimulation_fps.tdr"
* physical parameters
Parameter = "sdevice.par"

*OUTPUT FILES
Plot = "V@Version@_ID_VDS.tdr"
* electrical characteristics at the electrodes
Current= "V@Version@_ID_VDS.plt"
Plot = "V@Version@_ID_VDS.dat"

}

Electrode
{
{ name="source" Voltage=0.0 }
{ name="drain" Voltage=0.0 }
{ name="gate" Voltage=0.0 }
{ name="substrate" Voltage=0.0}
}

Thermode
{
{ Name = "source" Temperature = 300 }
{ Name = "drain" Temperature = 300 }
{ Name = "gate" Temperature = 300 }
{ Name = "substrate" Temperature = 300 }
}

*Physics(MaterialInterface="Silicon/Oxide") {
*	GateCurrent( DirectTunneling )
*}
*Physics(MaterialInterface="HfO2/Oxide") {
*	GateCurrent( DirectTunneling )
*}

Physics
{
eQuantumPotential
EffectiveIntrinsicDensity( BandGapNarrowing(oldSlotboom) )
Mobility( DopingDep 
	eHighFieldSaturation ( GradQuasiFermi)
	hHighFieldSaturation ( GradQuasiFermi)
	Enormal )
Recombination (
	SRH (DopingDep TempDependence)
	Band2Band(Model = NonLocalPath)
	)
eBarrierTunneling "NLM" hBarrierTunneling "NLM"
}


Plot
{
eDensity hDensity eCurrent hCurrent
ElectricField eEnormal hEnormal
eQuasiFermi hQuasiFermi
Potential Doping SpaceCharge
eMobility hMobility eVelocity hVelocity
DonorConcentration AcceptorConcentration
Doping
BandGap BandGapNarrowing ElectronAffinity
ConductionBandEnergy ValenceBandEnergy
eQuantumPotential
Band2BandGeneration
}


Math
{
Extrapolate
* use full derivatives in Newton method
Derivatives
* control on relative and absolute errors
RelErrControl
* relative error= 10^(-Digits)
Digits=5
* absolute error
Error(electron)=1e8
Error(hole)=1e8
* numerical parameter for space-charge regions
eDrForceRefDens=1e10
hDrForceRefDens=1e10
Notdamped=50
* maximum number of iteration at each step
Iterations=100
ExitOnFailure
* solver of the linear system
Method=ParDiSo
Wallclock
NoSRHperPotential
*Non Local MEsh for tunneling
Nonlocal "NLM" (Electrode="gate" Length=40e-7)
}

Solve
{
coupled {Poisson}
coupled{ Poisson Electron Hole }

quasistationary (InitialStep = 0.01 MaxStep = 0.01 MinStep=1e-5
Goal {name= "gate" voltage = @Vdd@}
plot { range=(0, 1) intervals=1 }
){coupled { Poisson  Electron Hole }}

quasistationary (InitialStep = 1e-2 MaxStep = 0.001 MinStep=1e-5
Goal {name= "drain" voltage = @Vdd@}
plot { range=(0, 1) intervals=3 }
){coupled { Poisson Electron Hole } }

}
