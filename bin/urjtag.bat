@echo off
if '%1' == '' (
  echo Usage: %0 svf_file [cable]
  echo Default cable: UsbBlaster.
  echo.
  echo   List of supported cables:
  echo     ARCOM         Arcom JTAG Cable
  echo     ByteBlaster   Altera ByteBlaster/ByteBlaster II/ByteBlasterMV Parallel Port Download Cable
  echo     UsbBlaster    Altera USB-Blaster Cable
  echo     FT2232        Generic FTDI FT2232 Cable
  echo     JTAGkey       Amontec JTAGkey ^(FT2232^) Cable
  echo     ARM-USB-OCD   Olimex ARM-USB-OCD[-TINY] ^(FT2232^) Cable
  echo     gnICE         Analog Devices Blackfin gnICE ^(FT2232^) Cable ^(EXPERIMENTAL^)
  echo     OOCDLink-s    OOCDLink-s ^(FT2232^) Cable ^(EXPERIMENTAL^)
  echo     Signalyzer    Xverve DT-USB-ST Signalyzer Tool ^(FT2232^) Cable ^(EXPERIMENTAL^)
  echo     Turtelizer2   Turtelizer 2 Rev. B ^(FT2232^) Cable ^(EXPERIMENTAL^)
  echo     USB-to-JTAG-IF USB to JTAG Interface ^(FT2232^) Cable ^(EXPERIMENTAL^)
  echo     Flyswatter    TinCanTools Flyswatter ^(FT2232^) Cable
  echo     usbScarab2    KrisTech usbScarabeus2 ^(FT2232^) Cable
  echo     DLC5          Xilinx DLC5 JTAG Parallel Cable III
  echo     EA253         ETC EA253 JTAG Cable
  echo     EI012         ETC EI012 JTAG Cable
  echo     IGLOO         Excelpoint IGLOO JTAG Cable
  echo     KeithKoep     Keith ^& Koep JTAG cable
  echo     Lattice       Lattice Parallel Port JTAG Cable
  echo     MPCBDM        Mpcbdm JTAG cable
  echo     TRITON        Ka-Ro TRITON Starterkit II ^(PXA255/250^) JTAG Cable
  echo     WIGGLER       Macraigor Wiggler JTAG Cable
  echo     WIGGLER2      Modified ^(with CPU Reset^) WIGGLER JTAG Cable
  echo     xpc_int       Xilinx Platform Cable USB internal chain
  echo     xpc_ext       Xilinx Platform Cable USB external chain
  echo     jlink         Segger/IAR J-Link, Atmel SAM-ICE and others.
  exit 255
)

set urjtag="%~dp0..\urjtag\jtag.exe"
if not exist %urjtag% (
  echo Urjtag is not found in the path. Please check your installation.
  exit 255
)

set progress="progress"
if '%1' == '-q' (
  set progress=""
  shift
)
set svf_file=%1
set cable=UsbBlaster
if '%2' NEQ '' set cable=%2

set rc_file="%~dp1jtag.rc"
echo cable %cable% > %rc_file%
echo addpart 10 >> %rc_file%
echo svf %svf_file% %progress% stop retry=0 >> %rc_file%
%urjtag% -n %rc_file%
set status=%errorlevel%
del %rc_file%

exit %status%
