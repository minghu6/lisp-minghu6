(in-package #:minghu6)


(defclass stack (sequence standard-object)
  ((value
    :reader value
    :initarg :value
    :initform nil)))


(defmethod initialize-instance :after ((instance stack) &key)
  )


(defmethod sequence:length ((self stack))
  (length (value self)))


(defmethod print-object ((self stack) stream)
  (if (and *print-readably* *read-eval*)
      (progn
        (format stream "#.")
        (print-object `(stack ,@(slist stack)) stream))
      (print-unreadable-object (self stream :type t)
        (format stream "~a" (value self)))))


(defun stack (&rest initial-contents)
  (make-instance 'stack :value initial-contents))


(defun slist-1 (stack-instance)
  (if (stackp stack-instance) (value stack-instance)
      stack-instance))


(defun slist (stack-instance)
  (map-tree (lambda (item)
              (if (stackp item) (slist item)
                  item))
            (slist-1 stack-instance)))


(defun stackp (instance)
  (typep instance 'stack))


(defmethod ens (item (stack-instance stack))
  (with-slots (value) stack-instance
    (push item value))
  stack-instance)


(defmethod des ((stack-instance stack))
  (with-slots (value) stack-instance
    (pop value)))
