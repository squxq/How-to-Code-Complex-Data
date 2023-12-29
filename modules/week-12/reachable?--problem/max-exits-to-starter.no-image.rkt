;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-to-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-to-starter.rkt

;PROBLEM:
;
;Using the following data definition, design a function that produces 
;the room to which the greatest number of other rooms have exits
;(in the case of a tie you can produce any of the rooms in the tie).

;; =================
;; Data Definitions: 

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

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

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited

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

;; Room -> Room
;; produce the reachable room from given room, r, to which the greatest
;; number of other rooms have exits

;; Stub:
#; (define (max-exits-to r) r)

;; Tests:
(check-expect (max-exits-to H1) (make-room "B" empty))
(check-expect (max-exits-to H2) (shared [(-A- (make-room "A" (list -B-)))
                                         (-B- (make-room "B" (list -A-)))]
                                  -A-))
(check-expect (max-exits-to H3) (shared [(-A- (make-room "A" (list -B-)))
                                         (-B- (make-room "B" (list -C-)))
                                         (-C- (make-room "C" (list -A-)))]
                                  -A-))
(check-expect (max-exits-to H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                         (-B- (make-room "B" (list -C- -E-)))
                                         (-C- (make-room "C" (list -B-)))
                                         (-D- (make-room "D" (list -E-)))
                                         (-E- (make-room "E" (list -F- -A-)))
                                         (-F- (make-room "F" empty))]
                                  -B-))
(check-expect (max-exits-to H4F) (make-room "F" empty))

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
(define (max-exits-to r0)
  ;; todo is (listof Room)
  ;; INVARIANT: a worklist accumulator

  ;; visited is (listof String)
  ;; INVARIANT: context preserving accumulator, names of rooms already visited

  ;; exits-to is (listof RSFE)
  ;; INVARIANT: result-so-far accumulator; rooms that have been metioned as
  ;;            exits by other rooms, and the number of times that happened
  ;; NOTE: r0 is the only node, that when visiting for the first time, doesn't
  ;;       count as exit for another room
  
  (local [(define-struct rsfe (count room))
          ;; RSFE (result-so-far accumulator entry) is (make-rsfe Natural Room)
          ;; interp. a result-so-far accumulator entry with a room and number of
          ;;         times that room has been referenced as exit of another room
          ;;         NOTE: count can only be greater than or equal to 0

          (define (fn-for-room r todo visited exits-to) 
            (if (member (room-name r) visited)
                (fn-for-lor todo visited (update-rsfe (room-name r) exits-to))
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (append exits-to (list (make-rsfe 1 r))))))
          
          (define (fn-for-lor todo visited exits-to)
            (cond [(empty? todo) (max-count exits-to)]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited
                                exits-to)]))


          ;; String (listof RSFE) -> (listof RSFE)
          ;; update an entry's count of given list of rsfe entries, exits-to,
          ;; with the room named rn, for a given room name
          ;; ASSUME: - room with name rn exits
          ;;         - there is at least one entry in exits-to

          ;; Stub:
          #; (define (update-rsfe rn exits-to) empty)
          
          ;; Template: <list>
          (define (update-rsfe rn exits-to)
            (local [(define r (rsfe-room (first exits-to)))]
              (cond [(string=? (room-name r) rn)
                     (cons (make-rsfe (add1 (rsfe-count (first exits-to))) r)
                           (rest exits-to))]
                    [else
                     (cons (first exits-to)
                           (update-rsfe rn (rest exits-to)))])))


          ;; (listof RSFE) -> Room
          ;; produce the room of all entries in given list of rsfe entries, exits-to,
          ;; that has the most count - times referenced as an exit to other rooms
          ;; NOTE: in case of a tie produce the first one
          ;; ASSUME: there is at least one entry in exits-to

          ;; Stub:
          #; (define (max-count exits-to) (make-room "A" empty))

          ;; Template: <list>
          (define (max-count exits-to0)
            ;; rsf is Natural
            ;; INVARIANT: result-so-far accumulator; the visited entry of exits-to0
            ;;            with the highest count value
            
            (local [(define (max-count exits-to rsf)
                      (cond [(empty? exits-to) (rsfe-room rsf)]
                            [else
                             (if (> (rsfe-count (first exits-to))
                                    (rsfe-count rsf))
                                 (max-count (rest exits-to) (first exits-to))
                                 (max-count (rest exits-to) rsf))]))]
              (max-count (rest exits-to0) (first exits-to0))))]
    
    (fn-for-lor (room-exits r0)
                (cons (room-name r0) empty)
                (cons (make-rsfe 0 r0) empty))))