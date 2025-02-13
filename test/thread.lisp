(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test thread-spawn-and-join ()
  (let ((thread (thread:spawn (fn () (sleep 1) (make-list 1)))))
    (is (thread:alive? thread))
    (is (== (make-list 1) (unwrap (thread:join thread))))
    (is (not (thread:alive? thread)))))

(define-test thread-lisp-typed-join ()
  (let ((thread
          (lisp (thread:Thread String) ()
            (bt2:make-thread (cl:lambda () "string"))))
        (thread-inferred
          (lisp (thread:Thread :a) ()
            (bt2:make-thread (cl:lambda () 1.01)))))
    (is (== "string" (unwrap (thread:join thread))))
    (is (== 1.01 (unwrap (thread:join thread-inferred))))))

(define-test thread-destroy-and-join ()
  (let ((thread (thread:spawn (fn () (sleep 10) 10))))
    (thread:destroy thread)
    (is (result:err? (thread:join thread)))
    (is (result:err? (thread:destroy thread)))))

(define-test thread-all-threads ()
  (is (some?
       (find (== (thread:current-thread))
             (thread:all-threads)))))

(define-test thread-all-threads-contains-new ()
  (let ((old-threads (thread:all-threads))
        (thread (thread:spawn (fn () (sleep 40)))))
    (sleep 1)
    (is (some? (find (== (into thread)) (thread:all-threads))))
    (is (none? (find (== (into thread)) old-threads)))
    (thread:destroy thread)))

(define-test thread-interrupt-twice ()
  (let ((thread (thread:spawn (fn () (sleep 40)))))
    (is (result:ok? (thread:interrupt thread (fn () Unit))))
    (is (result:ok? (thread:destroy thread)))
    ;; this won't work on CCL until this issue is solved
    ;; https://github.com/sionescu/bordeaux-threads/issues/127
    (sleep 1)
    #+ccl
    (warn "Fix Me: https://github.com/sionescu/bordeaux-threads/issues/127")
    #-ccl
    (is (result:err? (thread:interrupt thread (fn () Unit))))))
