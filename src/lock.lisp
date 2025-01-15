(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:lock)
  (define-type Lock
    "Wrapper for a native non-recursive lock.")

  (repr :native bt2:recursive-lock)
  (define-type RecursiveLock
    "Wrapper for a native recursive lock.")

  (declare make-lock (Unit -> Lock))
  (define (make-lock)
    "Creates a non-recursive lock."
    (lisp Lock ()
      (bt2:make-lock)))

  (declare acquire-lock (Lock -> Boolean))
  (define (acquire-lock lock)
    "Acquire `lock' for the calling thread."
    (lisp Boolean (lock)
      (bt2:acquire-lock lock)))

  (declare acquire-lock-no-wait (Lock -> Boolean))
  (define (acquire-lock-no-wait lock)
    "Acquire `lock' for the calling thread.
Returns Boolean immediately, True if `lock' was acquired, False otherwise."
    (lisp Boolean (lock)
      (bt2:acquire-lock lock :wait nil)))

  (declare release-lock (Lock -> (Result LispCondition Lock)))
  (define (release-lock lock)
    "Release `lock'. It is an error to call this unless
the lock has previously been acquired (and not released) by the same
thread. If other threads are waiting for the lock, the
`acquire-lock' call in one of them will now be able to continue.

Returns the lock."
    (lisp (Result LispCondition Lock) (lock)
      (cl:handler-case (Ok (bt2:release-lock lock))
        (cl:error (c) (Err c)))))

  (declare with-lock-held (Lock -> (Unit -> :a) -> :a))
  (define (with-lock-held lock thunk)
    (acquire-lock lock)
    (let ((result (thunk)))
      (release-lock lock)
      result))

  (declare make-recursive-lock (Unit -> RecursiveLock))
  (define (make-recursive-lock)
    "Creates a recursive lock."
    (lisp RecursiveLock ()
      (bt2:make-recursive-lock)))

  (declare acquire-recursive-lock (RecursiveLock -> Boolean))
  (define (acquire-recursive-lock lock)
    "Acquire `lock' for the calling thread."
    (lisp Boolean (lock)
      (bt2:acquire-recursive-lock lock)))

  (declare acquire-recursive-lock-no-wait (Lock -> Boolean))
  (define (acquire-recursive-lock-no-wait lock)
    "Acquire `lock' for the calling thread.
Returns Boolean immediately, True if `lock' was acquired, False otherwise."
    (lisp Boolean (lock)
      (bt2:acquire-recursive-lock lock :wait nil)))

  (declare release-recursive-lock (RecursiveLock -> (Result LispCondition RecursiveLock)))
  (define (release-recursive-lock lock)
    "Release `lock'. It is an error to call this unless
the lock has previously been acquired (and not released) by the same
thread. If other threads are waiting for the lock, the
`acquire-lock' call in one of them will now be able to continue.

Returns the lock."
    (lisp (Result LispCondition RecursiveLock) (lock)
      (cl:handler-case (Ok (bt2:release-recursive-lock lock))
        (cl:error (c) (Err c)))))

  (declare with-recursive-lock-held (RecursiveLock -> (Unit -> :a) -> :a))
  (define (with-recursive-lock-held lock thunk)
    (acquire-recursive-lock lock)
    (let ((result (thunk)))
      (release-recursive-lock lock)
      result)))
