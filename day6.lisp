;;;; day6.lisp

(in-package :aoc-2025)

(defun day6-problem1-parse (file)
  (with-open-file (stream (get-file-path file))
    (nreverse
     (loop for next = (read-line stream nil)
           while next
           collect (remove-if (lambda (l) (= (length l) 0)) (str:split " " next))))))

(defun day6-problem2-parse (file)
  (with-open-file (stream (get-file-path file))
    (nreverse
     (loop for next = (read-line stream nil)
           while next
           collect next))))

(defun day6-problem1 ()
  (let* ((exp (day6-problem1-parse "data/day6_input.txt"))
         (row-count (1- (length exp)))
         (col-count (length (car exp)))
         (arr (make-array (list row-count col-count) :element-type 'fixnum)))
    (loop for row in (cdr exp)
          for r-num from 0 do
            (loop for col in row
                  for c-num from 0
                  do (setf (aref arr r-num c-num) (parse-integer col))))

    (loop for expression in (car exp)
          for c-num from 0
          for fn = (intern expression)
          sum (loop for r-num below row-count
                    for aggr = (aref arr r-num c-num)
                      then (funcall fn aggr (aref arr r-num c-num))
                    finally (return aggr)))))

(defun day6-problem2 ()
  (let* ((exp (day6-problem2-parse "data/day6_input.txt"))
         (eqs (car exp))
         (nums (cdr exp)))

    (let ((current-nums nil)
          (current-op nil)
          (result 0))
      (labels ((eval-aggregate ()
                 (incf result
                       (reduce (intern (princ-to-string current-op))
                               current-nums
                               ))))
        
        (loop for i below (length (car exp)) do
          (when (char/= #\  (aref eqs i))
            (when current-op
              (eval-aggregate)
              (setf current-nums nil))
            (setf current-op (aref eqs i)))
          (loop for str in nums
                for j from 0
                for c = (aref str i)
                when (char/= c #\ )
                  collect c into next-num
                finally (when next-num
                          (push (parse-integer (coerce (nreverse next-num) 'string)) current-nums))))

        (eval-aggregate))
      result)))
