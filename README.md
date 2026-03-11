# cl-secure-memory

Secure memory allocation and wiping for Common Lisp.

## Features

- Secure buffer allocation with tracking
- Guaranteed memory zeroing (prevents optimization)
- Automatic cleanup on scope exit
- Thread-safe buffer management (SBCL)
- Zero external dependencies

## Installation

```lisp
(asdf:load-system :cl-secure-memory)
```

## Usage

```lisp
(use-package :cl-secure-memory)

;; Manual allocation/free
(let ((key (allocate-secure 32)))
  (unwind-protect
      (use-key key)
    (free-secure key)))

;; Automatic cleanup with macro
(with-secure-buffer (key 32)
  (copy-key-material-into key)
  (use-key key))
;; Key is automatically zeroed and freed here

;; Manual zeroing
(zero-memory buffer)
(zero-memory buffer :start 0 :end 16)

;; Cleanup all buffers (call on shutdown)
(cleanup-all-secure-buffers)
```

## API

- `allocate-secure size &key initial-element` - Allocate tracked buffer
- `free-secure buffer` - Zero and untrack buffer
- `zero-memory buffer &optional start end` - Securely zero bytes
- `lock-memory buffer` - Attempt to prevent swapping (platform-dependent)
- `unlock-memory buffer` - Unlock memory
- `with-secure-buffer (var size) &body` - Scoped secure buffer
- `cleanup-all-secure-buffers` - Zero and free all tracked buffers

## Security Notes

- Memory zeroing uses multiple passes to resist optimization
- Buffers are tracked to ensure cleanup on application exit
- lock-memory may not be available on all platforms

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC
