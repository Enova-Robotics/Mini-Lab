;; Auto-generated. Do not edit!


(when (boundp 'roboteq_msgs::Command)
  (if (not (find-package "ROBOTEQ_MSGS"))
    (make-package "ROBOTEQ_MSGS"))
  (shadow 'Command (find-package "ROBOTEQ_MSGS")))
(unless (find-package "ROBOTEQ_MSGS::COMMAND")
  (make-package "ROBOTEQ_MSGS::COMMAND"))

(in-package "ROS")
;;//! \htmlinclude Command.msg.html


(defclass roboteq_msgs::Command
  :super ros::object
  :slots (_commanded_velocity ))

(defmethod roboteq_msgs::Command
  (:init
   (&key
    ((:commanded_velocity __commanded_velocity) 0.0)
    )
   (send-super :init)
   (setq _commanded_velocity (float __commanded_velocity))
   self)
  (:commanded_velocity
   (&optional __commanded_velocity)
   (if __commanded_velocity (setq _commanded_velocity __commanded_velocity)) _commanded_velocity)
  (:serialization-length
   ()
   (+
    ;; float32 _commanded_velocity
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _commanded_velocity
       (sys::poke _commanded_velocity (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _commanded_velocity
     (setq _commanded_velocity (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get roboteq_msgs::Command :md5sum-) "55127b9d38b8d2d2ecd090775b958451")
(setf (get roboteq_msgs::Command :datatype-) "roboteq_msgs/Command")
(setf (get roboteq_msgs::Command :definition-)
      "# Commanded speed for the motors (rad/s)
float32 commanded_velocity

")



(provide :roboteq_msgs/Command "55127b9d38b8d2d2ecd090775b958451")


