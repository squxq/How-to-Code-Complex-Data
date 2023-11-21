;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Consider the following two functions:
;
;;; ListOfNumber -> ListOfNumber
;;; produce list with only postivie? elements of lon
;(check-expect (positive-only empty) empty)
;(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))
;
;;(define (positive-only lon) empty)   ;stub
;
;(define (positive-only lon)
;  (cond [(empty? lon) empty]
;        [else 
;         (if (positive? (first lon))
;             (cons (first lon) 
;                   (positive-only (rest lon)))
;             (positive-only (rest lon)))]))
;             
;;; ListOfNumber -> ListOfNumber
;;; produce list with only negative? elements of lon
;(check-expect (negative-only empty) empty)
;(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))   
;
;;(define (negative-only lon) empty)   ;stub
;
;(define (negative-only lon)
;  (cond [(empty? lon) empty]
;        [else 
;         (if (negative? (first lon))
;             (cons (first lon) 
;                   (negative-only (rest lon)))
;             (negative-only (rest lon)))]))
;
;Design an abstract function called filter2 based on these two functions.

;; ListOfNumber -> ListOfNumber
;; produce list with only positive? elements of lon

;; Stub:
;(define (positive-only lon) empty)

;; Tests:
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

;; Template: <used template from ListOfNumber>

(define (positive-only lon)
  (filter2 positive? lon))


;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon

;; Stub:
;(define (negative-only lon) empty)

;; Tests:
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

;; Template: <used template from ListOfNumber>

(define (negative-only lon)
  (filter2 negative? lon))

(define (filter2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (if (fn (first lon))
             (cons (first lon)
                   (filter2 fn (rest lon)))
             (filter2 fn (rest lon)))]))