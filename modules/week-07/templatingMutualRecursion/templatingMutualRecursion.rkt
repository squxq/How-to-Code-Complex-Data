;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname templatingMutualRecursion) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; Data definitions:

;; Note:
; When dealing with types involding mutual reference, group types commments and interpretations,
; examples and templates together.
;; End of Note.

(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

;; Examples: <Element>
(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))

;; Examples: <ListOfElement>
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

;; Template: <Element>
(define (fn-for-element e)
  (... (elt-name e)                ; String
       (elt-date e)                ; Integer
       (fn-for-loe (elt-subs e)))) ; ListOfElement

;; Template rules used: <Element>
;; - compound: 3 fields
;; - reference: (elt-subs e) is ListOfElement

;; Template: <ListOfElement>
(define (fn-for-loe loe)
  (cond [(empty? loe) (...)]
        [else
         (... (fn-for-element (first loe))
              (fn-for-loe (rest loe)))]))

;; Template rules used: <ListOfElement>
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons Element ListOfElement)
;; - reference: (first loe) is Element
;; - self-reference: (rest loe) is ListOfElement

;; Note:
; Only use fn-for-something when there is a reference to another data type.
;; End  of Note.
