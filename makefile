src = /test/test_build

main_source = .$(src)/main.c
mods_high = .$(src)/mods_high/myModulio.c .$(src)/mods_high/myOtherModulio.c 
mods_low = .$(src)/mods_low/_integer.c .$(src)/mods_low/_stream.c

compile:
	 gcc -nostdlib -o main $(main_source) $(mods_high) $(mods_low)