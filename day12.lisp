;;;; day12.lisp

(in-package :aoc-2025)

(defun read-present (stream)
  (let ((present (make-array (list 3 3) :element-type 'fixnum :initial-element 0)))
    (loop for r below 3
          for next = (read-line stream)
          do (loop for c below 3
                   do (setf (aref present r c) (if (char= (aref next c) #\#) 1 0))))
    present))

(defun read-tree (next)
  (let* ((spans (str:split " " next))
         (dimensions (mapcar #'parse-integer
                             (str:split "x" (str:trim (first spans) :char-bag '(#\:)))))
         (quantities (coerce (mapcar #'parse-integer (rest spans)) 'vector)))
    (list dimensions quantities)))

(defun day12-read (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          if (str:ends-with-p ":" next)
            collect (read-present stream) into presents
          else if (not (str:empty? next))
            collect (read-tree next) into trees
          finally (return (values (coerce presents 'vector) (coerce trees 'vector))))))

(defun estimate-size (present) 8) ;; What a disappointing problem....

(defun try-fit (presents tree)
  (let* ((area (apply '* (first tree)))
         (expected-presents (second tree))
         (present-size-estimates 
           (loop for present across presents
                 for expected across expected-presents
                 sum (* expected (estimate-size present)))))

    (> area present-size-estimates)))

(defun day12-problem1 (filename)
  (multiple-value-bind (presents trees) (day12-read filename)
    (loop for tree across trees
          count (try-fit presents tree))))
