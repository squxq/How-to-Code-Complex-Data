;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname strictly-decreasing-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; strictly-decreasing-starter.rkt

;PROBLEM:
;
;Design a function that consumes a list of numbers and produces true if the 
;numbers in lon are strictly decreasing. You may assume that the list has at 
;least two elements.

;; (listof Number) -> Boolean
;; produce true if the numbers in given list of number, lon, are strictly decreasing
;; otherwise false
;; ASSUME: (length lon) >= 2

;; Stub:
#; (define (decreasing? lon0) false)

;; Tests:
(check-expect (decreasing? (list 1 2)) false)
(check-expect (decreasing? (list 2 2)) false)
(check-expect (decreasing? (list 2 1)) true)

;; Template: <used template for list and context-preserving accummulator>
(define (decreasing? lon0)
  ;; previous is Number
  ;; INVARIANT: previous number to (first lon) in lon0
  (local [(define (decreasing? lon previous)
            (cond [(empty? lon) true]
                  [else
                   (and (< (first lon) previous)
                        (decreasing? (rest lon) (first lon)))]))]

    (decreasing? (rest lon0) (first lon0))))
