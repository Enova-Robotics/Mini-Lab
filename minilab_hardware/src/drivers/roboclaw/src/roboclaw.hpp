// roboclaw.hpp
// 

#ifndef ROBOCLAW_HPP
#define ROBOCLAW_HPP

class RoboClaw
{
public:
  RoboClaw(int address=128): _address(address), tx_len(0), rx_len(0) {};
  ~RoboClaw() {};
  
  int init(std::string device, int baudrate, int timeout_us=100e3);
  int read_firmware();
  float get_power_voltage();
  float get_logic_voltage();
  long long get_encoder_left();
  long long get_encoder_right();
  long long get_velocity(int motor_id);
  int reset_encoders();
  int set_PID_parameters(int motor_id, int P, int I, int D, int Vmax);
  int drive_with_constant_speed(int motor_id, int velocity);

private:
  Serial  serial;
  uint8_t tx_buf[64];
  uint8_t rx_buf[256];
  int tx_len;
  int rx_len;
  uint8_t _address;
  int _reply_delay_factor;   // us

  int checksum()
  {
    int cks=0;
    for(size_t i=0; i<tx_len-1;i++)
      cks += tx_buf[i];
    return (cks & 0x7F);
  }
};


#endif
