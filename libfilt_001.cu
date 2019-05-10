#include <iostream>
#include <cstdio>
#include "libfilt_001.h"

__global__ void kernel (uchar *arr, int rows, int cols) {
	int tid = (threadIdx.x + blockIdx.x * blockDim.x)*3;
	int step = gridDim.x * blockDim.x * 3;
	int N = rows * cols * 3;
	while (tid < N) {
		arr[tid] = 255;//(arr[tid] + arr[tid +1] + arr[tid +2])/3;
//		if ((tid%rows)%20 < 10) {
//			arr[tid] = 255;
//			arr[tid +1] = 0;
//			arr[tid +2] = 0;
//		} else {
//			arr[tid] = 255;
//			arr[tid +1] = 255;
//			arr[tid +2] = 255;
//		}
		tid += step;
	}
}

namespace _filt {
	_Dev_ptr::_Dev_ptr() : _dev_arr(NULL) {}
	_Dev_ptr::~_Dev_ptr() {
		if (_dev_arr) {
			printf ("_filt::_dev_ptr._dev_arr == %p\n", _dev_arr);
			cudaError_t err = cudaFree ( _dev_arr );
			if ( err != cudaSuccess ) {
				std::cout << "ERROR: cudaFree ( _filt::_dev_ptr._dev_arr ) : " << err << " : " << cudaGetErrorString(err) << std::endl;
			}
//			std::cout << "LOG 3" << std::endl;
		}
	}
	_Dev_ptr::operator uchar* () const {
		return _dev_arr;
	}
	_Dev_ptr::operator bool () const {
		return _dev_arr;
	}
	uchar*& _Dev_ptr::operator* () {
		return _dev_arr;
	}
	uchar* _Dev_ptr::operator* () const {
		return _dev_arr;
	}
	//_Dev_ptr _dev_ptr; // udefined behaviour in the destructor -> cudaError_t 29 "driver shutting down"
}

void filt (cv::Mat &m, _filt::_Dev_ptr *_dev_arr) {
//	static bool print = true;
	uchar *dev_arr = NULL;
	int rows(m.rows);
	int cols(m.cols);
	if (_dev_arr) {
		dev_arr = **_dev_arr;
	}
	if (dev_arr == NULL) {
		if ( cudaMalloc ( (void**)&dev_arr, rows*cols*3*sizeof(uchar) ) != cudaSuccess ) {
			std::cout << "ERROR: cudaMalloc error" << std::endl;
			return;
		}
//		std::cout << "LOG 1" << std::endl;
		if (_dev_arr) {
			**_dev_arr = dev_arr;
		}
	}
  switch (m.type()) {
    case CV_8UC3: {
//			if (print) {
//				std::cout << "CV_8UC3" << std::endl;
//				print = false;
//			}
			if ( cudaMemcpy ( dev_arr, m.data, rows*cols*3*sizeof(uchar), cudaMemcpyHostToDevice ) != cudaSuccess ) {
				std::cout << "ERROR: cudaMemcpyHostToDevice" << std::endl;
				break;
			}
			kernel<<<32,32>>> ( dev_arr, rows, cols );
			if ( cudaMemcpy ( m.data, dev_arr, rows*cols*3*sizeof(uchar), cudaMemcpyDeviceToHost ) != cudaSuccess ) {
				std::cout << "ERROR: cudaMemcpyDeviceToHost" << std::endl;
				break;
			}
      break;
    }
    default: {
      std::cout << "m.type() == " << m.type() << " is unknown" << std::endl;
    }
  }

	if (_dev_arr) {
	} else {
		if ( cudaFree ( dev_arr ) != cudaSuccess ) {
			std::cout << "ERROR: cudaFree" << std::endl;
		}
//		std::cout << "LOG 2" << std::endl;
	}
}

