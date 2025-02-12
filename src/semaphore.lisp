(defpackage #:coalton-threads/semaphore
  (:use #:coalton #:coalton-prelude)
  (:export
   #:Semaphore
   #:new
   #:signal
   #:await))
(in-package #:coalton-threads/semaphore)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:semaphore)
  (define-type Semaphore
    "Wrapper for a native semaphore.")

  (declare new (Unit -> Semaphore))
  (define (new)
    "Creates a semaphore with initial count 0."
    (lisp Semaphore ()
      (bt2:make-semaphore)))

  (declare signal (Semaphore -> UFix -> Unit))
  (define (signal sem count)
    "Increment `sem' by `count'.
If there are threads awaiting this semaphore, then `count' of them are woken up."
    (lisp Unit (sem count)
      (bt2:signal-semaphore sem :count count)
      Unit))

  (declare await (Semaphore -> Unit))
  (define (await sem)
    "Decrement the count of `sem' by 1 if the count is larger than zero.
If the count is zero, blocks until `sem' can be decremented."
    (lisp Unit (sem)
      (bt2:wait-on-semaphore sem)
      Unit)))
