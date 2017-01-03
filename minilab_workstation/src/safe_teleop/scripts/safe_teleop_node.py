#! /usr/bin/env python
import rospy
from sensor_msgs.msg import Range

class SafeTeleop:
    def __init__(self):
        rospy.Subscriber('/US1', Range, self.us1_cb)
        self.value = 0.0

    def us1_cb(self, msg):
        self.value = msg.range

    def update(self):
        print "Value: " + str(self.value)

rospy.init_node('safe_teleop_node')
node = SafeTeleop()
r = rospy.Rate(10)
while not rospy.is_shutdown():
    node.update()
    r.sleep()
