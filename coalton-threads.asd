(asdf:defsystem #:coalton-threads
  :author "garlic0x1"
  :license "MIT"
  :description "Primitive Threads and Concurrency Operations for Coalton"
  :depends-on (#:coalton #:bordeaux-threads)
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "thread")
                             (:file "lock")
                             (:file "condition-variable")
                             (:file "semaphore")
                             (:file "atomic")
                             (:file "mutex")
                             (:file "barrier"))))
  :in-order-to ((test-op (test-op #:coalton-threads/test))))

(asdf:defsystem #:coalton-threads/test
  :depends-on (#:coalton-threads #:coalton/testing)
  :components ((:module "test"
                :serial t
                :components ((:file "package")
                             (:file "thread")
                             (:file "lock")
                             (:file "recursive-lock")
                             (:file "condition-variable")
                             (:file "semaphore")
                             (:file "atomic")
                             (:file "mutex")
                             (:file "barrier"))))
  :perform (asdf:test-op
            (o s)
            (uiop:symbol-call '#:coalton-threads/test '#:run-tests)))
