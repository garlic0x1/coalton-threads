(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test atomic-incf-decf ()
  (let ((atomic (threads:make-atomic 3)))
    (is (== 13 (threads:incf-atomic! atomic 10)))
    (is (== 9 (threads:decf-atomic! atomic 4)))))

(define-test atomic-cas ()
  (let ((atomic (threads:make-atomic 4)))
    (is (not (threads:cas-atomic! atomic 0 100)))
    (is (threads:cas-atomic! atomic 4 3))
    (is (== 3 (threads:atomic-value atomic)))))

(define-test atomic-concurrency ()
  (let ((atomic (threads:make-atomic 4000))
        (incer (threads:spawn
                 (for x in (range 1 1000)
                   (threads:incf-atomic! atomic 1))))
        (decer (threads:spawn
                 (for x in (range 1 1000)
                   (threads:decf-atomic! atomic 1)))))
    (is (result:ok? (threads:join incer)))
    (is (result:ok? (threads:join decer)))
    (is (== 4000 (threads:atomic-value atomic)))))
