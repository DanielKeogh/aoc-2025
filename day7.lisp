;;;; day7

(in-package :aoc-2025)

(defun day7-problems ()
  (let ((map (read-2d-array "data/day7_input.txt" #'identity))
        (problem1-solution 0))
    (loop for row from 0 below (1- (array-dimension map 0)) do
      (loop for col from 0 below (array-dimension map 1)
            for c = (aref map row col)
            do
               (labels ((write-num (val row col)
                          (when (and (>= col 0)
                                     (<= col (1- (array-dimension map 1))))
                            (if (numberp (aref map row col))
                                (incf (aref map row col) val)
                                (setf (aref map row col) val))))
                        (write-beam (counter)
                          (when (< (1+ row) (array-dimension map 0))
                            (if (eq #\^ (aref map (1+ row) col))
                                (progn
                                  (incf problem1-solution)
                                  (write-num counter (1+ row) (1- col))
                                  (write-num counter (1+ row) (1+ col)))
                                (write-num counter (1+ row) col)
                                ))))
                 (cond ((eq #\S c)
                        (write-beam 1))
                       ((numberp c)
                        (write-beam c))))))

    (values problem1-solution
            (loop for col from 0 below (array-dimension map 1)
                  for val = (aref map (1- (array-dimension map 0)) col)
                  when val sum val))))
