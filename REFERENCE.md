# coalton-threads/thread

## Types

### THREAD :: *\* → \**

> A thread that can be joined to yield the result of the thunk used to create it.

## Values

### CURRENT-THREAD :: *(UNIT → LISPTHREAD)*

> Returns the thread object representing the calling thread.

### ALL-THREADS :: *(UNIT → (LIST LISPTHREAD))*

> Returns a fresh list of all running threads.

### INTERRUPT :: *∀ A. INTO A LISPTHREAD ⇒ (A → (UNIT → UNIT) → (RESULT LISPCONDITION A))*

> Interrupt thread and call \`thunk' within its dynamic context,
> then continue with the interrupted path of execution.

### DESTROY :: *∀ A. INTO A LISPTHREAD ⇒ (A → (RESULT LISPCONDITION A))*

> Terminates the thread \`thread'.

### ALIVE? :: *∀ A. INTO A LISPTHREAD ⇒ (A → BOOLEAN)*

> Returns True if \`thread' has not finished or \`destroy' has not been called on it.

### SPAWN :: *∀ A. ((UNIT → A) → (THREAD A))*

> Creates and returns a thread, which will call the function
> \`thunk' with no arguments: when \`thunk' returns, the thread terminates.

### JOIN :: *∀ A. ((THREAD A) → (RESULT LISPCONDITION A))*

> Wait until \`thread' terminates, or if it has already terminated, return immediately.

# coalton-threads/lock

## Types

### LOCK :: *\**

> Wrapper for a native non-recursive lock.

## Values

### ACQUIRE-NO-WAIT :: *(LOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.
> Returns Boolean immediately, True if \`lock' was acquired, False otherwise.

### WITH-LOCK-HELD :: *∀ A. (LOCK → (UNIT → A) → A)*

> NIL

### RELEASE :: *(LOCK → (RESULT LISPCONDITION LOCK))*

> Release \`lock'. It is an error to call this unless
> the lock has previously been acquired (and not released) by the same
> thread. If other threads are waiting for the lock, the
> \`acquire-lock' call in one of them will now be able to continue.
> 
> Returns the lock.

### ACQUIRE :: *(LOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

### NEW :: *(UNIT → LOCK)*

> Creates a non-recursive lock.

# coalton-threads/recursive-lock

## Types

### RECURSIVELOCK :: *\**

> Wrapper for a native recursive lock.

## Values

### ACQUIRE-NO-WAIT :: *(RECURSIVELOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.
> Returns Boolean immediately, True if \`lock' was acquired, False otherwise.

### WITH-LOCK-HELD :: *∀ A. (RECURSIVELOCK → (UNIT → A) → A)*

> NIL

### RELEASE :: *(RECURSIVELOCK → (RESULT LISPCONDITION RECURSIVELOCK))*

> Release \`lock'. It is an error to call this unless
> the lock has previously been acquired (and not released) by the same
> thread. If other threads are waiting for the lock, the
> \`acquire-lock' call in one of them will now be able to continue.
> 
> Returns the lock.

### ACQUIRE :: *(RECURSIVELOCK → BOOLEAN)*

> Acquire \`lock' for the calling thread.

### NEW :: *(UNIT → RECURSIVELOCK)*

> Creates a non-recursive lock.

# coalton-threads/condition-variable

## Types

### CONDITIONVARIABLE :: *\**

> Wrapper for a native condition variable.

## Values

### BROADCAST :: *(CONDITIONVARIABLE → UNIT)*

> Notify all of the threads waiting for \`cv'.

### NOTIFY :: *(CONDITIONVARIABLE → UNIT)*

> Notify one of the threads waiting for \`cv'.

### AWAIT :: *(CONDITIONVARIABLE → LOCK → UNIT)*

> Atomically release \`lock' and enqueue the calling thread waiting for \`cv'.
> The thread will resume when another thread has notified it using \`notify-cv';
> it may also resume if interrupted by some external event or in other
> implementation-dependent circumstances: the caller must always test on waking
> that there is threading to be done, instead of assuming that it can go ahead.

### NEW :: *(UNIT → CONDITIONVARIABLE)*

> Creates a condition variable.

# coalton-threads/semaphore

## Types

### SEMAPHORE :: *\**

> Wrapper for a native semaphore.

## Values

### SIGNAL :: *(SEMAPHORE → UFIX → UNIT)*

> Increment \`sem' by \`count'.
> If there are threads awaiting this semaphore, then \`count' of them are woken up.

### AWAIT :: *(SEMAPHORE → UNIT)*

> Decrement the count of \`sem' by 1 if the count is larger than zero.
> If the count is zero, blocks until \`sem' can be decremented.

### NEW :: *(UNIT → SEMAPHORE)*

> Creates a semaphore with initial count 0.

# coalton-threads/atomic

## Types

### ATOMICINTEGER :: *\**

> An unsigned machine word that allows atomic increment, decrement and swap.

## Values

### INCF! :: *(ATOMICINTEGER → U64 → U64)*

> Increments the value of \`atomic' by \`delta'.

### DECF! :: *(ATOMICINTEGER → U64 → U64)*

> Decrements the value of \`atomic' by \`delta'.

### READ :: *(ATOMICINTEGER → U64)*

> Returns the current value of \`atomic'.

### CAS! :: *(ATOMICINTEGER → U64 → U64 → BOOLEAN)*

> If the current value of \`atomic' is equal to \`old', replace it with \`new'.
> Returns True if the replacement was successful, otherwise False.

### NEW :: *(U64 → ATOMICINTEGER)*

> Creates an \`AtomicInteger' with initial value \`value'.

# coalton-threads/mutex

## Types

### MUTEX :: *\* → \**

> A mutually exclusive cell.

## Values

### UPDATE! :: *∀ A. ((MUTEX A) → (A → A) → A)*

> Swap the value held in a Mutex with a transforming function.

### WRITE! :: *∀ A. ((MUTEX A) → A → A)*

> Set the value held in a Mutex, returning the new value.

### SWAP! :: *∀ A. ((MUTEX A) → A → A)*

> Replace the value held in a Mutex, returning the old value.

### READ :: *∀ A. ((MUTEX A) → A)*

> Access the value held in a Mutex.

### NEW :: *∀ A. (A → (MUTEX A))*

> NIL

# coalton-threads/barrier

## Types

### BARRIER :: *\**

> nil

## Values

### UNBLOCK! :: *(BARRIER → UNIT)*

> NIL

### BLOCK! :: *(BARRIER → UNIT)*

> NIL

### AWAIT :: *(BARRIER → UNIT)*

> NIL

### NEW :: *(UNIT → BARRIER)*

> NIL

