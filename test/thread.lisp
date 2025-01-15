(in-package #:coalton-threads/test)
(named-readtables:in-readtable coalton:coalton)

(define-test thread-spawn-and-join ()
  (let ((thread (threads:spawn (sys:sleep (the Integer 1)) (make-list 1))))
    (is (threads:alive? thread))
    (is (== (make-list 1) (unwrap (threads:join thread))))
    (is (not (threads:alive? thread)))))

(define-test thread-lisp-typed-join ()
  (let ((thread
          (lisp (threads:Thread String) ()
            (bt2:make-thread (cl:lambda () "string"))))
        (thread-inferred
          (lisp (threads:Thread :a) ()
            (bt2:make-thread (cl:lambda () 1.01)))))
    (is (== "string" (unwrap (threads:join thread))))
    (is (== 1.01 (unwrap (threads:join thread-inferred))))))

(define-test thread-destroy-and-join ()
  (let ((thread (threads:spawn (sys:sleep (the Integer 10)) 10)))
    (threads:destroy thread)
    (is (result:err? (threads:join thread)))
    (is (result:err? (threads:destroy thread)))))

(define-test thread-all-threads ()
  (is (some?
       (find (== (threads:current-thread))
             (threads:all-threads)))))

(define-test thread-all-threads-contains-new ()
  (let ((old-threads (threads:all-threads))
        (thread (threads:spawn (sys:sleep (the Integer 40)))))
    (sys:sleep (the Integer 1))
    (is (some? (find (== (into thread)) (threads:all-threads))))
    (is (none? (find (== (into thread)) old-threads)))
    (threads:destroy thread)))

(define-test thread-interrupt-twice ()
  (let ((thread (threads:make-thread (fn () (sys:sleep (the Integer 40))))))
    (is (result:ok? (threads:interrupt thread (fn () Unit))))
    (is (result:ok? (threads:destroy thread)))
    ;; this won't work on CCL until this issue is solved
    ;; https://github.com/sionescu/bordeaux-threads/issues/127
    (sys:sleep (the Integer 1))
    #+ccl
    (warn "Fix Me: https://github.com/sionescu/bordeaux-threads/issues/127")
    #-ccl
    (is (result:err? (threads:interrupt thread (fn () Unit))))))
