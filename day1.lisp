;;;; day1.lisp

(in-package :aoc-2025)

(defun parse-lock-rotation (line)
  (* (if (char= #\R (aref line 0)) 1 -1)
     (parse-integer line :start 1)))

(defun day1-problem1 ()
  (with-open-file (stream (get-file-path "data/day1_input.txt"))
    (loop for dial = 50 then (mod (+ dial rotation) 100)
          for next-line = (read-line stream nil)
          while next-line
          for rotation = (parse-lock-rotation next-line)
          for next-dial = (mod (+ dial rotation) 100)
          count (= next-dial 0))))

(defun day1-problem2 ()
  (with-open-file (stream (resource-full-path "data/day1_input.txt"))
    (loop for dial = 50 then (mod (+ dial rotation) 100)
          for next-line = (read-line stream nil)
          while next-line
          for rotation = (parse-lock-rotation next-line)
          sum (let ((rots (+ dial rotation)))
                (cond ((> rots 99) (floor rots 100))
                      ((< rots 1)
                       (+ (if (= dial 0) 0 1)
                          (floor (abs rots) 100)))
                      (t 0))))))
