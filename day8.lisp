;;;; day8.lisp

(in-package :aoc-2025)

(defun read-day8 (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          collect (mapcar #'parse-integer (str:split "," next)) into result
          finally (return (coerce result 'vector)))))

(defun distance (vector1 vector2)
  (sqrt (loop for coordinate1 in vector1
              for coordinate2 in vector2
              sum (expt (- coordinate1 coordinate2) 2))))

(defun find-shortest-distances (vectors)
  (loop for a across vectors
        for i from 0
        nconc
        (loop for j from (1+ i) below (length vectors)
              for b = (aref vectors j)
              collect (list (distance a b) i j))
          into all-distances
        finally (return (mapcar #'cdr (sort all-distances #'< :key #'car)))))

(defun day8-problem1 (filename connection-count)
  (let* ((points (read-day8 filename))
         (distances (find-shortest-distances points))
         (g (graph:make-bidirectional-graph))
         (groups (coerce (loop for i below (length points) collect i) 'vector)))
    (dotimes (i (length points)) (graph:add-vertex g i))
    
    (loop for (p1 p2) in distances 
          repeat connection-count
          when (/= (aref groups p1) (aref groups p2))
            do
               (graph:add-edge-between g p1 p2)
               (algs:bidirectional-breadth-first-search
                g
                :root-vertex p2
                :on-discover-vertex-fn (lambda (x) (setf (aref groups x) p1))))

    (-> (coerce groups 'list)
        (group-by:group-by :key 'identity :value 'identity)
        (->> (mapcar 'length)
             (mapcar '1-))
        (sort #'>)
        (-<> (reduce '* <> :end 3)))))

(defun day8-problem2 (filename)
  (let* ((points (read-day8 filename))
         (distances (find-shortest-distances points))
         (g (graph:make-bidirectional-graph))
         (group-count (length points))
         (groups (coerce (loop for i below (length points) collect i) 'vector)))
    (dotimes (i (length points)) (graph:add-vertex g i))

    (loop for (p1 p2) in distances 
          when (/= (aref groups p1) (aref groups p2))
              do
                 (graph:add-edge-between g p1 p2)
                 (decf group-count)
                 (algs:bidirectional-breadth-first-search
                  g
                  :root-vertex p1
                  :on-discover-vertex-fn (lambda (x) (setf (aref groups x) p1)))
                 
          when (= 1 group-count)
            do (return (* (car (aref points p1))
                          (car (aref points p2)))))))

