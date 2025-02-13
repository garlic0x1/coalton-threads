(defpackage #:coalton-threads/recursive-lock
  (:use #:coalton #:coalton-prelude)
  (:import-from #:coalton-library/system #:LispCondition)
  (:export
   #:RecursiveLock
   #:with-lock-held
   #:new
   #:acquire
   #:acquire-no-wait
   #:release))
(in-package #:coalton-threads/recursive-lock)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:recursive-lock)
  (define-type RecursiveLock
    "Wrapper for a native recursive lock.")

  (declare new (Unit -> RecursiveLock))
  (define (new)
    "Creates a non-recursive lock."
    (lisp RecursiveLock ()
      (bt2:make-recursive-lock)))

  (declare acquire (RecursiveLock -> Boolean))
  (define (acquire lock)
    "Acquire `lock' for the calling thread."
    (lisp Boolean (lock)
      (bt2:acquire-recursive-lock lock)))

  (declare acquire-no-wait (RecursiveLock -> Boolean))
  (define (acquire-no-wait lock)
    "Acquire `lock' for the calling thread.
Returns Boolean immediately, True if `lock' was acquired, False otherwise."
    (lisp Boolean (lock)
      (bt2:acquire-recursive-lock lock :wait nil)))

  (declare release (RecursiveLock -> (Result LispCondition RecursiveLock)))
  (define (release lock)
    "Release `lock'. It is an error to call this unless
the lock has previously been acquired (and not released) by the same
thread. If other threads are waiting for the lock, the
`acquire-lock' call in one of them will now be able to continue.

Returns the lock."
    (lisp (Result LispCondition RecursiveLock) (lock)
      (cl:handler-case (Ok (bt2:release-recursive-lock lock))
        (cl:error (c) (Err c)))))

  (declare with-lock-held (RecursiveLock -> (Unit -> :a) -> :a))
  (define (with-lock-held lock thunk)
    (acquire lock)
    (let ((result (thunk)))
      (release lock)
      result)))
