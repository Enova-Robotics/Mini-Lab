#! /usr/bin/env python
import rospy
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist

#================================================#
class SafeTeleop:
    def __init__(self):
        rospy.Subscriber('/scan', LaserScan, self.scan_cb)
        rospy.Subscriber('/cmd_vel_in', Twist, self.cmd_vel_cb)
        self.pub_cmd = rospy.Publisher('/cmd_vel_secu', Twist, queue_size=1)
        self.scans = LaserScan()
        self.cmd_in = Twist()
        self.cmd_out = Twist()

    def cmd_vel_cb(self, msg):
        self.cmd_in = msg

    def scan_cb(self, msg):
        self.scans = msg

    def update(self):
        safe_drive = True
        for item in self.scans.ranges:
            if item < 0.30:
                safe_drive = False
                break
            else:
                safe_drive = True
        #========================#
        if (not safe_drive):
            if self.cmd_in.linear.x > 0.0:
                self.cmd_out.linear.x = 0.0
                self.cmd_out.angular.z = 0.0
            else:
                self.cmd_out = self.cmd_in
        else:
            self.cmd_out = self.cmd_in

        self.pub_cmd.publish(self.cmd_out)

#================================================#
rospy.init_node('safe_teleop_node')
node = SafeTeleop()
r = rospy.Rate(10)
while not rospy.is_shutdown():
    node.update()
    r.sleep()
