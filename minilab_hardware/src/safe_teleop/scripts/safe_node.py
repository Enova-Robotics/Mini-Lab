#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Range
from geometry_msgs.msg import Twist
from std_msgs.msg import Float32

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
        rospy.Subscriber('/cmd_vel_in', Twist, self.cmd_vel_cb)

        self.pub_cmd = rospy.Publisher('/cmd_vel', Twist, queue_size=1)
        self.pub_a1 = rospy.Publisher('/A1', Float32, queue_size=1)
        self.pub_a2 = rospy.Publisher('/A2', Float32, queue_size=1)
        self.pub_a3 = rospy.Publisher('/A3', Float32, queue_size=1)
        self.pub_a4 = rospy.Publisher('/A4', Float32, queue_size=1)
        self.pub_a5 = rospy.Publisher('/A5', Float32, queue_size=1)


        self.safe_drive = True
        self.cmd_in = Twist()
        self.cmd_out = Twist()

    def cmd_vel_cb(self, cmd):
        self.cmd_in = cmd

    def us1_cb(self, msg):
        us_list[0] = msg.range
        #print msg.range

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
        print "Combined List:"
        print combined_list


    def update(self):
        self.combined_reading()
        item = 0
        while(item in range(0,5)):
            if combined_list[item] < THRESHOLD:
                print combined_list[item]
                print "False"
                self.safe_drive = False
                break;
            else:
                self.safe_drive = True
            item += 1

        if not self.safe_drive:
            if self.cmd_in.linear.x < 0.0:
                self.cmd_out = self.cmd_in
            else:
                self.cmd_out.linear.x = 0.0
                self.cmd_out.angular.z = 0.0
        else:
            self.cmd_out = self.cmd_in    
        self.pub_cmd.publish(self.cmd_out)
        self.pub_a1.publish(combined_list[0])
        self.pub_a2.publish(combined_list[1])
        self.pub_a3.publish(combined_list[2])
        self.pub_a4.publish(combined_list[3])
        self.pub_a5.publish(combined_list[4])


rospy.init_node('safe_teleop_node')
node = SafeTeleop()
r = rospy.Rate(10)
while not rospy.is_shutdown():
    node.update()
    r.sleep()
