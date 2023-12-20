;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname van-koch-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; van-koch-starter.rkt

;PROBLEM:
;
;First review the discussion of the Van Koch Line fractal at:
;http://pages.infinit.net/garrick/fractals/.
;
;Now design a function to draw a SIMPLIFIED version of the fractal.  
;
;For this problem you will draw a simplified version as follows:
;
;
;       (open image file)
;       
;       
;Notice that the difference here is that the vertical parts of the 
;curve, or segments BC and DE in this figure (open image file)
;are just ordinary lines they are not themselves recursive Koch curves. 
;That ends up making things much simpler in terms of the math required 
;to draw this curve. 
;
;We want you to make the function consume positions using 
;DrRacket's posn structure. A reasonable data definition for these 
;is included below.
;
;The signature and purpose of your function should be:
;
;;; Posn Posn Image -> Image
;;; Add a simplified Koch fractal to image of length ln, going from p1 to p2
;;; length ln is calculated by (distance p1 p2)
;;; Assume p1 and p2 have same y-coordinate.
;
;(define (vkline p1 p2 img) img) ;stub
;
;Include a termination argument for your function.
;
;We've also given you some constants and two other functions 
;below that should be useful.

;; Create a simplified Van Koch Line fractal.

;; =================
;; Constants:

(define LINE-CUTOFF 5)

(define WIDTH 300)
(define HEIGHT 200)
(define MTS (empty-scene WIDTH HEIGHT))

;; =================
;; Data definitions:

;(define-struct posn (x y))   ;struct is already part of racket
;; Posn is (make-posn Number Number)
;; interp. A cartesian position, x and y are screen coordinates.

;; Examples:
(define Point1 (make-posn 20 30))
(define Point2 (make-posn 100 10))

(define P0 (make-posn 20 100))
(define P1 (make-posn 25 100))
(define P2 (make-posn 35 100))

;; =====================
;; Function Definitions:

;; Posn Posn -> Number
;; produce the distance between two points

;; Tests:
(check-expect (distance Point1 Point1) 0)
(check-within (distance Point1 Point2) 82.4621125 0.0000001)

(define (distance p1 p2)
  (sqrt (+ (sqr (- (posn-x p2) (posn-x p1)))
           (sqr (- (posn-y p2) (posn-y p2))))))


;; Posn Posn Image -> Image
;; add a black line from p1 to p2 on image

;; Tests:
(check-expect (simple-line Point1 Point2 MTS) (add-line MTS 20 30 100 10 "black")) 

(define (simple-line p1 p2 img)
  (add-line img (posn-x p1) (posn-y p1) (posn-x p2) (posn-y p2) "black"))


;; Posn Posn Image -> Image
;; Add a simplified Koch fractal to image of length ln, going from p1 to p2
;; length ln is calculated by (distance p1 p2)
;; ASSUME: p1 and p2 have same y-coordinate.

;; Stub:
#; (define (vkline p1 p2 img) img)

;; Tests:
(check-expect (vkline P0 P1 MTS)
              (simple-line P0 P1 MTS))
(check-expect (vkline P0 P2 MTS)
              (local [(define dist (/ (distance P0 P2) 3))
                      (define A (make-posn (+ (posn-x P0) dist) (posn-y P0)))
                      (define B (make-posn (posn-x A) (- (posn-y A) dist)))
                      (define C (make-posn (+ (posn-x B) dist) (posn-y B)))
                      (define D (make-posn (posn-x C) (posn-y P2)))]
                (simple-line P0 A (simple-line A B (simple-line B C (simple-line C D (simple-line D P2 MTS)))))))

;; Template: <used template for generative recursion>
(define (vkline p1 p2 img)
  (local [(define length (distance p1 p2))]
    (if (<= length LINE-CUTOFF)
        (simple-line p1 p2 img)
        (local [(define dist (/ length 3))
                (define A (make-posn (+ (posn-x p1) dist) (posn-y p2)))
                (define B (make-posn (posn-x A) (- (posn-y A) dist)))
                (define C (make-posn (+ (posn-x B) dist) (posn-y B)))
                (define D (make-posn (posn-x C) (posn-y p2)))]
          (vkline D p2 (simple-line C D (vkline B C (simple-line A B (vkline p1 A img)))))))))


;Three part termination argument for vkline:
;
;Base case: (<= length LINE-CUTOFF),
;distance between p1 and p2 is less than or equal to LINE-CUTOFF
;
;Reduction step: split length into three pieces, recurse on all three
;
;Argument: as long as LINE-CUTOFF > 0, and we're dividing the distance
;between p1 and p2 by 3, length will eventually be less than LINE-CUTOFF