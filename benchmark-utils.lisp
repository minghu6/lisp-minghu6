(in-package #:minghu6)


;;; reference some functions from `fiveam`
(defun gen-list (len)
  (labels ((gen-list-0 (remain-len acc)
             (if (<= remain-len 0) acc
                 (let ((random-elem (random 10)))
                   (gen-list-0 (1- remain-len) (cons random-elem acc))))))
    (gen-list-0 len nil)))


(defun ignore-output (body)
  (progn
    body
    nil))


(defun time-ign (body)
  (time (ignore-output body)))



