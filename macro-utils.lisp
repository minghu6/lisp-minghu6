(in-package #:minghu6)


(eval-when (:compile-toplevel :execute :load-toplevel)
  (defun sym (name)
    (intern (string-upcase name)))

  ;; Replaced with serapeum's string+
  ;; (defun string++ (&rest forms)
  ;;   (apply 'concatenate 'string forms))

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
  )


(defmacro apply* (macro args-list)
  "macro version of apply
add support for macro"
  (append `(,macro) args-list))


(defmacro lis-apply (callable forms)
  "callable are both fun or macro
Exp:
(lis-apply + ((1 2) (3 4))) => (3 7)
(lis-apply gen-restart-fun ((\"aaa\") (\"bbb\") (\"ccc\"))) => (AAA BBB CCC)
"

  (cons 'list (loop for one-form in forms collect `(,callable ,@one-form))))


;; function version of unless*
;; (defun unless* (test-form else-form)
;;   (let* ((test-result test-form))
;;     (if test-result test-result else-form)))

(defmacro unless* (test-form else-form)
  (once-only (test-form)
    `(if ,test-form ,test-form ,else-form)))
