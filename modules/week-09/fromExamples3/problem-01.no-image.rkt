;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;The following is a nearly completed design of an abstract function
;from two examples of repetitive code. All that's missing is the signature.   
;
;;; ListOfNumber -> Boolean
;;; produce true if every number in lon is positive
;(check-expect (all-positive? empty) true)
;(check-expect (all-positive? (list 1 -2 3)) false)
;(check-expect (all-positive? (list 1 2 3)) true)
;
;(define (all-positive? lon) (andmap2 positive? lon))
;
;;; ListOfNumber -> Boolean
;;; produce true if every number in lon is negative
;(check-expect (all-negative? empty) true)
;(check-expect (all-negative? (list 1 -2 3)) false)
;(check-expect (all-negative? (list -1 -2 -3)) true)
;
;(define (all-negative? lon) (andmap2 negative? lon))
;
;;;produce true if pred produces true for every element of the list
;(check-expect (andmap2 positive? empty) true)
;(check-expect (andmap2 positive? (list 1 -2 3)) false)
;(check-expect (andmap2 positive? (list 1 2 3)) true)
;(check-expect (andmap2 negative? (list -1 -2 -3)) true)
;
;(define (andmap2 pred lst)
;  (cond [(empty? lst) true]
;        [else 
;         (and (pred (first lst))
;              (andmap2 pred (rest lst)))]))

;; ListOfNumber -> Boolean
;; produce true if every number in lon is positive

;; Tests:
(check-expect (all-positive? empty) true)
(check-expect (all-positive? (list 1 -2 3)) false)
(check-expect (all-positive? (list 1 2 3)) true)

(define (all-positive? lon) (andmap2 positive? lon))

;; ListOfNumber -> Boolean
;; produce true if every number in lon is negative

;; Tests:
(check-expect (all-negative? empty) true)
(check-expect (all-negative? (list 1 -2 3)) false)
(check-expect (all-negative? (list -1 -2 -3)) true)

(define (all-negative? lon) (andmap2 negative? lon))


;; (A -> Boolean) (listof A) -> Boolean
;;produce true if pred produces true for every element of the list

;; Tests:
(check-expect (andmap2 positive? empty) true)
(check-expect (andmap2 positive? (list 1 -2 3)) false)
(check-expect (andmap2 positive? (list 1 2 3)) true)
(check-expect (andmap2 negative? (list -1 -2 -3)) true)

(define (andmap2 pred lst)
  (cond [(empty? lst) true]
        [else 
         (and (pred (first lst))
              (andmap2 pred (rest lst)))]))