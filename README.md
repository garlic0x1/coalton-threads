Primitive Threads and Concurrency Operations for Coalton

This library is a wrapper over
[bordeaux-threads](https://github.com/sionescu/bordeaux-threads) with
a few extras, like a Mutex type.  It is meant to be pretty primitive,
things like actors and parallel kernels are out of the scope of this
library.
     
# Warning

This software is still ALPHA quality. The APIs WILL change.

# Missing Features

Timeouts are not implemented for most operations, and some options
like named threads/locks/etc are not available.

# Known Issues

Interrupting a dead thread in CCL will not result in Err
https://github.com/sionescu/bordeaux-threads/issues/127