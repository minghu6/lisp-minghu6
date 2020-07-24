(in-package #:minghu6.tests)


(in-suite minghu6-tests)


(test character-list-p
      (is (character-list-p '(#\a #\b)))
      (is-false (character-list-p "ab"))
      (is-false (character-list-p #(#\a #\b))))
