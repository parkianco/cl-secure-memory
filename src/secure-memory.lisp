;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; secure-memory.lisp
;;;; Secure memory allocation and wiping
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(in-package #:cl-secure-memory)

;;; Track allocated secure buffers for cleanup
(defvar *secure-buffers* (make-hash-table :test 'eq))
(defvar *secure-buffers-lock* nil)

#+sbcl
(setf *secure-buffers-lock* (sb-thread:make-mutex :name "secure-buffers-lock"))

(defmacro with-secure-lock (&body body)
  "Execute body with secure buffers lock held."
  #+sbcl
  `(sb-thread:with-mutex (*secure-buffers-lock*)
     ,@body)
  #-sbcl
  `(progn ,@body))

(defun zero-memory (buffer &optional (start 0) (end nil))
  "Securely zero out a byte buffer.
   Uses volatile writes to prevent compiler optimization.
   BUFFER: A byte array to zero.
   START: Starting index (default 0).
   END: Ending index (default buffer length)."
  (let ((actual-end (or end (length buffer))))
    (declare (type fixnum start actual-end))
    ;; Write zeros byte by byte to prevent optimization
    (loop for i from start below actual-end do
      ;; Use volatile-ish pattern - write and read back
      (setf (aref buffer i) 0)
      ;; Force evaluation - prevents dead code elimination
      (unless (zerop (aref buffer i))
        (error "Memory zeroing failed")))
    ;; Additional pass with different pattern
    (loop for i from start below actual-end do
      (setf (aref buffer i) #xff))
    (loop for i from start below actual-end do
      (setf (aref buffer i) 0))
    buffer))

(defun allocate-secure (size &key (initial-element 0))
  "Allocate a secure byte buffer.
   The buffer will be tracked for explicit cleanup.
   SIZE: Number of bytes to allocate.
   INITIAL-ELEMENT: Initial value for all bytes (default 0).
   Returns a simple byte array."
  (let ((buffer (make-array size
                            :element-type '(unsigned-byte 8)
                            :initial-element initial-element)))
    (with-secure-lock
      (setf (gethash buffer *secure-buffers*) t))
    buffer))

(defun free-secure (buffer)
  "Securely free a buffer by zeroing and untracking it.
   BUFFER: A buffer previously allocated with allocate-secure.
   Returns T if the buffer was found and freed, NIL otherwise."
  (with-secure-lock
    (when (gethash buffer *secure-buffers*)
      (zero-memory buffer)
      (remhash buffer *secure-buffers*)
      t)))

(defun lock-memory (buffer)
  "Attempt to lock memory to prevent swapping.
   This is a best-effort operation - may not be available on all platforms.
   BUFFER: A byte array.
   Returns T if locking was attempted, NIL if not supported."
  (declare (ignore buffer))
  ;; SBCL doesn't provide direct mlock access without CFFI
  ;; This is a placeholder for platforms that support it
  #+sbcl
  (progn
    ;; On SBCL, we could use sb-alien to call mlock, but we avoid
    ;; external dependencies. Return nil to indicate not implemented.
    nil)
  #-sbcl
  nil)

(defun unlock-memory (buffer)
  "Unlock previously locked memory.
   BUFFER: A byte array.
   Returns T if unlocking was attempted, NIL if not supported."
  (declare (ignore buffer))
  #+sbcl nil
  #-sbcl nil)

(defmacro with-secure-buffer ((var size &key (initial-element 0)) &body body)
  "Execute body with a secure buffer bound to VAR.
   The buffer is automatically zeroed and freed when body exits.
   SIZE: Number of bytes to allocate.
   INITIAL-ELEMENT: Initial value for all bytes (default 0)."
  (let ((buffer-var (gensym "SECURE-BUFFER")))
    `(let* ((,buffer-var (allocate-secure ,size :initial-element ,initial-element))
            (,var ,buffer-var))
       (unwind-protect
            (progn ,@body)
         (free-secure ,buffer-var)))))

;;; Cleanup function for application shutdown
(defun cleanup-all-secure-buffers ()
  "Zero and free all tracked secure buffers.
   Call this during application shutdown."
  (with-secure-lock
    (maphash (lambda (buffer present)
               (declare (ignore present))
               (zero-memory buffer))
             *secure-buffers*)
    (clrhash *secure-buffers*))
  t)
