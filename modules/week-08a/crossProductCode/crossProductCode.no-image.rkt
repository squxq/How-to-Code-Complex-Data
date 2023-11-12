;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname crossProductCode.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; prefix-equal-starter.rkt

;PROBLEM: design a function that consumes two lists of strings and produces true
;if the first list is a prefix of the second. Prefix means that the elements of
;the first list match the elements of the second list 1 for 1, and the second list
;is at least as long as the first.
;
;For reference, the ListOfString data definition is provided below.

;; =================
;; Data Definitions:

;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; interp. a list of strings

;; Examples: <ListOfString>
(define LS0 empty)
(define LS1 (cons "a" empty))
(define LS2 (cons "a" (cons "b" empty)))
(define LS3 (cons "c" (cons "b" (cons "a" empty))))

;; Template: <ListOfString>
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else 
         (... (first los)
              (fn-for-los (rest los)))]))

;; ==========
;; Functions:

;; ListOfString ListOfString -> Boolean
;; produce true if lsta is a prefix of lstb

;; Stub:
;(define (prefix=? lsta lstb) false)

;; Tests:
(check-expect (prefix=? empty empty) true)
(check-expect (prefix=? (list "x") empty) false)
(check-expect (prefix=? empty (list "x")) true)
(check-expect (prefix=? (list "x") (list "x")) true)
(check-expect (prefix=? (list "x") (list "y")) false)
(check-expect (prefix=? (list "x" "y") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "x") (list "x" "y")) false)
(check-expect (prefix=? (list "x") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "y" "z") (list "x" "y")) false)

;; Template: <ListOfString ListOfString>

;(define (prefix=? lsta lstb)
;  (cond [(and (empty? lsta) (empty? lstb)) (...)]
;        [(and (cons? lsta) (empty? lstb)) (... (first lsta)
;                                               (fn-for-los (rest lsta)))]
;        [(and (cons? lstb) (empty? lsta)) (... (first lstb)
;                                               (fn-for-los (rest lstb)))]          
;        [(and (cons? lsta) (cons? lstb)) (... (first lsta) (first lstb)
;                                              (fn-for-los (rest lsta))
;                                              (fn-for-los (rest lstb)))]))

#;
(define (prefix=? lsta lstb)
  (cond [(empty? lsta) (...)]
        [(empty? lstb) (...)]
        [else (... (first lsta) (first lstb)
                   (fn-for-los (rest lsta))
                   (fn-for-los (rest lstb)))]))

(define (prefix=? lsta lstb)
  (cond [(empty? lsta) true]
        [(empty? lstb) false]
        [else (if (string=? (first lsta) (first lstb))
                   (prefix=? (rest lsta) (rest lstb))
                   false)]))