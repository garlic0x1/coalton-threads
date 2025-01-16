(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-struct (Mutex :a)
    "A mutually exclusive cell."
    (lock Lock)
    (cell (cell:Cell :a)))

  (declare read-mutex (Mutex :a -> :a))
  (define (read-mutex mutex)
    "Access the value held in a Mutex."
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:read (.cell mutex)))))

  (declare update-mutex! (Mutex :a -> (:a -> :a) -> :a))
  (define (update-mutex! mutex f)
    "Swap the value held in a Mutex with a transforming function."
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:update! f (.cell mutex)))))

  (declare write-mutex! (Mutex :a -> :a -> :a))
  (define (write-mutex! mutex value)
    "Set the value held in a Mutex."
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:write! (.cell mutex) value)))))
