(defpackage #:coalton-threads/atomic
  (:use #:coalton #:coalton-prelude)
  (:export
   #:AtomicInteger
   #:new
   #:cas!
   #:decf!
   #:incf!
   #:read))
(in-package #:coalton-threads/atomic)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-type-alias Word #+32-bit U32 #+64-bit U64
    "An integer that fits in a CPU word.")

  (repr :native bt2:atomic-integer)
  (define-type AtomicInteger
    "An unsigned machine word that allows atomic increment, decrement and swap.")

  (declare new (Word -> AtomicInteger))
  (define (new value)
    "Creates an `AtomicInteger' with initial value `value'."
    (lisp AtomicInteger (value)
      (bt2:make-atomic-integer :value value)))

  (declare cas! (AtomicInteger -> Word -> Word -> Boolean))
  (define (cas! atomic old new)
    "If the current value of `atomic' is equal to `old', replace it with `new'.
Returns True if the replacement was successful, otherwise False."
    (lisp Boolean (atomic old new)
      (bt2:atomic-integer-compare-and-swap atomic old new)))

  (declare decf! (AtomicInteger -> Word -> Word))
  (define (decf! atomic delta)
    "Decrements the value of `atomic' by `delta'."
    (lisp Word (atomic delta)
      (bt2:atomic-integer-decf atomic delta)))

  (declare incf! (AtomicInteger -> Word -> Word))
  (define (incf! atomic delta)
    "Increments the value of `atomic' by `delta'."
    (lisp Word (atomic delta)
      (bt2:atomic-integer-incf atomic delta)))

  (declare read (AtomicInteger -> Word))
  (define (read atomic)
    "Returns the current value of `atomic'."
    (lisp Word (atomic)
      (bt2:atomic-integer-value atomic))))
