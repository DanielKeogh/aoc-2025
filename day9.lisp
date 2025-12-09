;;;; day9.lisp

(in-package :aoc-2025)

(defun read-day9 (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          collect (mapcar #'parse-integer (str:split "," next)))))

(defun day9-area (x1 y1 x2 y2)
  (* (1+ (abs (- x2 x1))) (1+ (abs (- y2 y1)))))

(defun day9-problem1 (filename)
  (let ((pairs (read-day9 filename)))
    (loop for (x1 y1) in pairs
          for i from 0
          maximize (loop for (x2 y2) in pairs 
                         maximize (day9-area x1 y1 x2 y2)))))

(defun group-xy-pairs (pairs group-fn value-fn)
  (loop for (group . rest) in (group-by:group-by pairs :key group-fn :value value-fn :test #'=)
        nconc (loop for (coord1 coord2) on (sort rest #'<) by #'cddr
                    collect (list group coord1 coord2))))

(defun day9-problem2 (filename)
  (loop with pairs = (read-day9 filename)
        with horts = (group-xy-pairs pairs #'first #'second)
        with verts = (group-xy-pairs pairs #'second #'first)
        for (x1 y1) in pairs
        maximize
        (loop for (x2 y2) in pairs
              while (and (/= x1 x2) (/= y1 y2)) ; be less O(N^2).
              for (minx maxx) = (min-max x1 x2)
              for (miny maxy) = (min-max y1 y2)
              when (and (loop for (hx hy0 hy1) in horts
                              always (or (<= hx minx) (>= hx maxx)
                                         (<= hy1 miny) (>= hy0 maxy)))
                        (loop for (vy vx0 vx1) in verts
                              always (or (<= vy miny) (>= vy maxy)
                                         (<= vx1 minx) (>= vx0 maxx))))
                maximize (day9-area x1 y1 x2 y2))))

