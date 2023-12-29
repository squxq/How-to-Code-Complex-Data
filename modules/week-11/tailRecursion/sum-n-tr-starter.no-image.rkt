;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sum-n-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-n-tr-starter.rkt

;PROBLEM:
;
;Consider the following function that consumes Natural number n and produces the sum 
;of all the naturals in [0, n].
;    
;Use an accumulator to design a tail-recursive version of sum-n.

;; Natural -> Natural
;; produce sum of Natural[0, n]

;; Stub:
#; (define (sum-n n0) n0)

;; Tests:
(check-expect (sum-n 0) 0)
(check-expect (sum-n 1) 1)
(check-expect (sum-n 3) (+ 3 2 1 0))

;; Template: <used template for Natural>
#; (define (sum-n n)
     (cond [(zero? n) 0]
           [else
            (+ n
               (sum-n (sub1 n)))]))

;; or using a result-so-far accumulator

;; Template: <used template for Natural and result-so-far accumulator>
(define (sum-n n0)
  ;; sum is Natural (Natural + Natural = Natural)
  ;; INVARIANT: sum of all natural numbers n, n <= n0
  
  (local [(define (sum-n n sum)
            (cond [(zero? n) sum]
                  [else
                   (sum-n (sub1 n) (+ n sum))]))]

    (sum-n n0 0)))