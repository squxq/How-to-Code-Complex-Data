;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname concat-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; concat-starter.rkt

;Problem:
;
;Given the data definition below, design a function called concat that
;consumes two ListOfString and produces a single list with all the elements 
;of lsta preceding lstb.
;
;(concat (list "a" "b" ...) (list "x" "y" ...)) should produce:
;
;(list "a" "b" ... "x" "y" ...)
;
;You are basically going to design the function append using a cross product 
;of type comments table. Be sure to simplify your design as much as possible. 
;
;Hint: Think carefully about the values of both lists. You might see a way to 
;change a cell's content so that 2 cells have the same value.

;; =================
;; Data Definitions:

;; ListOfString is one of:
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings

;; Examples: <ListOfString>
(define LOS1 empty)
(define LOS2 (cons "a" (cons "b" empty)))

;; Template: <ListOfString>
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first (los))
              (fn-for-los (rest los)))]))

;; ==========
;; Functions:

;; ListOfString ListOfString -> ListOfString
;; produce a list with all of the first given list, lsta, elements precending the ones
;;         from the second given list, lstb

;; Stub:
#;
(define (concat lsta lstb) empty)

;; Tests:
(check-expect (concat empty empty) empty)
(check-expect (concat empty LOS2) LOS2)
(check-expect (concat LOS2 empty) LOS2)
(check-expect (concat (list "a" "b") (list "x" "y"))
              (list "a" "b" "x" "y"))
(check-expect (concat (list "a" "b" "c") (list "x"))
              (list "a" "b" "c" "x"))
(check-expect (concat (list "a") (list "x" "y" "z"))
              (list "a" "x" "y" "z"))
(check-expect (concat (list "a" "b" "c") (list "x" "y" "z"))
              (list "a" "b" "c" "x" "y" "z"))

;    lstb                 lsta | empty |          (cons String ListOfString)
;   ---------------------------|-------|----------------------------------------------
;   empty                      |       |                     lsta
;   ---------------------------| lstb  |----------------------------------------------
;   (cons String ListOfString) |       | (cons (first lsta) (concat (rest lsta) lstb))

;; Template:
#;
(define (concat lsta lstb)
  (cond [(empty? lsta) (... lstb)]
        [(empty? lstb) (... lsta)]
        [else (...)]))

(define (concat lsta lstb)
  (cond [(empty? lsta) lstb]
        [(empty? lstb) lsta]
        [else (cons (first lsta)
                    (concat (rest lsta) lstb))]))