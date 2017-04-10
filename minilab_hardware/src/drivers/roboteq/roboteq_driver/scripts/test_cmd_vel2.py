#!/usr/bin/env python
import rospy
from geometry_msgs.msg import Twist
from roboteq_msgs.msg import Command

width = 0.3834
radius = (0.125 / 2.0)

def callback(data):
    rospy.loginfo("Received a /cmd_vel message!")
    rospy.loginfo("Linear Components: [%f, %f, %f]"%(data.linear.x, data.linear.y, data.linear.z))
    rospy.loginfo("Angular Components: [%f, %f, %f]"%(data.angular.x, data.angular.y, data.angular.z))
    pub = rospy.Publisher('/right/cmd', Command, queue_size=10)
    pub2 = rospy.Publisher('/left/cmd', Command, queue_size=10)
    msg = Command()
    msg.commanded_velocity = ((data.linear.x + data.angular.z * (width / 2)) / radius) * 50 * 0.6
    msg2 = Command()
    msg2.commanded_velocity = - ((data.linear.x - data.angular.z * (width /2)) / radius) * 50 * 0.6
    rospy.loginfo("Conversion to drive command for each wheel")
    rospy.loginfo("Right wheel command %f", msg.commanded_velocity)
    rospy.loginfo("Left wheel command %f", msg2.commanded_velocity)
    pub.publish(msg)
    pub2.publish(msg2)

def listener():
    rospy.init_node('cmd_vel_listener')
    rospy.Subscriber("/cmd_vel", Twist, callback)
    rospy.spin()

if __name__ == '__main__':
    listener()
