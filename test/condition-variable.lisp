(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test condition-variable-concurrency ()
  (let ((atomic (atomic:new 0))
        (target 30)
        (cv (cv:new))
        (lock (lock:new)))
    (let ((worker (fn (i)
                    (lock:with-lock-held lock
                      (fn ()
                        (while (not (== i (atomic:read atomic)))
                          (cv:await cv lock)
                          ;;(sleep 1/10)
                          )
                        (atomic:incf! atomic 1)))
                    (cv:broadcast cv))))
      (for x in (range target 1)
        (thread:spawn
          (fn ()
            ;;(sleep 1/10)
            (worker (- target x)))))
      (lock:with-lock-held lock
        (fn ()
          (while (not (== target (atomic:read atomic)))
            (cv:await cv lock))))
      (is (== target (atomic:read atomic))))))
