#!/usr/bin/env python
import rospy
from std_msgs.msg import Float32
from sensor_msgs.msg import Range
from geometry_msgs.msg import Twist

TOP_LIMIT = 30.0
BUTTOM_LIMIT = 0.0
THRESHOLD = 20

us_list = [.0, .0, .0, .0, .0]
ir_list = [.0, .0, .0, .0, .0]
combined_list = [.0, .0, .0, .0, .0]

class SafeTeleop:
    def __init__(self):
        rospy.Subscriber('/US1', Range, self.us1_cb)
        rospy.Subscriber('/US2', Range, self.us2_cb)
        rospy.Subscriber('/US3', Range, self.us3_cb)
        rospy.Subscriber('/US4', Range, self.us4_cb)
        rospy.Subscriber('/US5', Range, self.us5_cb)
        rospy.Subscriber('/IR1', Range, self.ir1_cb)
        rospy.Subscriber('/IR2', Range, self.ir2_cb)
        rospy.Subscriber('/IR3', Range, self.ir3_cb)
        rospy.Subscriber('/IR4', Range, self.ir4_cb)
        rospy.Subscriber('/IR5', Range, self.ir5_cb)

        self.pub_a1 = rospy.Publisher('/A1', Float32, queue_size=1)
        self.pub_a2 = rospy.Publisher('/A2', Float32, queue_size=1)
        self.pub_a3 = rospy.Publisher('/A3', Float32, queue_size=1)
        self.pub_a4 = rospy.Publisher('/A4', Float32, queue_size=1)
        self.pub_a5 = rospy.Publisher('/A5', Float32, queue_size=1)

    def us1_cb(self, msg):
        us_list[0] = msg.range

    def us2_cb(self, msg):
        us_list[1] = msg.range

    def us3_cb(self, msg):
        us_list[2] = msg.range

    def us4_cb(self, msg):
        us_list[3] = msg.range

    def us5_cb(self, msg):
        us_list[4] = msg.range

    def ir1_cb(self, msg):
        ir_list[4] = msg.range

    def ir2_cb(self, msg):
        ir_list[3] = msg.range

    def ir3_cb(self, msg):
        ir_list[2] = msg.range

    def ir4_cb(self, msg):
        ir_list[1] = msg.range

    def ir5_cb(self, msg):
        ir_list[0] = msg.range

    def combined_reading(self):
        for item in range(0, 5):
            if us_list[item] < TOP_LIMIT:
                combined_list[item] = ir_list[item]
            else:
                combined_list[item] = us_list[item]
        self.pub_a1.publish(combined_list[0])
        self.pub_a2.publish(combined_list[1])
        self.pub_a3.publish(combined_list[2])
        self.pub_a4.publish(combined_list[3])
        self.pub_a5.publish(combined_list[4])

rospy.init_node('safe_teleop_node')
node = SafeTeleop()
r = rospy.Rate(5)
while not rospy.is_shutdown():
    node.combined_reading()
    r.sleep()
