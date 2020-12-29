(in-package #:minghu6.tests)


(def-suite minghu6-tests :description "suite contains one level tests belongs to minghu6")
(def-suite collections-tests)

(defun test-minghu6 ()
  (run! 'minghu6-tests))


(defun test-collections ()
  (run! 'collections-tests))
