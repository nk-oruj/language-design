src = /test/test_build

compile:
	 gcc -nostdlib -o main -I$(src) .$(src)/main.c .$(src)/myModulio.c .$(src)/_integer.c .$(src)/_stream.c