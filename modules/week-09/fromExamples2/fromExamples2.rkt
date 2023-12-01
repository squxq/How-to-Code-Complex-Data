;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname parameterization-v2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ListOfString -> Boolean
;; produce true if los includes "UBC"

;; Stub:
;(define (contains-ubc? los) false)

;; Tests:
(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? (cons "McGill" empty)) false)
(check-expect (contains-ubc? (cons "UBC" empty)) true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) true)

(define (contains-ubc? los) (contains? "UBC" los))

;; ListOfString -> Boolean
;; produce true if los includes "McGill"

;; Stub:
;(define (contains-mcgill? los) false)

;; Tests:
(check-expect (contains-mcgill? empty) false)
(check-expect (contains-mcgill? (cons "UBC" empty)) false)
(check-expect (contains-mcgill? (cons "McGill" empty)) true)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) true)

(define (contains-mcgill? los) (contains? "McGill" los))


;; produce true if the given list of strings, los, includes the also given string, s

;; Tests:
(check-expect (contains? "UBC" empty) false)
(check-expect (contains? "UBC" (cons "McGill" empty)) false)
(check-expect (contains? "UBC" (cons "UBC" empty)) true)
(check-expect (contains? "UBC" (cons "McGill" (cons "UBC" empty))) true)
(check-expect (contains? "UBC" (cons "UBC" (cons "McGill" empty))) true)
(check-expect (contains? "Toronto" (cons "UBC" (cons "McGill" empty))) false)

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

(define (squares lon) (map2 sqr lon))

;; ListOfNumber -> ListOfNumber
;; produce list of sqrt of every number in lon

;; Stub:
;(define (square-roots lon) empty)

;; Tests:
(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

(define (square-roots lon) (map2 sqrt lon))


; produce list of sqr or sqrt of every number in the given list, lon ; not a good purpose, since the function is more abstract than this
;; given a function, fn, and a list (list n0 n1 ...), lon, produce (list (fn n0) (fn n1) ...)

;; Tests:
(check-expect (map2 sqr empty) empty)
(check-expect (map2 sqr (list 2 4)) (list 4 16))
(check-expect (map2 sqrt (list 16 9)) (list 4 3))
(check-expect (map2 abs (list 2 -3 4)) (list 2 3 4))

(define (map2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map2 fn (rest lon)))]))


;; ====================

;; ListOfNumber -> ListOfNumber
;; produce list with only positive? elements of lon

;; Stub:
;(define (positive-only lon) empty)

;; Tests:
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

(define (positive-only lon) (filter2 positive? lon))


;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon

;; Stub:
;(define (negative-only lon) empty)

;; Tests:
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

(define (negative-only lon) (filter2 negative? lon))


(define (filter2 pred lon)
  (cond [(empty? lon) empty]
        [else
         (if (pred (first lon))
             (cons (first lon)
                   (filter2 pred (rest lon)))
             (filter2 pred (rest lon)))]))
