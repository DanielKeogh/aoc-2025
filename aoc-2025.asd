;;;; aoc-2025.asd

(asdf:defsystem #:aoc-2025
  :description "2025 Advent of Code solutions"
  :author "Daniel Keogh"
  :license "None"
  :serial t
  :depends-on (:str)
  :components ((:file "package")
               (:file "day1")
               (:file "day2")
               (:file "day3")))
