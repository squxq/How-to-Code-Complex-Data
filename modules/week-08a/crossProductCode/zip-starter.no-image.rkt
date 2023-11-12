;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname zip-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; zip-starter.rkt

;Problem:
;
;Given the data definition below, design a function called zip that consumes two     
;lists of numbers and produces a list of Entry, formed from the corresponding 
;elements of the two lists.
;
;(zip (list 1 2 ...) (list 11 12 ...)) should produce:
;
;(list (make-entry 1 11) (make-entry 2 12) ...)
;
;Your design should assume that the two lists have the same length.

;; =================
;; Data Definitions:

;; ListOfNumber is one of:
;; - empty
;; - (cons Number ListOfNumber)
;; interp. a list of numbers

;; Examples: <ListOfNumber>
(define LON0 empty)
(define LON1 (list 1 2 3))

;; Template: <ListOfNumber>
#;
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else
         (... (first lon)
              (fn-for-lon (rest lon)))]))

(define-struct entry (k v))
;; Entry is (make-entry Number Number)
;; Interp. an entry maps a key to a value

;; Examples: <Entry>
(define E1 (make-entry 3 12))

;; Template: <Entry>
#;
(define (fn-for-entry e)
  (... (entry-k e) (entry-v e)))


;; ListOfEntry is one of:
;;  - empty
;;  - (cons Entry ListOfEntry)
;; interp. a list of key value entries

;; Examples: <ListOfEntry>
(define LOE0 empty)
(define LOE1 (list E1 (make-entry 1 11)))

;; Template: <ListOfEntry>
#;
(define (fn-for-loe loe)
  (cond [(empty? loe) (...)]
        [else
         (... (fn-for-entry (first loe))
              (fn-for-loe (rest loe)))]))


;; ==========
;; Functions:

;; ListOfNumber ListOfNumber -> ListOfEntry
;; produce a list of entry, formed from the corresponding elements from the two given lists of numbers, lsta and lstb
;; ASSUME: the given lists of numbers, lsta and lstb, have the same length

;; Stub:
#;
(define (zip lsta lstb) empty)

;; Tests:
(check-expect (zip empty empty) empty)
(check-expect (zip (list 1) (list 11))
              (list (make-entry 1 11)))
(check-expect (zip (list 1 2) (list 11 12))
              (list (make-entry 1 11) (make-entry 2 12)))
(check-expect (zip (list 1 2 3) (list 11 12 13))
              (list (make-entry 1 11) (make-entry 2 12) (make-entry 3 13)))

;; nao -> not an option
;    lstb                 lsta | empty |          (cons Number ListOfNumber)
;   ---------------------------|-------|----------------------------------------------
;   empty                      | empty |                     nao
;   ---------------------------|-------|----------------------------------------------
;   (cons Number ListOfNumber) |  nao  | (cons (make-entry (first lsta) (first lstb))
;                              |       |       (zip (rest lsta) (rest lstb)))

;; Template:
#;
(define (zip lsta lstb)
  (cond [(empty? lsta) (...)]
        [else
         (... (first lsta) (first lstb)
              (fn-for-lon (rest lsta))
              (fn-for-lon (rest lstb)))]))

(define (zip lsta lstb)
  (cond [(empty? lsta) empty]
        [else
         (cons (make-entry (first lsta) (first lstb))
               (zip (rest lsta) (rest lstb)))]))