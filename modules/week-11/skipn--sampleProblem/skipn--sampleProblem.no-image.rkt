;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname skipn--sampleProblem.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;PROBLEM:
;
;Design a function that consumes a list of elements lox and a natural number
;n and produces the list formed by including the first element of lox, then 
;skipping the next n elements, including an element, skipping the next n 
;and so on.
;
; (skipn (list "a" "b" "c" "d" "e" "f") 2) should produce (list "a" "d")

;; (listof X) Natural -> (listof X)
;; produce a filtered list where each element has, in the given list, lox,
;; index = 0 | given natural, n, multiple of n + 1

;; Stub:
#; (define (skipn lox0 n0) lox)

;; Tests:
(check-expect (skipn empty 1) empty) ;; any n would produce empty
(check-expect (skipn (list 1 2 3) 0) (list 1 2 3)) ;; n = 0 produces lox
(check-expect (skipn (list 1) 9) (list 1)) ;; any n always produces lox's index 0
(check-expect (skipn (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))

;; Template: <used template for (listof X) and for Accumulator>
#; (define (skipn lox0 n0)
     (local [;; Natural
             ;; n, n = n0 + 1
             (define n (add1 n0))

             ;; acc: Natural; 0-indexed position of (first lox) in given lox0

             ;; Examples:
             ;; (skipn (list "a" "b" "c") 0)
             ;; (skipn (list     "b" "c") 1)
             ;; (skipn (list         "c") 2)
          
             (define (skipn lox acc)
               (cond [(empty? lox) empty]
                     [else
                      (if (= (remainder acc n) 0)
                          (cons (first lox) (skipn (rest lox) (add1 acc)))
                          (skipn (rest lox) (add1 acc)))]))]

       (skipn lox0 0)))

;; or using the accumulator as a count-down

;; Template: <used template for (listof X) and for Accumulator>
#; (define (skipn lox0 n0)
     (local [;; acc: Natural; the number of elements to skip before including
             ;;               the next one

             ;; Examples:
             ;; (skipn (list "a" "b" "c" "d") 0)
             ;; (skipn (list     "b" "c" "d") 2)
             ;; (skipn (list         "c" "d") 1)
             ;; (skipn (list             "d") 0)
             ;; (skipn (list                ) 2)
          
             (define (skipn lox acc)
               (cond [(empty? lox) empty]
                     [else
                      (if (zero? acc)
                          (cons (first lox) (skipn (rest lox) n0))
                          (skipn (rest lox) (sub1 acc)))]))]

       (skipn lox0 0)))

;; or using the accumulator as a count-up

;; Template: <used template for (listof X) and for Accumulator>
(define (skipn lox0 n0)
  (local [;; acc: Natural; the number of elements that were skipped
          ;;               since the last one was included

          ;; Examples:
          ;; (skipn (list "a" "b" "c" "d") 2)
          ;; (skipn (list     "b" "c" "d") 0)
          ;; (skipn (list         "c" "d") 1)
          ;; (skipn (list             "d") 2)
          ;; (skipn (list                ) 0)
          
          (define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (= acc n0)
                       (cons (first lox) (skipn (rest lox) 0))
                       (skipn (rest lox) (add1 acc)))]))]

    (skipn lox0 n0)))