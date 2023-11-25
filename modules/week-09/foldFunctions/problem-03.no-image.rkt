;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-03.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;PROBLEM
;
;If the tree is very large, then fold-element is not a good way to implement the find 
;function from last week. Why? If you aren't sure then discover the answer by implementing
;find using fold-element and then step the two versions with different arguments.

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
                (elt-data e)                         ; Integer
                (fn-for-loe (elt-subs e))))          ; Y 

          (define (fn-for-loe loe)                   ; Y
            (cond [(empty? loe) b]                   ; Y
                  [else                              
                   (c2 (fn-for-element (first loe))  ; X
                       (fn-for-loe (rest loe)))]))]  ; Y
    (fn-for-element e)))


;; String -> Integer or false
;; search the given tree, e, for an element with the given name, s, produce data if found; false otherwise

;; Stub:
#;(define (find-fold-version s e) false)
#;(define (find-first-version s e) false)

;; Tests:
(check-expect (find-fold-version "F3" F1) false)
(check-expect (find-fold-version "F3" F3) 3)
(check-expect (find-fold-version "F3" D4) false)
(check-expect (find-fold-version "F1" D4) 1)
(check-expect (find-fold-version "F2" D4) 2)
(check-expect (find-fold-version "D4" D4) 0)
(check-expect (find-fold-version "D6" D6) 0)
(check-expect (find-fold-version "F1" D6) 1)
(check-expect (find-fold-version "F3" D5) 3)

(check-expect (find-first-version "F3" F1) false)
(check-expect (find-first-version "F3" F3) 3)
(check-expect (find-first-version "F3" D4) false)
(check-expect (find-first-version "F1" D4) 1)
(check-expect (find-first-version "F2" D4) 2)
(check-expect (find-first-version "D4" D4) 0)
(check-expect (find-first-version "D6" D6) 0)
(check-expect (find-first-version "F1" D6) 1)
(check-expect (find-first-version "F3" D5) 3)

;; Template:
#;(define (find-fold-version s e)
    (fold-element ... ... ... e))
;; <used template from Element and (listof Element)>

(define (find-fold-version s e)
  (local [(define (c1 n d loe)
            (if (string=?  s n) d loe))
          (define (c2 e loe)
            (if (not (false? e)) e loe))]
    (fold-element c1 c2 false e)))

(define (find-first-version s e)
  (local [(define (fn-for-element e)
            (if (string=? s (elt-name e))
                (elt-data e)
                (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) false]
                  [else
                   (local [(define find--element (fn-for-element (first loe)))]
                     (if (not (false? find--element))
                         find--element
                         (fn-for-loe (rest loe))))]))]
    (fn-for-element e)))

;The primary issue with the fold-version (or fold-element version) lies in the fact that it continues folding
;even after the target element has been found. This can lead to unnecessary traversals of the tree, which is
;inefficient, especially in the context of large trees.
;
;In the fold-version, the folding functions (c1 and c2) do not have a mechanism to signal that the target element
;has been found and further folding is unnecessary. As a result, the entire tree is traversed even after finding
;the target element, and the folding functions are applied to every element.
;
;On the other hand, in the find-first-version, a recursive approach is used, and as soon as the target element is
;found, the recursion stops, preventing unnecessary traversal.
;
;In summary, the missing aspect in the fold-version is a mechanism to terminate the folding process once the target
;element is found. The find-first-version addresses this by using recursion and returning the result as soon as the  
;target element is located.