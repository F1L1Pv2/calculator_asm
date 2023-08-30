#!/bin/sh

set -xe

nasm -felf64 -g ./parse_buff.asm
ld -o parse_buff ./parse_buff.o
