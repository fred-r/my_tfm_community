#!/usr/bin/env bash
#******************************************************************************
#  * @attention
#  *
#  * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
#  * All rights reserved.</center></h2>
#  *
#  * This software component is licensed by ST under BSD 3-Clause license,
#  * the "License"; You may not use this file except in compliance with the
#  * License. You may obtain a copy of the License at:
#  *                        opensource.org/licenses/BSD-3-Clause
#  *
#  ******************************************************************************

echo "TFM UPDATE started"
sn_option=""
if [ $# -eq 1 ]; then
sn_option="sn=$1"
fi
# Absolute path to this script
SCRIPT=$(readlink -f $0)
# Absolute path this script
SCRIPTPATH=`dirname $SCRIPT`
BINPATH="$SCRIPTPATH/bin"
PATH="/C/Program Files/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/":$PATH
stm32programmercli="STM32_Programmer_CLI"
# part ot be updated according to flash_layout.h
slot0=0xc038000
slot1=0xc098000
slot2=0x70000000
slot3=0x70068000
its=0xc034000
sst=0xc030000
scratch=0xc000000
nvcounter=0xc02c000
boot=0xc012000
nvmcnt=0xc010000
prov=0xc02b000
unused=0xc118000
#select external flash according to slot2 value
u5=0x70000000
l5=0x90000000
if [ $slot2 == $u5 ]; then
external_loader="C:\PROGRA~1\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\ExternalLoader\MX25LM51245G_STM32U585I-IOT02A.stldr"
fi
if [ $slot2 == $l5 ]; then
external_loader="C:\PROGRA~1\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\ExternalLoader\MX25LM51245G_STM32L562E-DK.stldr"
fi
connect_no_reset="-c port=SWD "$sn_option" mode=UR -el $external_loader"
connect="-c port=SWD "$sn_option" mode=UR --hardRst -el $external_loader"

echo "Write TFM_Appli Secure"
# part ot be updated according to flash_layout.h

$stm32programmercli $connect -d $BINPATH/tfm_s_signed.bin $slot0 -v
echo "TFM_Appli Secure Written"
echo "Write TFM_Appli NonSecure"
$stm32programmercli $connect -d $BINPATH/tfm_ns_signed.bin $slot1 -v
echo "TFM_Appli NonSecure Written"
echo "Write TFM_SBSFU_Boot"
$stm32programmercli $connect -d $BINPATH/bl2.bin $boot -v
echo "TFM_SBSFU_Boot Written"
echo "TFM_UPDATE Done"