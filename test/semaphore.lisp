(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test semaphore-signal-await ()
  (let ((sem (threads:make-semaphore)))
    (threads:spawn
      (sleep 1/2)
      (threads:signal-semaphore sem 2))
    (threads:await-semaphore sem)
    (threads:await-semaphore sem)
    (is True)))

(define-test semaphore-n-of-m ()
  (let ((sem (threads:make-semaphore))
        (count (threads:make-atomic 0)))
    (threads:spawn
      (sleep 1)
      (threads:signal-semaphore sem 4))
    (for x in (range 1 5)
      (threads:spawn
        (threads:await-semaphore sem)
        (threads:incf-atomic! count 1)))
    (sleep 1)
    (is (== 4 (threads:atomic-value count)))
    (threads:signal-semaphore sem 1)
    (sleep 1)
    (is (== 5 (threads:atomic-value count)))))
