;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname rev-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; rev-tr-starter.rkt

;PROBLEM:
;
;Design a function that consumes (listof X) and produces a list of the same 
;elements in the opposite order. Use an accumulator. Call the function rev. 
;(DrRacket's version is called reverse.) Your function should be tail recursive.
;  
;In this problem only the first step of templating is provided.

;; (listof X) -> (listof X)
;; produce list with elements of lox in reverse order

;; Stub:
#; (define (rev lox) empty)

;; Tests:
(check-expect (rev empty) empty)
(check-expect (rev (list 1)) (list 1))
(check-expect (rev (list "a" "b" "c")) (list "c" "b" "a"))

;; Template: <used template for list>
#; (define (rev lox)
     (cond [(empty? lox) empty]
           [else
            (append (rev (rest lox))
                    (list (first lox)))]))

;; Template: <used template for list and result-so-far accumulator>
(define (rev lox0)
  ;; rsf is (listof X)
  ;; INVARIANT: list of all (first lox) seen so far; the most recent ones come first
  
  (local [(define (rev lox rsf)
            (cond [(empty? lox) rsf]
                  [else
                   (rev (rest lox) (cons (first lox) rsf))]))]

    (rev lox0 empty)))