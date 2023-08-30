#!/bin/sh

set -xe

nasm -felf64 -g ./calculator.asm
ld -o calculator ./calculator.o
