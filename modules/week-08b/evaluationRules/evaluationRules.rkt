;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname evaluationRules) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define b 1)

(+ b
   (local [(define b 2)]
     (* b b))
   b)
;; outputs 6

;; 1st step:
(+ 1
   (local [(define b 2)]
     (* b b))
   b)

;; 2nd step:
(+ 1
   (local [(define b_0 2)]
     (* b_0 b_0))
   b)

;; 3rd step:
(define b_0 2)
(+ 1
   (local []
     (* b_0 b_0))
   b)

;; 4th step:
(+ 1
   (* b_0 b_0)
   b)

;; 5th step:
(+ 1
   (* 2 b_0)
   b)

;; 6th step:
(+ 1
   (* 2 2)
   b)

;; 7th step:
(+ 1
   4
   b)

;; 8th step
(+ 1
   4
   1)

;; 9th step
6