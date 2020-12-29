(in-package #:minghu6.tests)

(in-suite collections-tests)


(test list-mut-class
      (is (== '(1 2 3)
              (value (list-mut 1 2 3))))
      (is (== '(1 4 3)
              (let ((l (list-mut 1 2 3)))
                (setf (value l) '(1 4 3))
                (value l)
                ))
          )

      (is (== 3
              (length (list-mut 1 2 3))))

      (is (list-mut-p (list-mut 1 2 3)))

      (is-false (list-mut-p '(1 2 3)))

      (is-false (list-mut-p nil))

      (is (== (list 1 (list-mut 2) 3)
              (list 1 (list-mut 2) 3)))

      (is (== (list 1 (list-mut 2) 3)
              (mlist-1 (list-mut 1 (list-mut 2) 3))))

      (is (== (list 1 (list 2) 3)
              (mlist (list-mut 1 (list-mut 2) 3))))

      (is (== (list-mut 1 (list-mut 2 3 (list-mut 5)) 4)
              (instance-from (list-mut) '(1 (2 3 (5)) 4))
              ))
      )

