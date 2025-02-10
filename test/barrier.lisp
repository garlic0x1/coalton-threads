(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test barrier-concurrency ()
  (let barrier = (threads:make-barrier))
  (let atomic  = (threads:make-atomic 0))

  (for _ in (iter:range-increasing 1 0 100)
    (threads:make-thread
     (fn ()
       (threads:await-barrier barrier)
       (threads:incf-atomic! atomic 1))))

  (is (== 0 (threads:atomic-value atomic)))
  (threads:unblock-barrier barrier)
  (sleep 1)
  (is (== 100 (threads:atomic-value atomic))))
