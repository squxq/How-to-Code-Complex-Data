;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname wide-only-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; wide-only-starter.rkt

;PROBLEM:
;
;Use the built in version of filter to design a function called wide-only 
;that consumes a list of images and produces a list containing only those 
;images that are wider than they are tall.

;; (listof Image) -> (listof Image)
;; given a list of images, loi, produce a list containing only
;; the images that are wider than they are tall (width > height)

;; Stub:
#; (define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list (square 10 "solid" "white"))) empty)
(check-expect (wide-only (list (rectangle 20 10 "solid" "white")))
              (list (rectangle 20 10 "solid" "white")))
(check-expect (wide-only (list (rectangle 10 20 "solid" "white"))) empty)
(check-expect (wide-only (list (rectangle 20 30 "solid" "white")
                               (rectangle 10 5 "solid" "blue")
                               (rectangle 15 45 "outline" "yellow")))
              (list (rectangle 10 5 "solid" "blue")))

;; Template:
#; (define (wide-only loi)
     (filter ... loi))

(define (wide-only loi)
     (local [(define (wide? i) (> (image-width i) (image-height i)))]
       (filter wide? loi)))