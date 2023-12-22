;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname lambdaExpressions.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;PROBLEM:
;
;Rewite each of the following function definitions using lambda.

;; Number (listof Number) -> (listof Number)
;; produce only elements of lon > threshold

;; Tests:
(check-expect (only-bigger 2 empty) empty)
(check-expect (only-bigger 3 (list 2 4 5)) (list 4 5))

#; (define (only-bigger threshold lon)
     (local [(define (pred n) 
               (> n threshold))]
    
       (filter pred lon)))

(define (only-bigger threshold lon)
  (filter (lambda (n) (> n threshold)) lon))


;; (listof Image) -> (listof Natural)
;; produce list of areas of images

;; Tests:
(check-expect (all-areas (list (rectangle 2 3 "solid" "blue") 
                               (square 10 "solid" "white")))
              (list 6 100))

#; (define (all-areas loi)
     (local [(define (area i)
               (* (image-width i)
                  (image-height i)))]
       (map area loi)))

(define (all-areas loi)
  (map (lambda (i)
         (* (image-width i)
            (image-height i))) loi))


;; (listof Number)  ->  (listof Number)
;; produce list of numbers sorted in ASCENDING order
;; ASSUMPTION: lon contains no duplicates

;; Tests:
(check-expect (qsort empty)                empty)
(check-expect (qsort (list 8))             (list 8))
(check-expect (qsort (list 7 8 9))         (list 7 8 9))
(check-expect (qsort (list  4 3 2 1))      (list 1 2 3 4))
(check-expect (qsort (list 6 8 1 9 3 7 2)) (list 1 2 3 6 7 8 9))

#; (define (qsort lon)
     (if (empty? lon) 
         empty
         (local [(define p (first lon))
                 (define (<p? n) (< n p))
                 (define (>p? n) (> n p))]
           (append (qsort (filter <p? lon))
                   (list p) 
                   (qsort (filter >p? lon))))))

(define (qsort lon)
  (if (empty? lon) 
      empty
      (local [(define p (first lon))]
        (append (qsort (filter (λ (n) (< n p)) lon))
                (list p) 
                (qsort (filter (λ (n) (> n p)) lon))))))


