; Auto-generated. Do not edit!


(cl:in-package jack_msgs-msg)


;//! \htmlinclude JackAudio.msg.html

(cl:defclass <JackAudio> (roslisp-msg-protocol:ros-message)
  ((data
    :reader data
    :initarg :data
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (size
    :reader size
    :initarg :size
    :type cl:fixnum
    :initform 0)
   (header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header)))
)

(cl:defclass JackAudio (<JackAudio>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <JackAudio>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'JackAudio)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name jack_msgs-msg:<JackAudio> is deprecated: use jack_msgs-msg:JackAudio instead.")))

(cl:ensure-generic-function 'data-val :lambda-list '(m))
(cl:defmethod data-val ((m <JackAudio>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader jack_msgs-msg:data-val is deprecated.  Use jack_msgs-msg:data instead.")
  (data m))

(cl:ensure-generic-function 'size-val :lambda-list '(m))
(cl:defmethod size-val ((m <JackAudio>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader jack_msgs-msg:size-val is deprecated.  Use jack_msgs-msg:size instead.")
  (size m))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <JackAudio>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader jack_msgs-msg:header-val is deprecated.  Use jack_msgs-msg:header instead.")
  (header m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <JackAudio>) ostream)
  "Serializes a message object of type '<JackAudio>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'data))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-single-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)))
   (cl:slot-value msg 'data))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'size)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'size)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <JackAudio>) istream)
  "Deserializes a message object of type '<JackAudio>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'data) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'data)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-single-float-bits bits))))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'size)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'size)) (cl:read-byte istream))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<JackAudio>)))
  "Returns string type for a message object of type '<JackAudio>"
  "jack_msgs/JackAudio")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'JackAudio)))
  "Returns string type for a message object of type 'JackAudio"
  "jack_msgs/JackAudio")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<JackAudio>)))
  "Returns md5sum for a message object of type '<JackAudio>"
  "7e9da74397c8b7c277f8bbd8fe28001b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'JackAudio)))
  "Returns md5sum for a message object of type 'JackAudio"
  "7e9da74397c8b7c277f8bbd8fe28001b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<JackAudio>)))
  "Returns full string definition for message of type '<JackAudio>"
  (cl:format cl:nil "float32[] data~%uint16    size~%Header    header~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'JackAudio)))
  "Returns full string definition for message of type 'JackAudio"
  (cl:format cl:nil "float32[] data~%uint16    size~%Header    header~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <JackAudio>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
     2
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <JackAudio>))
  "Converts a ROS message object to a list"
  (cl:list 'JackAudio
    (cl:cons ':data (data msg))
    (cl:cons ':size (size msg))
    (cl:cons ':header (header msg))
))
