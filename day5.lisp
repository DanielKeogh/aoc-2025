;;;; day5.lisp

(in-package :aoc-2025)

(defun parse-ingredients (file)
  (with-open-file (stream (get-file-path file))
    (values
     (loop for next = (read-line stream)
           while (> (length next) 0)
           collect (mapcar #'parse-integer (str:split "-" next)))
     (loop for next = (read-line stream nil)
           while next
           collect (parse-integer next)))))

(defun day5-problem1 ()
  (multiple-value-bind (ranges ingredients) (parse-ingredients "data/day5_input.txt")
      (loop for ingredient in ingredients
            count (loop for (start end) in ranges
                        thereis (and (>= ingredient start)
                                     (<= ingredient end))))))

(defun day5-problem2 ()
  (let* ((ranges (parse-ingredients "data/day5_sample.txt"))
         (s (sort ranges (lambda (a b) (< (car a) (car b))))))
    (let ((last-start (caar s))
          (last-end (cadar s))
          (r (list)))
      (loop for (start end) in (cdr s) do
        (if (> start last-end)
            (progn
              (push (list last-start last-end) r)
              (setf last-start start
                    last-end end))
            (when (> end last-end)
              (setf last-end end)))
            finally (push (list last-start last-end) r))
      (loop for (start end) in r
            sum (1+ (- end start))))))
