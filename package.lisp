;;;; package.lisp

(defpackage #:minghu6
  (:use #:cl #:cl-package-locks)
  (:export
   #:self
   #:string2list
   #:list2string
   #:butlast
   #:elt*
   #:filter
   #:flatten-1
   #:sym
   #:gen-view-method
   #:view
   #:gen-++-method
   #:pp
   #:gen-of-method
   #:of
   #:init-hash-table
   #:plist2alist
   #:gen-acdr-method
   #:acdr))
