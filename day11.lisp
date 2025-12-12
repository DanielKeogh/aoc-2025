;;;; day11.lisp

(in-package :aoc-2025)

(defun read-day11 (filename)
  (with-open-file (stream (get-file-path filename))
    (loop for next = (read-line stream nil)
          while next
          collect (mapcar (lambda (a) (str:trim a :char-bag '(#\:)))
                          (str:split " " next))
          into data
          finally (return
                    (graph:with-graph* ((graph:make-bidirectional-graph
                                          :vertex-equality-fn #'equal))
                      (loop for b in data
                            for from = (first b) do
                              (loop for to in (rest b) do
                                (graph:add-edges-and-vertices-between*
                                 from to))))))))

(defun strip-unreachable-edges (g start)
  (let* ((visited (make-hash-table))
         (visit (lambda (e) (setf (gethash e visited) t))))
    (algs:depth-first-search g :root-vertex start
     :on-tree-edge-fn visit
     :on-forward-or-cross-edge-fn visit
     :on-back-edge-fn visit)
    (loop for edge in (graph:edges g)
          unless (gethash edge visited) do
            (graph:remove-edge g edge))))

(defun count-between (old-graph start end)
  (let ((counters (make-hash-table :test 'equal))
        (visits (make-hash-table :test 'equal))
        (q (q:make-queue 100000))
        (g (graph:clone old-graph)))

    (strip-unreachable-edges g start)
    
    (q:enqueue (list start 1) q)
    (loop until (q:queue-empty-p q)
          for (next visit-count) = (q:dequeue q)
          do
             (loop for edge in (graph:out-edges g next)
                   for target = (graph:edge-target edge)
                   for next-visits = (incf (gethash target visits 0) visit-count)
                   for counts = (incf (gethash target counters 0))
                      
                   when (= counts (length (graph:in-edges g target)))
                    do (q:enqueue (list target next-visits)
                                  q)))
    (gethash end visits)))


(defun day11-problem1 (filename)
  (let ((g (read-day11 filename)))
    (count-between g "you" "out")))

(defun day11-problem2 (filename)
  (let ((g (read-day11 filename)))
    (* (count-between g "svr" "fft")
       (count-between g "fft" "dac") 
       (count-between g "dac" "out"))))
