#!/usr/bin/env python
# license removed for brevity
import rospy
from roboteq_msgs.msg import Command
#from std_msgs.msg import String

def talker():
    pub = rospy.Publisher('/single/cmd', Command, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(5) # 10hz
    while not rospy.is_shutdown():
        #hello_str = "hello world %s" % rospy.get_time()
        rospy.loginfo("Sent Value : 157")
        pub.publish(157)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
