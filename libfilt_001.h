#ifndef FILT_001_H_
#define FILT_001_H_

#include <opencv2/imgproc/imgproc.hpp>

namespace _filt {
	struct _Dev_ptr {
		uchar *_dev_arr;
		_Dev_ptr();
		~_Dev_ptr();
		operator uchar* () const;
		explicit operator bool () const;
		uchar*& operator* ();
		uchar* operator* () const;
	};
}

void filt (cv::Mat &m, _filt::_Dev_ptr *_dev_arr = NULL);

#endif
