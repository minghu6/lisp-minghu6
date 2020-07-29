(in-package #:minghu6.tests)


(in-suite minghu6-tests)


(test apply*
      (is (== (apply* + (1 2 3)) 6)))


(test lis-apply
      (is (== (lis-apply + ((1 2) (3 4))) '(3 7))))


(test unless*
      (is (== (unless* 1 2) 1))
      (is (== (unless* nil 2) 2)))
