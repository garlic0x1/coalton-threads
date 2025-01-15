(in-package #:coalton-threads)
(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (repr :native bt2:atomic-integer)
  (define-type AtomicInteger
    "An unsigned machine word that allows atomic increment, decrement and swap.")

  (declare make-atomic (#+32-bit U32 #+64-bit U64 -> AtomicInteger))
  (define (make-atomic value)
    "Creates an `AtomicInteger' with initial value `value'."
    (lisp AtomicInteger (value)
      (bt2:make-atomic-integer :value value)))

  (declare cas-atomic! (AtomicInteger -> #+32-bit U32 #+64-bit U64 -> #+32-bit U32 #+64-bit U64 -> Boolean))
  (define (cas-atomic! atomic old new)
    "If the current value of `atomic' is equal to `old', replace it with `new'.
Returns True if the replacement was successful, otherwise False."
    (lisp Boolean (atomic old new)
      (bt2:atomic-integer-compare-and-swap atomic old new)))

  (declare decf-atomic! (AtomicInteger -> #+32-bit U32 #+64-bit U64 -> #+32-bit U32 #+64-bit U64))
  (define (decf-atomic! atomic delta)
    "Decrements the value of `atomic' by `delta'."
    (lisp #+32-bit U32 #+64-bit U64 (atomic delta)
      (bt2:atomic-integer-decf atomic delta)))

  (declare incf-atomic! (AtomicInteger -> #+32-bit U32 #+64-bit U64 -> #+32-bit U32 #+64-bit U64))
  (define (incf-atomic! atomic delta)
    "Increments the value of `atomic' by `delta'."
    (lisp #+32-bit U32 #+64-bit U64 (atomic delta)
      (bt2:atomic-integer-incf atomic delta)))

  (declare atomic-value (AtomicInteger -> #+32-bit U32 #+64-bit U64))
  (define (atomic-value atomic)
    "Returns the current value of `atomic'."
    (lisp #+32-bit U32 #+64-bit U64 (atomic)
      (bt2:atomic-integer-value atomic))))
