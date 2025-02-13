(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test barrier-concurrency ()
  (let barrier = (barrier:new))
  (let atomic  = (atomic:new 0))

  (for _ in (iter:range-increasing 1 0 100)
    (thread:spawn
      (fn ()
        (barrier:await barrier)
        (atomic:incf! atomic 1))))

  (is (== 0 (atomic:read atomic)))
  (barrier:unblock! barrier)
  (sleep 1)
  (is (== 100 (atomic:read atomic))))
