;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname average-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; average-starter.rkt

;PROBLEM:
;
;Design a function called average that consumes (listof Number) and produces the
;average of the numbers in the list.

;; (listof Number) -> Number
;; produce the average of all numbers in the given list of numbers, lon

;; Stub:
#; (define (average lon0) 0)

;; Tests:
(check-expect (average empty) 0)
(check-expect (average (list 1)) 1)
(check-expect (average (list 7)) 7)
(check-expect (average (list 1 2 3)) 2)
(check-expect (average (list 1 2 3 4)) 2.5)

;; Template: <used template for list, result-so-far accumulator
;;            and context-preserving accumulator>
(define (average lon0)
  ;; count is Natural
  ;; INVARIANT: 1-based counter of elements in lon0: for every (first lon) add 1

  ;; sum is Number
  ;; INVARIANT: sum of all elements in lon0 visited so far: sum = sum + (first lon)
  
  (local [(define (average lon counter sum)
            (cond [(empty? lon) (/ sum counter)]
                  [else
                   (average (rest lon)
                            (add1 counter)
                            (+ sum (first lon)))]))]

    (if (empty? lon0)
        0
        (average lon0 0 0))))