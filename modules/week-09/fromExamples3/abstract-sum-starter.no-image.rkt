;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstract-sum-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; abstract-sum-starter.rkt

;PROBLEM A:
;
;Design an abstract function (including signature, purpose, and tests) to 
;simplify the two sum-of functions. 

;; (listof Number) -> Number
;; produce the sum of the squares of the numbers in lon

;; Tests:
(check-expect (sum-of-squares empty) 0)
(check-expect (sum-of-squares (list 2 4)) (+ 4 16))

#; (define (sum-of-squares lon)
     (cond [(empty? lon) 0]
           [else
            (+ (sqr (first lon))
               (sum-of-squares (rest lon)))]))


;; (listof String) -> Number
;; produce the sum of the lengths of the strings in los

;; Tests:
(check-expect (sum-of-lengths empty) 0)
(check-expect (sum-of-lengths (list "a" "bc")) 3)

#; (define (sum-of-lengths los)
     (cond [(empty? los) 0]
           [else
            (+ (string-length (first los))
               (sum-of-lengths (rest los)))]))


;; (x -> Y) (listof X) -> (listof Y)
;; given a function, fn, and a list (list n0 n1 ...), l, produce (list (fn n0) (fn n1) ...)

;; Stub:
#; (define (map2 fn l) l)

;; Tests:
(check-expect (map2 sqr empty) 0)
(check-expect (map2 sqr (list 8 6)) 100)
(check-expect (map2 string-length (list "a" "bc" "def")) 6)

(define (map2 fn l)
  (cond [(empty? l) 0]
        [else
         (+ (fn (first l))
            (map2 fn (rest l)))]))


;PROBLEM B:
;
;Now re-define the original functions to use abstract-sum. 
;
;Remember, the signature and tests should not change from the original 
;functions.

(define (sum-of-squares lon)
  (map2 sqr lon))

(define (sum-of-lengths los)
  (map2 string-length los))
