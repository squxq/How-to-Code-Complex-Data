;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-from-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-from-starter.rkt

;PROBLEM:
;
;Using the following data definition, design a function that produces the room with
;the most exits (in the case of a tie you can produce any of the rooms in the tie).

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
;; produce the reachable room from given room, r, with the most exits
;; ASSUME: in case of a tie, produce the first room that was found

;; Stub:
#; (define (max-exits-from r) (make-room "A" empty))

;; Tests:
(check-expect (max-exits-from H1)
              (make-room "A" (list (make-room "B" empty))))
(check-expect (max-exits-from H2) (shared [(-A- (make-room "A" (list -B-)))
                                           (-B- (make-room "B" (list -A-)))]
                                    -A-))
(check-expect (max-exits-from H3) (shared [(-A- (make-room "A" (list -B-)))
                                           (-B- (make-room "B" (list -C-)))
                                           (-C- (make-room "C" (list -A-)))]
                                    -A-))
(check-expect (max-exits-from H4) (shared [(-A- (make-room "A" (list -B- -D-)))
                                           (-B- (make-room "B" (list -C- -E-)))
                                           (-C- (make-room "C" (list -B-)))
                                           (-D- (make-room "D" (list -E-)))
                                           (-E- (make-room "E" (list -F- -A-)))
                                           (-F- (make-room "F" empty))]
                                    -A-))
(check-expect (max-exits-from H4F) (make-room "F" empty))

;; Template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited
(define (max-exits-from r0)
  ;; todo is (listof Room)
  ;; INVARIANT: a worklist accumulator
  
  ;; visited is (listof String)
  ;; INVARIANT: context preserving accumulator, names of rooms already visited

  ;; max-exits is Room
  ;; INVARIANT: result-so-far accumulator, room with the most amount of exists
  ;;            that has been visited in r0
  
  (local [(define (fn-for-room r todo visited max-exits) 
            (local [(define new-exits
                      (if (> (length (room-exits r))
                             (length (room-exits max-exits)))
                          r
                          max-exits))]
              (if (member (room-name r) visited)
                  (fn-for-lor todo visited new-exits)
                  (fn-for-lor (append (room-exits r) todo)
                              (cons (room-name r) visited)
                              new-exits))))
          (define (fn-for-lor todo visited max-exits)
            (cond [(empty? todo) max-exits]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited
                                max-exits)]))]
    (fn-for-lor (room-exits r0)
                (cons (room-name r0) empty)
                r0)))