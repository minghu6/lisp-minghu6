(defpackage #:minghu6.tests
  (:use #:cl
        #:alexandria
        #:serapeum
        #:fiveam
        #:minghu6)
  (:shadowing-import-from #:minghu6 :gen-list)
  (:export #:run
           #:run!
           #:run!!
           #:run-all-tests
           #:explain!
           #:minghu6-tests
           #:test-minghu6
           #:collections-tests
           #:test-collections
           ))
