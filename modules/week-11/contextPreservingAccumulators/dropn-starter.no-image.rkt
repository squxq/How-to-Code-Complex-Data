;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname dropn-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; dropn-starter.rkt

PROBLEM:

Design a function that consumes a list of elements lox and a natural number
n and produces the list formed by dropping every nth element from lox.

(dropn (list 1 2 3 4 5 6 7) 2) should produce (list 1 2 4 5 7)

;; (listof X) Natural -> (listof X)
;; produce a list formed by dropping every given natural, n, nth element of
;; given list, lox

;; Stub:
#; (define (dropn lox0 n) lox)

;; Tests:
(check-expect (dropn empty 3) empty)
(check-expect (dropn (list 1 2) 0) empty)
(check-expect (dropn (list 1 2 3 4 5 6 7) 2) (list 1 2 4 5 7))

;; Template: <used template for list and context-preserving accumulator>
(define (dropn lox0 n)
  ;; countup is Natural[0, n]
  ;; INVARIANT: the number of elements in lox0 that have been added to the result
  ;;            when countup = n, do not add (first lox) and reset the countup to 0
  (local [(define (dropn lox countup)
            (cond [(empty? lox) empty]
                  [else
                   (if (= n countup)
                       (dropn (rest lox) 0)
                       (cons (first lox) (dropn (rest lox) (add1 countup))))]))]

    (dropn lox0 0)))