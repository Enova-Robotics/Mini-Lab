;; Auto-generated. Do not edit!


(when (boundp 'roboteq_msgs::Feedback)
  (if (not (find-package "ROBOTEQ_MSGS"))
    (make-package "ROBOTEQ_MSGS"))
  (shadow 'Feedback (find-package "ROBOTEQ_MSGS")))
(unless (find-package "ROBOTEQ_MSGS::FEEDBACK")
  (make-package "ROBOTEQ_MSGS::FEEDBACK"))

(in-package "ROS")
;;//! \htmlinclude Feedback.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass roboteq_msgs::Feedback
  :super ros::object
  :slots (_header _motor_current _motor_power _commanded_velocity _measured_velocity _measured_position _supply_voltage _supply_current _motor_temperature _channel_temperature ))

(defmethod roboteq_msgs::Feedback
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:motor_current __motor_current) 0.0)
    ((:motor_power __motor_power) 0.0)
    ((:commanded_velocity __commanded_velocity) 0.0)
    ((:measured_velocity __measured_velocity) 0.0)
    ((:measured_position __measured_position) 0.0)
    ((:supply_voltage __supply_voltage) 0.0)
    ((:supply_current __supply_current) 0.0)
    ((:motor_temperature __motor_temperature) 0.0)
    ((:channel_temperature __channel_temperature) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _motor_current (float __motor_current))
   (setq _motor_power (float __motor_power))
   (setq _commanded_velocity (float __commanded_velocity))
   (setq _measured_velocity (float __measured_velocity))
   (setq _measured_position (float __measured_position))
   (setq _supply_voltage (float __supply_voltage))
   (setq _supply_current (float __supply_current))
   (setq _motor_temperature (float __motor_temperature))
   (setq _channel_temperature (float __channel_temperature))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:motor_current
   (&optional __motor_current)
   (if __motor_current (setq _motor_current __motor_current)) _motor_current)
  (:motor_power
   (&optional __motor_power)
   (if __motor_power (setq _motor_power __motor_power)) _motor_power)
  (:commanded_velocity
   (&optional __commanded_velocity)
   (if __commanded_velocity (setq _commanded_velocity __commanded_velocity)) _commanded_velocity)
  (:measured_velocity
   (&optional __measured_velocity)
   (if __measured_velocity (setq _measured_velocity __measured_velocity)) _measured_velocity)
  (:measured_position
   (&optional __measured_position)
   (if __measured_position (setq _measured_position __measured_position)) _measured_position)
  (:supply_voltage
   (&optional __supply_voltage)
   (if __supply_voltage (setq _supply_voltage __supply_voltage)) _supply_voltage)
  (:supply_current
   (&optional __supply_current)
   (if __supply_current (setq _supply_current __supply_current)) _supply_current)
  (:motor_temperature
   (&optional __motor_temperature)
   (if __motor_temperature (setq _motor_temperature __motor_temperature)) _motor_temperature)
  (:channel_temperature
   (&optional __channel_temperature)
   (if __channel_temperature (setq _channel_temperature __channel_temperature)) _channel_temperature)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float32 _motor_current
    4
    ;; float32 _motor_power
    4
    ;; float32 _commanded_velocity
    4
    ;; float32 _measured_velocity
    4
    ;; float32 _measured_position
    4
    ;; float32 _supply_voltage
    4
    ;; float32 _supply_current
    4
    ;; float32 _motor_temperature
    4
    ;; float32 _channel_temperature
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float32 _motor_current
       (sys::poke _motor_current (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _motor_power
       (sys::poke _motor_power (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _commanded_velocity
       (sys::poke _commanded_velocity (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _measured_velocity
       (sys::poke _measured_velocity (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _measured_position
       (sys::poke _measured_position (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _supply_voltage
       (sys::poke _supply_voltage (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _supply_current
       (sys::poke _supply_current (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _motor_temperature
       (sys::poke _motor_temperature (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _channel_temperature
       (sys::poke _channel_temperature (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float32 _motor_current
     (setq _motor_current (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _motor_power
     (setq _motor_power (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _commanded_velocity
     (setq _commanded_velocity (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _measured_velocity
     (setq _measured_velocity (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _measured_position
     (setq _measured_position (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _supply_voltage
     (setq _supply_voltage (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _supply_current
     (setq _supply_current (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _motor_temperature
     (setq _motor_temperature (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _channel_temperature
     (setq _channel_temperature (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get roboteq_msgs::Feedback :md5sum-) "2b31653367731d6254182bb2f9dbb81a")
(setf (get roboteq_msgs::Feedback :datatype-) "roboteq_msgs/Feedback")
(setf (get roboteq_msgs::Feedback :definition-)
      "# 50Hz feedback message for controls purposes
Header header

# Current flowing in the motors (A)
float32 motor_current

# Output stage, as a proportion of full (-1..1)
float32 motor_power

# Commanded and measured speed of the motors (rad/s)
# Position is reported in rads, and wraps around +-6M
float32 commanded_velocity
float32 measured_velocity
float32 measured_position

# Electrical power supply to the driver (V, A)
float32 supply_voltage
float32 supply_current

# Measured temperatures (C)
# Motor temp is processed from a thermal sensor connected to analog input 1.
float32 motor_temperature
# Channel temp is the temperature of the FETs. This is reported by the controller.
float32 channel_temperature

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
# 0: no frame
# 1: global frame
string frame_id

")



(provide :roboteq_msgs/Feedback "2b31653367731d6254182bb2f9dbb81a")


