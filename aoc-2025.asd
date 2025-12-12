;;;; aoc-2025.asd

(asdf:defsystem #:aoc-2025
  :description "2025 Advent of Code solutions"
  :author "Daniel Keogh"
  :license "None"
  :serial t
  :depends-on (:alexandria
               :arrows
               :str
               :group-by
               ;; need versions from github for these:
               :com.danielkeogh.graph ; https://github.com/DanielKeogh/com.danielkeogh.graph
               :cl-z3 ; https://github.com/mister-walter/cl-z3
               )
  :components ((:file "package")
               (:file "utils")
               (:file "day1")
               (:file "day2")
               (:file "day3")
               (:file "day4")
               (:file "day5")
               (:file "day6")
               (:file "day7")
               (:file "day8")
               (:file "day9")
               (:file "day10")
               (:file "day11")
               (:file "day12")))
