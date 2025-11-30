@echo off

call nasm main
call nasm read_o
call nasm read_V0
call nasm graficos
call nasm simula

freelink main.obj read_o.obj read_V0.obj simula.obj graficos.obj

echo feito
