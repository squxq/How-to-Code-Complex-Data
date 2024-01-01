;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname part-02.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


; PROBLEM 2:
;
; In UBC's version of How to Code, there are often more than 800 students taking
; the course in any given semester, meaning there are often over 40 Teaching
; Assistants.
;
; Designing a schedule for them by hand is hard work - luckily we've learned enough
; now to write a program to do it for us!
;
; Below are some data definitions for a simplified version of a TA schedule. There
; are some number of slots that must be filled, each represented by a natural number.
; Each TA is available for some of these slots, and has a maximum number of shifts
; they can work.
;
; Design a search program that consumes a list of TAs and a list of Slots, and
; produces one valid schedule where each Slot is assigned to a TA, and no TA is
; working more than their maximum shifts. If no such schedules exist, produce false.
;
; You should supplement the given check-expects and remember to follow the recipe!

;; ====================== DATA DEFINITIONS ======================

;; Slot is Natural
;; interp. each TA slot has a number, is the same length, and none overlap

;; Examples: <examples for Natural are redundant>

;; Templates:
#; (define (fn-for-slot s)
     (... s))

#; (define (fn-for-los los)
     (cond [(empty? los) (...)]
           [else
            (... (fn-for-los (first los))
                 (fn-for-los (rest los)))]))


(define-struct ta (name max avail))
;; TA is (make-ta String Natural (listof Slot))
;; interp. the TA's name, number of slots they can work, and slots they're
;;         available for

;; Examples:
(define SOBA (make-ta "Soba" 2 (list 1 3)))
(define UDON (make-ta "Udon" 1 (list 3 4)))
(define RAMEN (make-ta "Ramen" 1 (list 2)))

(define NOODLE-TAs (list SOBA UDON RAMEN))

;; Template:
#; (define (fn-for-ta ta)
     (... (ta-name ta)
          (ta-max ta)
          (fn-for-los (ta-avail ta))))


(define-struct assignment (ta slot))
;; Assignment is (make-assignment TA Slot)
;; interp. the TA is assigned to work the slot

;; Examples:
(define A0 (make-assignment SOBA 1))
(define A1 (make-assignment SOBA 3))
(define A2 (make-assignment UDON 4))
(define A3 (make-assignment RAMEN 2))

;; Template:
#; (define (fn-for-assignment a)
     (... (fn-for-ta (assignment-ta a))
          (fn-for-slot (assignment-slot a))))


;; Schedule is (listof Assignment)
;; interp. schedule is a list of assignments

;; Examples:
(define SD0 (list A0))
(define SD1 (list A1 A0))
(define SD2 (list A2 A1 A3 A0))

;; Template:
#; (define (fn-for-schedule sd)
     (cond [(empty? sd) (...)]
           [else
            (... (fn-for-assignment (first sd))
                 (fn-for-schedule (rest sd)))]))


(define-struct ta-count (ta count avail))
;; TA-Count is (make-entry TA Natural (list of ))
;; interp. custom data structure to serve as context-preserving accumulator;
;;         represents a single TA information relative to a certain schedule:
;;         ta-count has a TA, the current max number of slots they can work on,
;;         and the slots they are still available for

;; Examples:
(define TA-COUNT-SOBA-0 (make-ta-count SOBA 2 (list 1 3)))
(define TA-COUNT-SOBA-1 (make-ta-count SOBA 1 (list 3)))
(define TA-COUNT-UDON (make-ta-count UDON 1 (list 3 4)))
(define TA-COUNT-RAMEN (make-ta-count RAMEN 1 (list 2)))

;; Template:
#; (define (fn-for-ta-count ta)
     (... (fn-for-ta (ta-count-ta ta))
          (ta-count-count ta)
          (fn-for-los (ta-count-avail ta))))

#; (define (fn-for-list-ta-count tas)
     (cond [(empty? tas) (...)]
           [else
            (... (fn-for-ta-count (first tas))
                 (fn-for-list-ta-count (rest tas)))]))


(define-struct entry (schedule list-ta-count))
;; Entry is (make-entry Schedule (listof TA-Count))
;; interp. an entry for a result-so-far accumulator with a schedule and
;;         a list of ta-counts to represent the information about the TAs
;;         of the current schedule

;; Examples:
(define ENTRY0 (make-entry
                SD0 (list TA-COUNT-SOBA-1 TA-COUNT-UDON TA-COUNT-RAMEN)))
(define ENTRY1 (make-entry
                SD1 (list TA-COUNT-UDON TA-COUNT-RAMEN)))
