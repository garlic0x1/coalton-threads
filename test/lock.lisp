(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test lock-acquire-release ()
  (let ((lock (threads:make-lock)))
    (is (threads:acquire-lock lock))
    (threads:release-lock lock)
    (is (threads:acquire-lock-no-wait lock))
    (threads:release-lock lock)))

(define-test lock-fail-acquire ()
  (let ((lock (threads:make-lock))
        (thread
          (threads:spawn
            (threads:with-lock-held lock (fn () (sys:sleep (the Integer 60)))))))
    (sys:sleep (the Integer 1))
    (is (not (threads:acquire-lock-no-wait lock)))
    (threads:destroy thread)))
