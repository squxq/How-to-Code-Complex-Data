;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstract-some-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; abstract-some-starter.rkt

;PROBLEM:
;
;Design an abstract function called some-pred? (including signature, purpose, 
;and tests) to simplify the following two functions. When you are done
;rewrite the original functions to use your new some-pred? function.

;; ListOfNumber -> Boolean
;; produce true if some number in lon is positive

;; Tests:
(check-expect (some-positive? empty) false)
(check-expect (some-positive? (list 2 -3 -4)) true)
(check-expect (some-positive? (list -2 -3 -4)) false)

#;(define (some-positive? lon)
    (cond [(empty? lon) false]
          [else
           (or (positive? (first lon))
               (some-positive? (rest lon)))]))


;; ListOfNumber -> Boolean
;; produce true if some number in lon is negative

;; Tests:
(check-expect (some-negative? empty) false)
(check-expect (some-negative? (list 2 3 -4)) true)
(check-expect (some-negative? (list 2 3 4)) false)

#;(define (some-negative? lon)
    (cond [(empty? lon) false]
          [else
           (or (negative? (first lon))
               (some-negative? (rest lon)))]))


;; (X -> Boolean) (listof X) -> Boolean
;; produce true if any of elements of the given list, l, make the predicate, pred, true

;; Stub:
#; (define (some-pred? pred l) false)

;; Tests:
(check-expect (some-pred? positive? empty) false)
(check-expect (some-pred? negative? (list -32 93 -9)) true)
(check-expect (some-pred? positive? (list -32 -0 -9)) false)
(check-expect (some-pred? negative? (list -32 93 -9 4 72 8 -9)) true)

(define (some-pred? pred l)
  (cond [(empty? l) false]
        [else
         (or (pred (first l))
             (some-pred? pred (rest l)))]))

(define (some-positive? lon)
  (some-pred? positive? lon))

(define (some-negative? lon)
  (some-pred? negative? lon))