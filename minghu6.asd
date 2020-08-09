;;;; minghu6.asd

(asdf:defsystem #:minghu6
  :description "Common utils disjoin with "
  :author "minghu6 <a19678zy@163.com>"
  :license  "BSD-3"
  :version "0.0.1"
  :serial t
  :in-order-to ((test-op (test-op "minghu6/tests")))
  :depends-on (#:cl-package-locks
               #:cl-fad
               #:ppath
               #:cl-ppcre
               #:serapeum
               #:alexandria)
  :components ((:file "package")
               (:file "macro-utils")
               (:file "types")
               (:file "minghu6")
               (:file "benchmark-utils")
               (:file "conditions")
               (:module "collections"
                        :serial nil
                        :pathname "collections"
                        :components ((:file "stack")))
               ))


(asdf:defsystem #:minghu6/tools
  :description "Some small tools integrated in minghu6"
  :author "minghu6 <a19678zy@163.com>"
  :license  "BSD-3"
  :version "0.0.1"
  :serial t
  :pathname "tools"
  :depends-on (#:minghu6)
  :components ((:file "package")
               (:file "self-install")
               ))


(asdf:defsystem #:minghu6/tests
  :description "Unit tests for minghu6"
  :author "minghu6 <a19678zy@163.com>"
  :license  "BSD-3"
  :version "0.0.1"
  :serial t
  :pathname "tests"
  :depends-on (#:minghu6 #:fiveam)
  :perform (test-op (o s)
                    (uiop:symbol-call :minghu6.tests :test-minghu6))
  :components ((:file "package")
               (:file "setup")
               (:file "macro-utils-test")
               (:file "types-test")
               (:file "minghu6-test")))
