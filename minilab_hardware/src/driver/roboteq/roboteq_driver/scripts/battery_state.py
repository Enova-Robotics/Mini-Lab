#!/usr/bin/env python
import rospy
from std_msgs.msg import Bool
from std_msgs.msg import Float32

from roboteq_msgs.msg import Command
from roboteq_msgs.msg import Feedback
import time

def voltageCallback(voltage):
    pub = rospy.Publisher('/battery_voltage', Float32, queue_size=10)
    pub.publish(voltage.supply_voltage)
    now = time.time()
    seconds = now / 60
    with open("battery.txt", "a") as fo:
        fo.write("\n"+str(voltage.supply_voltage))
        fo.close()
        time.sleep(1)



def listener():
    rospy.init_node('voltage_listener')
    rospy.Subscriber("/right/feedback", Feedback, voltageCallback) # need to check this
    rospy.spin()

if __name__ == '__main__':
    listener()
