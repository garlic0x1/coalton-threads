(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-struct (Mutex :a)
    (lock Lock)
    (cell (cell:Cell :a)))

  (declare read-mutex (Mutex :a -> :a))
  (define (read-mutex mutex)
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:read (.cell mutex)))))

  (declare update-mutex! (Mutex :a -> (:a -> :a) -> :a))
  (define (update-mutex! mutex f)
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:update! f (.cell mutex)))))

  (declare write-mutex! (Mutex :a -> :a -> :a))
  (define (write-mutex! mutex value)
    (with-lock-held (.lock mutex)
      (fn ()
        (cell:write! (.cell mutex) value)))))
