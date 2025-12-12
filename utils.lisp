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

(defun rotate-string (str)
  (let* ((lines (str:lines str))
         (line-len (length (first lines))))
    (loop for line in (rest lines)
          do (assert (= (length line) line-len)))
    (str:join *newline*
              (loop for i below line-len
                    collect (coerce (loop for line in lines
                                          collect (aref line i))
                                    'string)))))

(defun min-max (&rest args)
  (sort args #'<))

(defun rotate-array (arr)
  (let ((copy (alexandria:copy-array arr))
        (width (array-dimension arr 0)))
    (loop for r below width do
      (loop for c below width do
        (setf (aref copy (- width c 1) r) (aref arr r c))))
    copy))
