;;;; day3.lisp

(in-package :aoc-2025)

(defun read-jolts (next)
  (map 'vector (lambda (c) (parse-integer (princ-to-string c))) next))

(defmacro max-by (fn a b)
  `(if (> (,fn ,a) (,fn ,b)) ,a ,b))

(defun max-joltage-between (jolts start end)
  (loop 
    for biggest = start
      then (max-by (lambda (x) (aref jolts x)) i biggest)
    for i from (1+ start) below end 
    finally (return biggest)))

(defun max-joltages (jolts batteries-count)
  (loop for x below batteries-count
        for last-index = 0 then (1+ index)
        for index = (max-joltage-between
                     jolts
                     last-index
                     (- (+ 1 (length jolts) x) batteries-count))
        collect index))

(defun day3-problem-sum-jolt (file batteries-count)
  (with-open-file (stream (get-file-path file))
    (loop for next = (read-line stream nil)
          while next
          for jolts = (read-jolts next)
          for indicies = (max-joltages jolts batteries-count)
          sum (loop for i in (nreverse indicies)
                    for exp = 1 then (* 10 exp)
                    sum (* exp (aref jolts i))))))

(defun day3-problem1 ()
  (day3-problem-sum-jolt "data/day3_input.txt" 2))

(defun day3-problem2 ()
  (day3-problem-sum-jolt "data/day3_input.txt" 12))
