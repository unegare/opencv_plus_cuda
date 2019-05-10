#include <iostream>
#include <chrono>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "libfilt_001.h"

int main (int argc, char **argv) {
  if (argc == 1) {
    std::cout << "argv[1] is needed" << std::endl;
    return 0;
  }
  cv::VideoCapture cap;
  cap.open(argv[1]);
  cv::Mat frame;
  std::chrono::high_resolution_clock::time_point t2, t1 = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> time_span;

  _filt::_Dev_ptr dev_ptr;

  double sum = 0;
  int i = 1;

  for (; /*i < 100*/; i++)  {
    cap >> frame;
    if (frame.empty()) {
      std::cout << "frame.empty() == true" << std::endl;
      return 0;
    }
    
    filt (frame, NULL);
    
//    size_t total_X3 = frame.total()*3;
//    for (int i = 0; i < total_X3; i+=3) {
////      frame.data[i] = (frame.data[i] + frame.data[i+1] + frame.data[i+2])/3;
//      frame.data[i] = 255;
//    }

    cv::namedWindow("Example", cv::WINDOW_AUTOSIZE);
    cv::imshow("Example", frame);
    char c = (char) cv::waitKey(1);
    if (c == 27) break;
    t2 = std::chrono::high_resolution_clock::now();
    sum += (std::chrono::duration_cast<std::chrono::duration<double>> (t2 - t1)).count();
//    std::cout << sum << " ms" << std::endl;
    t1 = t2;
  }

  std::cout << "Average: " << sum/i << " ms" << std::endl;
  return 0;
}