(define ENTRY2 (make-entry
                SD2 empty))

;; Template:
#; (define (fn-for-entry e)
     (... (fn-for-schedule (entry-schedule e))
          (fn-for-list-ta-count (entry-list-ta-count e))))


;; ====================== FUNCTION DEFINITIONS ======================

;; (listof TA) (listof Slot) -> Schedule | false
;; produce valid schedule given TAs and Slots; false if impossible

;; Stub:
#; (define (schedule-tas tas slots) empty)

;; Tests:
(check-expect (schedule-tas empty empty) empty)
(check-expect (schedule-tas empty (list 1 2)) false)
(check-expect (schedule-tas (list SOBA) empty) empty)

(check-expect (schedule-tas (list SOBA) (list 1)) SD0)
(check-expect (schedule-tas (list SOBA) (list 2)) false)
(check-expect (schedule-tas (list SOBA) (list 1 3)) SD1)

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4)) SD2)

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4 5)) false)

;; Template: <generative recursion of an arbitrary arity tree
;;            and backtracking search + result-so-far accumulator>
(define (schedule-tas tas slots)
  ;; loe is (listof Entry)
  ;; INVARIANT: result-so-far accumulator; schedules and their list of
  ;;            TAs seen so far
  
  (local [;; Schedule (listof TA-Count) (listof Slot) -> Schedule | false
          ;; same purpose as main function

          ;; Stub:
          #; (define (fn-for--schedule sd ta-counts))

          ;; Template: <generative recursion>
          (define (fn-for--schedule sd ta-counts los)
            (if (empty? los)
                sd
                (fn-for--loe (next-entries sd (first los) ta-counts)
                             (rest los))))


          ;; (listof Entry) (listof Slot) -> Schedule | false
          ;; same purpose as main function

          ;; Stub:
          #; (define (fn-for--loe loe los))

          ;; Template: <backtracking search and (listof Entry)>
          (define (fn-for--loe loe los)
            (cond [(empty? loe) false]
                  [else
                   (local [(define e (first loe))
                           (define try (fn-for--schedule
                                        (entry-schedule e)
                                        (entry-list-ta-count e) los))]
                     
                     (if (not (false? try))
                         try
                         (fn-for--loe (rest loe)
                                                los)))]))]

    (fn-for--schedule empty (create-ta-counts tas) slots)))


;; (listof TA) -> (listof TA-Count)
;; produce the initial value of the field list-ta-count of every entry
;; of the result-so-far accumulator for the previous function with given
;; list of TAs, tas

;; Stub:
#; (define (create-ta-counts tas) empty)

;; Tests:
(check-expect (create-ta-counts empty) empty)
(check-expect (create-ta-counts (list SOBA))
              (list (make-ta-count SOBA 2 (list 1 3))))
(check-expect (create-ta-counts NOODLE-TAs)
              (list (make-ta-count SOBA 2 (list 1 3))
                    (make-ta-count UDON 1 (list 3 4))
                    (make-ta-count RAMEN 1 (list 2))))

;; Template: <(listof TA) + result-so-far accumulator>
(define (create-ta-counts tas0)
  ;; ta-counts is (listof TA-Count)
  ;; INVARIANT: result-so-far accumulator; list of ta-count elements created so far
            
  (local [;; (listof TA) (listof TA-Count) -> (listof TA-Count)
          ;; same purpose as the main function

          ;; Stub:
          #; (define (create-ta-counts tas ta-counts) empty)

          ;; Template: <(listof TA) + result-so-far accumulator>
          (define (create-ta-counts tas ta-counts)
            (cond [(empty? tas) ta-counts]
                  [else
                   (create-ta-counts
                    (rest tas)
                    (append
                     ta-counts
                     (list (make-ta-count (first tas) (ta-max (first tas))
                                          (ta-avail (first tas))))))]))]
              
    (create-ta-counts tas0 empty)))


;; Schedule Slot (listof TA-Count) -> (listof Entry)
;; produce a list of all possible and valid schedules and their resulting list of TAs
;; given the starter schedule, sd, the slot to fill, s, and the information about the
;; TAs at this current point, like the number of schedules and schedules themselves
;; they have left to fill and, ta-counts

;; Stub:
#; (define (next-entries sd s ta-counts) empty)

;; Tests:
(check-expect (next-entries empty 2 empty) empty)
(check-expect (next-entries empty 2 (list (make-ta-count SOBA 2 (list 1 3)))) empty)
(check-expect (next-entries empty 2 (list (make-ta-count RAMEN 1 (list 2))))
              (list (make-entry (cons (make-assignment RAMEN 2) empty) empty)))
