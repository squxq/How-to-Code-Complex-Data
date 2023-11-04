;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname hp-family-tree-starter.no-image) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))

;; hp-family-tree-starter.rkt

;In this problem set you will represent information about descendant family 
;trees from Harry Potter and design functions that operate on those trees.
;
;To make your task much easier we suggest two things:
;  - you only need a DESCENDANT family tree
;  - read through this entire problem set carefully to see what information 
;    the functions below are going to need. Design your data definitions to
;    only represent that information.
;  - you can find all the information you need by looking at the individual 
;    character pages like the one we point you to for Arthur Weasley.

;PROBLEM 1:
;
;Design a data definition that represents a family tree from the Harry Potter 
;wiki, which contains all necessary information for the other problems.  You 
;will use this data definition throughout the rest of the homework.

;; Data Definitions:

(define-struct wand (length wood core))
;; Wand is (make-wand Number String String)
;; interp. wand that belongs to a wizard, based on the Harry Potter wiki, with:
;;         length, is the wand's length in inches (") - 0 means the length is unknown
;;         wood, is the wand's wood
;;         core, is the wand's core
;;         for the 2 above fields: "" - means the information if not present (unknown)

;; Examples: <Wand>
(define UNKNOWN-WAND (make-wand 0 "" ""))
(define CHARLES-WAND (make-wand 12 "Ash" "unicorn tail hair"))
(define RONALD-WAND-1 (make-wand 12 "Ash" "unicorn tail hair"))
(define RONALD-WAND-2 (make-wand 14 "Willow" "unicorn tail hair"))
(define RONALD-WAND-3 (make-wand 9.25 "Chestnut" "Dragon heartstring"))
(define GINEVRA-WAND (make-wand 0 "Yew" ""))
(define ALBUS-WAND (make-wand 0 "Cherry" ""))

;; Template: <Wand>
#;
(define (fn-for-wand wand)
  (... (wand-length wand)
       (wand-wood wand)
       (wand-core wand)))


;; ListOfWand is one of:
;; - empty
;; - (cons Wand ListOfWand)
;; interp. list of wands; empty means no wand

;; Examples: <ListOfWand>
(define NO-WAND empty)
(define UNKNOWN-WANDS (list UNKNOWN-WAND))
(define CHARLES-WANDS (list CHARLES-WAND UNKNOWN-WAND))
(define RONALD-WANDS (list RONALD-WAND-1 RONALD-WAND-2 RONALD-WAND-3))
(define GINEVRA-WANDS (list GINEVRA-WAND))
(define ALBUS-WANDS (list ALBUS-WAND))

;; Template: <ListOfWand>
#;
(define (fn-for-low low)
  (cond [(empty? low) (...)]
        [else
         (... (fn-for-wand (first low))   ; --> Reference to Wand
              (fn-for-low (rest low)))])) ; --> Self-Reference to ListOfWand


(define-struct wizard (first-name last-name patronus wands children))
;; Wizard is (make-wizard String String String ListOfWand DescendantsOfWizard)
;; interp. wizard from the Harry Potter wiki with:
;;         first-name, is the wizard's first name
;;         last-name, is the wizard's last name
;;         patronus, is the wizard's patronus - "" means no patronus
;;         wands, are the wizard's wands - empty means no wand
;;         children, are the wizard's children

;; DescendantsOfWizard is one of:
;; - empty
;; - (cons Wizard DescendantsOfWizard)
;; interp. the descendants of a given wizard
;;         empty means no descendants, or they are not relevant

