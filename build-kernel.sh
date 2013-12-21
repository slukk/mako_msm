#!/bin/bash
# Copyright (C) 2013 MartinRo
# credits to sparksco for the SaberMod kernel buildscript as base
# Build Script. Use bash to run this script, bash mako-kernel from source directory
export MANUFACTURER=lge;
export DEVICE=mako;

# GCC
export CC=$HOST_CC;
export CXX=$HOST_CXX;
export USE_CCACHE=1

# Source Directory PATH
#export DIRSRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )";


# Kernel Source PATH
#export KERNELSRC=$DIRSRC;

# Target gcc version
export TARGET_GCC=4.8;

#the following lines one have some effect if you use 4.8 as TARGET_GCC
#if you want to use cfx, uncomment next line
export TARGET_GCC_SUB=cfx;

#default one : googles toolchain. comment it out if you want to use different one
#export TARGET_GCC_SUB=google; 

#if you want to use the old sabermod toolchain from github, uncomment the next line
#export TARGET_GCC_SUB=sm_old;

#if you want to use the most current sabermod toolchain from sourceforge, uncomment the next line
#export TARGET_GCC_SUB=sm_new;


if [ $TARGET_GCC == "4.8" ];
then
    if [ -z "$TARGET_GCC_SUB" ];
    then
        export TARGET_GCC_SUB=google;
    fi;
    export ARM_EABI_TOOLCHAIN=../../../prebuilts/gcc/linux-x86/arm/arm-eabi-$TARGET_GCC/$TARGET_GCC_SUB;
else  
    export ARM_EABI_TOOLCHAIN=../../../prebuilts/gcc/linux-x86/arm/arm-eabi-$TARGET_GCC;
fi;
export PATH=$PATH:$ARM_EABI_TOOLCHAIN/bin:$ARM_EABI_TOOLCHAIN/arm-eabi/bin;

 echo 'Kernel buid with ' $ARM_EABI_TOOLCHAIN;

# Build ID
export LOCALVERSION="-PSK-V3"
export KBUILD_BUILD_USER=PSX
export KBUILD_BUILD_HOST="PURE-SPEED-KERNEL"

# Cross compile with arm
export ARCH=arm;
export CCOMPILE=$CROSS_COMPILE;
export CROSS_COMPILE=$ARM_EABI_TOOLCHAIN/bin/arm-eabi-;

# Start the build
echo "";
echo "Starting the kernel build";
echo "";
#cd $KERNELSRC
if [ -e ./arch/arm/boot/zImage ] ;
then
    rm ./arch/arm/boot/zImage;
fi;

make mako_defconfig;
time make -j8;

if [ -e ./arch/arm/boot/zImage ] ;
then
 cp ./arch/arm/boot/zImage -f ../../../device/lge/mako-kernel/kernel;
 echo "Kernel build finished, Continuing with ROM build";
 echo "";
else
    echo "";
    echo "error detected in kernel build, now exiting";
    exit 1;
fi;
