(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:condition-variable)
  (define-type ConditionVariable
    "Wrapper for a native condition variable.")

  (declare make-cv (Unit -> ConditionVariable))
  (define (make-cv)
    "Creates a condition variable."
    (lisp ConditionVariable ()
      (bt2:make-condition-variable)))

  (declare await-cv (ConditionVariable -> Lock -> Unit))
  (define (await-cv cv lock)
    "Atomically release `lock' and enqueue the calling thread waiting for `cv'.
The thread will resume when another thread has notified it using `notify-cv';
it may also resume if interrupted by some external event or in other
implementation-dependent circumstances: the caller must always test on waking
that there is threading to be done, instead of assuming that it can go ahead."
    (lisp Unit (cv lock)
      (bt2:condition-wait cv lock)
      Unit))

  (declare notify-cv (ConditionVariable -> Unit))
  (define (notify-cv cv)
    "Notify one of the threads waiting for `cv'."
    (lisp Unit (cv)
      (bt2:condition-notify cv)
      Unit))

  (declare broadcast-cv (ConditionVariable -> Unit))
  (define (broadcast-cv cv)
    "Notify all of the threads waiting for `cv'."
    (lisp Unit (cv)
      (bt2:condition-broadcast cv)
      Unit)))
