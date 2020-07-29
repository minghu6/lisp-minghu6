(in-package #:minghu6)


(defmacro gen-restart-fun (name)
  `(defun ,(sym name) (c)
     (declare
      (condition c)
      (ignore c))
     (let ((restart (find-restart ',(sym name))))
       (when restart (invoke-restart restart)))))


(eval-when (:compile-toplevel :execute :load-toplevel)
  ;(lis-gen-fun-macro gen-restart-fun)
  )
