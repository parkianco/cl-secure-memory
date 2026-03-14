;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; package.lisp
;;;; Package definition for cl-secure-memory
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(defpackage #:cl-secure-memory
  (:use #:cl)
  (:export
   ;; Memory operations
   #:allocate-secure
   #:free-secure
   #:zero-memory
   #:lock-memory
   #:unlock-memory
   ;; Macro
   #:with-secure-buffer))
