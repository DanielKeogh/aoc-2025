;;;; aoc-2025.asd

(asdf:defsystem #:aoc-2025
  :description "2025 Advent of Code solutions"
  :author "Daniel Keogh"
  :license "None"
  :serial t
  :depends-on (:str :alexandria :map-overlap)
  :components ((:file "package")
               (:file "utils")
               (:file "day1")
               (:file "day2")
               (:file "day3")
               (:file "day4")
               (:file "day5")))