(check-expect (next-entries empty 1 (create-ta-counts NOODLE-TAs))
              (list (make-entry (cons (make-assignment SOBA 1) empty)
                                (list (make-ta-count SOBA 1 (list 3))
                                      (make-ta-count UDON 1 (list 3 4))
                                      (make-ta-count RAMEN 1 (list 2))))))
(check-expect (next-entries (list A0) 2
                            (list (make-ta-count SOBA 1 (list 3))
                                  (make-ta-count UDON 1 (list 3 4))
                                  (make-ta-count RAMEN 1 (list 2))))
              (list (make-entry (cons (make-assignment RAMEN 2) (list A0))
                                (list (make-ta-count SOBA 1 (list 3))
                                      (make-ta-count UDON 1 (list 3 4))))))
(check-expect (next-entries (list A0 A3) 3
                            (list (make-ta-count SOBA 1 (list 3))
                                  (make-ta-count UDON 1 (list 3 4))))
              (list (make-entry (cons (make-assignment SOBA 3) (list A0 A3))
                                (list (make-ta-count UDON 1 (list 3 4))))
                    (make-entry (cons (make-assignment UDON 3) (list A0 A3))
                                (list (make-ta-count SOBA 1 (list 3))))))

;; Template: <encapsulation with local and
;;            context-preserving + result-so-far accumualators>
(define (next-entries sd s ta-counts)
  ;; loe is (listof Entry)
  ;; INVARIANT: result-so-far accumulator; all valid schedules, and their
  ;;            respective TAs information, visted so far

  ;; seen-tas is (listof TA-Count)
  ;; INVARIANT: context-preserving accumulator; already visited TA
  ;;            information about the schedule, sd
  
  (local [;; (listof TA-Count) (listof Entry) (listof TA-Count) -> (listof Entry)
          ;; same purpose as the main function

          ;; Stub:
          #; (define (fn-for--ta-counts ta-counts loe seen-tas) empty)

          ;; Template: <(listof TA-Count) + result-so-far accumulator
          ;;            + context-preserving accumulator>
          (define (fn-for--ta-counts ta-counts loe seen-tas)
            (cond [(empty? ta-counts) loe]
                  [else
                   (fn-for--ta-counts
                    (rest tas)
                    (fn-for--ta-count (first ta-counts) loe seen-tas (rest ta-counts))
                    (append seen-tas (list (first ta-counts))))]))
          

          ;; TA-Count (listof Entry)
          ;;          (listof TA-COUNT) (listof TA-COUNT) -> (listof Entry)
          ;; same purpose as the main function

          ;; Stub:
          #; (define (fn-for--ta-count ta-count loe
                                       seen-ta-counts rest-ta-counts) empty)

          ;; Template: <(listof Slot) + context-preservinga accumulator>
          (define (fn-for--ta-count ta-count loe seen-ta-counts rest-ta-counts)
            ;; slots is (listof Slot)
            ;; INVARIANT: context-preserving accumulator; all slots seen so far
            ;;            that are not equal to given slot s
            
            (local [;; (listof Slot) (listof Slot) -> (listof Entry)
                    ;; same purpose as its parent function

                    ;; Stub:
                    #; (define (traverse-avail los slots) empty)

                    ;; Template: <(listof Slot) + context-preserving accumulator>
                    (define (traverse-avail los slots)
                      (cond [(empty? los) loe]
                            [(= s (first los))
                             (append
                              loe
                              (list
                               (make-entry
                                (cons (make-assignment (ta-count-ta ta-count) s) sd)
                                (update-ta-counts ta-count (append slots (rest los))
                                                  seen-ta-counts rest-ta-counts))))]
                            [else (traverse-avail
                                   (rest los) (cons (first los) slots))]))]

              (traverse-avail (ta-count-avail ta-count) empty)))


          ;; TA-Count (listof Slot)
          ;;          (listof TA-Count) (listof TA-Count) -> (listof TA-Count)
          ;; same purpose as the parent function

          ;; Stub:
          #; (define (update-ta-counts ta-count avail
                                       seen-ta-counts rest-ta-counts) empty)

          ;; Template: <TA-Count>
          (define (update-ta-counts ta-count avail seen-ta-counts rest-ta-counts)
            (append
             seen-tas (if (= (ta-count-count ta) 1) empty
                          (list (make-ta-count (ta-count-ta ta)
                                               (sub1 (ta-count-count ta))
                                               avail))) rest-tas))]

    (fn-for--ta-counts ta-counts empty empty)))