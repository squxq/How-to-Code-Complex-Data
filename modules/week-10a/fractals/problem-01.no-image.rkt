;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;PROBLEM:
;
;Design a function to produce a Sierpinski carpet of size s.  
;
;Here is an example of a larger Sierpinski carpet.
;
;(open image file)

(define CUTOFF 3)

;; Number -> Image
;; produce a Sierpinski carpet of the given size, s

;; Stub:
#; (define (scarpet s) empty-image)

;; Tests:
(check-expect (scarpet CUTOFF)
              (square CUTOFF "outline" "red"))
(check-expect (scarpet (* CUTOFF 3))
              (overlay (square (* CUTOFF 3) "outline" "red")
                       (local [(define sub (square CUTOFF "outline" "red"))
                               (define blank (square CUTOFF "solid" "transparent"))]
                         (above (beside sub sub sub)
                                (beside sub blank sub)
                                (beside sub sub sub)))))

;; Template:
#; (define (scarpet s)
     (if (trivial? s)
         (trivial-answer s)
         (... s
              (scarpet (next-problem s)))))

(define (scarpet s)
     (if (<= s CUTOFF)
         (square s "outline" "red")
         (overlay (square s "outline" "red")
              (local [(define sub (scarpet (/ s 3)))
                      (define blank (square (/ s 3) "solid" "transparent"))]
                (above (beside sub sub sub)
                       (beside sub blank sub)
                       (beside sub sub sub))))))