
;;;; package.lisp
(eval-when (:compile-toplevel)
  (defvar *MINGHU6-FILE* *compile-file-truename*)
  )

(defpackage #:minghu6
  (:use #:cl #:alexandria #:serapeum)
  (:export
   ;; Macro Utils (include control-flow)
   #:flatten-1
   #:sym
   #:apply*
   #:lis-apply
   #:unless*
   ;#:when*

   ;; Constants (minghu6.lisp)
   #:*digits*
   #:*hex-digits*
   #:*ascii-letters*
   #:*ascii-lowercase*
   ;; minghu6
   #:string-list
   #:list-string
   #:butlast*
   #:elt*
   #:gen==method
   #:==
   #:!=
   #:gen-view-method
   #:view
   #:gen-pp-method
   #:pp
   #:gen-of-method
   #:of
   #:init-hash-table
   #:gen-acdr-method
   #:acdr
   #:format*
   #:step-replace-all
   #:plistp
   #:file-contents-string
   #:qlist*
   #:paren-matcher
   #:next-queue

   ;; Types
   #:character-list-p
   #:character-list

   ;; Benchmark utils
   #:gen-list
   #:ignore-output
   #:time-ign

   ;; Conditions
   #:gen-restart-fun

   ;; Collections
   #:list-mut
   #:list-mut-p
   #:mlist-1
   #:mlist
   #:value
   #:instance-from

   #:stack
   #:ens
   #:des
   #:stackp
   ))


(cl-package-locks:lock-package 'minghu6)
