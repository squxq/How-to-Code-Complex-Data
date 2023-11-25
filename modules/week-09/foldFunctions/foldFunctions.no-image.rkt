;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname foldFunctions.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; At this point in the course, the type (listof X) means:

;; ListOfX is one of:
;; - empty
;; - (cons X ListOfX)
;; interp. a list of X

;; and the template for (listof X) is:
#;
(define (fn-for-lox lox)
  (cond [(empty? lox) (...)]
        [else
         (... (first lox)
              (fn-for-lox (rest lox)))]))

;PROBLEM:
;
;Design an abstract fold function for (listof X). 

;; (X Y -> Y) Y (listof X) -> Y
;; the abstract fold function for (listof X)

;; Tests:
(check-expect (fold + 0 (list 1 2 3)) 6)
(check-expect (fold * 1 (list 1 2 3)) 6)
(check-expect (fold string-append "" (list "a" "bc" "def")) "abcdef")

(define (fold fn b lox)
  (cond [(empty? lox) b] ; base case result
        [else
         (fn (first lox) ; the combination function (combines (first lox) 
              (fold fn b (rest lox)))])) ; and the natural recursion on (rest lox))


;; ======================

;PROBLEM:
;
;Design an abstract fold function for Element (and (listof Element)).


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

