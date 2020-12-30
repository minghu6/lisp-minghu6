(in-package #:minghu6)


(defclass stack (list-mut) nil)


(defmethod initialize-instance :after ((instance stack) &key)
  )


(defun stack (&rest initial-contents)
  (make-instance 'stack :value initial-contents))


(defun stackp (instance)
  (typep instance 'stack))


(defmethod ens (item (stack-instance stack))
  (with-slots (value) stack-instance
    (push item value))
  stack-instance)


(defmethod des ((stack-instance stack))
  (with-slots (value) stack-instance
    (pop value)))
