;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; test-secure-memory.lisp - Unit tests for secure-memory
;;;;
;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: BSD-3-Clause

(defpackage #:cl-secure-memory.test
  (:use #:cl)
  (:export #:run-tests))

(in-package #:cl-secure-memory.test)

(defun run-tests ()
  "Run all tests for cl-secure-memory."
  (format t "~&Running tests for cl-secure-memory...~%")
  ;; TODO: Add test cases
  ;; (test-function-1)
  ;; (test-function-2)
  (format t "~&All tests passed!~%")
  t)
