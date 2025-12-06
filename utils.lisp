;;;; utils.lisp

(in-package :aoc-2025)

(defun get-file-path (file)
  (multiple-value-bind (a b system-path)
        (asdf:locate-system :aoc-2025)
    (declare (ignore a b))
    (merge-pathnames file system-path)))

(defvar *newline* (princ-to-string #\Newline))

(defun read-2d-array (file fn &key (separator *newline*) (type t))
  (loop with lines = (str:split separator (alexandria:read-file-into-string (get-file-path file)))
        with result = (make-array (list (length lines) (length (car lines)))
                                  :element-type type
                                  :initial-element nil)
        for line in lines
        for row from 0
        do (loop for c across line
                 for col from 0
                 do (setf (aref result row col) (funcall fn c)))
        finally (return result)))
