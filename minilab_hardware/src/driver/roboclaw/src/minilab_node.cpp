#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <nav_msgs/Odometry.h>
#include <std_msgs/Float64.h>

#include "serial.hpp"
#include "roboclaw.hpp"

// Geometrical paramters
#define WHEEL_RADIUS (0.125/2.0)                 // m
#define Wheelbase  (0.3965)

// CPR + Gear
#define CPR_CODEUR 2048                            // tics / tr
#define GEAR_RATIO 25                              //
#define CPR_GEAR   (CPR_CODEUR*4*GEAR_RATIO)       // tics / tr (quadrature)

#define VMAX_MOT   (3000)                          // rpm
#define VMAX       ((VMAX_MOT/GEAR_RATIO)/60*CPR_GEAR)  // tics / s (quad)
#define PI         (3.145926)

// Unit conversion
//meter to tics
#define M_2_TICS   (CPR_GEAR/(2*PI*WHEEL_RADIUS))
#define M_2_TICS_90   (CPR_GEAR/(3*(PI/2)*WHEEL_RADIUS))
// tics to meter
#define TICS_2_M   (1/M_2_TICS)

// Motor disposition
#define LEFT 1
#define RIGHT 0

// Gloal variables
// long long raw_motor_encoder[2];
// long long raw_motor_encoder_TEST[2];             // motor encoders tics (quad)
// long long raw_motor_encoder_prev[2];       // previous
// long long raw_motor_delta_encoder[2];      // delta
double battery_voltage;

ros::Time current_time, last_time;
ros::Time last_cmd_vel_time;

RoboClaw *motors_driver;

void cmd_vel_cb(const geometry_msgs::Twist::ConstPtr& msg)
{
  double vx = msg->linear.x;
  double wz = msg->angular.z;

  double v_right = vx + (Wheelbase/2.)*wz;
  double v_left  = vx - (Wheelbase/2.)*wz;

  double v_right_raw =  v_right*M_2_TICS;
  double v_left_raw  =  v_left *M_2_TICS;
  

//  ROS_INFO("cmd_vel = (%.2f,%.2f) -> (%.2f,%.2f) -> (%i,%i)",
//     vx,wz, v_left, v_right, (int)v_left_raw, (int)v_right_raw);

  // Inverted rotation sign on right wheel
  motors_driver->drive_with_constant_speed(RIGHT, (int) v_right_raw);
  motors_driver->drive_with_constant_speed(LEFT, (int) v_left_raw);
  last_cmd_vel_time = ros::Time::now();
}


