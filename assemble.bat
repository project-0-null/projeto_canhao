@echo off

nasm16 -f obj %1.asm -o %1.obj


nasm16 -f obj %2.asm -o %2.obj


freelink %1.obj %2.obj

echo feito
