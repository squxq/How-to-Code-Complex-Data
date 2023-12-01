;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;From the previous section, we have the following:
;
;;; ListOfNumber -> ListOfNumber
;;; produce list with only positive? elements of lon
;
;;; Stub:
;;(define (positive-only lon) empty)
;
;;; Tests:
;(check-expect (positive-only empty) empty)
;(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))
;
;(define (positive-only lon) (filter2 positive? lon))
;
;
;;; ListOfNumber -> ListOfNumber
;;; produce list with only negative? elements of lon
;
;;; Stub:
;;(define (negative-only lon) empty)
;
;;; Tests:
;(check-expect (negative-only empty) empty)
;(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))
;
;(define (negative-only lon) (filter2 negative? lon))
;
;
;
;(define (filter2 p lon)
;  (cond [(empyt? lon) empty]
;        [else 
;         (if (p (first lon))
;             (cons (first lon) 
;                   (filter2 p (rest lon)))
;             (filter2 p (rest lon)))]))
;
;Continue working on the design of this abstract function by completing the   
;purpose and check-expects for filter2. 

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



;; produce only the elements of the given list, lon, that satisfy the predicate, pred

;; Tests:
(check-expect (filter2 positive? empty) empty)
(check-expect (filter2 negative? (list 1 -2 3 -4)) (list -2 -4))
(check-expect (filter2 positive? (list -5 -513 875 -20835 094)) (list 875 094))

(define (filter2 pred lon)
  (cond [(empty? lon) empty]
        [else
         (if (pred (first lon))
             (cons (first lon)
                   (filter2 pred (rest lon)))
             (filter2 pred (rest lon)))]))
