(defpackage #:coalton-threads/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:local-nicknames
   (#:thread #:coalton-threads/thread)
   (#:lock #:coalton-threads/lock)
   (#:rlock #:coalton-threads/recursive-lock)
   (#:cv #:coalton-threads/condition-variable)
   (#:sem #:coalton-threads/semaphore)
   (#:atomic #:coalton-threads/atomic)
   (#:mutex #:coalton-threads/mutex)
   (#:barrier #:coalton-threads/barrier))
  (:local-nicknames
   (#:iter #:coalton-library/iterator)
   (#:result #:coalton-library/result))
  (:export #:run-tests))
(in-package #:coalton-threads/test)

(fiasco:define-test-package #:coalton-threads/fiasco-test-package)
(coalton-fiasco-init #:coalton-threads/fiasco-test-package)

(cl:defun run-tests (cl:&optional interactive)
  (fiasco:run-package-tests
   :packages '(#:coalton-threads/fiasco-test-package)
   :interactive interactive))

(coalton-toplevel
  (define (sleep n)
    (lisp Unit (n)
      (cl:sleep n)
      Unit)))
