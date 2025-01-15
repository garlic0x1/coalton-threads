(asdf:defsystem #:coalton-threads
  :author "garlic0x1"
  :license "MIT"
  :depends-on (#:coalton #:bordeaux-threads)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "thread")
                             (:file "lock")
                             (:file "condition-variable")
                             (:file "semaphore")
                             (:file "atomic")
                             (:file "mutex"))))
  :in-order-to ((test-op (test-op #:coalton-threads/test))))

(asdf:defsystem #:coalton-threads/test
  :depends-on (#:coalton-threads #:coalton/testing)
  :serial t
  :components ((:module "test"
                :serial t
                :components ((:file "package")
                             (:file "thread")
                             (:file "lock")
                             (:file "condition-variable")
                             (:file "semaphore")
                             (:file "atomic")
                             (:file "mutex"))))
  :perform (asdf:test-op
            (o s)
            (uiop:symbol-call '#:coalton-threads/test '#:run-tests)))
