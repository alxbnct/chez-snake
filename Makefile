scheme=scheme
LIBDIRS=D:\home\src\chez-sdl\lib
all: events.ss
	$(scheme) --libdirs $(LIBDIRS) --script events.ss