;; Examples: <Wizard>
(define VICTOIRE (make-wizard "Victoire" "Weasly" "" NO-WAND empty))
(define DOMINIQUE (make-wizard "Dominique" "Weasley" "" NO-WAND empty))
(define LOUIS (make-wizard "Louis" "Weasley" "" NO-WAND empty))
(define JAMES (make-wizard "James" "Potter" "" NO-WAND empty))
(define ALBUS (make-wizard "Albus" "Potter" "" ALBUS-WANDS empty))
(define LILY (make-wizard "Lily" "Potter" "" NO-WAND empty))
;; Examples: <DescendantsOfWizard>
(define DOW0 empty)
(define DOW1 (cons VICTOIRE empty))
(define WILLIAM-CHILDREN (list VICTOIRE DOMINIQUE LOUIS))
(define GINEVRA-CHILDREN (list JAMES ALBUS LILY))
;; Examples: <Wizard>
(define WILLIAM (make-wizard "William" "Weasley" "Non-Corporeal" UNKNOWN-WANDS WILLIAM-CHILDREN))
(define CHARLES (make-wizard "Charles" "Weasley" "Non-Corporeal" CHARLES-WANDS empty))
(define PERCY (make-wizard "Percy" "Weasley" "Non-Corporeal" UNKNOWN-WANDS empty))
(define FRED (make-wizard "Fred" "Weasley" "Magpie" UNKNOWN-WANDS empty))
(define GEORGE (make-wizard "George" "Weasley" "Magpie" UNKNOWN-WANDS empty))
(define RONALD (make-wizard "Ronald" "Weasley" "Jack Russel terrier" RONALD-WANDS empty))
(define GINEVRA (make-wizard "Ginevra" "Potter" "Horse" GINEVRA-WANDS GINEVRA-CHILDREN))
;; Examples: <DescendantsOfWizard>
(define ARTHUR-CHILDREN (list WILLIAM CHARLES PERCY FRED GEORGE RONALD GINEVRA))

;; Template: <Wizard>
#;
(define (fn-for-wizard w)
  (... (wizard-first-name w)
       (wizard-last-name w)
       (wizard-patronus w)
       (fn-for-low (wizard-wands w))      ; --> Reference to ListOfWand
       (fn-for-dow (wizard-children w)))) ; --> Mutual Reference to DescendantsOfWizard

;; Template: <DescendantsOfWizard>
#;
(define (fn-for-dow dow)
  (cond [(empty? dow) (...)]
        [else (...
               (fn-for-wizard (first dow)) ; --> Mutual Reference to Wizard
               (fn-for-dow (rest dow)))])) ; --> Self-Reference to DescendantsOfWizard


;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; a list of strings

;; Examples: <ListOfString>
(define LOS0 empty)
(define LOS1 (list "Ginevra Potter" "Horse"))

;; Template: <ListOfString>
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))])) ; --> Self-Reference to ListOfString


;; PairList is one of:
;; - empty
;; - (cons ListOfString PairList)
;; interp. list of lists of string
;; ASSUME: length of ListOfString is always 2

;; Examples: <PairList>
(define PL0 empty)
(define PL1 (list (list "William Weasley" "Non-Corporeal")))
(define PL2 (list (list "William Weasley" "Non-Corporeal")
                    (list "Charles Weasley" "Non-Corporeal")
                    (list "Percy Weasley" "Non-Corporeal")
                    (list "Fred Weasley" "Magpie")
                    (list "George Weasley" "Magpie")
                    (list "Ronald Weasley" "Jack Russel terrier")
                    (list "Ginevra Potter" "Horse")))

;; Template: <PairList>
#;
(define (fn-for-pl pl)
  (cond [(empty? pl) (...)]
        [else
         (... (fn-for-los (first pl))   ; --> Reference to ListOfString
              (fn-for-pl (rest pl)))])) ; --> Self-Reference to PairList


;; WandFilter is one of:
;; - Number
;; - String
;; interp. a filter to search for a specific wand length or material
;;         if WandFilter is a number: 0 means the length is unknown
;;         if WandFilter is a string: "" - means the information if not present (unknown)

;; Examples: <WandFilter>
(define UNKNOWN-LENGTH 0)
(define UNKNOWN-MATERIAL "")
(define WF2 12)
(define WF3 "Ash")

