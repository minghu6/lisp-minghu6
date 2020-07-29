
;;;; package.lisp
(defparameter *MINGHU6-FILE* *load-truename*)

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
   #:*ascii-letters*
   #:*ascii-lowercase*
   ;; minghu6
   #:self
   #:string2list
   #:list2string
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
   ;#:plist2alist ; replaced with Alexandria's plist-alist
   #:gen-acdr-method
   #:acdr

   ;; Types
   #:character-list-p
   #:character-list

   ;; Benchmark utils
   #:gen-list
   #:ignore-output
   #:time-ign

   ;; Conditions
   #:gen-restart-fun
   ))


(cl-package-locks:lock-package 'minghu6)
