;;;; cl-secure-memory.asd
;;;; Secure memory allocation and wiping
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(asdf:defsystem #:cl-secure-memory
  :description "Secure memory allocation, wiping, and locking"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "secure-memory")))))
