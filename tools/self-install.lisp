(eval-when (:compile-toplevel)
  (in-package :minghu6.tools))

(eval-when (:execute :load-toplevel)
  (ql:quickload "cl-fad")
  (ql:quickload "ppath")
  )

(defparameter *home-dir* (user-homedir-pathname))


(defun install-minghu6 (&key (install-dir (ppath:dirname (ppath:abspath "."))) (force nil))
  "install lib to local
default install-dir: parent dir of working dir"
  (let* ((config-dir (path:catdir
                      *home-dir*
                      ".config/common-lisp/source-registry.conf.d/"))
         (config-file (path:catfile config-dir "lib-minghu6.conf"))
         )
    (ensure-directories-exist config-dir)
    (if (and (not force) (path:-e config-file))
        nil
        (progn
          (with-open-file (config-file-stream config-file
                                            :direction :output
                                            :if-exists :supersede
                                            :if-does-not-exist :create)
            (format config-file-stream "~S~%" `(:tree (,install-dir))))
          (asdf:initialize-source-registry)
          install-dir)
    )))

