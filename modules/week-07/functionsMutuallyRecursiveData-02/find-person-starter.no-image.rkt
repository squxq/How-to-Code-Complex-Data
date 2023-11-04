;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname find-person-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; find-person-starter.rkt

;The following program implements an arbitrary-arity descendant family 
;tree in which each person can have any number of children.
;
;PROBLEM A:
;
;Decorate the type comments with reference arrows and establish a clear 
;correspondence between template function calls in the templates and 
;arrows in the type comments.

;; Data definitions:

(define-struct person (name age kids))
;; Person is (make-person String Natural ListOfPerson) --> Mutual Reference
;; interp. A person, with first name, age and their children

;; Examples:
(define P1 (make-person "N1" 5 empty))
(define P2 (make-person "N2" 25 (list P1)))
(define P3 (make-person "N3" 15 empty))
(define P4 (make-person "N4" 45 (list P3 P2)))

;; Template: <Person>
#;
(define (fn-for-person p)
  (... (person-name p)
       (person-age p)  
       (fn-for-lop (person-kids p)))) ; --> Mutual Reference to ListOfPerson


;; ListOfPerson is one of:
;;  - empty
;;  - (cons Person        --> Mutual Reference
;;          ListOfPerson) --> Self-Reference
;; interp. a list of persons

;; Template: <ListOfPerson>
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop)) ; --> Mutual Reference to Person
              (fn-for-lop (rest lop)))])) ; --> Self-Reference


;; Functions:

;PROBLEM B:
;
;Design a function that consumes a Person and a String. The function
;should search the entire tree looking for a person with the given 
;name. If found the function should produce the person's age. If not 
;found the function should produce false.

;; Person String -> Natural or false
;; ListOfPerson String -> Natural or false
;; search the entire tree, p, for a person with the given name, s; if found produce the person's age; otherwise false

;; Stubs:
;(define (search--person p s) false)
;(define (search--lop lop s) false)

;; Tests:
(check-expect (search--lop empty "N1") false)
(check-expect (search--person P1 "N1") 5)
(check-expect (search--person P2 "N1") 5)
(check-expect (search--lop (list P1) "N1") 5)
(check-expect (search--person P3 "N1") false)
(check-expect (search--person P4 "N2") 25)
(check-expect (search--person P4 "N1") 5)
(check-expect (search--lop (list P3 P2) "N3") 15)

;; Template: <Person>
(define (search--person p s)
  (if (string=? (person-name p) s)
       (person-age p)  
       (search--lop (person-kids p) s)))

;; Template: <ListOfPerson>
(define (search--lop lop s)
  (cond [(empty? lop) false]
        [else
         (if (not (false? (search--person (first lop) s)))
             (search--person (first lop) s)
             (search--lop (rest lop) s))]))