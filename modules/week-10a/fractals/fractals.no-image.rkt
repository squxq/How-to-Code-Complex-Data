;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fractals.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;PROBLEM: 
;
;Design a function that consumes a number and produces a Sierpinski
;triangle of that size. Your function should use generative recursion.
;
;One way to draw a Sierpinski triangle is to:
;
; - start with an equilateral triangle with side length s
; 
;     (open image file)
;     
; - inside that triangle are three more Sierpinski triangles
;     (open image file)
;     
; - and inside each of those... and so on
; 
;So that you end up with something that looks like this:
;   
;
;   
;
;(open image file)
;   
;Note that in the 2nd picture above the inner triangles are drawn in 
;black and slightly smaller just to make them clear. In the real
;Sierpinski triangle they should be in the same color and of side
;length s/2. Also note that the center upside down triangle is not
;an explicit triangle, it is simply formed from the other triangles.

(define CUTOFF 2)

;; Number -> Image
;; produce a Sierpinski triangle of the given size, s

;; Stub:
#; (define (stri s) (square 0 "solid" "white"))

;; Tests:
(check-expect (stri CUTOFF)
              (triangle CUTOFF "outline" "red"))
(check-expect (stri (* CUTOFF 2))
              (overlay (triangle (* CUTOFF 2) "outline" "red")
                   (local [(define sub (triangle CUTOFF "outline" "red"))]
                     (above sub (beside sub sub)))))

;; Template:
#;
(define (genrec-fn d)
  (if (trivial? d)
      (trivial-answer d)
      (... d
           (genrec-fn (next-problem d)))))

(define (stri s)
  (if (<= s CUTOFF)
      (triangle s "outline" "red")
      (overlay (triangle s "outline" "red")
           (local [(define sub (stri (/ s 2)))]
                     (above sub (beside sub sub))))))

