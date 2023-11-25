;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname builtInAbstractFunctions.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; Some setup data and functions to enable more interesting examples
;; below

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))

;; Image -> Boolean
;; produce true if image is wide/tall/square

;; Tests:
(check-expect (wide? I1) false)
(check-expect (wide? I2) true)
(check-expect (tall? I3) true)
(check-expect (tall? I4) false)
(check-expect (square? I1) false)
(check-expect (square? I2) false)
(check-expect (square? I5) true)

(define (wide?   img) (> (image-width img) (image-height img)))
(define (tall?   img) (< (image-width img) (image-height img)))
(define (square? img) (= (image-width img) (image-height img)))


;; Image -> Number
;; produce area of image

;; Tests:
(check-expect (area I1) 200)
(check-expect (area I2) 600)

(define (area img)
  (* (image-width img)
     (image-height img)))

;In addition to map and filter there are several other useful abstract 
;list functions built into ISL.  These are listed on the Language page
;of the course web site. Examples of their use are shown below:

(check-expect (map positive? (list 1 -2 3 -4)) (list true false true false))
; here 'positive?' is the function
(check-expect (filter negative? (list 1 -2 3 -4)) (list -2 -4))
; here 'negative?' is the predicate

(check-expect (foldr + 0 (list 1 2 3)) (+ 1 2 3 0))   ; foldr is abstraction
(check-expect (foldr * 1 (list 1 2 3)) (* 1 2 3 1))   ; of sum and product
; here '*' is the conbination and '1' is the base-case result

(check-expect (build-list 6 identity) (list 0 1 2 3 4 5))
; here, the function 'identity' produces its argument, and build-list produces a list of given number - 1
(check-expect (build-list 4 sqr) (list 0 1 4 9))


;PROBLEM: 
;
;Complete the design of the following functions by coding them using a 
;built-in abstract list function.

;; (listof Image) -> (listof Image)
;; produce list of only those images that are wide?

;; Stub:
#;
(define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

;; Template:
#;
(define (wide-only loi)
  (filter ... loi))

(define (wide-only loi)
  (filter wide? loi))


;; (listof Image) -> Boolean
;; are all the images in loi tall?

;; Stub:
#;
(define (all-tall? loi) false)

;; Tests:
(check-expect (all-tall? LOI1) false)

;; Template:
#;
(define (all-tall? loi)
  (andmap ... loi))

(define (all-tall? loi)
  (andmap tall? loi))


;; (listof Number) -> Number
;; sum the elements of a list

;; Stub:
#;
(define (sum lon) 0)

;; Tests:
(check-expect (sum (list 1 2 3 4)) 10)

;; Template:
#;
(define (sum lon)
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))


;; Natural -> Natural
;; produce the sum of the first n natural numbers

;; Stub:
#;
(define (sum-to n) 0)

;; Tests:
(check-expect (sum-to 3) (+ 0 1 2))

;; Template:
#;
(define (sum-to n)
  (foldr ... ... (build-list ... ...)))

(define (sum-to n)
  (foldr + 0 (build-list n identity)))