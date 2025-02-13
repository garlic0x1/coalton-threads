(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test atomic-incf-decf ()
  (let ((atomic (atomic:new 3)))
    (is (== 13 (atomic:incf! atomic 10)))
    (is (== 9 (atomic:decf! atomic 4)))))

(define-test atomic-cas ()
  (let ((atomic (atomic:new 4)))
    (is (not (atomic:cas! atomic 0 100)))
    (is (atomic:cas! atomic 4 3))
    (is (== 3 (atomic:read atomic)))))

(define-test atomic-concurrency ()
  (let ((atomic (atomic:new 4000))
        (incer (thread:spawn
                 (fn ()
                   (for x in (range 1 1000)
                     (atomic:incf! atomic 1)))))
        (decer (thread:spawn
                 (fn ()
                   (for x in (range 1 1000)
                     (atomic:decf! atomic 1))))))
    (is (result:ok? (thread:join incer)))
    (is (result:ok? (thread:join decer)))
    (is (== 4000 (atomic:read atomic)))))
