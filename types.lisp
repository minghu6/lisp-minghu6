(in-package #:minghu6)



(defun character-list-p (instance)
  (and (listp instance)
       (every 'characterp instance)))

(deftype character-list ()
  `(satisfies character-list-p))
