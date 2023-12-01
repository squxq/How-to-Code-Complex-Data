;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname closures.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; Some setup data and functions to enable more interesting examples
;; below

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))

;; NOTE: Unlike using-built-ins-starter.rkt this file does not define
;; the functions tall? wide? square? and area.

;PROBLEM: 
;
;Complete the design of the following functions by completing the body
;which has already been templated to use a built-in abstract list function.

;; (listof Image) -> (listof Image)
;; produce list of only those images that have width >= height

;; Stub:
#;
(define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

;; Template:
#;
(define (wide-only loi) 
  (filter ... loi))

(define (wide-only loi)
  (local [(define (wide? i)
            (> (image-width i) (image-height i)))]
    (filter wide? loi)))


;; Number (listof Image) -> (listof Image)
;; produce list of only those images in loi with width >= w

;; Stub:
#;
(define (wider-than-only w loi) empty)

;; Tests:
(check-expect (wider-than-only 40 LOI1) (list I4 I5))

;; Template:
#;
(define (wider-than-only w loi)
  (filter ... loi))

(define (wider-than-only w loi)
  (local [(define (wider-than? i) (> (image-width i) w))]
  (filter wider-than? loi)))


;; (listof Number) -> (listof Number)
;; produce list of each number in lon cubed

;; Stub:
(define (cube-all lon) empty)

;; Tests:
(check-expect (cube-all (list 1 2 3)) (list (* 1 1 1) (* 2  2 2) (* 3 3 3)))

;; Template:
#;
(define (cube-all lon)
  (map ... lon))


;; String (listof String) -> (listof String)
;; produce list of all elements of los prefixed by p

;; Stub:
(define (prefix-all p los) empty)

;; Tests:
(check-expect (prefix-all "accio " (list "portkey" "broom"))
              (list "accio portkey" "accio broom"))

;; Template:
#;
(define (prefix-all p los)
  (map ... los))



