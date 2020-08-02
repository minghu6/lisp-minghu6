(in-package #:minghu6.tests)


(in-suite minghu6-tests)


(test ==
      (is (== "aaa" "aaa"))
      (is-false (== "aaa" "AAA"))
      (is (== 'a 'a))
      (is (== 'a 'A))
      (is (== #\a #\a))
      )


(test !=
      (is-false (!= "aaa" "aaa"))
      (is (!= "aaa" "AAA"))
      (is-false (!= 'a 'a))
      (is-false (!= 'a 'A))
      (is-false (!= #\a #\a)))


(test pp
  (is (== (pp "aa" "bbb" "cc") "aabbbcc"))
  (is (== (pp #\a #\b #\c) "abc")))


(test self
  (is (eql 'a (self 'a))))


(test string-list
      (is (== (string-list "abcde") '(#\a #\b #\c #\d #\e)))
      (is (== (string-list "") nil)))


(test list-string
      (is (== (list-string '(#\a #\b #\c #\d #\e)) "abcde"))
      (is (== (list-string nil) "")))


(test butlast*
  (is (== (butlast* '(1 2 3)) '(1 2)))
  (is (== (butlast* #(1 2 3)) #(1 2)))
  (is (== (butlast* "123") "12")))


(test elt*
  (is (== (elt* '(1 2 3) 2) 3))
  (is (== (elt* '(1 2 3) -1) 3)))


(test flatten-1
  (is (== (flatten-1 '(1 2 (3 4) (5 (6 7))))
          '(1 2 3 4 5 (6 7)))))


(test sym
  (is (== (sym "aaa") 'aaa))
  (is (== (sym "AAA") 'aaa)))


(test of
  (is (of "aaa" '("bbb" "aaa" "ccc")))
  (is-false (of "aaa" '("bbb" "AAA" "ccc")))
  (is-false (of "aaa" #("bbb" "AAA" "ccc")))
  (is (of "aaa" #("bbb" "aaa" "ccc"))))


(test pp
  (is (== (pp "aa" "bb" "cc") "aabbcc"))
  (is (== (pp #(1 2 3) #(4 5) #(6)) #(1 2 3 4 5 6))))


(test acdr
  (is (== (acdr 'a '((a . 1) (b . 2))) 1))
  (is (== (acdr "a" '(("a" . 1) ("b" . 2))) 1)))


(test init-hash-table
      (let ((table-0 (make-hash-table)))
        (setf (gethash 'a table-0) 1)
        (setf (gethash 'b table-0) 2)
        (setf (gethash 'c table-0) 3)

        (is (== (init-hash-table '(a 1 b 2 c 3)) table-0))
        ))



