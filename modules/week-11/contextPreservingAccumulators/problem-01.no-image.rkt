;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; You are asked to design a function that numbers a list of strings by
; inserting a number and a colon before each element of the list based     
; on its position. So for example:
;
; (number-list (list "first" "second" "third")) would produce
;  (list "1: first" "2: second" "3: third")

;; (listof String) -> (listof String)
;; given a list of strings, los, produce a list of string where each element
;; is made up from concatenating its position to its value in los

;; Stub:
#; (define (number-list los0) los)

;; Tests:
(check-expect (number-list empty) empty)
(check-expect (number-list (list "a")) (list "1: a"))
(check-expect (number-list (list "a" "b" "c")) (list "1: a" "2: b" "3: c"))

;; Template: <used template for (listof String) and Accumulator>
(define (number-list los0)
  ;; acc: Natural; 1-based position of (first los) in los0

  ;; Examples:
  ;; (number-list (list "a" "b" "c") 1)
  ;; (number-list (list     "b" "c") 2)
  ;; (number-list (list         "c") 3)
  
  (local [(define (number-list los acc)
            (cond [(empty? los) empty]
                  [else
                   (cons (string-append (number->string acc)": " (first los))
                         (number-list (rest los) (add1 acc)))]))]

    (number-list los0 1)))