;; Template: <WandFilter>
#;
(define (fn-for-wand-filter wf)
  (cond [(number? wf) (... wf)]
        [else (... wf)]))

;PROBLEM 2: 
;
;Define a constant named ARTHUR that represents the descendant family tree for 
;Arthur Weasley. You can find all the infomation you need by starting 
;at: http://harrypotter.wikia.com/wiki/Arthur_Weasley.
;
;You must include all of Arthur's children and these grandchildren: Lily, 
;Victoire, Albus, James.
;
;
;Note that on the Potter wiki you will find a lot of information. But for some 
;people some of the information may be missing. Enter that information with a 
;special value of "" (the empty string) meaning it is not present. Don't forget
;this special value when writing your interp.

(define ARTHUR (make-wizard "Arthur" "Weasley" "Weasel" UNKNOWN-WANDS ARTHUR-CHILDREN))

;PROBLEM 3:
;
;Design a function that produces a pair list (i.e. list of two-element lists)
;of every person in the tree and his or her patronus. For example, assuming 
;that HARRY is a tree representing Harry Potter and that he has no children
;(even though we know he does) the result would be: (list (list "Harry" "Stag")).
;
;You must use ARTHUR as one of your examples.

;; Function Definitions:

;; Wizard -> PairList
;; DescendantsOfWizard -> PairList
;; produce a pair list of every person in the tree, w or dow, and his or her patronus
;; EXAMPLE: I: HARRY -> O: (list (list "Harry" "Stag"))

;; Stubs:
;(define (get-patronus--wizard w) empty)
;(define (get-patronus--dow dow) empty)

;; Tests:
(check-expect (get-patronus--dow DOW0) empty)
(check-expect (get-patronus--wizard VICTOIRE) empty)
(check-expect (get-patronus--dow DOW1) empty)
(check-expect (get-patronus--dow WILLIAM-CHILDREN) empty)
(check-expect (get-patronus--wizard WILLIAM) (list (list "William Weasley" "Non-Corporeal")))
(check-expect (get-patronus--wizard GEORGE) (list (list "George Weasley" "Magpie")))
(check-expect (get-patronus--dow ARTHUR-CHILDREN) PL2)
(check-expect (get-patronus--wizard ARTHUR)
              (cons (list "Arthur Weasley" "Weasel") PL2))

;; Template: get-patronus--wizard
(define (get-patronus--wizard w)
  (if (string=? "" (wizard-patronus w))
      empty
      (cons (list (string-append (wizard-first-name w) " " (wizard-last-name w))
                  (wizard-patronus w)) (get-patronus--dow (wizard-children w)))))

;; Template: <DescendantsOfWizard>
(define (get-patronus--dow dow)
  (cond [(empty? dow) empty]
        [else (if (not (empty? (get-patronus--wizard (first dow))))
                  (append (get-patronus--wizard (first dow))
                        (get-patronus--dow (rest dow)))
                  (get-patronus--dow (rest dow)))]))


;PROBLEM 4:
;
;Design a function that produces the names of every person in a given tree 
;whose wands are made of a given length or material. 
;
;You must use ARTHUR as one of your examples.

;; Wizard WandFilter -> ListOfString
;; DescendantsOfWizard WandFilter -> ListOfString
;; produce the name of every person in a given tree, w or dow, whose wands have
;;         a given length or are made of a given material, wf

;; Stubs:
;(define (filter-wand--wizard w wf) empty)
;(define (filter-wand--dow dow wf) empty)

