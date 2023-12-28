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


(define-struct work (parent-house wizard))
;; Work is (make-work (House | "") Wizard)
;; interp. a single element for worklist accumulator with wizard's parent-house
;;         parent-house can either be House or "", since the root wizard doesn't
;;         have a parent, it doesn't have a parent-house

;; Template:
#; (define (fn-for--work work)
     (... (work-parent-house work)
          (work-wizard work)))


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
#; (define (same-house-as-parent w)
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


;PROBLEM:
;
;Design a function that consumes a wizard and produces the number of wizards 
;in that tree (including the root). Your function should be tail recursive.

;; Wizard -> Natural
;; produces the total number of wizards in the given wizard tree, w,
;; including the root

;; Stub:
#; (define (count w) 0)

;; Tests:
(check-expect (count Wa) 1)
(check-expect (count Wk) 11)

;; Template: <used template from Wizard and for Context Preserving Accumulators>
(define (count w)
  ;; rsf is Natural; the number of wizards seen so far
  ;; todo is (listof Wizard); wizards we still need to vist with fn-for--wizard
  
  ;; Example:
  ;; (count Wk)  
  ;; (fn-for-wiz Wk 0)
  ;; (fn-for-wiz Wh 1)
  ;; (fn-for-wiz Wc 2)
  ;; ...
  
  (local [(define (fn-for--wizard w todo rsf) 
            (fn-for--low (append (wizard-children w) todo)
                         (add1 rsf)))

          (define (fn-for--low todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for--wizard (first todo) (rest todo) rsf)]))]

    (fn-for--wizard w empty 0)))


;PROBLEM:
;
;Design a new function definition for same-house-as-parent that is tail 
;recursive. You will need a worklist accumulator.

;; Template: <used template from Wizard, from Work,
;;            for Result-so-Far Accumulator and for Worklist Accumulator>
#; (define (same-house-as-parent w)
     ;; rsf is (listof String); names of wizards that have been visited with
     ;;                       ; fn-for--work and have the same House as their parents
     ;;                       ; result-so-far accumulator
     ;; wl is (listof Work); wizards we still need to visit with fn-for--work
     ;;                    ; and their parent's House - worklist accumulator

     (local [(define (fn-for--work work wl rsf)
               (local [(define w (work-wizard work))
                       (define next-wl
                         (append (map
                                  (λ (c) (make-work (wizard-house w) c))
                                  (wizard-children w)) wl))]
                 (if (string=? (wizard-house w) (work-parent-house work))
                     (fn-for--wl next-wl (append rsf (list (wizard-name w))))
                     (fn-for--wl next-wl rsf))))

             (define (fn-for--wl wl rsf)
               (cond [(empty? wl) rsf]
                     [else
                      (fn-for--work (first wl) (rest wl) rsf)]))]

       (fn-for--work (make-work "" w) empty empty)))

;; or

;; Template: <used template from Wizard, for Result-so-Far Accumulator,
;;            for Worklist Accumulator, and compount data definition
;;            for worklist entries>
(define (same-house-as-parent w)
  ;; todo is (listof ...); a worklist accumulator
  ;; rsf is (listof String); a result-so-far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard House)
          ;; interp. a worklist entry with the wizard to pass to fn-for--wizard
          ;;         and that wizard's parent house
          ;; NOTE: In case of the root wizard, we never create a wle with it;
          ;;       therefore any (wle-ph ...) will be of type House

          (define (fn-for--wizard w ph todo rsf)
            (fn-for--todo (append (map (λ (c) (make-wle c (wizard-house w)))
                                       (wizard-children w)) todo)
                          (if (string=? (wizard-house w) ph)
                              (append rsf (list (wizard-name w)))
                              rsf)))

          (define (fn-for--todo todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for--wizard (wle-w (first todo)) (wle-ph (first todo))
                                   (rest todo) rsf)]))]

    (fn-for--wizard w "" empty empty)))