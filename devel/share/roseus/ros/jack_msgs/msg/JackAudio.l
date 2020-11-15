;; Auto-generated. Do not edit!


(when (boundp 'jack_msgs::JackAudio)
  (if (not (find-package "JACK_MSGS"))
    (make-package "JACK_MSGS"))
  (shadow 'JackAudio (find-package "JACK_MSGS")))
(unless (find-package "JACK_MSGS::JACKAUDIO")
  (make-package "JACK_MSGS::JACKAUDIO"))

(in-package "ROS")
;;//! \htmlinclude JackAudio.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass jack_msgs::JackAudio
  :super ros::object
  :slots (_data _size _header ))

(defmethod jack_msgs::JackAudio
  (:init
   (&key
    ((:data __data) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:size __size) 0)
    ((:header __header) (instance std_msgs::Header :init))
    )
   (send-super :init)
   (setq _data __data)
   (setq _size (round __size))
   (setq _header __header)
   self)
  (:data
   (&optional __data)
   (if __data (setq _data __data)) _data)
  (:size
   (&optional __size)
   (if __size (setq _size __size)) _size)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:serialization-length
   ()
   (+
    ;; float32[] _data
    (* 4    (length _data)) 4
    ;; uint16 _size
    2
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32[] _data
     (write-long (length _data) s)
     (dotimes (i (length _data))
       (sys::poke (elt _data i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;; uint16 _size
       (write-word _size s)
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32[] _data
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _data (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _data i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     ))
   ;; uint16 _size
     (setq _size (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;;
   self)
  )

(setf (get jack_msgs::JackAudio :md5sum-) "7e9da74397c8b7c277f8bbd8fe28001b")
(setf (get jack_msgs::JackAudio :datatype-) "jack_msgs/JackAudio")
(setf (get jack_msgs::JackAudio :definition-)
      "float32[] data
uint16    size
Header    header


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
string frame_id

")



(provide :jack_msgs/JackAudio "7e9da74397c8b7c277f8bbd8fe28001b")


