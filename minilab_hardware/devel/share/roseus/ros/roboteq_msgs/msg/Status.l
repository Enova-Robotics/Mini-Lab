;; Auto-generated. Do not edit!


(when (boundp 'roboteq_msgs::Status)
  (if (not (find-package "ROBOTEQ_MSGS"))
    (make-package "ROBOTEQ_MSGS"))
  (shadow 'Status (find-package "ROBOTEQ_MSGS")))
(unless (find-package "ROBOTEQ_MSGS::STATUS")
  (make-package "ROBOTEQ_MSGS::STATUS"))

(in-package "ROS")
;;//! \htmlinclude Status.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(intern "*FAULT_OVERHEAT*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_OVERHEAT* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_OVERHEAT* 1)
(intern "*FAULT_OVERVOLTAGE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_OVERVOLTAGE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_OVERVOLTAGE* 2)
(intern "*FAULT_UNDERVOLTAGE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_UNDERVOLTAGE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_UNDERVOLTAGE* 4)
(intern "*FAULT_SHORT_CIRCUIT*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_SHORT_CIRCUIT* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_SHORT_CIRCUIT* 8)
(intern "*FAULT_EMERGENCY_STOP*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_EMERGENCY_STOP* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_EMERGENCY_STOP* 16)
(intern "*FAULT_SEPEX_EXCITATION_FAULT*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_SEPEX_EXCITATION_FAULT* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_SEPEX_EXCITATION_FAULT* 32)
(intern "*FAULT_MOSFET_FAILURE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_MOSFET_FAILURE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_MOSFET_FAILURE* 64)
(intern "*FAULT_STARTUP_CONFIG_FAULT*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*FAULT_STARTUP_CONFIG_FAULT* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*FAULT_STARTUP_CONFIG_FAULT* 128)
(intern "*STATUS_SERIAL_MODE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_SERIAL_MODE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_SERIAL_MODE* 1)
(intern "*STATUS_PULSE_MODE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_PULSE_MODE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_PULSE_MODE* 2)
(intern "*STATUS_ANALOG_MODE*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_ANALOG_MODE* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_ANALOG_MODE* 4)
(intern "*STATUS_POWER_STAGE_OFF*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_POWER_STAGE_OFF* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_POWER_STAGE_OFF* 8)
(intern "*STATUS_STALL_DETECTED*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_STALL_DETECTED* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_STALL_DETECTED* 16)
(intern "*STATUS_AT_LIMIT*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_AT_LIMIT* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_AT_LIMIT* 32)
(intern "*STATUS_MICROBASIC_SCRIPT_RUNNING*" (find-package "ROBOTEQ_MSGS::STATUS"))
(shadow '*STATUS_MICROBASIC_SCRIPT_RUNNING* (find-package "ROBOTEQ_MSGS::STATUS"))
(defconstant roboteq_msgs::Status::*STATUS_MICROBASIC_SCRIPT_RUNNING* 128)
(defclass roboteq_msgs::Status
  :super ros::object
  :slots (_header _fault _status _ic_temperature _internal_voltage _adc_voltage ))

(defmethod roboteq_msgs::Status
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:fault __fault) 0)
    ((:status __status) 0)
    ((:ic_temperature __ic_temperature) 0.0)
    ((:internal_voltage __internal_voltage) 0.0)
    ((:adc_voltage __adc_voltage) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _fault (round __fault))
   (setq _status (round __status))
   (setq _ic_temperature (float __ic_temperature))
   (setq _internal_voltage (float __internal_voltage))
   (setq _adc_voltage (float __adc_voltage))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:fault
   (&optional __fault)
   (if __fault (setq _fault __fault)) _fault)
  (:status
   (&optional __status)
   (if __status (setq _status __status)) _status)
  (:ic_temperature
   (&optional __ic_temperature)
   (if __ic_temperature (setq _ic_temperature __ic_temperature)) _ic_temperature)
  (:internal_voltage
   (&optional __internal_voltage)
   (if __internal_voltage (setq _internal_voltage __internal_voltage)) _internal_voltage)
  (:adc_voltage
   (&optional __adc_voltage)
   (if __adc_voltage (setq _adc_voltage __adc_voltage)) _adc_voltage)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; uint8 _fault
    1
    ;; uint8 _status
    1
    ;; float32 _ic_temperature
    4
    ;; float32 _internal_voltage
    4
    ;; float32 _adc_voltage
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; uint8 _fault
       (write-byte _fault s)
     ;; uint8 _status
       (write-byte _status s)
     ;; float32 _ic_temperature
       (sys::poke _ic_temperature (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _internal_voltage
       (sys::poke _internal_voltage (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _adc_voltage
       (sys::poke _adc_voltage (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; uint8 _fault
     (setq _fault (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _status
     (setq _status (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; float32 _ic_temperature
     (setq _ic_temperature (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _internal_voltage
     (setq _internal_voltage (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _adc_voltage
     (setq _adc_voltage (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get roboteq_msgs::Status :md5sum-) "d3a9b223fdfb0968255e25e5a859ac29")
(setf (get roboteq_msgs::Status :datatype-) "roboteq_msgs/Status")
(setf (get roboteq_msgs::Status :definition-)
      "# 10Hz status message for informational/diagnostics purposes
Header header

uint8 FAULT_OVERHEAT=1
uint8 FAULT_OVERVOLTAGE=2
uint8 FAULT_UNDERVOLTAGE=4
uint8 FAULT_SHORT_CIRCUIT=8
uint8 FAULT_EMERGENCY_STOP=16
uint8 FAULT_SEPEX_EXCITATION_FAULT=32
uint8 FAULT_MOSFET_FAILURE=64
uint8 FAULT_STARTUP_CONFIG_FAULT=128
uint8 fault

uint8 STATUS_SERIAL_MODE=1
uint8 STATUS_PULSE_MODE=2
uint8 STATUS_ANALOG_MODE=4
uint8 STATUS_POWER_STAGE_OFF=8
uint8 STATUS_STALL_DETECTED=16
uint8 STATUS_AT_LIMIT=32
uint8 STATUS_MICROBASIC_SCRIPT_RUNNING=128
uint8 status

# Temperature of main logic chip (C)
float32 ic_temperature

# Internal supply and reference voltage (V)
float32 internal_voltage
float32 adc_voltage

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



(provide :roboteq_msgs/Status "d3a9b223fdfb0968255e25e5a859ac29")


