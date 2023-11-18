;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-02.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Encapsulation doesn't just work with mutually recursive functions.
;As a guideline, it is valuable whenever one function is useful at top-level,
;and it has one or more helpers that are not useful at top level.
;With that in mind, let's look at using encapsulation with a sorting example similar
;to what you saw in the arrange-images problem from the Function Composition lecture.   
;
;Go ahead and encapsulate sort-lon and insert using local.

;;; ListOfNumber -> ListOfNumber
;;; sort the numbers in lon in increasing order
;
;;; Tests:
;(check-expect (sort-lon empty) empty)
;(check-expect (sort-lon (list 1)) (list 1))
;(check-expect (sort-lon (list 1 2 3)) (list 1 2 3))
;(check-expect (sort-lon (list 2 1 3)) (list 1 2 3))
;(check-expect (sort-lon (list 3 2 1)) (list 1 2 3))
;
;(define (sort-lon lon)
;  (cond [(empty? lon) empty]
;        [else
;         (insert (first lon)
;                 (sort-lon (rest lon)))]))
;                 
;;; Number ListOfNumber -> ListOfNumber
;;; insert n in proper position in lon
;;; ASSUME: lon is sorted in increasing order
;
;;; Tests:
;(check-expect (insert 2 empty) (list 2))
;(check-expect (insert 2 (list 1 3)) (list 1 2 3))
;
;(define (insert n lon)
;  (cond [(empty? lon) (cons n empty)]
;        [else
;         (if (> (first lon) n)
;             (cons n lon)
;             (cons (first lon) (insert n (rest lon))))]))

;; ListOfNumber -> ListOfNumber
;; sort the numbers in lon in increasing order

;; Tests:
(check-expect (sort-lon empty) empty)
(check-expect (sort-lon (list 1)) (list 1))
(check-expect (sort-lon (list 1 2 3)) (list 1 2 3))
(check-expect (sort-lon (list 2 1 3)) (list 1 2 3))
(check-expect (sort-lon (list 3 2 1)) (list 1 2 3))

(define (sort-lon lon)
  (local [
          (define (sort-lon lon)
            (cond [(empty? lon) empty]
                  [else
                   (insert (first lon)
                           (sort-lon (rest lon)))]))
          
          ;; Number ListOfNumber -> ListOfNumber
          ;; insert n in proper position in lon
          ;; ASSUME: lon is sorted in increasing order
          (define (insert n lon)
            (cond [(empty? lon) (cons n empty)]
                  [else
                   (if (> (first lon) n)
                       (cons n lon)
                       (cons (first lon) (insert n (rest lon))))]))]
    (sort-lon lon)))