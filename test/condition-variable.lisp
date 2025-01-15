(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test condition-variable-concurrency ()
  (let ((atomic (threads:make-atomic 0))
        (target 30)
        (cv (threads:make-cv))
        (lock (threads:make-lock)))
    (let ((worker (fn (i)
                    (threads:with-lock-held lock
                      (fn ()
                        (while (not (== i (threads:atomic-value atomic)))
                          (threads:await-cv cv lock)
                          (sleep 1/10))
                        (threads:incf-atomic! atomic 1)))
                    (threads:broadcast-cv cv))))
      (for x in (range target 1)
        (threads:spawn
          (sleep 1/10)
          (worker (- target x))))
      (threads:with-lock-held lock
        (fn ()
          (while (not (== target (threads:atomic-value atomic)))
            (threads:await-cv cv lock))))
      (is (== target (threads:atomic-value atomic))))))
