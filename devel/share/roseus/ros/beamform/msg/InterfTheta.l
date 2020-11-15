;; Auto-generated. Do not edit!


(when (boundp 'beamform::InterfTheta)
  (if (not (find-package "BEAMFORM"))
    (make-package "BEAMFORM"))
  (shadow 'InterfTheta (find-package "BEAMFORM")))
(unless (find-package "BEAMFORM::INTERFTHETA")
  (make-package "BEAMFORM::INTERFTHETA"))

(in-package "ROS")
;;//! \htmlinclude InterfTheta.msg.html


(defclass beamform::InterfTheta
  :super ros::object
  :slots (_id _angle ))

(defmethod beamform::InterfTheta
  (:init
   (&key
    ((:id __id) 0)
    ((:angle __angle) 0.0)
    )
   (send-super :init)
   (setq _id (round __id))
   (setq _angle (float __angle))
   self)
  (:id
   (&optional __id)
   (if __id (setq _id __id)) _id)
  (:angle
   (&optional __angle)
   (if __angle (setq _angle __angle)) _angle)
  (:serialization-length
   ()
   (+
    ;; uint16 _id
    2
    ;; float32 _angle
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint16 _id
       (write-word _id s)
     ;; float32 _angle
       (sys::poke _angle (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint16 _id
     (setq _id (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; float32 _angle
     (setq _angle (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get beamform::InterfTheta :md5sum-) "75b733ac85d023a2ec3fae9ccef4c89e")
(setf (get beamform::InterfTheta :datatype-) "beamform/InterfTheta")
(setf (get beamform::InterfTheta :definition-)
      "uint16  id
float32 angle


")



(provide :beamform/InterfTheta "75b733ac85d023a2ec3fae9ccef4c89e")


