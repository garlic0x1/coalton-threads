## coalton-threads

### [Type] CONDITIONVARIABLE *\**

> Wrapper for a native condition variable.

### [Type] RECURSIVELOCK *\**

> Wrapper for a native recursive lock.

### [Type] ATOMICINTEGER *\**

> An unsigned machine word that allows atomic increment, decrement and swap.

### [Type] LISPTHREAD *\**

> A plain lisp thread.

### [Type] SEMAPHORE *\**

> Wrapper for a native semaphore.

### [Type] THREAD *\* → \**

> A thread that can be joined to yield the result of the thunk used to create it.

### [Type] MUTEX *\* → \**

> A mutually exclusive cell.

### [Type] WORD *\**

> An integer that fits in a CPU word.

### [Type] LOCK *\**

> Wrapper for a native non-recursive lock.

### [Value] ACQUIRE-RECURSIVE-LOCK-NO-WAIT *(LOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

> Returns Boolean immediately, True if \`lock' was acquired, False otherwise.

### [Value] WITH-RECURSIVE-LOCK-HELD *∀ A. (RECURSIVELOCK → (UNIT → A) → A)*

> NIL

### [Value] RELEASE-RECURSIVE-LOCK *(RECURSIVELOCK → (RESULT LISPCONDITION RECURSIVELOCK))*

> Release \`lock'. It is an error to call this unless

> the lock has previously been acquired (and not released) by the same

> thread. If other threads are waiting for the lock, the

> \`acquire-lock' call in one of them will now be able to continue.

> 

> Returns the lock.

### [Value] ACQUIRE-RECURSIVE-LOCK *(RECURSIVELOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

### [Value] ACQUIRE-LOCK-NO-WAIT *(LOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

> Returns Boolean immediately, True if \`lock' was acquired, False otherwise.

### [Value] MAKE-RECURSIVE-LOCK *(UNIT → RECURSIVELOCK)*

> Creates a recursive lock.

### [Value] SIGNAL-SEMAPHORE *(SEMAPHORE → UFIX → UNIT)*

> Increment \`sem' by \`count'.

> If there are threads awaiting this semaphore, then \`count' of them are woken up.

### [Value] AWAIT-SEMAPHORE *(SEMAPHORE → UNIT)*

> Decrement the count of \`sem' by 1 if the count is larger than zero.

> If the count is zero, blocks until \`sem' can be decremented.

### [Value] WITH-LOCK-HELD *∀ A. (LOCK → (UNIT → A) → A)*

> NIL

### [Value] MAKE-SEMAPHORE *(UNIT → SEMAPHORE)*

> Creates a semaphore with initial count 0.

### [Value] CURRENT-THREAD *(UNIT → LISPTHREAD)*

> Returns the thread object representing the calling thread.

### [Value] UPDATE-MUTEX! *∀ A. ((MUTEX A) → (A → A) → A)*

> Swap the value held in a Mutex with a transforming function.

### [Value] WRITE-MUTEX! *∀ A. ((MUTEX A) → A → A)*

> Set the value held in a Mutex.

### [Value] RELEASE-LOCK *(LOCK → (RESULT LISPCONDITION LOCK))*

> Release \`lock'. It is an error to call this unless

> the lock has previously been acquired (and not released) by the same

> thread. If other threads are waiting for the lock, the

> \`acquire-lock' call in one of them will now be able to continue.

> 

> Returns the lock.

### [Value] INCF-ATOMIC! *(ATOMICINTEGER → U64 → U64)*

> Increments the value of \`atomic' by \`delta'.

### [Value] DECF-ATOMIC! *(ATOMICINTEGER → U64 → U64)*

> Decrements the value of \`atomic' by \`delta'.

### [Value] BROADCAST-CV *(CONDITIONVARIABLE → UNIT)*

> Notify all of the threads waiting for \`cv'.

### [Value] ATOMIC-VALUE *(ATOMICINTEGER → U64)*

> Returns the current value of \`atomic'.

### [Value] ACQUIRE-LOCK *(LOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

### [Value] MAKE-THREAD *∀ A. ((UNIT → A) → (THREAD A))*

> Creates and returns a thread, which will call the function

> \`thunk' with no arguments: when \`thunk' returns, the thread terminates.

### [Value] MAKE-ATOMIC *(U64 → ATOMICINTEGER)*

> Creates an \`AtomicInteger' with initial value \`value'.

### [Value] CAS-ATOMIC! *(ATOMICINTEGER → U64 → U64 → BOOLEAN)*

> If the current value of \`atomic' is equal to \`old', replace it with \`new'.

> Returns True if the replacement was successful, otherwise False.

### [Value] ALL-THREADS *(UNIT → (LIST LISPTHREAD))*

> Returns a fresh list of all running threads.

### [Value] READ-MUTEX *∀ A. ((MUTEX A) → A)*

> Access the value held in a Mutex.

### [Value] NOTIFY-CV *(CONDITIONVARIABLE → UNIT)*

> Notify one of the threads waiting for \`cv'.

### [Value] MAKE-LOCK *(UNIT → LOCK)*

> Creates a non-recursive lock.

### [Value] INTERRUPT *∀ A. INTO A LISPTHREAD ⇒ (A → (UNIT → UNIT) → (RESULT LISPCONDITION A))*

> Interrupt thread and call \`thunk' within its dynamic context,

> then continue with the interrupted path of execution.

### [Value] AWAIT-CV *(CONDITIONVARIABLE → LOCK → UNIT)*

> Atomically release \`lock' and enqueue the calling thread waiting for \`cv'.

> The thread will resume when another thread has notified it using \`notify-cv';

> it may also resume if interrupted by some external event or in other

> implementation-dependent circumstances: the caller must always test on waking

> that there is threading to be done, instead of assuming that it can go ahead.

### [Value] MAKE-CV *(UNIT → CONDITIONVARIABLE)*

> Creates a condition variable.

### [Value] DESTROY *∀ A. INTO A LISPTHREAD ⇒ (A → (RESULT LISPCONDITION A))*

> Terminates the thread \`thread'.

### [Value] ALIVE? *∀ A. INTO A LISPTHREAD ⇒ (A → BOOLEAN)*

> Returns True if \`thread' has not finished or \`destroy' has not been called on it.

### [Value] MUTEX *∀ A. (LOCK → (CELL A) → (MUTEX A))*

> A mutually exclusive cell.

### [Value] JOIN *∀ A. ((THREAD A) → (RESULT LISPCONDITION A))*

> Wait until \`thread' terminates, or if it has already terminated, return immediately.

