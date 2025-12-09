;;;; aoc-2025.asd

(asdf:defsystem #:aoc-2025
  :description "2025 Advent of Code solutions"
  :author "Daniel Keogh"
  :license "None"
  :serial t
  :depends-on (:str :alexandria :arrows :com.danielkeogh.graph :group-by)
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
               (:file "day9")))
