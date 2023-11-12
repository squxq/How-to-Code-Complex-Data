;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname merge-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; merge-starter.rkt

;Problem:
;
;Design the function merge. It consumes two lists of numbers, which it assumes are 
;each sorted in ascending order. It produces a single list of all the numbers, 
;also sorted in ascending order. 
;
;Your solution should explicitly show the cross product of type comments table, 
;filled in with the values in each case. Your final function should have a cond 
;with 3 cases. You can do this simplification using the cross product table by 
;recognizing that there are subtly equal answers. 
;
;Hint: Think carefully about the values of both lists. You might see a way to 
;change a cell content so that 2 cells have the same value.

;; Data Definitions:

;; ListOfNumber is one of:
;; - empty
;; - (cons Number ListOfNumber)
;; interp. a list of numbers

;; Examples: <ListOfNumber>
(define LON0 empty)
(define LON1 (cons 1 empty))
(define LON2 (list 2 3))
(define LON3 (list 7 11))
(define LON4 (list 5 20))

;; Template: <ListOfNumber>
#;
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else
         (... (first lon)
              (fn-for-lon (rest lon)))]))

;; ListOfNumber ListOfNumber-> ListOfNumber
;; produce a single list of all the numbers in both given lists of numbers, lsta and lstb, in ascending order
;; ASSUME: the given lists of numbers, lsta and lstb, are sorted in ascending order

;; Stub:
#;
(define (merge lsta lstb) empty)

;; Tests:
(check-expect (merge empty empty) empty)
(check-expect (merge empty LON1) LON1)
(check-expect (merge LON1 empty) LON1)
(check-expect (merge LON1 LON2) (list 1 2 3))
(check-expect (merge LON2 LON3) (list 2 3 7 11))
(check-expect (merge LON3 LON4) (list 5 7 11 20))
(check-expect (merge (list 10 21) (list 9 13))
              (list 9 10 13 21))

;    lstb                 lsta | empty |          (cons String ListOfString)
;   ---------------------------|-------|----------------------------------------------
;   empty                      |       |                     lsta
;   ---------------------------|       |----------------------------------------------
;                              |       | (if (< (first lsta) (first lstb))
;                              | lstb  |     (cons (first lsta)
;  (cons String ListOfString)  |       |           (merge (rest lsta) lstb))
;                              |       |     (cons (first lstb)
;                              |       |           (merge lsta (rest lstb))))

;; Template:
#;
(define (merge lsta lstb)
  (cond [(empty? lsta) (... lstb)]
        [(empty? lstb) (... lsta)]
        [else
         (... lsta lstb)]))

(define (merge lsta lstb)
  (cond [(empty? lsta) lstb]
        [(empty? lstb) lsta]
        [else (if (< (first lsta) (first lstb))
                  (cons (first lsta)
                        (merge (rest lsta) lstb))
                  (cons (first lstb)
                        (merge lsta (rest lstb))))]))