;;;; day10.lisp

(in-package :aoc-2025)

(defun parse-machine (line)
  (let* ((lines (str:split " " line))
         (indicator (loop with s = (-> (first lines)
                                       (str:trim :char-bag '(#\[ #\])))
                          with r = (make-array (list (length s)) :element-type 'boolean
                                               :initial-element nil)
                          for i from 0
                          for c across s
                          when (char= #\# c)
                            do (setf (aref r i) t)
                          finally (return r)))
         (buttons (mapcar (lambda (l)
                             (-> l
                                 (str:trim :char-bag '(#\( #\)))
                                 (->> (str:split ",")
                                      (mapcar #'parse-integer))))
                           (butlast (rest lines))))
         (jolts  (-> (car (last lines))
                  (str:trim :char-bag '(#\{ #\}))
                  (->> (str:split ",")
                       (mapcar #'parse-integer))
                  (coerce 'vector))))

    (list indicator buttons jolts)))

(defun read-day10 (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          collect (parse-machine next))))

(defun min-presses (target buttons)
  (let ((q (q:make-queue 1000))
        (seen (make-hash-table)))
    (q:enqueue (list 0 (make-array (list (length target))
                                   :initial-element nil
                                   :element-type 'boolean))
               q)
    
    (loop for (c display) = (q:dequeue q)
          if (equalp display target)
            do (return c)
          else do
            (loop for button in buttons
                  for next-arr = (copy-seq display)
                  do
                     (loop for wire in button do
                       (setf (aref next-arr wire) (not (aref next-arr wire))))
                     (let ((n (loop for x across next-arr
                                    for e = 1 then (+ e e)
                                    when x sum e)))
                       (unless (gethash n seen)
                         (setf (gethash n seen) t)
                         (q:enqueue (list (1+ c) next-arr) q)))))))

(defun day10-problem1 (filename)
  (let ((data (read-day10 filename)))
    (loop for (target buttons) in data
          for i from 0
          sum (min-presses target buttons))))

(defun min-jolts (jolt-target buttons)
  (z3:solver-init)
  (let ((solver (z3:make-optimizer))
        (bvars (coerce (loop for i from 0 below (length buttons) 
                             collect (intern (format nil "BUTTON~A" i)))
                       'vector)))

    (z3:solver-push solver)
    (loop for bvar across bvars do
      (z3:z3-assert-fn `(,bvar :int)
                       `(>= ,bvar 0)
                       solver))
    
    (loop for i from 0
          for target across jolt-target 
          for vvars = (loop for j from 0
                            for button in buttons
                            when (find i button)
                              collect (aref bvars j))
          do
             (z3:z3-assert-fn (loop for b in vvars
                                    collect b
                                    collect :int)
                              `(= (+ ,@vvars) ,target)
                              solver))
     
    (z3::z3-optimize-minimize-fn (loop for b across bvars
                                       collect b
                                       collect :int)
                                 `(+ ,@(coerce bvars 'list))
                                 solver)

    (z3:check-sat solver)
    (loop for (symbol val) in (z3:get-model-as-assignment solver)
          sum val)))

(defun day10-problem2 (filename)
  (let ((data (read-day10 filename)))
    (loop for (target buttons jolt-target) in data
      sum (min-jolts jolt-target buttons))))

