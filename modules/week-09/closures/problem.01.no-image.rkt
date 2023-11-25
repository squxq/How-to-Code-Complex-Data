;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem.01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Complete the design of the two function definitions below:
;
;;; (listof Number) -> (listof Number)
;;; produce list of each number in lon cubed
;
;;; Stub:
;(define (cube-all lon) empty)
;
;;; Tests:
;(check-expect (cube-all (list 1 2 3)) (list (* 1 1 1) (* 2  2 2) (* 3 3 3)))   
;
;;; Template:
;#;
;(define (cube-all lon)
;  (map ... lon))
;
;
;;; String (listof String) -> (listof String)
;;; produce list of all elements of los prefixed by p
;
;;; Stub:
;(define (prefix-all p los) empty)
;
;;; Tests:
;(check-expect (prefix-all "accio " (list "portkey" "broom"))
;              (list "accio portkey" "accio broom"))
;
;;; Template:
;#;
;(define (prefix-all p los)
;  (map ... los))

;; (listof Number) -> (listof Number)
;; produce list of each number in lon cubed

;; Stub:
#;
(define (cube-all lon) empty)

;; Tests:
(check-expect (cube-all (list 1 2 3)) (list (* 1 1 1) (* 2  2 2) (* 3 3 3)))

;; Template:
#;
(define (cube-all lon)
  (map ... lon))

(define (cube-all lon)
  (local [(define (cube n) (* n n n))]
  (map cube lon)))


;; String (listof String) -> (listof String)
;; produce list of all elements of los prefixed by p

;; Stub:
#;
(define (prefix-all p los) empty)

;; Tests:
(check-expect (prefix-all "accio " (list "portkey" "broom"))
              (list "accio portkey" "accio broom"))

;; Template:
#;
(define (prefix-all p los)
  (map ... los))

(define (prefix-all p los)
  (local [(define (prefix s) (string-append p s))]
  (map prefix los)))