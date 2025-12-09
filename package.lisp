;;;; package.lisp

(defpackage #:aoc-2025
  (:use #:cl :arrows)
  (:local-nicknames (:graph :com.danielkeogh.graph)
                    (:algs :com.danielkeogh.graph.algorithms)
                    (:q :cl-speedy-queue)))
