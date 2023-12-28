;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sum-odds-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-odds-tr-starter.rkt

;PROBLEM:
;
;Consider the following function that consumes a list of numbers and produces
;the sum of all the odd numbers in the list.
;
;Use an accumulator to design a tail-recursive version of sum-odds.

;; (listof Number) -> Number
;; produce sum of all odd numbers of lon

;; Stub:
#; (define (sum-odds lon) 0)

;; Tests:
(check-expect (sum-odds empty) 0) 
(check-expect (sum-odds (list 1 2 5 6 11)) 17) 

;; Template: <used template for list>
#; (define (sum-odds lon)
     (cond [(empty? lon) 0]
           [else
            (if (odd? (first lon))
                (+ (first lon)
                   (sum-odds (rest lon)))
                (sum-odds (rest lon)))]))

;; or using a result-so-far accumulator

;; Template: <used template for list and result-so-far accumulator>
(define (sum-odds lon0)
  ;; sum is Number
  ;; INVARIANT: sum of all visited (first lon) in lon0
  
  (local [(define (sum-odds lon sum)
            (cond [(empty? lon) sum]
                  [else
                   (if (odd? (first lon))
                       (sum-odds (rest lon) (+ (first lon) sum))
                       (sum-odds (rest lon) sum))]))]

    (sum-odds lon0 0)))

(sum-odds (list 1 2 3 4 5 6 7 8 9))