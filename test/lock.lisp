(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test lock-acquire-release ()
  (let ((lock (lock:new)))
    (is (lock:acquire lock))
    (lock:release lock)
    (is (lock:acquire-no-wait lock))
    (lock:release lock)))

(define-test lock-fail-acquire ()
  (let ((lock (lock:new))
        (thread
          (thread:spawn
            (fn ()
              (lock:with-lock-held lock
                (fn ()
                  (sleep 60)))))))
    (sleep 1)
    (is (not (lock:acquire-no-wait lock)))
    (thread:destroy thread)))
