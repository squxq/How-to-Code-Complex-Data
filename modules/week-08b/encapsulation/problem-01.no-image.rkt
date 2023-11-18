;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Recall the following functions from the Mutual Reference module:

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

;; Template:
#;
(define (fn-for-person p)
  (local [
          (define (fn-for-person p)
            (... (person-name p) (person-age p) (person-children p)))

          (define (fn-for-lop lop)
            (cond [(empty? lop) (...)]
                  [else
                   (... (fn-for-person (first lop))
                        (fn-for-lop (rest lop)))]))]
    (fn-for-person p)))


;;; Person -> ListOfString
;;; ListOfPerson -> ListOfString
;;; produce a list of the names of the persons under 20
;
;(check-expect (names-under-20--person P1) (list "N1"))
;(check-expect (names-under-20--lop empty) empty)
;(check-expect (names-under-20--person P2) (list "N1"))
;(check-expect (names-under-20--person P4) (list "N3" "N1"))
;
;(define (names-under-20--person p)
;  (if (< (person-age p) 20)
;      (cons (person-name p)
;            (names-under-20--lop (person-children p)))
;      (names-under-20--lop (person-children p))))
;      
;(define (names-under-20--lop lop)
;  (cond [(empty? lop) empty]
;        [else
;         (append (names-under-20--person (first lop))
;                 (names-under-20--lop (rest lop)))]))

;The function that other parts of the program are interested in is names-under-20--person.   
;Let's call the new function names-under-20.
;
;Encapsulate the functions names-under-20--person and names-under-20--lop using local.

;; Person -> ListOfString
;; produce a list of the names of the persons under 20

(check-expect (names-under-20 P1) (list "John"))
(check-expect (names-under-20 P2) (list "Mary"))
(check-expect (names-under-20 P3) (list "John" "Mary"))
(check-expect (names-under-20 P4) (list "Harry"))
(check-expect (names-under-20 P5) (list "Harry"))
(check-expect (names-under-20 P6) (list "John" "Mary" "Harry"))

(define (names-under-20 p)
  (local [
          (define (names-under-20--person p)
            (if (< (person-age p) 20)
                (cons (person-name p)
                      (names-under-20--lop (person-children p)))
                (names-under-20--lop (person-children p))))
      
          (define (names-under-20--lop lop)
            (cond [(empty? lop) empty]
                  [else
                   (append (names-under-20--person (first lop))
                           (names-under-20--lop (rest lop)))]))]
    (names-under-20--person p)))