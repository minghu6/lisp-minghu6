

;;;; minghu6.lisp

(in-package #:minghu6)



(defun string2list (s)
  "\"abc\" => (#\a #\b #\c)"
  (map 'list 'self s))


(defun self (x) x)


;;; Constant
(defvar *digits*
  (string2list"0123456789"))

(defvar *ascii-letters*
  (string2list "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(defvar *ascii-lowercase*
  (string2list "abcdefghijklmnopqrstuvwxyz"))


(defun list2string (l)
  "(#\a #\b #\c) => \"abc\""
  (map 'string 'self l))


(defun butlast* (s)
  (subseq s 0 (1- (length s))))


(defun elt* (s i)
  "support negative index, same with python"
  (elt s (if (< i 0) (+ (length s) i) i)))


;; replace with serapeum:filter
;; (defmacro filter (f l)
;;   `(reduce (lambda (acc x)
;;              (if (,f x) (append acc (list x)) acc)) ,l :initial-value '()))


(defun flatten-1 (l)
  "(flatten-1 '(1 (2 3) (4 (5 6)))) => (1 2 3 4 (5 6)) "
  (labels ((flatten-1-0 (l0 acc)
             (let ((head (car l0))
                   (tail (cdr l0)))
               (if head
                   (let ((tail-list (if (atom head) `(,head) head)))
                     (flatten-1-0 tail (append acc tail-list)))
                   acc))))
    (flatten-1-0 l nil)))


(eval-when (:compile-toplevel :execute :load-toplevel)
  (defun sym (name)
    (intern (string-upcase name)))

  (defun string++ (&rest forms)
    (apply 'concatenate 'string forms))
)


(defmacro simple-gen-gen-method (method-name body &key
                                                    generic-method
                                                    default-method)

  "Template for method with signature (class-type fun &rest keys)"
  (let ((gen-method-name (string++ "gen-" method-name "-method")))
    `(list
      ,generic-method
      ,default-method
      (defmacro ,(sym gen-method-name) (class-type fun)
        ,@body))))


(eval-when (:compile-toplevel :execute :load-toplevel)
  (simple-gen-gen-method "=="
                         (`(defmethod == ((x ,class-type) y)
                             (,fun x y)))
                         :generic-method (defgeneric == (x y)
                                           (:documentation
                                            "generic method for equal
should extend itself for struct/class"
                                            ))
                         :default-method (defmethod == (x y)
                                           (equal x y)))

  ;; string is subtype of vector
  (gen-==-method string string=)
  (gen-==-method vector equalp)
  (gen-==-method hash-table equalp)

  (defmethod != (x y)
    (not (== x y)))

  (simple-gen-gen-method "view"
                         (`(defmethod view ((instance ,class-type))
                             (,fun instance)))
                         :generic-method (defgeneric view (instance)
                                           (:documentation
                                            "view instance, like __str__ in python"))
                         :default-method (defmethod view (instance)
                                           nil))

  (gen-view-method hash-table (lambda (instance)
                                (maphash (lambda (k v) (format t "~a => ~a~%" k v)) instance)))


  ;; There is also a candidate: `serapeum:in`, its sytax is confused however:
  ;; (serapeum:in #\a #\b #\a) => T and not support extend as a generic method
  (simple-gen-gen-method "of"
                         (`(defmethod of ((instance ,class-type) seq)
                             (block nil
                               (serapeum:do-each (x seq)
                                 (when (,fun x instance)
                                   (return t)))))
                           )
                         :generic-method (defgeneric of (instance seq)
                                           (:documentation  "alias: instance contains of form"))
                         :default-method (defmethod of (instance seq)
                                           (block nil
                                             (serapeum:do-each (x seq)
                                               (when (== x instance)
                                                 (return t))))))


  (simple-gen-gen-method "pp"
                         (`(defmethod pp ((first-elem ,class-type) &rest other-elems)
                             (apply 'concatenate ,fun (cons first-elem other-elems))))
                         :generic-method (defgeneric pp (first-elem &rest other-elems)
                                           (:documentation "Concatenate seqs."))
                         )

  (gen-pp-method vector 'vector)
  (gen-pp-method string 'string)
  (gen-pp-method list 'list)
  (defmethod pp ((first-elem character) &rest other-elems)
    (list2string (cons first-elem other-elems)))


  (simple-gen-gen-method "acdr"
                         (
                          `(defmethod acdr ((car-elem ,class-type) form &rest keys)
                             (setf (getf keys :test) ,fun)
                             (cdr (apply 'assoc car-elem form keys))))
                         :generic-method (defgeneric acdr (car-elem form &rest keys)
                                           (:documentation  "=== (-> second assoc)"))
                         :default-method (defmethod acdr (car-elem form &rest keys)
                                           (setf (getf keys :test) '==)
                                           (cdr (apply 'assoc car-elem form keys))))


 )


;; Replaced with Alexandria's plist-alist
;; (defun plist2alist (l)
;;   "(a 1 b 2 c 3) => ((a 1) (b 2) (c 3))"
;;   (labels ((plist2alist-0 (remains acc)
;;              (let ((head (car remains))
;;                    (tail (cdr remains)))
;;                (if head (plist2alist-0 (cdr tail)
;;                                        (append acc `((,head . ,(car tail)))))
;;                    acc))))
;;     (plist2alist-0 l nil)))


(defun init-hash-table (forms &rest keys)
  "Exp: (defparameter *h* (init-hash-table '(a 1 b 2 c 3) :size 100))"
  (let ((table (apply 'make-hash-table keys) ))
    (dolist (item (plist-alist forms))
      (let ((k (car item))
            (v (cdr item)))
        (setf (gethash k table) v)))
    table))

