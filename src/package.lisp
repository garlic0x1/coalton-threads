(defpackage #:coalton-threads
  (:use #:coalton #:coalton-prelude)
  (:local-nicknames (#:cell #:coalton-library/cell))
  (:import-from #:coalton-library/system #:LispCondition)
  (:shadow #:join)
  (:export
   ;; thread.lisp
   #:Thread
   #:spawn
   #:make-thread
   #:current-thread
   #:all-threads
   #:join
   #:interrupt
   #:destroy
   #:alive?
   ;; lock.lisp
   #:Lock
   #:RecursiveLock
   #:with-lock-held
   #:with-recursive-lock-held
   #:make-lock
   #:make-recursive-lock
   #:acquire-lock
   #:acquire-lock-no-wait
   #:acquire-recursive-lock
   #:acquire-recursive-lock-no-wait
   #:release-lock
   #:release-recursive-lock
   ;; condition-variable.lisp
   #:ConditionVariable
   #:make-cv
   #:await-cv
   #:notify-cv
   #:broadcast-cv
   ;; semaphore.lisp
   #:Semaphore
   #:make-semaphore
   #:signal-semaphore
   #:await-semaphore
   ;; atomic.lisp
   #:AtomicInteger
   #:make-atomic
   #:cas-atomic!
   #:decf-atomic!
   #:incf-atomic!
   #:atomic-value
   ;; mutex.lisp
   #:Mutex
   #:read-mutex
   #:update-mutex!
   #:write-mutex!
   ))
