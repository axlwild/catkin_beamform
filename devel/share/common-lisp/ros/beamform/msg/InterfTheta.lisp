; Auto-generated. Do not edit!


(cl:in-package beamform-msg)


;//! \htmlinclude InterfTheta.msg.html

(cl:defclass <InterfTheta> (roslisp-msg-protocol:ros-message)
  ((id
    :reader id
    :initarg :id
    :type cl:fixnum
    :initform 0)
   (angle
    :reader angle
    :initarg :angle
    :type cl:float
    :initform 0.0))
)

(cl:defclass InterfTheta (<InterfTheta>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <InterfTheta>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'InterfTheta)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name beamform-msg:<InterfTheta> is deprecated: use beamform-msg:InterfTheta instead.")))

(cl:ensure-generic-function 'id-val :lambda-list '(m))
(cl:defmethod id-val ((m <InterfTheta>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader beamform-msg:id-val is deprecated.  Use beamform-msg:id instead.")
  (id m))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <InterfTheta>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader beamform-msg:angle-val is deprecated.  Use beamform-msg:angle instead.")
  (angle m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <InterfTheta>) ostream)
  "Serializes a message object of type '<InterfTheta>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'id)) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'angle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <InterfTheta>) istream)
  "Deserializes a message object of type '<InterfTheta>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'id)) (cl:read-byte istream))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'angle) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<InterfTheta>)))
  "Returns string type for a message object of type '<InterfTheta>"
  "beamform/InterfTheta")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'InterfTheta)))
  "Returns string type for a message object of type 'InterfTheta"
  "beamform/InterfTheta")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<InterfTheta>)))
  "Returns md5sum for a message object of type '<InterfTheta>"
  "75b733ac85d023a2ec3fae9ccef4c89e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'InterfTheta)))
  "Returns md5sum for a message object of type 'InterfTheta"
  "75b733ac85d023a2ec3fae9ccef4c89e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<InterfTheta>)))
  "Returns full string definition for message of type '<InterfTheta>"
  (cl:format cl:nil "uint16  id~%float32 angle~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'InterfTheta)))
  "Returns full string definition for message of type 'InterfTheta"
  (cl:format cl:nil "uint16  id~%float32 angle~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <InterfTheta>))
  (cl:+ 0
     2
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <InterfTheta>))
  "Converts a ROS message object to a list"
  (cl:list 'InterfTheta
    (cl:cons ':id (id msg))
    (cl:cons ':angle (angle msg))
))
