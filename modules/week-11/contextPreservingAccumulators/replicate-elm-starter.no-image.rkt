;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname replicate-elm-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; replicate-elm-starter.rkt

;PROBLEM:
;
;Design a function that consumes a list of elements and a natural n, and produces 
;a list where each element is replicated n times. 
;
;(replicate-elm (list "a" "b" "c") 2) should produce (list "a" "a" "b" "b" "c" "c")

;; (listof X) Natural -> (listof X)
;; produce a list where each element in given list, lox, is replicated given, n, times

;; Stub:
#; (define (replicate-elm lox0 n) lox0)

;; Tests:
(check-expect (replicate-elm empty 2) empty)
(check-expect (replicate-elm (list 1 2) 0) empty)
(check-expect (replicate-elm (list 1 2) 1) (list 1 2))
(check-expect (replicate-elm (list "a" "b" "c") 2)
              (list "a" "a" "b" "b" "c" "c"))

;; Template: <used template for list and context-preserving accumulator>
(define (replicate-elm lox0 n)
  ;; countdown is Natural
  ;; INVARIANT: number of (first lox) elements that still need to be copied
  ;;            before moving on to the next of the elements in lox0
  (local [(define (replicate-elm lox countdown)
            (cond [(empty? lox) empty]
                  [else
                   (if (zero? countdown)
                       (replicate-elm (rest lox) n)
                       (cons (first lox) (replicate-elm lox (sub1 countdown))))]))]

    (replicate-elm lox0 n)))