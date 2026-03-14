;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; cl-secure-memory.asd
;;;; Secure memory allocation and wiping
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(asdf:defsystem #:cl-secure-memory
  :description "Secure memory allocation, wiping, and locking"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "0.1.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "secure-memory")))))

(asdf:defsystem #:cl-secure-memory/test
  :description "Tests for cl-secure-memory"
  :depends-on (#:cl-secure-memory)
  :serial t
  :components ((:module "test"
                :components ((:file "test-secure-memory"))))
  :perform (asdf:test-op (o c)
             (let ((result (uiop:symbol-call :cl-secure-memory.test :run-tests)))
               (unless result
                 (error "Tests failed")))))
