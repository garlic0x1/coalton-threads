(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-struct Barrier
    (blocking? (cell:Cell Boolean))
    (cv        ConditionVariable)
    (lock      Lock))

  (declare make-barrier (Unit -> Barrier))
  (define (make-barrier)
    (Barrier (cell:new True) (make-cv) (make-lock)))

  (declare unblock-barrier (Barrier -> Unit))
  (define (unblock-barrier barrier)
    (with-lock-held (.lock barrier) 
      (fn () 
        (cell:write! (.blocking? barrier) False)
        (broadcast-cv (.cv barrier)))))

  (declare block-barrier (Barrier -> Unit))
  (define (block-barrier barrier)
    (with-lock-held (.lock barrier)
      (fn () 
        (cell:write! (.blocking? barrier) True)))
    Unit)

  (declare await-barrier (Barrier -> Unit))
  (define (await-barrier barrier)
    (with-lock-held (.lock barrier)
      (fn ()
        (when (cell:read (.blocking? barrier))
          (await-cv (.cv barrier) (.lock barrier)))))
    Unit)
  )
