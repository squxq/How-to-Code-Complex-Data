;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname count-odd-even-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; count-odd-even-starter.rkt

;PROBLEM:
;
;Previously we have written functions to count the number of elements in a list.
;In this  problem we want a function that produces separate counts of the number
;of odd and even numbers in a list, and we only want to traverse the list once
;to produce that result.
;
;Design a tail recursive function that produces the Counts for a given list of numbers.
;Your function should produce Counts, as defined by the data definition below.
;
;There are two ways to code this function, one with 2 accumulators and one with
;a single accumulator. You should provide both solutions.

;; =================
;; Data Definitions:

(define-struct counts (odds evens))
;; Counts is (make-counts Natural Natural)
;; interp. describes the number of even and odd numbers in a list

;; Examples:
(define C1 (make-counts 0 0)) ;describes an empty list
(define C2 (make-counts 3 2)) ;describes (list 1 2 3 4 5))


;; =====================
;; Function Definitions:

;; (listof Number) -> Counts
;; produce separate counts of the number of odd and even numbers in given lon

;; Stub:
#; (define (count-odd-even lon) C1)

;; Tests:
(check-expect (count-odd-even empty) C1)
(check-expect (count-odd-even (list 1)) (make-counts 1 0))
(check-expect (count-odd-even (list 2 2)) (make-counts 0 2))
(check-expect (count-odd-even (list 1 2 3 4 5)) C2)

;; Template: <used template for list and for result-so-far accumulator>
#; (define (count-odd-even lon0)
     ;; odd is Natural
     ;; INVARIANT: the number of visited odd (first lon) in lon0

     ;; even is Natural
     ;; INVARIANT: the number of visited even (first lon) in lon0
  
     (local [(define (count-odd-even lon odd even)
               (cond [(empty? lon) (make-counts odd even)]
                     [else
                      (if (odd? (first lon))
                          (count-odd-even (rest lon) (add1 odd) even)
                          (count-odd-even (rest lon) odd (add1 even)))]))]

       (count-odd-even lon0 0 0)))

;; or

;; Template: <used template for list and for result-so-far accumulator>
#; (define (count-odd-even lon0)
  ;; odd is Natural
  ;; INVARIANT: the number of visited odd (first lon) in lon0
  ;; NOTE: (length lon0) >= odd
  
  (local [(define (count-odd-even lon odd)
            (cond [(empty? lon)
                   (make-counts odd (- (length lon0) odd))]
                  [else
                   (if (odd? (first lon))
                       (count-odd-even (rest lon) (add1 odd))
                       (count-odd-even (rest lon) odd))]))]

    (count-odd-even lon0 0)))

;; or

;; Template: <used template for list and for result-so-far accumulator>
(define (count-odd-even lon0)
  ;; rsf is Counts
  ;; INVARIANT: the number of visited odd (first lon) in lon0
  
  (local [(define (count-odd-even lon rsf)
            (cond [(empty? lon) rsf]
                  [else
                   (if (odd? (first lon))
                       (count-odd-even (rest lon)
                                       (make-counts (add1 (counts-odds rsf))
                                                    (counts-evens rsf)))
                       (count-odd-even (rest lon)
                                       (make-counts (counts-odds rsf)
                                                    (add1 (counts-evens rsf)))))]))]

    (count-odd-even lon0 (make-counts 0 0))))