;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accumulators-quiz.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; PROBLEM 1:
; 
; Assuming the use of at least one accumulator, design a function that consumes
; a list of strings, and produces the length of the longest string in the list.

;; (listof String) -> Natural
;; produce the length of the longest string in the given list of strings, los

;; Stub:
#; (define (longest-string los) 0)

;; Tests:
(check-expect (longest-string empty) 0)
(check-expect (longest-string (list "")) 0)
(check-expect (longest-string (list "a" "b" "c" "d")) 1)
(check-expect (longest-string (list "hello" "how" "are" "you")) 5)
(check-expect (longest-string (list "thank" "you" "for" "reading" "this")) 7)

;; Template: <used template for list and context-preserving accumulator>
(define (longest-string los0)
  ;; max-length is Natural
  ;; INVARIANT: the length of the longest (first los) seen so far in los0
  
  (local [(define (longest-string los max-length)
            (cond [(empty? los) max-length]
                  [else
                   (local [(define current-length
                             (string-length (first los)))]
                     (if (> current-length max-length)
                         (longest-string (rest los) current-length)
                         (longest-string (rest los) max-length)))]))]

    (longest-string los0 0)))


; PROBLEM 2:
; 
; The Fibbonacci Sequence https://en.wikipedia.org/wiki/Fibonacci_number is 
; the sequence 0, 1, 1, 2, 3, 5, 8, 13,... where the nth element is equal to 
; n-2 + n-1. 
; 
; Design a function that given a list of numbers at least two elements long, 
; determines if the list obeys the fibonacci rule, n-2 + n-1 = n, for every 
; element in the list. The sequence does not have to start at zero, so for 
; example, the sequence 4, 5, 9, 14, 23 would follow the rule. 

;; (listof Number) -> Boolean
;; produce true if the given list of numbers, lon, obeys to the fibonacci rule
;; otherwise produce false
;; ASSUME: (length lon) >= 2
;; NOTE: fibonacci rule - n-2 + n-1 = n

;; Stub:
#; (define (fibonacci? lon) false)

;; Tests:
(check-expect (fibonacci? (list 1 2)) true)
(check-expect (fibonacci? (list 1 2 4)) false)
(check-expect (fibonacci? (list 1 2 3 5 9)) false)
(check-expect (fibonacci? (list 0 1 1 2 3 5 8 13)) true)
(check-expect (fibonacci? (list 4 5 9 14 23)) true)
(check-expect (fibonacci? (list 5 30 35 65 100)) true)

;; Template: <used template for list and context-preserving accumulator>
(define (fibonacci? lon0)
  ;; previous is Number
  ;; INVARIANT: previous number in lon0 for a given (first lon)

  ;; previous-previous is Number
  ;; INVARIANT: 2 numbers in lon0 for a given (first lon)
  
  (local [(define first-n (first lon0))
          (define second-n (second lon0))
          (define starting-lon (rest (rest lon0)))

          (define (fibonacci? lon previous previous-previous)
            (cond [(empty? lon) true]
                  [else
                   (and (= (+ previous previous-previous) (first lon))
                        (fibonacci? (rest lon) (first lon) previous))]))]

    (fibonacci? starting-lon second-n first-n)))


; PROBLEM 3:
; 
; Refactor the function below to make it tail recursive.

;; Natural -> Natural
;; produces the factorial of the given number

;; Stub:
#; (define (fact n) n)

;; Tests:
(check-expect (fact 0) 1)
(check-expect (fact 3) 6)
(check-expect (fact 5) 120)

;; Template: <used template for Natural>
#; (define (fact n)
     (cond [(zero? n) 1]
           [else 
            (* n (fact (sub1 n)))]))

;; tail recursive version:

;; Template: <used template for Natural and result-so-far accumulator>
(define (fact n0)
  ;; rsf is Natural
  ;; INVARIANT: product of all numbers, x: n < x <= n0
  
  (local [(define (fact n rsf)
            (cond [(zero? n) rsf]
                  [else
                   (fact (sub1 n) (* n rsf))]))]

    (fact n0 1)))


; PROBLEM 4:
; 
; Recall the data definition for Region from the Abstraction Quiz. Use a worklist 
; accumulator to design a tail recursive function that counts the number of regions 
; within and including a given region. 
; So (count-regions CANADA) should produce 7

;; =================
;; Data Definitions:

(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

;; Template: <Region, Type and (listof Region)>
#; (define (fn-for-region r)
     (local [(define (fn-for-region r)
               (... (region-name r)
                    (fn-for-type (region-type r))
                    (fn-for-lor (region-subregions r))))
          
             (define (fn-for-type t)
               (cond [(string=? t "Continent") (...)]
                     [(string=? t "Country") (...)]
                     [(string=? t "Province") (...)]
                     [(string=? t "State") (...)]
                     [(string=? t "City") (...)]))
          
             (define (fn-for-lor lor)
               (cond [(empty? lor) (...)]
                     [else 
                      (... (fn-for-region (first lor))
                           (fn-for-lor (rest lor)))]))]
       (fn-for-region r)))


;; =====================
;; Constant Definitions:

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))


;; =====================
;; Function Definitions:

;; Region -> Natural
;; produce the number of regions within and including a given region, r

;; Stub:
#; (define (count-regions r) 1)

;; Tests:
(check-expect (count-regions VANCOUVER) 1)
(check-expect (count-regions BC) 3)
(check-expect (count-regions ALBERTA) 3)
(check-expect (count-regions CANADA) 7)

;; Template: <used template from Region and for worklist accumulator>
(define (count-regions r0)
  ;; todo is (listof Region)
  ;; INVARIANT: worklist accumulator

  ;; count is Natural
  ;; INVARIANT: number of regions that have been counted so far
  
  (local [(define (fn-for-region r count todo)
            (fn-for-lor (append todo (region-subregions r))
                        (add1 count)))
          
          (define (fn-for-lor todo count)
            (cond [(empty? todo) count]
                  [else 
                   (fn-for-region (first todo) count (rest todo))]))]

    (fn-for-region r0 0 empty)))