// test.cpp
// 

#include <cstdlib>
#include <cstdio>
#include <string>
#include <stdint.h>
#include <unistd.h>
#include <ros/ros.h>

#include "serial.hpp"
#include "roboclaw.hpp"


long long value_right = 0;
long long value_left = 0;
long long prev_value_right = 0;
long long prev_value_left = 0;
int status_right = 0;
int status_left = 0;
// ---------------------------------------------------------------------------
int RoboClaw::init(std::string device, int baudrate, int timeout_us)
{
  if(serial.connect(device)) {
    printf("Serial error: Cannot open %s\n", device.c_str());
    return 1;
  }
  if(serial.set_baudrate(baudrate)) {
    printf("Serial error: Invalide Baudrate\n");
    return 1;
  }

  // Responce delay related to RoboClaw firmware
  _reply_delay_factor = (int)(6*1e6*10/(float)baudrate);
  printf("Delay = %i\n", _reply_delay_factor);

  serial.set_timeout(timeout_us);
  return 0;
}

// ---------------------------------------------------------------------------
int RoboClaw::read_firmware()
{
  tx_len = 3;
  tx_buf[0] = _address;   // Address
  tx_buf[1] = 21;         // Registre
  tx_buf[2] = checksum();
    
  serial.write_buffer(tx_buf, tx_len);
  usleep(32*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 32);
  printf("Version : %s", rx_buf);
  return 0;
}

// ---------------------------------------------------------------------------
float RoboClaw::get_power_voltage()
{
  tx_len = 3;
  tx_buf[0] = _address;   // Address
  tx_buf[1] = 24;         // Registre
  tx_buf[2] = checksum();
    
  serial.write_buffer(tx_buf, tx_len);
  usleep(3*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 3);
  //printf("rx_len=%i\n", rx_len);
  if(rx_len != 3)
    return 0.0;
    
  int value = (rx_buf[0]<<8) + rx_buf[1];
  //printf("%i\n",value);
  return (float)value/10.;
}    

// ---------------------------------------------------------------------------
float RoboClaw::get_logic_voltage()
{
  tx_len = 3;
  tx_buf[0] = _address;   // Address
  tx_buf[1] = 25;         // Registre
  tx_buf[2] = checksum();
    
  serial.write_buffer(tx_buf, tx_len);
  usleep(3*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 3);
    
  if(rx_len != 3)
    return 0.0;

  int value = (rx_buf[0]<<8) + rx_buf[1];
  return (float)value/10.;
}    

// ---------------------------------------------------------------------------
long long RoboClaw::get_encoder_left()
{
  tx_len=3;
  tx_buf[0] = _address;       // card addr
  tx_buf[1] = 17;          // cmd = {16, 17}
  tx_buf[2] = checksum();

  serial.write_buffer(tx_buf, tx_len);
  usleep(6*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 6);
  
  //Wassim : Removing length check, caused some jumps.   
  /*if(rx_len != 6)
    return 0;*/
  
  status_left = 0;
  status_left = rx_buf[4];
  if (status_left & 00000010) 
  	ROS_WARN("Direction change");
  if (status_left & 00000001) 
  	ROS_WARN("Underflow");
  if (status_left & 00000100) 
  	ROS_WARN("Overflow");

  value_left = 0;
  value_left = (rx_buf[0]<<24) 
    + (rx_buf[1]<<16)
    + (rx_buf[2]<<8)
    + (rx_buf[3]);
  if (abs(value_left-prev_value_left) > 50000)
  {
  	return prev_value_left;
  }  
  ROS_INFO("RBRW left = %llu", value_left);
  prev_value_left = value_left;
  return value_left;
}

