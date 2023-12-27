;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname worklistAccumulators.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))


;PROBLEM:
;
;In the Harry Potter movies, it is very important which of the four houses a
;wizard is placed in when they are at Hogwarts. This is so important that in 
;most families multiple generations of wizards are all placed in the same family. 
;
;Design a representation of wizard family trees that includes, for each wizard,
;their name, the house they were placed in at Hogwarts and their children. We
;encourage you to get real information for wizard families from: 
;   http://harrypotter.wikia.com/wiki/Main_Page
;
;The reason we do this is that designing programs often involves collection
;domain information from a variety of sources and representing it in the program
;as constants of some form. So this problem illustrates a fairly common scenario.
;
;That said, for reasons having to do entirely with making things fit on the
;screen in later videos, we are going to use the following wizard family tree,
;in which wizards and houses both have 1 letter names. (Sigh)

;; =================
;; Data Definitions:

;; House is one of:
;; - "G"
;; - "H"
;; - "R"
;; - "S"
;; interp. Hogwarts School of Witchcraft and Wizardry is divided this in four houses

;; Template:
#; (define (fn-for-house h)
     (cond [(string=? "G" h) (...)]
           [(string=? "H" h) (...)]
           [(string=? "R" h) (...)]
           [else (...)])) ;; (string=? "S" h)


(define-struct wizard (name house children))
;; Wizard is (make-wizard String House (listof Wizard))
;; interp. wizard from the Harry Potter wiki with:
;;         - name, is the wizard's name first letter
;;         - house, is the first letter of the house the
;;           wizard was placed in at Hogwarts
;;         - children, is a list of the wizard's children

;; Template:
#; (define (fn-for-wizard w)
     (local [(define (fn-for--wizard w)
               (... (wizard-name w)
                    (fn-for-house (wizard-house w))
                    (fn-for--low (wizard-children w))))

             (define (fn-for--low low)
               (cond [(empty? low) (...)]
                     [else
                      (... (fn-for--wizard (first low))
                           (fn-for--low (rest low)))]))]

       (fn-for--wizard w)))


;; =====================
;; Constant Definitions:

;; WIZARDS:

(define Wa (make-wizard "A" "S" empty))
(define Wb (make-wizard "B" "G" empty))
(define Wc (make-wizard "C" "R" empty))
(define Wd (make-wizard "D" "H" empty))
(define We (make-wizard "E" "R" empty))
(define Wf (make-wizard "F" "R" (list Wb)))
(define Wg (make-wizard "G" "S" (list Wa)))
(define Wh (make-wizard "H" "S" (list Wc Wd)))
(define Wi (make-wizard "I" "H" empty))
(define Wj (make-wizard "J" "R" (list We Wf Wg)))
(define Wk (make-wizard "K" "G" (list Wh Wi Wj)))


;PROBLEM:
;
;Design a function that consumes a wizard and produces the names of every 
;wizard in the tree that was placed in the same house as their immediate
;parent. 

;; =====================
;; Function Definitions:

;; Wizard -> (listof String)
;; produce the name of every wizard in the given wizard family tree, w, that was
;; placed in the same house as their immediate parent

;; Stub:
#; (define (same-house-as-parent w) empty)

;; Tests:
(check-expect (same-house-as-parent Wa) empty) ;; no children
(check-expect (same-house-as-parent Wf) empty) ;; w is in house R & child is in G
(check-expect (same-house-as-parent Wg) (list "A")) ;; child of given w
;; first two are children of w, and third one is child of w's child Wg
(check-expect (same-house-as-parent Wj) (list "E" "F" "A"))
(check-expect (same-house-as-parent Wk) (list "E" "F" "A"))

;; Template: <used template from Wizard and for Context Preserving Accumulator>
(define (same-house-as-parent w)
  ;; acc: House; the house of this wizard's immediate parent
  ;; ASSUME: wizard, w, always has a parent, because root wizard is
  ;;         never passed into a function. fn-for--low is called for
  ;;         all children of root wizard, so we are at depth 1

  ;; Example:
  ;; (same-house-as-parent Wj)
  ;; (fn-for--low (list We Wf Wg) "R")
  ;; (fn-for--wizard (make-wizard "E" "R" empty) "R")
  ;; (fn-for--low empty "R")
  ;; (fn-for--wizard (make-wizard "F" "R" (list Wb)) "R")
  ;; (fn-for--low (list Wb) "R")
  ;; (fn-for--wizard (make-wizard "B" "G" empty) "R")
  ;; (fn-for--low empty "G")
  ;; (fn-for--wizard (make-wizard "G" "S" (list Wa)) "R")
  ;; (fn-for--low (list Wa) "S")
  ;; (fn-for--wizard (make-wizard "A" "S" empty) "S")
  
  (local [(define (fn-for--wizard w acc)
            (if (string=? (wizard-house w) acc)
                (cons (wizard-name w)
                      ;; here we don't need to change acc, because
                      ;; w parent's house is the same as w's house
                      (fn-for--low (wizard-children w) acc))
                (fn-for--low (wizard-children w) (wizard-house w))))

          (define (fn-for--low low acc)
            (cond [(empty? low) empty]
                  [else
                   (append (fn-for--wizard (first low) acc)
                           (fn-for--low (rest low) acc))]))]

    (fn-for--low (wizard-children w) (wizard-house w))))

