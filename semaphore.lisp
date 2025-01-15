(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:semaphore)
  (define-type Semaphore
    "Wrapper for a native semaphore.")

  (declare make-semaphore (Unit -> Semaphore))
  (define (make-semaphore)
    "Creates a semaphore with initial count 0."
    (lisp Semaphore ()
      (bt2:make-semaphore)))

  (declare signal-semaphore (Semaphore -> UFix -> Unit))
  (define (signal-semaphore sem count)
    "Increment `sem' by `count'.
If there are threads awaiting this semaphore, then `count' of them are woken up."
    (lisp Unit (sem count)
      (bt2:signal-semaphore sem :count count)
      Unit))

  (declare await-semaphore (Semaphore -> Unit))
  (define (await-semaphore sem)
    "Decrement the count of `sem' by 1 if the count is larger than zero.
If the count is zero, blocks until `sem' can be decremented."
    (lisp Unit (sem)
      (bt2:wait-on-semaphore sem)
      Unit)))
