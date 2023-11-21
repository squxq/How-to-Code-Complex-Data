;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fromExamples1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; parameterization-starter.rkt

(* pi (sqr 4)) ; area of circle radius 4
(* pi (sqr 6)) ; area of circle radius 6

(define (area r)
  (* pi (sqr r)))

(area 4) ; area of circle radius 4
(area 6) ; area of circle radius 6

;; ====================

;; ListOfString -> Boolean
;; produce true if los includes "UBC"

;; Stub:
;(define (contains-ubc? los) false)

;; Tests:
(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? (cons "McGill" empty)) false)
(check-expect (contains-ubc? (cons "UBC" empty)) true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) true)

;; Template: <used template from ListOfString>

(define (contains-ubc? los)
  (contains? "UBC" los))

;; ListOfString -> Boolean
;; produce true if los includes "McGill"

;; Stubs:
;(define (contains-mcgill? los) false)

;; Tests:
(check-expect (contains-mcgill? empty) false)
(check-expect (contains-mcgill? (cons "UBC" empty)) false)
(check-expect (contains-mcgill? (cons "McGill" empty)) true)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) true)

;; Template: <used template from ListOfString>

(define (contains-mcgill? los)
  (contains? "McGill" los))

(define (contains? s los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) s)
             true
             (contains? s (rest los)))]))


;; ====================

;; ListOfNumber -> ListOfNumber
;; produce list of sqr of every number in lon

;; Stub:
;(define (squares lon) empty)

;; Tests:
(check-expect (squares empty) empty)
(check-expect (squares (list 3 4)) (list 9 16))

;; Template: <used template from ListOfNumber>

(define (squares lon)
  (map2 sqr lon))

;; ListOfNumber -> ListOfNumber
;; produce list of sqrt of every number in lon

;; Stub:
;(define (square-roots lon) empty)

;; Tests:
(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

;; Template: <used template from ListOfNumber>

(define (square-roots lon)
  (map2 sqrt lon))

(define (map2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map2 fn (rest lon)))]))
