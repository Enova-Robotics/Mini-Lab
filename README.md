# Mini-Lab packages for ROS noetic
This branch contains the noetic version of Minilab packages

# Mini-Lab packages
Please refere to the robot wiki entry in the link below: http://wiki.ros.org/Mini-Lab

Our tutorial pages contain all the needed information to simulate the robot and test all of its features.

<br />

# Changelog

* openni-camera replaced by freenect for kinect drivers

* minilab_simulation/launch/minilab_state_publisher.launch update:

	robot_state_publisher instead of state_publisher
	
* added python-is-python3 for python2/python3 compatibility

* minilab_teleop/src/keyboard_teleop updated for python3

* minilab_navigation/config parameters updated

	removed "/" for "/map","/base_link"
  
	removed "/" for "/odom","/base_link"
  