// ---------------------------------------------------------------------------
long long RoboClaw::get_encoder_right()
{
  tx_len=3;
  tx_buf[0] = _address;       // card addr
  tx_buf[1] = 16;          // cmd = {16, 17}
  tx_buf[2] = checksum();

  serial.write_buffer(tx_buf, tx_len);
  usleep(6*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 6);
  
  //Wassim : Removing length check, caused some jumps.   
  /*if(rx_len != 6)
    return 0;*/
  
  status_right = 0;
  status_right = rx_buf[4];
  if (status_right & 00000010) 
  	ROS_WARN("Direction change");
  if (status_right & 00000001) 
  	ROS_WARN("Underflow");
  if (status_right & 00000100) 
  	ROS_WARN("Overflow");

  value_right = 0;
  value_right = (rx_buf[0]<<24) 
    + (rx_buf[1]<<16)
    + (rx_buf[2]<<8)
    + (rx_buf[3]);
  if (abs(value_right-prev_value_right) > 50000)
  {
  	return prev_value_right;
  }    

  ROS_INFO("RBRW right = %llu", value_right);
  prev_value_right = value_right;
  return value_right;
}

// ---------------------------------------------------------------------------
long long RoboClaw::get_velocity(int motor_id)
{
  uint8_t id   = (uint8_t)(motor_id & 0x01);        // motor_id = {0,1}
  tx_len=3;
  tx_buf[0] = _address;       // card addr
  tx_buf[1] = id+18;          // cmd = {18, 19}
  tx_buf[2] = checksum();

  serial.write_buffer(tx_buf, tx_len);
  usleep(6*_reply_delay_factor);
  rx_len = serial.read_buffer(rx_buf, 6);
    
  if(rx_len != 6)
    return 0;
  long long value =0;      
  value = (rx_buf[0]<<24) 
    + (rx_buf[1]<<16)
    + (rx_buf[2]<<8)
    + (rx_buf[3]);
    
  return value;
}

// ---------------------------------------------------------------------------
int RoboClaw::reset_encoders()
{
  tx_len=3;
  tx_buf[0] = _address;     // card addr
  tx_buf[1] = 20;           // cmd = 20
  tx_buf[2] = checksum();

  serial.write_buffer(tx_buf, tx_len);
  return 0;
}


// ---------------------------------------------------------------------------
int RoboClaw::set_PID_parameters(int motor_id, int P, int I, int D, int Vmax)
{
  uint8_t id   = (uint8_t)(motor_id & 0x01);        // motor_id = {0,1}

  tx_len=19;
  tx_buf[0] = _address;       // card addr
  tx_buf[1] = 28+id;          // cmd = {28, 29}
  tx_buf[2] = (D >> 24) & 0xFF;
  tx_buf[3] = (D >> 16) & 0xFF;
  tx_buf[4] = (D >> 8) & 0xFF;
  tx_buf[5] = (D ) & 0xFF;

  tx_buf[6] = (P >> 24) & 0xFF;
  tx_buf[7] = (P >> 16) & 0xFF;
  tx_buf[8] = (P >> 8) & 0xFF;
  tx_buf[9] = (P) & 0xFF;

  tx_buf[10] = (I >> 24) & 0xFF;
  tx_buf[11] = (I >> 16) & 0xFF;
  tx_buf[12] = (I >> 8) & 0xFF;
  tx_buf[13] = (I) & 0xFF;

  tx_buf[14] = (Vmax >> 24) & 0xFF;
  tx_buf[15] = (Vmax >> 16) & 0xFF;
  tx_buf[16] = (Vmax >> 8) & 0xFF;
  tx_buf[17] = (Vmax) & 0xFF;

  tx_buf[18]= checksum();

  serial.write_buffer(tx_buf, tx_len);
  return 0;  
}

// ---------------------------------------------------------------------------
int RoboClaw::drive_with_constant_speed(int motor_id, int velocity)
{
  uint8_t id   = (uint8_t)(motor_id & 0x01);        // motor_id = {0,1}

  tx_len=7;
  tx_buf[0] = _address;       // card addr
  tx_buf[1] = 35+id;          // cmd = {35, 36}
  tx_buf[2] = (velocity >> 24) & 0xFF;
  tx_buf[3] = (velocity >> 16) & 0xFF;
  tx_buf[4] = (velocity >> 8) & 0xFF;
  tx_buf[5] = (velocity) & 0xFF;
  tx_buf[6]= checksum();

  serial.write_buffer(tx_buf, tx_len);
  return 0;
    
}

