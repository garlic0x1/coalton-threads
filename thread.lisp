(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(cl:defmacro spawn (cl:&body body)
  `(make-thread (fn () ,@body)))

(coalton-toplevel
  (repr :native bt2:thread)
  (define-type (Thread :a)
    "A thread that can be joined to yield the result of the thunk used to create it.")

  (repr :native bt2:thread)
  (define-type LispThread
    "A plain lisp thread.")

  (define-instance (Eq LispThread)
    (define (== a b)
      (lisp Boolean (a b) (to-boolean (cl:eq a b)))))

  (define-instance (Eq (Thread :a))
    (define (== a b)
      (lisp Boolean (a b) (to-boolean (cl:eq a b)))))

  (define-instance (Into (Thread :a) LispThread)
    (define (into thread)
      (lisp LispThread (thread)
        thread)))

  (declare make-thread ((Unit -> :a) -> Thread :a))
  (define (make-thread thunk)
    "Creates and returns a thread, which will call the function
`thunk' with no arguments: when `thunk' returns, the thread terminates."
    (lisp (Thread :a) (thunk)
      (bt2:make-thread
       (cl:lambda () (call-coalton-function thunk Unit)))))

  (declare current-thread (Unit -> LispThread))
  (define (current-thread)
    "Returns the thread object representing the calling thread."
    (lisp LispThread ()
      (bt2:current-thread)))

  (declare all-threads (Unit -> (List LispThread)))
  (define (all-threads)
    "Returns a fresh list of all running threads."
    (lisp (List LispThread) ()
      (bt2:all-threads)))

  (declare join (Thread :a -> (Result LispCondition :a)))
  (define (join thread)
    "Wait until `thread' terminates, or if it has already terminated, return immediately."
    (lisp (Result LispCondition :a) (thread)
      (cl:handler-case (Ok (bt2:join-thread thread))
        (cl:error (c) (Err c)))))

  (declare interrupt ((Into :a LispThread) => :a -> (Unit -> Unit) -> (Result LispCondition :a)))
  (define (interrupt thread thunk)
    "Interrupt thread and call `thunk' within its dynamic context,
then continue with the interrupted path of execution."
    (lisp (Result LispCondition :a) (thread thunk)
      (cl:handler-case
          (Ok (bt2:interrupt-thread
               thread
               (cl:lambda () (call-coalton-function thunk Unit))))
        (cl:error (c) (Err c)))))

  (declare destroy ((Into :a LispThread) => :a -> (Result LispCondition :a)))
  (define (destroy thread)
    "Terminates the thread `thread'."
    (lisp (Result LispCondition :a) (thread)
      (cl:handler-case (Ok (bt2:destroy-thread thread))
        (cl:error (c) (Err c)))))

  (declare alive? ((Into :a LispThread) => :a -> Boolean))
  (define (alive? thread)
    "Returns True if `thread' has not finished or `destroy' has not been called on it."
    (lisp Boolean (thread)
      (bt2:thread-alive-p thread))))
