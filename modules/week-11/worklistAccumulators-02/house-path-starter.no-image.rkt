;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname house-path-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; house-path-starter.rkt

;Consider the following house diagram:
;
;(open image file)
;
;Starting from the porch, there are many paths through the house that you can
;follow without retracing your steps.  If we represent these paths as lists:
;(list 
; (list "Porch")
; (list "Porch" "Living Room")
; (list "Porch" "Living Room" "Hall")
; ...)
;
;you can see that a lot of these paths start with the same sequence of rooms.
;We can represent these paths, and capture their shared initial parts, by using
;a tree:
;(open image file)
;
;The following data definition does exactly this.

;; =================
;; Data Definitions:

(define-struct path (room nexts))
;; Path is (make-path String (listof Path))
;; interp. An arbitrary-arity tree of paths.
;;  - (make-path room nexts) represents all the paths downward from room

;; Examples:
(define P0 (make-path "A" empty)) ; a room from which there are no paths
(define PH
  (make-path
   "Porch" (list (make-path
                  "Living Room"
                  (list (make-path
                         "Dining Room"
                         (list (make-path
                                "Kitchen"
                                (list (make-path
                                       "Hall"
                                       (list (make-path "Study" (list))
                                             (make-path "Bedroom" (list))
                                             (make-path "Bathroom" (list))))))))
                        (make-path
                         "Hall"
                         (list (make-path
                                "Kitchen"
                                (list (make-path "Dining Room" (list))))
                               (make-path "Study" (list))
                               (make-path "Bedroom" (list))
                               (make-path "Bathroom" (list)))))))))

;; Template:   
#; (define (fn-for-path p)
     (local [(define (fn-for-path p)
               (... (path-room p)
                    (fn-for-lop (path-nexts p))))
             (define (fn-for-lop lop)
               (cond [(empty? lop) (...)]
                     [else
                      (... (fn-for-path (first lop))
                           (fn-for-lop (rest lop)))]))]
       (fn-for-path p)))


;The problems below also make use of the following data definition and function:

;; Result is one of:
;; - Boolean
;; - "never"
;; interp. three possible answers to a question

;; Examples:
(define R0 true)
(define R1 false)
(define R2 "never")

;; Template:
#; (define (fn-for-result r)
     (cond 
       [(boolean? r) (... r)]
       [else (...)]))


;; =====================
;; Function Definitions:

;; Result Result -> Result
;; produce the logical combination of two results

;; Stub:
#; (define (and-result r0 r1) false)

;Cross Product of Types Table:
;
; ╔════════════════╦═══════════════╦══════════════╗
; ║                ║               ║              ║
; ║            r0  ║   Boolean     ║   "never"    ║
; ║                ║               ║              ║
; ║    r1          ║               ║              ║
; ╠════════════════╬═══════════════╬══════════════╣
; ║                ║               ║              ║
; ║   Boolean      ║ (and r0 r1)   ║              ║
; ║                ║               ║              ║
; ╠════════════════╬═══════════════╣  r1          ║
; ║                ║               ║              ║
; ║   "never"      ║  r0           ║              ║
; ║                ║               ║              ║
; ╚════════════════╩═══════════════╩══════════════╝

;; Tests:
(check-expect (and-result false false) false)
(check-expect (and-result false true) false)
(check-expect (and-result false "never") false)
(check-expect (and-result true false) false)
(check-expect (and-result true true) true)
(check-expect (and-result true "never") true)
(check-expect (and-result "never" true) true)
(check-expect (and-result "never" false) false)
(check-expect (and-result "never" "never") "never")

;; Template: <used template from Result>
(define (and-result r0 r1)
  (cond [(and (boolean? r0) (boolean? r1)) (and r0 r1)]
        [(string? r0) r1]
        [else r0]))


;PROBLEM 1:   
;
;Design a function called always-before that takes a path tree p and two room
;names b and c, and determines whether starting from p:
;1) you must pass through room b to get to room c (produce true),
;2) you can get to room c without passing through room b (produce false), or
;3) you just can't get to room c (produce "never").
;
;Note that if b and c are the same room, you should produce false since you don't
;need to pass through the room to get there.
 
;; Path String String -> Result
;; given a path tree, p, and two rooms, b and c, respectively, starting from p:
;; - we must pass through room b to get given room c: produce true
;; - we can get to room c without passing through room b: produce false
;; - we can't get to room c: produce "never"
;; NOTE: if b and c are the same room, produce false

;; Stub:
#; (define (always-before p b c) false)

;; Tests:
(check-expect (always-before P0 "A" "B") "never")
(check-expect (always-before P0 "B" "A") false)
(check-expect (always-before PH "Hall" "Study") true)
(check-expect (always-before PH "Kitchen" "Dining Room") false)
(check-expect (always-before PH "Bedroom" "Basement") "never")

;; Template: <used template from Path and for context-preserving accumulator>
(define (always-before p0 b c)
  ;; seenB is Boolean
  ;; INVARIANT: true if any parent node of (first lop) is b
  
  (local [(define (fn-for-path p seenB)
            (if (string=? (path-room p) c)
                seenB
                (fn-for-lop (path-nexts p) (string=? (path-room p) b))))
          
          (define (fn-for-lop lop seenB)
            (cond [(empty? lop) "never"]
                  [else
                   (and-result (fn-for-path (first lop) seenB)
                               (fn-for-lop (rest lop) seenB))]))]

    (fn-for-path p0 false)))


;OPTIONAL EXTRA PRACTICE PROBLEM:
;
;Once you have always-before working, make a copy of it, rename the copy to
;always-before-tr, and then modify the function to be tail recursive.

;; same signature as previous version
;; same purpose as previous version

;; Stub:
#; (define (always-before-tr p b c) false)

;; Tests:
(check-expect (always-before-tr P0 "A" "B") "never")
(check-expect (always-before-tr P0 "B" "A") false)
(check-expect (always-before-tr PH "Hall" "Study") true)
(check-expect (always-before-tr PH "Kitchen" "Dining Room") false)
(check-expect (always-before-tr PH "Bedroom" "Basement") "never")

;; Template: <used template from Path, for context-preserving accumulator
;;            and for worklist accumulator>
(define (always-before-tr p0 b c)
  ;; todo is (listof WLE)
  ;; INVARIANT: a worklist accumulator

  ;; result is Result
  ;; INVARIANT: a result-so-far accumulator
  
  (local [(define-struct wle (path seenB))
          ;; WLE (worklist entry) is (make-wle Path Boolean)
          ;; interp. a worklist entry with the Path to pass to fn-for-path
          ;;         and a boolean that tells whether before visiting current
          ;;         path we have visited b

          (define (fn-for-path p seenB todo result)
            (local [(define new-seenB (or seenB (string=? (path-room p) b)))]
              (if (string=? (path-room p) c)
                  (fn-for-todo todo (and-result seenB result))
                  (fn-for-todo (append (map (λ (n) (make-wle n new-seenB))
                                            (path-nexts p)) todo) result))))
          
          (define (fn-for-todo todo result)
            (cond [(empty? todo) result]
                  [else
                   (fn-for-path (wle-path (first todo))
                                (wle-seenB (first todo))
                                (rest todo)
                                result)]))]

    (fn-for-path p0 false empty "never")))
