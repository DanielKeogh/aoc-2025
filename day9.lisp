;;;; day9.lisp

(in-package :aoc-2025)

(defun read-day9 (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          collect (mapcar #'parse-integer (str:split "," next)) into result
          finally (return (coerce result 'vector)))))

(defun day9-problem1 (filename))
