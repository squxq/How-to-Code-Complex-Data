;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname reachable?--problem.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; graphs-v2.rkt

;PROBLEM: 
;
;Imagine you are suddenly transported into a mysterious house, in which all
;you can see is the name of the room you are in, and any doors that lead OUT
;of the room.  One of the things that makes the house so mysterious is that
;the doors only go in one direction. You can't see the doors that lead into
;the room.
;
;Here are some examples of such a house:
;
;(open image file)
;(open image file)
;(open image file)
;(open image file)
;
;In computer science, we refer to such an information structure as a directed
;graph. Like trees, in directed graphs the arrows have direction. But in a
;graph it is  possible to go in circles, as in the second example above. It
;is also possible for two arrows to lead into a single node, as in the fourth
;example.
;
;   
;Design a data definition to represent such houses. Also provide example data
;for the four houses above.

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

;; Examples:
; (open image file)
(define H1 (make-room "A" (list (make-room "B" empty))))

; (open image file)
(define H2 (shared [(-0- (make-room
                          "A" (list (make-room
                                     "B" (list -0-)))))] -0-))

; (open image file)
#; (define H3 (shared [(-0- (make-room
                           "A" (list (make-room
                                      "B" (list (make-room
                                                 "C" (list -0-)))))))] -0-))

(define H3 (shared [(-A- (make-room "A" (list -B-)))
                    (-B- (make-room "B" (list -C-)))
                    (-C- (make-room "C" (list -A-)))]
             -A-))

; (open image file)
(define H4 (shared [(-A- (make-room "A" (list -B- -D-)))
                    (-B- (make-room "B" (list -C- -E-)))
                    (-C- (make-room "C" (list -B-)))
                    (-D- (make-room "D" (list -E-)))
                    (-E- (make-room "E" (list -F- -A-)))
                    (-F- (make-room "F" empty))]
             -A-))

(define H4F (shared [(-A- (make-room "A" (list -B- -D-)))
                     (-B- (make-room "B" (list -C- -E-)))
                     (-C- (make-room "C" (list -B-)))
                     (-D- (make-room "D" (list -E-)))
                     (-E- (make-room "E" (list -F- -A-)))
                     (-F- (make-room "F" empty))]
              -F-))

;; Template: <structural recursion, encapsulate with local,
;;            tail recursive with worklist, context-preserving accumulator
;;            what rooms have we already visited>
#; (define (fn-for-house r0)
     ;; todo is (listof Room)
     ;; INVARIANT: worklist accumulator

     ;; visited is (listof String)
     ;; INVARIANT: context-preserving accumulator, names of rooms already visited
     ;; ASSUME: room names are unique
  
     (local [(define (fn-for-room r todo visited)
               (if (member (room-name r) visited)
                   (fn-for-lor todo visited)
                   (fn-for-lor (append (room-exits r) todo)
                               (cons (room-name r) visited)))) ; (... (room-name r))
          
             (define (fn-for-lor todo visited)
               (cond [(empty? todo) (...)]
                     [else
                      (fn-for-room (first todo)
                                   (rest todo)
                                   visited)]))]
       (fn-for-room r0 empty empty)))


; PROBLEM:
;
; Design a function that consumes a Room and a room name, and produces true if
; it is possible to each a room with the given name starting at the given root.
; For example :
;
;   (reachable? H1 "A") produces true
;   (reachable? H1 "B") produces true
;   (reachable? H1 "C") produces false
;   (reachable? H4 "F") produces true
;
; But note that if you defined H4F to be the room named F in the H4 house than
; (reachable? H4F "A") would produce false because it is not possible to get to
; A from F in that house.

;; =====================
;; Function Definitions:

;; Room String -> Boolean
;; produce true if starting at r0 it is possible to reach a room named rn

;; Stub:
#; (define (reachable? r0 rn) false)

;; Tests:
(check-expect (reachable? H1 "A") true)
(check-expect (reachable? H1 "B") true)
(check-expect (reachable? H1 "C") false)
(check-expect (reachable? (first (room-exits H1)) "A") false)
(check-expect (reachable? H4 "F") true)
(check-expect (reachable? H4F "A") false)

;; Template: <structural recursion, encapsulate with local,
;;            tail recursive with worklist, context-preserving accumulator
;;            what rooms have we already visited>
(define (reachable? r0 rn)
  ;; todo is (listof Room)
  ;; INVARIANT: worklist accumulator

  ;; visited is (listof String)
  ;; INVARIANT: context-preserving accumulator, names of rooms already visited
  ;; ASSUME: room names are unique
  
  (local [(define (fn-for-room r todo visited)
            (cond [(string=? (room-name r) rn) true]
                  [(member (room-name r) visited)
                   (fn-for-lor todo visited)]
                  [else 
                   (fn-for-lor (append (room-exits r) todo)
                               (cons (room-name r) visited))]))
          
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) false]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited)]))]
    (fn-for-room r0 empty empty)))

