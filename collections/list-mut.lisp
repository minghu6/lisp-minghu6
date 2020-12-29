(in-package #:minghu6)


(defclass list-mut (sequence standard-object)
  ((value
    :accessor value
    :initarg :value
    :initform nil)
   )

  (:documentation "mutable list data structure support find."))


(defmethod sequence:length ((self list-mut))
  (length (value self)))


(defmethod print-object ((self list-mut) stream)
  (if (and *print-readably* *read-eval*)
      nil
      (print-unreadable-object (self stream :type t)
        (format stream "~a" (value self)))))


(defun list-mut (&rest initial-contents)
  (make-instance 'list-mut :value initial-contents))


(defun list-mut-p (instance)
  (typep instance 'list-mut))


(defun mlist-1 (instance)
  (if (list-mut-p instance) (value instance)
      instance))


(defun mlist (instance)
  (map-tree (lambda (item)
              (if (list-mut-p item) (mlist item)
                  item))
            (mlist-1 instance)))


(defmethod == ((x list-mut) (y list-mut))
  (== (value x) (value y)))

(defgeneric instance-from (class-type data-type &key))


(defmethod instance-from ((self list-mut) (origin-seq sequence) &key)
  (make-instance
   'list-mut
   :value
   (loop for item in origin-seq collect
        (if (listp item) (instance-from self item)
            item))
   ))
