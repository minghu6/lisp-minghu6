;;;; minghu6.asd

(asdf:defsystem #:minghu6
  :description "Common utils for minghu6"
  :author "minghu6 <a19678zy@163.com>"
  :license  "BSD-3"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-package-locks)
  :components ((:file "package")
               (:file "minghu6")))
