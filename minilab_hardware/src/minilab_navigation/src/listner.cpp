#include <ros/ros.h>
#include <nav_msgs/Odometry.h>

void listnerCallback(tf2_msgs::TFMessage msg)
{
  float px,py;
  ros::Rate rate(0.0333);
  px = msg.pose.pose.position.x;
  py = msg.pose.pose.position.y;
  ROS_INFO("HEllO ! I'm in position [%f] [%f]",px,py);
  rate.sleep();
}




int main(int argc, char** argv){
  ros::init(argc, argv, "tf_listner");

  ros::NodeHandle n;
 
  ros::Subscriber sub = n.subscribe("tf", 1, listnerCallback);
 ros::spin();
}

