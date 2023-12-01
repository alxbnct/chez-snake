scheme=scheme
LIBDIRS=D:\home\src\chez-sdl\lib
all: snake.ss
	$(scheme) --libdirs $(LIBDIRS) --script snake.ss
