;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-02.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

;(open image file)

;; Examples:
(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

;; Template:
#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ;String
                 (elt-data e)    ;Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))


;; (String Integer Y -> X) (X Y -> Y) Y Element -> X
;; the abstract fold function for Element

;; Tests:
(check-expect (local [(define (c1 n d los) (cons n los))]
                (fold-element c1 append empty D6))
              (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (fold-element c1 c2 b e)
  (local [(define (fn-for-element e)                 ; X
            (c1 (elt-name e)                         ; String
                 (elt-data e)                        ; Integer
                 (fn-for-loe (elt-subs e))))         ; Y 

          (define (fn-for-loe loe)                   ; Y
            (cond [(empty? loe) b]                   ; Y
                  [else                              
                   (c2 (fn-for-element (first loe))  ; X
                        (fn-for-loe (rest loe)))]))] ; Y
    (fn-for-element e)))


;PROBLEM
;
;Complete the design of sum-data that consumes Element and produces   
;the sum of all the data in the element and its subs.

;; Element -> Integer
;; produce the sum of all the data in element (and its subs)

;; Stub:
#;
(define (sum-data e) 0)

;; Tests:
(check-expect (sum-data F1) 1)
(check-expect (sum-data D5) 3)
(check-expect (sum-data D4) (+ 1 2))
(check-expect (sum-data D6) (+ 1 2 3))

;; Template:
#;
(define (sum-data e)
  (fold-element ... ... ... e))

(define (sum-data e)
  (local [(define (c1 n d los) (+ d los))]
    (fold-element c1 + 0 e)))


;PROBLEM
;
;Complete the design of all-names that consumes Element and produces a list of the
;names of all the elements in the tree. 

;; Element -> ListOfString
;; produce list of the names of all the elements in the tree

;; Stub:
#;
(define (all-names e) empty)

;; Tests:
(check-expect (all-names F1) (list "F1"))
(check-expect (all-names D5) (list "D5" "F3"))
(check-expect (all-names D4) (list "D4" "F1" "F2"))
(check-expect (all-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

;; Template:
#;
(define (all-names e)
  (fold-element ... ... ... e))

(define (all-names e)
  (local [(define (c1 n d los) (cons n los))]
    (fold-element c1 append empty e)))