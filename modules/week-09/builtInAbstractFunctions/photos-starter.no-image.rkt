;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname photos-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; photos-starter.rkt

;; =================
;; Data definitions:

(define-struct photo (location album favourite))
;; Photo is (make-photo String String Boolean)
;; interp. a photo having a location, belonging to an album and having a
;; favourite status (true if photo is a favourite, false otherwise)

;; Examples:
(define PHT1 (make-photo "photos/2012/june" "Victoria" true))
(define PHT2 (make-photo "photos/2013/birthday" "Birthday" true))
(define PHT3 (make-photo "photos/2012/august" "Seattle" true))

;; =================
;; Functions:

;PROBLEM:
;
;Design a function called to-frame that consumes an album name and a list of photos 
;and produces a list of only those photos that are favourites and that belong to 
;the given album. You must use built-in abstract functions wherever possible.

;; String (listof Photo) -> (listof Photo)
;; given an album name, n, and a list of photos, lop, filter the
;; non-favorite and different album lists from the given elements

;; Stub:
#; (define (to-frame n lop) empty)

;; Tests:
(check-expect (to-frame "Victoria" (list PHT2 PHT3)) empty)
(check-expect (to-frame "Victoria" (list PHT1 PHT3)) (list PHT1))
(check-expect (to-frame "Birthday" (list PHT2 PHT3
                (make-photo "photos/2017/january" "Birthday" false)))
              (list PHT2))
(check-expect (to-frame "Seattle" (list PHT1 PHT2 PHT3
                (make-photo "photos/2014/june" "Seattle" true)
                (make-photo "photos/2012/august" "Seattle" false)))
              (list PHT3 (make-photo "photos/2014/june" "Seattle" true)))

;; Template:
#; (define (to-frame n lop)
     (filter ... lop))

(define (to-frame n lop)
     (local [(define (fav-album p) (and (photo-favourite p) (string=? n (photo-album p))))]
       (filter fav-album lop)))
