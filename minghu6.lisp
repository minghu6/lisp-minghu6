

;;;; minghu6.lisp

(in-package #:minghu6)



(defun string-list (s)
  "\"abc\" => (#\a #\b #\c)"
  (map 'list 'identity s))


;;; Constant
(defvar *digits*
  (string-list "0123456789"))

(defvar *hex-digits*
  (string-list "0123456789AaBbCcDdEeFf"))

(defvar *ascii-letters*
  (string-list "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(defvar *ascii-lowercase*
  (string-list "abcdefghijklmnopqrstuvwxyz"))


(defun list-string (l)
  "(#\a #\b #\c) => \"abc\""
  (map 'string 'identity l))


(defun butlast* (s)
  (subseq s 0 (1- (length s))))


(defun elt* (s i)
  "support negative index, same with python"
  (elt s (if (< i 0) (+ (length s) i) i)))


;; replace with serapeum:filter
;; (defmacro filter (f l)
;;   `(reduce (lambda (acc x)
;;              (if (,f x) (append acc (list x)) acc)) ,l :initial-value '()))


(defmacro simple-gen-gen-method (method-name body &key
                                                    generic-method
                                                    default-method)

  "Template for method with signature (class-type fun &rest keys)"
  (let ((gen-method-name (string+ "gen-" method-name "-method")))
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

  (defmethod == ((x list) (y list))
      (and
       (== (length x) (length y))
       (every #'(lambda (n) (== (nth n x) (nth n y)))
              (range 0 (length x)))))

  (defmethod == ((x queue) (y queue))
    (== (qlist x) (qlist y)))


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
                               (do-each (x seq)
                                 (when (,fun x instance)
                                   (return t)))))
                           )
                         :generic-method (defgeneric of (instance seq)
                                           (:documentation  "alias: instance contains of form"))
                         :default-method (defmethod of (instance seq)
                                           (block nil
                                             (do-each (x seq)
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


(defmacro format* (stream &rest forms)
  (when stream
    `(format ,stream ,@forms)))


(defun elt-string-queue-string (elt-string-queue)
  (apply 'string+ (qlist elt-string-queue)))


(defun step-replace-all (pat str rep &key simple-calls)
  "apply ppcre replace step by step to all"
  (labels ((step-replace-all-0 (pat rep acc-str-queue remains-str &key simple-calls)
             (if (emptyp remains-str) (elt-string-queue-string acc-str-queue)
                 (multiple-value-bind (match-start match-end reg-starts reg-ends)
                     (ppcre:scan pat remains-str)
                   (if match-start
                       (progn
                         ;(format t "~s, ~s~%" match-start match-end)
                         (enq (subseq remains-str 0 match-start) acc-str-queue)
                         (enq
                          (ppcre:regex-replace pat remains-str rep
                                               :start match-start :end match-end
                                               :simple-calls simple-calls)
                          acc-str-queue)
                         (step-replace-all-0
                          pat
                          rep
                          acc-str-queue
                          (subseq remains-str (1+ match-end))
                          :simple-calls simple-calls
                          )
                         )
                       (elt-string-queue-string (enq remains-str acc-str-queue)))
                   ))))
    (step-replace-all-0 (ppcre:create-scanner pat) rep (queue) str :simple-calls simple-calls)))


(defun plistp (l)
  (evenp (length l)))


(defun file-contents-string (filename)
  (with-open-file (stream filename)
    (let ((contents (make-string (file-length stream))))
      (read-sequence contents stream)
      contents)))


(defun qlist* (source-queue)
  (map-tree (lambda (item)
              (if (queuep item) (qlist* item)
                  item))
            (qlist source-queue)))


(defun next-queue (source-queue end-test-fun &key (recycle-tail nil) (state-stack (stack)))
  "consume source-queue,
recycle-tail flag: reinsert tail delimiter char "
  (loop
     with new-queue = (queue)
     for item = (deq source-queue) then (deq source-queue)
     while (and item
                (if (functionp end-test-fun)
                    (not (if (emptyp state-stack) (funcall end-test-fun item)
                             (funcall end-test-fun item :state-stack state-stack)))
                    (!= end-test-fun item)))
     do (enq item new-queue)
     finally (progn
               (when recycle-tail (undeq item source-queue))
               (return new-queue))))


(defgeneric the-other-paren (paren)
  (:documentation " (the-other-paren \"{\" => })
 (the-other-paren #\\*) => *
"))


(defmethod the-other-paren ((paren string))
  (switch (paren :test '==)
    ("(" ")")
    ("[" "]")
    ("{" "}")
    (otherwise paren)))


(defmethod the-other-paren ((paren character))
  (switch (paren :test '==)
    (#\( #\))
    (#\[ #\])
    (#\{ #\})
    (otherwise paren)))


(defun paren-matcher (match-identifier &key (key 'identity))
  (let ((match-0 match-identifier)
        (match-1 (the-other-paren match-identifier)))
    (lambda (item &key state-stack)
        (switch (item :test '== :key (lambda (item) (funcall key item)))
          (match-0 (ens match-0 state-stack))
          (match-1 (des state-stack)))
        (emptyp state-stack))
    ))


;;; Temporary part
(defun chain-getf (l &rest keys)
  (if (emptyp keys) l
      (let ((head (car keys))
            (tail (cdr keys)))
        (apply #'chain-getf (append (list (getf l head)) tail)))))


(defmacro chain-setf (l keys value)
  "(chain-setf tree0 (:value :type) 'DD1)"
  `(setf ,(append (list '~> l) (mapcar (lambda (x) `(getf ,x)) keys)) ,value)
  )

(defmacro return-if* (test-form block-name)
  (once-only (test-form)
    `(if ,test-form (return-from ,block-name ,test-form))))


(defun test-return-if* ()
  (return-if* (+ 6 6) test-return-if*))
;;; Temporary part end
