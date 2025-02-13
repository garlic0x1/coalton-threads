(defpackage #:coalton-threads/barrier
  (:use #:coalton #:coalton-prelude)
  (:local-nicknames
   (#:cv #:coalton-threads/condition-variable)
   (#:lock #:coalton-threads/lock)
   (#:cell #:coalton-library/cell))
  (:export
   #:Barrier
   #:new
   #:unblock!
   #:block!
   #:await
   ))
(in-package #:coalton-threads/barrier)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-struct Barrier
    (blocking? (cell:Cell Boolean))
    (cv        cv:ConditionVariable)
    (lock      lock:Lock))

  (declare new (Unit -> Barrier))
  (define (new)
    (Barrier (cell:new True) (cv:new) (lock:new)))

  (declare unblock! (Barrier -> Unit))
  (define (unblock! barrier)
    (lock:with-lock-held (.lock barrier)
      (fn ()
        (cell:write! (.blocking? barrier) False)
        (cv:broadcast (.cv barrier)))))

  (declare block! (Barrier -> Unit))
  (define (block! barrier)
    (lock:with-lock-held (.lock barrier)
      (fn ()
        (cell:write! (.blocking? barrier) True)))
    Unit)

  (declare await (Barrier -> Unit))
  (define (await barrier)
    (lock:with-lock-held (.lock barrier)
      (fn ()
        (when (cell:read (.blocking? barrier))
          (cv:await (.cv barrier) (.lock barrier)))))
    Unit))
