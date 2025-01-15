(asdf:defsystem #:coalton-threads
  :author "garlic0x1"
  :license "MIT"
  :depends-on (#:coalton #:bordeaux-threads)
  :components ((:file "package")
               (:file "thread")
               (:file "lock")
               (:file "condition-variable")
               (:file "semaphore")
               (:file "atomic")
               (:file "mutex")))