int main(int argc, char** argv){

  ros::init(argc, argv, "minilab_node");
  std_msgs::Float64 v_batt_msg;
  ros::NodeHandle n;
  ros::Publisher batt_volt_pub = n.advertise<std_msgs::Float64>("v_batt", 10 );
  ros::Publisher odom_pub = n.advertise<nav_msgs::Odometry>("odom", 10);
  tf::TransformBroadcaster odom_broadcaster;
  ros::Subscriber cmd_vel_sub = n.subscribe("cmd_vel_secu", 10, cmd_vel_cb);

  double x = 0.0;
  double y = 0.0;
  double th = 0.0;

  double vx = 0.0;
  double vy = 0.0;
  double vth = 0.0;
  
  //Wassim : some values here exceed 4 billions, int won't cut it
  long long raw_motor_encoder[2]={0,0};            // motor encoders tics (quad)
  long long raw_motor_encoder_prev[2]={0,0};       // previous
  long long raw_motor_delta_encoder[2]={0,0};      // delta
  long long raw_motor_encoder_TEST[2]={0,0};

  //Wassim : Need to compute vx, vy, vth before going on

  ros::Time current_time, last_time;
  current_time = ros::Time::now();
  last_time = ros::Time::now();
  last_cmd_vel_time = ros::Time::now();
  ros::Rate r(10.0);


    //Init RoboClaw
  motors_driver = new RoboClaw(128);
  if(motors_driver->init("/dev/RoboClaw", 38400, 10e3))
    return 1;
  motors_driver->read_firmware();
  printf("Power voltage : %.2f V\n", motors_driver->get_power_voltage());
  motors_driver->reset_encoders();
  for(int id=0;id<2;id++) {
    motors_driver->set_PID_parameters(id, 22100, 6100, 1500, VMAX);
    //PID_parameters = PID_constant in RoboClaw Datasheet
    //!!! Wassim:Copy pasting PID parameters here, need to be double checked
    usleep(100e3);
  }
  raw_motor_encoder_TEST[LEFT]  = motors_driver->get_encoder_left();
    usleep(100e3);
    raw_motor_encoder_TEST[RIGHT] = motors_driver->get_encoder_right();
    usleep(100e3);
  while( raw_motor_encoder_TEST[RIGHT] != 0 || raw_motor_encoder_TEST[LEFT] != 0){
  	motors_driver->reset_encoders();
    ROS_WARN("RESETTING ENCODERS");
  }
  while(n.ok()){

    ros::spinOnce();               // check for incoming messages
    current_time = ros::Time::now();

    double last_cmd_vel_dt = (current_time-last_cmd_vel_time).toSec();
    //Drives with null velocity if it exceedes 1.0;
    if(last_cmd_vel_dt>1.0) {
      motors_driver->drive_with_constant_speed(RIGHT, 0);
      motors_driver->drive_with_constant_speed(LEFT, 0);
    }


    //compute odometry in a typical way given the velocities of the robot
    double dt = (current_time - last_time).toSec();

    // Wassim: Getting encoder data for odom computing
    // Inverted rotation sign on right wheel, Wassim: Maybe need to remove that invertion actually
    raw_motor_encoder_prev[LEFT]  = raw_motor_encoder[LEFT];
    raw_motor_encoder_prev[RIGHT] = raw_motor_encoder[RIGHT];
    raw_motor_encoder[LEFT]  = +motors_driver->get_encoder_left();
    usleep(100e3);
    raw_motor_encoder[RIGHT] = +motors_driver->get_encoder_right();
    usleep(100e3);
    ROS_INFO("MNRW left = %llu", raw_motor_encoder[LEFT]);
    ROS_INFO("MNRW right = %llu", raw_motor_encoder[RIGHT]);
    raw_motor_delta_encoder[LEFT]=
      raw_motor_encoder[LEFT]-raw_motor_encoder_prev[LEFT];
    raw_motor_delta_encoder[RIGHT]=
      raw_motor_encoder[RIGHT]-raw_motor_encoder_prev[RIGHT];

  
    // Compute robot delta pos in tics
    // Wassim: Copy pasting here
    long long raw_delta_x     = (raw_motor_delta_encoder[RIGHT]
         +raw_motor_delta_encoder[LEFT])/2;
    long long raw_delta_theta = (raw_motor_delta_encoder[RIGHT]
         -raw_motor_delta_encoder[LEFT])/Wheelbase;

    //Wassim : trying to invert right and left here as it seems the encoder are inverted
    //uncomment above for normal operating
    // long long raw_delta_x     = (raw_motor_delta_encoder[LEFT]
    //      +raw_motor_delta_encoder[RIGHT])/2;
    // long long raw_delta_theta = (raw_motor_delta_encoder[LEFT]
    //      -raw_motor_delta_encoder[RIGHT])/Wheelbase;
    // Compute robot delta pos in m
    double dl  = raw_delta_x * TICS_2_M;
    double dth = raw_delta_theta * TICS_2_M;

    battery_voltage =  motors_driver->get_power_voltage();
    v_batt_msg.data = battery_voltage;
    batt_volt_pub.publish(v_batt_msg);
    ROS_INFO("Volts = %.3f", battery_voltage);
    //Checks battery voltage and shutdowns node if < 10V
   /* if (10.0 < battery_voltage < 10.30){
    	ROS_WARN("WARNING BATTERY LEVEL LOW : %f", battery_voltage);
    }
    if (battery_voltage < 10.0){
    	ROS_ERROR("WARNING CRITICAL BATTERY LEVEL  : %f", battery_voltage);
    	ros::shutdown();
    }*/
    //Wassim : need to integrate data, commenting for now
    // double delta_x = (vx * cos(th) - vy * sin(th)) * dt;
    // double delta_y = (vx * sin(th) + vy * cos(th)) * dt;
    // double delta_th = vth * dt;
    
    //Wassim : integration here
    double delta_x = dl * cos(th);
    double delta_y = dl * sin(th);
    double delta_th = dth;

    x += delta_x;
    y += delta_y;
    th += delta_th;

    ROS_INFO("x = %.2f", x);
    ROS_INFO("y = %.2f", y);
    ROS_INFO("th = %.2f", th);

    //since all odometry is 6DOF we'll need a quaternion created from yaw
    geometry_msgs::Quaternion odom_quat = tf::createQuaternionMsgFromYaw(th);

    //first, we'll publish the transform over tf
    geometry_msgs::TransformStamped odom_trans;
    odom_trans.header.stamp = current_time;
    odom_trans.header.frame_id = "odom";
    odom_trans.child_frame_id = "base_footprint";

    odom_trans.transform.translation.x = x;
    odom_trans.transform.translation.y = y;
    odom_trans.transform.translation.z = 0.0;
    odom_trans.transform.rotation = odom_quat;

    //send the transform
    odom_broadcaster.sendTransform(odom_trans);

    //next, we'll publish the odometry message over ROS
    nav_msgs::Odometry odom;
    odom.header.stamp = current_time;
    odom.header.frame_id = "odom";

    //set the position
    odom.pose.pose.position.x = x;
    odom.pose.pose.position.y = y;
    odom.pose.pose.position.z = 0.0;
    odom.pose.pose.orientation = odom_quat;

    //set the velocity
    odom.child_frame_id = "base_footprint";
    odom.twist.twist.linear.x = vx;
    odom.twist.twist.linear.y = vy;
    odom.twist.twist.angular.z = vth;

    //publish the message
    odom_pub.publish(odom);

    last_time = current_time;
    r.sleep();
  }
}
