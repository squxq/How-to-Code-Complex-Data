;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;PROBLEM:
;
;Complete the function definition for sum using foldr.

;; (listof Number) -> Number
;; add up all numbers in list

;; Stub:
#;
(define (sum lon) 0)

;; Tests:
(check-expect (sum empty) 0)
(check-expect (sum (list 2 3 4)) 9)

;; Template:
#;
(define (sum lon)
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))


;PROBLEM:
;
;Complete the function definition for juxtapose using foldr.

;; (listof Image) -> Image
;; juxtapose all images beside each other

;; Stub:
#;
(define (juxtapose loi) (square 0 "solid" "white"))

;; Tests:
(check-expect (juxtapose empty) (square 0 "solid" "white"))
(check-expect (juxtapose (list (triangle 6 "solid" "yellow")
                               (square 10 "solid" "blue")))
              (beside (triangle 6 "solid" "yellow")
                      (square 10 "solid" "blue")
                      (square 0 "solid" "white")))

;; Template:
#;
(define (juxtapose loi)
  (foldr ... ... loi))

(define (juxtapose loi)
  (foldr beside (square 0 "solid" "white") loi))


;PROBLEM:
;
;Complete the function definition for copy-list using foldr.

;; (listof X) -> (listof X)
;; produce copy of list

;; Stub:
#;
(define (copy-list lox) empty)

;; Tests:
(check-expect (copy-list empty) empty)
(check-expect (copy-list (list 1 2 3)) (list 1 2 3))

;; Template:
#;
(define (copy-list lox)
  (foldr ... ... lox))

(define (copy-list lox)
  (foldr cons empty lox))