;; Tests:
(check-expect (filter-wand--dow empty UNKNOWN-LENGTH) empty)
(check-expect (filter-wand--w VICTOIRE UNKNOWN-MATERIAL) empty)
(check-expect (filter-wand--w ALBUS UNKNOWN-MATERIAL) (list "Albus Potter"))
(check-expect (filter-wand--w ALBUS UNKNOWN-LENGTH) (list "Albus Potter"))
(check-expect (filter-wand--w ALBUS "Cherry") (list "Albus Potter"))
(check-expect (filter-wand--w WILLIAM UNKNOWN-LENGTH) (list "William Weasley"))
(check-expect (filter-wand--w CHARLES "Ash") (list "Charles Weasley"))
(check-expect (filter-wand--w RONALD "unicorn tail hair") (list "Ronald Weasley"))
(check-expect (filter-wand--dow GINEVRA-CHILDREN 0) (list "Albus Potter"))
(check-expect (filter-wand--w GINEVRA 0) (list "Ginevra Potter" "Albus Potter"))
(check-expect (filter-wand--w GINEVRA "Yew") (list "Ginevra Potter"))
(check-expect (filter-wand--dow ARTHUR-CHILDREN "")
              (list "William Weasley" "Charles Weasley" "Percy Weasley" "Fred Weasley" "George Weasley"
                    "Ginevra Potter" "Albus Potter"))
(check-expect (filter-wand--w ARTHUR "")
              (list "Arthur Weasley" "William Weasley" "Charles Weasley" "Percy Weasley"
                    "Fred Weasley" "George Weasley" "Ginevra Potter" "Albus Potter"))
(check-expect (filter-wand--dow ARTHUR-CHILDREN 12)
              (list "Charles Weasley" "Ronald Weasley"))
(check-expect (filter-wand--dow ARTHUR-CHILDREN "unicorn tail hair")
              (list "Charles Weasley" "Ronald Weasley"))
(check-expect (filter-wand--w ARTHUR "Chestnut") (list "Ronald Weasley"))

;; Template: <Wizard>
(define (filter-wand--w w wf)
  (if (is-wand-list-filter? (wizard-wands w) wf)
      (cons (string-append (wizard-first-name w) " " (wizard-last-name w))
            (filter-wand--dow (wizard-children w) wf))
       (filter-wand--dow (wizard-children w) wf)))

;; Template: <DescendantsOfWizard>
(define (filter-wand--dow dow wf)
  (cond [(empty? dow) empty]
        [else (append (filter-wand--w (first dow) wf)
               (filter-wand--dow (rest dow) wf))]))


;; ListOfWand WandFilter -> Boolean
;; return true if at least one element of the given list of wands, low, has the given length or
;;        is made of a given material, wf; otherwise return false

;; Stub:
;(define is-wand-list-filter? low wf)

;; Tests:
(check-expect (is-wand-list-filter? NO-WAND "") false)
(check-expect (is-wand-list-filter? UNKNOWN-WANDS 0) true)
(check-expect (is-wand-list-filter? CHARLES-WANDS "Dragon heartstring") false)
(check-expect (is-wand-list-filter? RONALD-WANDS "Chestnut") true)
(check-expect (is-wand-list-filter? RONALD-WANDS 9.25) true)

;; Template: <ListOfWand>
(define (is-wand-list-filter? low wf)
  (cond [(empty? low) false]
        [else
         (or (is-wand-filter? (first low) wf)
             (is-wand-list-filter? (rest low) wf))]))


;; Wand WandFilter -> Boolean
;; given a wand, wand, and a wand filter, wf, return true if the wand has the given length
;;       or is made of a given material, wf; otherwise return false

;; Stub:
;(define is-wand-filter? wand wf)

;; Tests:
(check-expect (is-wand-filter? UNKNOWN-WAND 0) true)
(check-expect (is-wand-filter? CHARLES-WAND 14) false)
(check-expect (is-wand-filter? RONALD-WAND-3 "Willow") false)
(check-expect (is-wand-filter? GINEVRA-WAND "Yew") true)

;; Template: <WandFilter>
(define (is-wand-filter? wand wf)
  (cond [(number? wf) (= (wand-length wand) wf)]
        [else (or (string=? (wand-wood wand) wf) (string=? (wand-core wand) wf))]))