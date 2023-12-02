;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname terminationArguments.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;The Collatz conjecture is a conjecture in mathematics named
;after Lothar Collatz, who first proposed it in 1937. ...
;The sequence of numbers involved is referred to as the hailstone 
;sequence or hailstone numbers (because the values are usually 
;subject to multiple descents and ascents like hailstones in a 
;cloud). 
;
;f(n) = /   n/2     if n is even
;       \   3n + 1  if n is odd 
;      
;
;The Collatz conjecture is: This process will eventually reach
;the number 1, regardless of which positive integer is chosen
;initially.
;
;(open image file)
;
;[Image and part of text from: https://en.wikipedia.org/wiki/Collatz_conjecture]

;; Integer[>=1] -> (listof Integer[>=1])
;; produce hailstone sequence for n

;; Tests:
(check-expect (hailstones 1) (list 1))
(check-expect (hailstones 2) (list 2 1))
(check-expect (hailstones 4) (list 4 2 1))
(check-expect (hailstones 5) (list 5 16 8 4 2 1))

(define (hailstones n)
  (if (= n 1) 
      (list 1)
      (cons n 
            (if (even? n)
                (hailstones (/ n 2))
                (hailstones (add1 (* n 3)))))))


;PROBLEM:
;
;The stri, scarpet and hailstones functions use generative recursion. So
;they are NOT based on a well-formed self-referential type comment. How do
;we know they are going terminate? That is, how do we know every recursion 
;will definitely stop? 
;
;Construct a three part termination argument for stri.
;
;Base case:
;
;Reduction step:
;
;Argument that repeated application of reduction step will eventually 
;reach the base case:

;Three part termination argument for stri.
;
;Base case: (<= s CUTOFF)
;
;Reduction step: (/ s 2)
;
;Argument that repeated application of reduction step will eventually 
;reach the base case: as long as the CUTOFF is > 0 and s starts >= 0
;repeated division by 2 will eventually be less than CUTOFF.

;Three part termination argument for hailstones.
;
;Base case: (= n 1)
;
;Reduction step:
;    if n is even (/ n 2)
;    if n is odd  (+ 1 (* n 3))
;
;Argument that repeated application of reduction step will eventually 
;reach the base case: THIS IS A TRICK PROBLEM!!
