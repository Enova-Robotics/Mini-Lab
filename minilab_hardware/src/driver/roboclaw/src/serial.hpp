// Enove Robotics - Minilab project
// serial.cpp
//
// Serial Wrapper C++

#ifndef SERIAL_HPP
#define SERIAL_HPP

namespace SerialError
{
  const static int OpenError = 1;
  const static int UndefinedBaudrate = 2;
};

class Serial
{
public:
  Serial(): _serial_fd(-1),_timeout_us(100e3) {};
  ~Serial()
  {
    disconnect();
  }

  int connect(std::string device);
  void disconnect();
  int set_baudrate(int baudrate);
  void set_timeout(int timeout_us);
  int read_buffer(uint8_t *buffer, int length);
  int read_byte(uint8_t *value);
  int read_word(uint16_t *value);
  int read_dword(uint32_t *value);

  int write_buffer(uint8_t *buffer, int length);


private:
  int _serial_fd;
  int _timeout_us;
};

#endif
