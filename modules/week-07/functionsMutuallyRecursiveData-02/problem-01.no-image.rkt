;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;The following is a revised data definition for Person and ListOfPerson:

(define-struct person (name age children))
;; Person is (make-person String Natural ListOfPeople)
;; interp. a person with first name, age and a list of their children

;; ListOfPeople is one of:
;; - empty
;; - (cons Person ListOfPeople)
;; interp. a list of people

;; Examples: <Person>
(define P1 (make-person "John" 2 empty))
(define P2 (make-person "Mary" 10 empty))
(define P3 (make-person "Elisabeth" 29 (list P1 P2)))
(define P4 (make-person "Harry" 15 empty))
(define P5 (make-person "George" 36 (list P4)))
(define P6 (make-person "Grandma" 67 (list P3 P5)))

;; Examples: <ListOfPeople>
(define LOP1 empty)
(define LOP2 (list P1 P2))
(define LOP3 (list P4))
(define LOP4 (list P3 P5))

;; Template: <Person>
#;
(define (fn-for-person p)
  (... (person-name p) (person-age p) (person-children p)))

;; Template rules used: <Person>
;; - compound: 3 fields
;; - reference: (person-children p) is ListOfPeople

;; Template: <ListOfPeople>
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop))
              (fn-for-lop (rest lop)))]))

;; Template rules used: <ListOfPeople>
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons Person ListOfPeople)
;; - reference: (first lop) is Person
;; - self-reference: (rest lop) is ListOfPeople


;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; interp. a list of strings (in this scenario: a list of names)

;; Template:
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))

;We would like to design a function that consumes a person and produces
;a list of the names of all the people in the tree under 20 ("in the tree" includes the original person).

;; Person -> ListOfString
;; ListOfPeople -> ListOfString
;; produce a list of the names of all the people in the tree younger than 20 (< 20)
;; NOTE: "in the tree" includes the original person

;; Stubs:
#;
(define (get-names--person p) empty)
#;
(define (get-names--los los) empty)

;; Tests: <Person>
(check-expect (get-names--person P1) (list "John"))
(check-expect (get-names--person P3) (list "John" "Mary"))
(check-expect (get-names--person P4) (list "Harry"))
(check-expect (get-names--person P6) (list "John" "Mary" "Harry"))

;; Tests: <ListOfPeople>
(check-expect (get-names--lop LOP1) empty)
(check-expect (get-names--lop LOP2) (list "John" "Mary"))
(check-expect (get-names--lop LOP3) (list "Harry"))
(check-expect (get-names--lop LOP4) (list "John" "Mary" "Harry"))

;; Template: <Person>
(define (get-names--person p)
  (if (< (person-age p) 20)
      (cons (person-name p) (get-names--lop (person-children p)))
      (get-names--lop (person-children p))))

;; Template: <ListOfPeople>
(define (get-names--lop lop)
  (cond [(empty? lop) empty]
        [else
         (append (get-names--person (first lop))
              (get-names--lop (rest lop)))]))
