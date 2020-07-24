;;;; package.lisp

(defpackage #:minghu6
  (:use #:cl #:alexandria)
  (:export
   ;;Constants
   #:*digits*
   #:*ascii-letters*
   #:*ascii-lowercase*

   #:self
   #:string2list
   #:list2string
   #:butlast*
   #:elt*
   #:flatten-1
   #:sym
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
   #:character-list))


(cl-package-locks:lock-package 'minghu6)
