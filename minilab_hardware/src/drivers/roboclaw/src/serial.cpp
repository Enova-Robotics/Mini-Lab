// Enove Robotics - Minilab project
// serial.cpp
//
// Serial Wrapper C++


#include <cstdlib>
#include <cstdio>
#include <string>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <sys/select.h>

#include "serial.hpp"

int Serial::connect(std::string device)
{
  int fd;
  struct termios new_tio;
  //struct termios old_tio;
  
  fd = open(device.c_str(), O_RDWR | O_NOCTTY | O_NONBLOCK);
  if (fd <0) 
    return SerialError::OpenError;

  memset((void*)&new_tio, 0, sizeof(new_tio));
  new_tio.c_cflag = CS8 | CLOCAL | CREAD;
  new_tio.c_iflag = IGNPAR;
  new_tio.c_oflag = 0;

  /* set input mode (non-canonical, no echo,...) */
  new_tio.c_lflag = 0;

  new_tio.c_cc[VTIME] = 1;   /* 0.1s inter-character timeout */
  new_tio.c_cc[VMIN]  = 1;   /* blocking read 1 */

  tcflush(fd, TCIFLUSH);
  tcsetattr(fd,TCSANOW,&new_tio);

  _serial_fd = fd;
  return 0;
}

void Serial::disconnect()
{
  if(_serial_fd>0)
    close(_serial_fd);
  _serial_fd=-1;
}

int Serial::set_baudrate(int baudrate)
{  
  struct termios options;
  int baudrate_code=0;
  
  switch(baudrate) {
  case 1200:
    baudrate_code = B1200;
    break;
  case 2400:
    baudrate_code = B2400;
    break;
  case 4800:
    baudrate_code = B4800;
    break;
  case 9600:
    baudrate_code = B9600;
    break;
  case 19200:
    baudrate_code = B19200;
    break;
  case 38400: 
    baudrate_code = B38400;
    break;
  case 57600:
    baudrate_code = B57600;
    break;
  case 115200:
    baudrate_code = B115200;
    break;
  case 230400:
    baudrate_code = B230400;
    break;
  case 460800:
    baudrate_code = B460800;
    break;
  case 500000:
    baudrate_code = B500000;
    break;
  case 576000:
    baudrate_code = B576000;
    break;
  case 921600:
    baudrate_code = B921600;
    break;
  case 1000000:
    baudrate_code = B1000000;
    break;
  default:
    return SerialError::UndefinedBaudrate;
  }

  tcgetattr(_serial_fd, &options);
  cfsetispeed(&options, baudrate_code);
  cfsetospeed(&options, baudrate_code);
  tcsetattr(_serial_fd, TCSANOW, &options);
  
  return 0;
};  

void Serial::set_timeout(int timeout_us)
{
  _timeout_us = timeout_us;
}

int Serial::read_buffer(uint8_t *buffer, int length)
{
  int res;                                                            
  fd_set readfs;                                  
  struct timeval Timeout;     

  FD_SET(_serial_fd, &readfs);
  Timeout.tv_usec = _timeout_us;
  Timeout.tv_sec  = 0;  
  res = select(_serial_fd+1, &readfs, NULL, NULL, &Timeout);                 
  if (!FD_ISSET(_serial_fd, &readfs))
    return -1;
  else
    return read(_serial_fd, buffer, length);
}

int Serial::write_buffer(uint8_t *buffer, int length)
{
  int ret;
  
  ret = write(_serial_fd, (void *)buffer, length);
  if(ret==length)
    return 0;
  else
    return 1;
}
