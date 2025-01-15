(defpackage #:coalton-threads/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:local-nicknames (#:threads #:coalton-threads)
                    (#:sys #:coalton-library/system)
                    (#:result #:coalton-library/result))
  (:export #:run-tests))
(in-package #:coalton-threads/test)

(fiasco:define-test-package #:coalton-threads/fiasco-test-package)
(coalton-fiasco-init #:coalton-threads/fiasco-test-package)

(cl:defun run-tests (cl:&optional interactive)
  (fiasco:run-package-tests
   :packages '(#:coalton-threads/fiasco-test-package)
   :interactive interactive))
