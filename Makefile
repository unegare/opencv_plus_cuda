.PHONY: all
all: main

main: main.o libfilt_001.so
	g++ ./main.o -L./ -lfilt_001 -L/usr/local/lib -lopencv_core -lopencv_highgui -lopencv_videoio -Wl,-rpath,. -o main
#	nvcc ./main.o -L./ -lfilt_001 -L/usr/local/lib -lopencv_core -lopencv_highgui -lopencv_videoio --linker-options -rpath,. -o main

main.o: main.cpp libfilt_001.h
	g++ -std=c++14 -O2 -c ./main.cpp -I/usr/local/include/opencv4/
#	nvcc -std=c++14 -c ./main.cpp -I/usr/local/include/opencv4/

libfilt_001.so: libfilt_001.cu libfilt_001.h
	nvcc -std=c++14 -O2 -c libfilt_001.cu -I/usr/local/include/opencv4/ --compiler-options -fPIC
	nvcc -shared libfilt_001.o -o ./libfilt_001.so

.PHONY: clean
clean:
	rm -rf main ./*.o ./*.so
