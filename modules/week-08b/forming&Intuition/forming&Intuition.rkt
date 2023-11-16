;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname forming&Intuition) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(local [(define a 1)
        (define b 2)]
  (+ a b))
;; outputs 3

(local [(define p "accio")
        (define (fetch n) (string-append p " " n))]
  (fetch "portkey"))
;; outputs "accio portkey"

(define p "accio")
(define (fetch n) (string-append p " " n))
(fetch "portkey")
;; ouputs "accio portkey"

;a
;; outputs a: this variable is not defined