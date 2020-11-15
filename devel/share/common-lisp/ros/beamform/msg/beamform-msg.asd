
(cl:in-package :asdf)

(defsystem "beamform-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "InterfTheta" :depends-on ("_package_InterfTheta"))
    (:file "_package_InterfTheta" :depends-on ("_package"))
  ))