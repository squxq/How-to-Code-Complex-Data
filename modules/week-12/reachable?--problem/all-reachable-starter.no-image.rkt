;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname all-reachable-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; all-reachable-starter.rkt

;PROBLEM:
;
;Using the following data definition:
;
;a) Design a function that consumes a room and produces a list of the names of
;   all the rooms reachable from that room.
;
;b) Revise your function from (a) so that it produces a list of the rooms
;   not the room names

;; =================
;; Data Definitions: 

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

;; Examples:
; (open image file) 
(define H1 (make-room "A" (list (make-room "B" empty))))

; (open image file)
(define H2 
  (shared ((-0- (make-room "A" (list (make-room "B" (list -0-))))))
    -0-)) 

; (open image file)
(define H3
  (shared ((-A- (make-room "A" (list -B-)))
           (-B- (make-room "B" (list -C-)))
           (-C- (make-room "C" (list -A-))))
    -A-))
           
; (open image file)
(define H4
  (shared ((-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -A-)))
           (-F- (make-room "F" (list))))
    -A-))

(define H4F (shared [(-A- (make-room "A" (list -B- -D-)))
                     (-B- (make-room "B" (list -C- -E-)))
                     (-C- (make-room "C" (list -B-)))
                     (-D- (make-room "D" (list -E-)))
                     (-E- (make-room "E" (list -F- -A-)))
                     (-F- (make-room "F" empty))]
              -F-))

;; Template: structural recursion, encapsulate w/ local, 
;;           context-preserving accumulator what rooms traversed on this path
#;
(define (fn-for-house r0)
  ;; path is (listof String); context preserving accumulator, names of rooms
  (local [(define (fn-for-room r  path) 
            (if (member (room-name r) path)
                (... path)
                (fn-for-lor (room-exits r) 
                            (cons (room-name r) path)))) 
          (define (fn-for-lor lor path)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-room (first lor) path)
                        (fn-for-lor (rest lor) path))]))]
    (fn-for-room r0 empty)))

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
#;
(define (fn-for-house r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
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


;; =====================
;; Function Definitions:

;; Room -> (listof String)
;; produce a list of the names of all the rooms reachable from the given room, r

;; Stub:
#; (define (reachable-names r) empty)

;; Tests:
(check-expect (reachable-names H1) (list "A" "B"))
(check-expect (reachable-names H2) (list "A" "B"))
(check-expect (reachable-names H3) (list "A" "B" "C"))
(check-expect (reachable-names H4) (list "A" "B" "C" "E" "F" "D"))
(check-expect (reachable-names H4F) (list "F"))

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
(define (reachable-names r0)
  ;; todo is (listof Room)
  ;; INVARIANT: a worklist accumulator

  ;; visited is (listof String)
  ;; INVARIANT: context preserving accumulator, names of rooms already visited
  ;; ASSUME: room names are unique
  
  (local [(define (fn-for-room r todo visited) 
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (append visited (list (room-name r))))))
          
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) visited]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited)]))]
    
    (fn-for-room r0 empty empty)))


;; Room -> (listof Room)
;; produce a list of all the rooms reachable from the given room, r

;; Stub:
#; (define (reachable-rooms r) empty)

;; Tests:
(check-expect (reachable-rooms H1) (shared [(-A- (make-room "A" (list -B-)))
                                            (-B- (make-room "B" empty))]
                                     (list -A- -B-)))
(check-expect (reachable-rooms H2) (shared [(-A- (make-room "A" (list -B-)))
                                            (-B- (make-room "B" (list -A-)))]
                                     (list -A- -B-)))
(check-expect (reachable-rooms H3) (shared [(-A- (make-room "A" (list -B-)))
                                            (-B- (make-room "B" (list -C-)))
                                            (-C- (make-room "C" (list -A-)))]
                                     (list -A- -B- -C-)))
(check-expect (reachable-rooms H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                            (-B- (make-room "B" (list -C- -E-)))
                                            (-C- (make-room "C" (list -B-)))
                                            (-D- (make-room "D" (list -E-)))
                                            (-E- (make-room "E" (list -F- -A-)))
                                            (-F- (make-room "F" empty))]
                                     (list -A- -B- -C- -E- -F- -D-)))
(check-expect (reachable-rooms H4F) (list (make-room "F" empty)))

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
(define (reachable-rooms r0)
  ;; todo is (listof Room)
  ;; INVARIANT: a worklist accumulator

  ;; visited is (listof Room)
  ;; INVARIANT: context preserving accumulator, rooms already visited
  ;; ASSUME: room names are unique
  
  (local [(define (fn-for-room r todo visited) 
            (if (includes-room? (room-name r) visited) ; or using an ormap
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (append visited (list r)))))
          
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) visited]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited)]))

          
          ;; String (listof Room) -> Boolean
          ;; produce true if given room name, rn, is in one of the top level rooms
          ;; in given list of rooms, lor

          ;; Stub:
          #; (define (includes-room? rn lor) false)

          ;; Template: <ormap>
          (define (includes-room? rn lor)
            (cond [(empty? lor) false]
                  [else
                   (or (string=? (room-name (first lor)) rn)
                       (includes-room? rn (rest lor)))]))]
    
    (fn-for-room r0 empty empty)))