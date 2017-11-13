#include "ros/ros.h"
#include "sensor_msgs/Joy.h"
#include "geometry_msgs/Twist.h"
#include "ros/console.h"
#include "math.h"

/* definition class */
class MyJoy{
	
	public: 
		MyJoy(); 
		
	private: 
		ros::NodeHandle nh_; 
		ros::Publisher pub_cmd_; 
		ros::Subscriber sub_joy_; 
		
		void joyCallback(const sensor_msgs::Joy::ConstPtr& joy);
		
		int ind_joy_ang_z_, ind_joy_lin_x_, deadman_axis_; 
		float vel_ang_z_, vel_lin_x_, vel_ang_z_scale_, vel_lin_x_scale_; 	
		
}; 

/* constructeur */
MyJoy::MyJoy(): ind_joy_ang_z_(0), ind_joy_lin_x_(1), deadman_axis_(4), vel_ang_z_scale_(0.5), vel_lin_x_scale_(0.4)
{
	pub_cmd_ = nh_.advertise<geometry_msgs::Twist>("/cmd_vel",1);
	sub_joy_ = nh_.subscribe<sensor_msgs::Joy>("/joy", 10, &MyJoy::joyCallback, this); 	
}

/* callback */	
void MyJoy::joyCallback(const sensor_msgs::Joy::ConstPtr& joy){
		
	geometry_msgs::Twist twist_msg; 
			
	vel_lin_x_    = vel_lin_x_scale_ * joy->axes[ind_joy_lin_x_]; 
	vel_ang_z_    = vel_ang_z_scale_ * joy->axes[ind_joy_ang_z_];	

    if (fabs(vel_lin_x_) < 0.1){
        vel_lin_x_ = 0;
    }
    if (fabs(vel_ang_z_) < 0.2){
        vel_ang_z_ = 0;
    }

	twist_msg.linear.x = vel_lin_x_; 
	twist_msg.angular.z = vel_ang_z_; 
	
	pub_cmd_.publish(twist_msg); 
}

/* main */
int main(int argc, char** argv) 
{
  ros::init(argc, argv, "minilab_joy");
  MyJoy telop_joy_node;
  ros::spin(); 
}
