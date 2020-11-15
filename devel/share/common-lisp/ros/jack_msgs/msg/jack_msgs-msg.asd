
(cl:in-package :asdf)

(defsystem "jack_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "JackAudio" :depends-on ("_package_JackAudio"))
    (:file "_package_JackAudio" :depends-on ("_package"))
  ))