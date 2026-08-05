#!/usr/bin/env sh

# Amalgamate all files in one
amalg -s main.lua -o timepass.lua lib.argparse lib.json modules.fs modules.time

# Generate bytecode
luajit -b -n timepass_script timepass.lua timepass.h

# Compile script
# Edit this to match your computer's libraries :(
gcc -O2 core.c -o timepass -L/opt/homebrew/lib -lluajit-5.1 -I/opt/homebrew/include/luajit-2.1
