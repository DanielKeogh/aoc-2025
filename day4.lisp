;;;; day4.lisp

(in-package :aoc-2025)

(defun read-day4-map (file)
  (loop with lines = (str:lines (alexandria:read-file-into-string (get-file-path file)))
        with result = (make-array (list (length lines) (length (car lines)))
                                  :element-type 'boolean
                                  :initial-element nil)
        for line in lines
        for row from 0
        do (loop for c across line
                 for col from 0
                 do (setf (aref result row col) (char-equal c #\@)))
        finally (return result)))

(defun forklift-accessible (map row col)
  (and (aref map row col)
       (loop for r from (max 0 (1- row))
               to (min (1+ row) (1- (array-dimension map 0)))
             sum (loop for c from (max 0 (1- col))
                         to (min (1+ col) (1- (array-dimension map 1)))
                       count (aref map r c))
               into adjacent
             always (< adjacent 5))))

(defun count-forkliftable-rolls (map)
  (let ((new-map (alexandria:copy-array map)))
    (values
     (loop for row below (array-dimension map 0)
           sum (loop for col below (array-dimension map 1)
                     count (prog1 (forklift-accessible map row col)
                             (setf (aref new-map row col) nil))))
     new-map)))

(defun day4-problem1 ()
  (let ((map (read-day4-map "data/day4_input.txt")))
    (nth-value 0 (count-forkliftable-rolls map))))

(defun day4-problem2 ()
  (loop for map = (read-day4-map "data/day4_input.txt") then new-map
        for (removed new-map) = (multiple-value-list (count-forkliftable-rolls map))
        while (> removed 0)
        sum removed))
