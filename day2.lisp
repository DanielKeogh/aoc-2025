;;;; day2.lisp

(in-package :aoc-2025)

(defun read-ranges (file)
  (with-open-file (stream (get-file-path file))
    (loop for next = (read-line stream nil)
          while next
          nconc (mapcar (lambda (s) (mapcar #'parse-integer (str:split "-" s)))
                        (str:split "," next)))))

(defun day2-invalid-id1 (n)
  (declare (type fixnum n)
           (optimize (speed 3) (safety 0)))
  (let* ((digit-count (1+ (floor (log n 10))))
         (exponent (expt 10 (floor digit-count 2))))
    (and (= 0 (mod digit-count 2))
         (= (floor n exponent)
            (mod n exponent)))))

(defun day2-invalid-id2 (n)
  (declare (type fixnum n)
           (optimize (speed 3) (safety 0)))
  (loop with digit-count fixnum = (1+ (the fixnum (floor (log n 10))))
        for seq-len fixnum from 1 to (floor digit-count 2)
        for exponent fixnum = 10 then (* 10 exponent)
          thereis (and (= 0 (mod digit-count seq-len))
                       (loop with x fixnum = (mod n exponent)
                             for y fixnum = (floor n exponent) then (floor y exponent)
                             while (> y 0)
                             always (= x (the fixnum (mod y exponent)))))))

(defun day2-problem-sum-invalid (validation-fn file)
  (loop for (start end) in (read-ranges file)
        sum (loop for val fixnum from start to end
                  when (funcall validation-fn val) sum val)))

(defun day2-problem1 ()
  (day2-problem-sum-invalid #'day2-invalid-id1 "data/day2_input.txt"))

(defun day2-problem2 ()
  (day2-problem-sum-invalid #'day2-invalid-id2 "data/day2_input.txt"))
