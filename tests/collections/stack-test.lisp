(in-package #:minghu6.tests)

(in-suite collections-tests)


(test stack-class
  (is (== '(1 2 3)
          (value (stack 1 2 3))))
  (is (== '(1 4 3)
          (let ((l (stack 1 2 3)))
            (setf (value l) '(1 4 3))
            (value l)
            )))

  (is (== 3
          (length (stack 1 2 3))))

  (is (stackp (stack 1 2 3)))

  (is (list-mut-p (stack 1 2 3)))

  (is-false (stackp '(1 2 3)))

  (is-false (stackp nil))

  (is (== (list 1 (stack 2) 3)
          (list 1 (stack 2) 3)))

  (is (== (list 1 (stack 2) 3)
          (mlist-1 (stack 1 (stack 2) 3))))

  (is (== (list 1 (list 2) 3)
          (mlist (stack 1 (stack 2) 3))))

  (is (== (stack 1 (stack 2 3 (stack 5)) 4)
          (instance-from (stack) '(1 (2 3 (5)) 4))
          ))
  )
