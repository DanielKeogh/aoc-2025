;;;; utils.lisp

(in-package :aoc-2025)

(defun get-file-path (file)
  (multiple-value-bind (a b system-path)
        (asdf:locate-system :aoc-2025)
    (declare (ignore a b))
    (merge-pathnames file system-path)))
