;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname pattern-match-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; pattern-match-starter.rkt

;Problem:
;
;It is often useful to be able to tell whether the first part of a sequence of 
;characters matches a given pattern. In this problem you will design a (somewhat 
;limited) way of doing this.
;
;Assume the following type comments and examples:

;; =================
;; Data Definitions:

;; 1String is String
;; interp. these are strings only 1 character long

;; Examples: <1String>
(define 1SA "x")
(define 1SB "2")

;; Template: <1String>
#;
(define (fn-for-1string 1s)
  (... 1s))


;; Pattern is one of:
;;  - empty
;;  - (cons "A" Pattern)
;;  - (cons "N" Pattern)
;; interp.
;;  A pattern describing certain ListOf1String. 
;;  "A" means the corresponding letter must be alphabetic.
;;  "N" means it must be numeric. For example:
;;      (list "A" "N" "A" "N" "A" "N")
;;  describes Canadian postal codes like:
;;      (list "V" "6" "T" "1" "Z" "4")

;; Examples: <Pattern>
(define PATTERN1 (list "A" "N" "A" "N" "A" "N"))

;; Template: <Pattern>
#;
(define (fn-for-pattern p)
  (cond [(empty? p) (...)]
        [(string=? "A" (first p))
         (... (first p) (fn-for-pattern (rest p)))]
        [else
         (... (first p) (fn-for-pattern (rest p)))]))


;; ListOf1String is one of:
;;  - empty
;;  - (cons 1String ListOf1String)
;; interp. a list of strings each 1 long

;; Examples: <ListOf1String>
(define LOS0 empty)
(define LOS1 (list "V" "6" "T" "1" "Z" "4"))

;; Template: <ListOf1String>
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))


;Now design a function that consumes Pattern and ListOf1String and produces true 
;if the pattern matches the ListOf1String. For example,
;
;(pattern-match? (list "A" "N" "A" "N" "A" "N")
;                (list "V" "6" "T" "1" "Z" "4"))
;
;should produce true. If the ListOf1String is longer than the pattern, but the 
;first part matches the whole pattern produce true. If the ListOf1String is 
;shorter than the Pattern you should produce false.       
;
;Treat this as the design of a function operating on 2 complex data. After your 
;signature and purpose, you should write out a cross product of type comments 
;table. You should reduce the number of cases in your cond to 4 using the table, 
;and you should also simplify the cond questions using the table.
;
;You should use the following helper functions in your solution:

;; ==========
;; Functions:

;; 1String -> Boolean
;; produce true if 1s is alphabetic/numeric

;; Stubs:
;(define (alphabetic? 1s) false)
;(define (numeric? 1s) false)

;; Tests:
(check-expect (alphabetic? " ") false)
(check-expect (alphabetic? "1") false)
(check-expect (alphabetic? "a") true)
(check-expect (numeric? " ") false)
(check-expect (numeric? "1") true)
(check-expect (numeric? "a") false)

;; Templates: <used template from 1Stirng>

(define (alphabetic? 1s) (char-alphabetic? (string-ref 1s 0)))
(define (numeric? 1s) (char-numeric? (string-ref 1s 0)))


;; Pattern ListOf1String -> Boolean
;; produce true if the given pattern, p, matches the given list of strings with 1 character, los

;; Stub:
#;
(define (pattern-match? p los) false)

;; Tests:
(check-expect (pattern-match? empty empty) true)
(check-expect (pattern-match? empty (list "2" "A")) true)
(check-expect (pattern-match? (list "A" "N") empty) false)
(check-expect (pattern-match? (list "A") (list "a")) true)
(check-expect (pattern-match? (list "A") (list "1")) false)
(check-expect (pattern-match? (list "N") (list "a")) false)
(check-expect (pattern-match? (list "N") (list "1")) true)
(check-expect (pattern-match? PATTERN1 LOS1) true)

;    p             los | empty |                    (cons 1String ListOf1String)
;   -------------------|-------|---------------------------------------------------------------------
;        empty         |                                        true
;   -------------------|-------|---------------------------------------------------------------------
;   (cons "A" Pattern) |       | (and (alphabetic? (first los)) (pattern-match? (rest p) (rest los)))
;   -------------------| false |---------------------------------------------------------------------
;   (cons "N" Pattern) |       | (and (numeric? (first los)) (pattern-match? (rest p) (rest los)))

;; Template:
#;
(define (pattern-match? p los)
  (cond [(empty? p) (...)]
        [(empty? los) (...)]
        [(string=? "A" (first p)) (... los)]
        [else (... los)]))

(define (pattern-match? p los)
  (cond [(empty? p) true]
        [(empty? los) false]
        [(string=? "A" (first p))
         (and (alphabetic? (first los)) (pattern-match? (rest p) (rest los)))]
        [else (and (numeric? (first los)) (pattern-match? (rest p) (rest los)))]))