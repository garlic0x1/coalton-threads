(defpackage #:coalton-threads/mutex
  (:use #:coalton #:coalton-prelude)
  (:local-nicknames
   (#:lock #:coalton-threads/lock)
   (#:cell #:coalton-library/cell))
  (:export
   #:Mutex
   #:new
   #:swap!
   #:write!
   #:update!
   #:read))
(in-package #:coalton-threads/mutex)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-struct (Mutex :a)
    "A mutually exclusive cell."
    (lock lock:Lock)
    (cell (cell:Cell :a)))

  (declare new (:a -> Mutex :a))
  (define (new elt)
    (Mutex (lock:new) (cell:new elt)))

  (declare read (Mutex :a -> :a))
  (define (read mutex)
    "Access the value held in a Mutex."
    (lock:with-lock-held (.lock mutex)
      (fn ()
        (cell:read (.cell mutex)))))

  (declare swap! (Mutex :a -> :a -> :a))
  (define (swap! mutex value)
    "Replace the value held in a Mutex, returning the old value."
    (lock:with-lock-held (.lock mutex)
      (fn ()
        (cell:swap! (.cell mutex) value))))

  (declare write! (Mutex :a -> :a -> :a))
  (define (write! mutex value)
    "Set the value held in a Mutex, returning the new value."
    (lock:with-lock-held (.lock mutex)
      (fn ()
        (cell:write! (.cell mutex) value))) )

  (declare update! (Mutex :a -> (:a -> :a) -> :a))
  (define (update! mutex f)
    "Swap the value held in a Mutex with a transforming function."
    (lock:with-lock-held (.lock mutex)
      (fn ()
        (cell:update! f (.cell mutex))))))
