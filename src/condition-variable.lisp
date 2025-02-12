(defpackage #:coalton-threads/condition-variable
  (:use #:coalton #:coalton-prelude)
  (:local-nicknames
   (#:lock #:coalton-threads/lock))
  (:export
   #:ConditionVariable
   #:new
   #:await
   #:notify
   #:broadcast))
(in-package #:coalton-threads/condition-variable)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:condition-variable)
  (define-type ConditionVariable
    "Wrapper for a native condition variable.")

  (declare new (Unit -> ConditionVariable))
  (define (new)
    "Creates a condition variable."
    (lisp ConditionVariable ()
      (bt2:make-condition-variable)))

  (declare await (ConditionVariable -> lock:Lock -> Unit))
  (define (await cv lock)
    "Atomically release `lock' and enqueue the calling thread waiting for `cv'.
The thread will resume when another thread has notified it using `notify-cv';
it may also resume if interrupted by some external event or in other
implementation-dependent circumstances: the caller must always test on waking
that there is threading to be done, instead of assuming that it can go ahead."
    (lisp Unit (cv lock)
      (bt2:condition-wait cv lock)
      Unit))

  (declare notify (ConditionVariable -> Unit))
  (define (notify cv)
    "Notify one of the threads waiting for `cv'."
    (lisp Unit (cv)
      (bt2:condition-notify cv)
      Unit))

  (declare broadcast (ConditionVariable -> Unit))
  (define (broadcast cv)
    "Notify all of the threads waiting for `cv'."
    (lisp Unit (cv)
      (bt2:condition-broadcast cv)
      Unit)))
