;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname triangle-solitaire-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; triangle-solitaire-starter.rkt

;PROBLEM:
;
;The game of triangular peg solitaire is described at a number of web sites,
;including http://www.mathsisfun.com/games/triangle-peg-solitaire/#. 
;
;We would like you to design a program to solve triangular peg solitaire
;boards. Your program should include a function called solve that consumes
;a board and produces a solution for it, or false if the board is not
;solvable. Read the rest of this problem box VERY CAREFULLY, it contains
;both hints and additional constraints on your solution.
;
;The key elements of the game are:
;
;  - there is a BOARD with 15 cells, each of which can either
;    be empty or contain a peg (empty or full).
;    
;  - a potential JUMP whenever there are 3 holes in a row
;  
;  - a VALID JUMP  whenever from and over positions contain
;    a peg (are full) and the to position is empty
;    
;  - the game starts with a board that has a single empty
;    position
;    
;  - the game ends when there is only one peg left - a single
;    full cell                                                       
;    
;Here is one sample sequence of play, in which the player miraculously does
;not make a single incorrect move. (A move they have to backtrack from.) No
;one is actually that lucky!
;
;
;(open image file)
;(open image file)
;(open image file)

;; Brute force Triangular Peg Solitaire

;; In this game, the board has 15 cells, which
;; can be empty or contain a peg. A jump can be
;; performed if there are 3 holes in a row, but
;; it is only valid whenever "from" and "over"
;; positions contain a peg and the "to" position
;; is empty.

;; The game starts with a board that has single
;; empty position and ends when there is only 1
;; peg left.

;; =================
;; Data Definitions:

;; Cell is Boolean
;; interp. a cell is a single space in the board (defined below)
;;         which can be empty, represented with false, or it
;;         can contain a peg, represented with true. To a cell
;;         it is attributed a position (defined below).

;; Template:
#; (define (fn-for-cell c)
     (... c))


;; Board is (listof Cell)
;; interp. visually a board is a 15 cell equilateral triangle.
;;         But we represent it as a single flat list in which
;;         the rows are layed out one after the other in a
;;         linear fashion. This list has length 15.

;; Template:
#; (define (fn-for-board b)
     (cond [(empty? b) (...)]
           [else
            (... (fn-for-cell (first b))
                 (fn-for-board (rest b)))]))


;; Position is Natural[0, 14]
;; interp. the position of a cell in the board, which is
;;         0-indexed. The distribution of positions per row
;;         of the given triangular board is as follows:
;;          - row 0: positions = (list 0)
;;          - row 1: positions = (list 1 2)
;;          - row 2: positions = (list 3 4 5)
;;          - row 3: positions = (list 6 7 8 9)
;;          - row 4: positions = (list 10 11 12 13 14)

;; Template:
#; (define (fn-for-position p)
     (... p))


(define-struct jump (from over))
;; Jump is (make-jump Position Position)
;; interp. a potential jump, which happens whenever there
;;         are three cells in a row. This means diagonal
;;         moves are not possible.
;;          - from is the jump's origin position
;;          - over is the cell's position that is jumped over

;; Template:
#; (define (fn-for-jump j)
     (... (jump-from j)
          (jump-over j)))


(define-struct possible-jumps (to loj))
;; PossibleJumps is (make-possible-jumps Position (listof Jump))
;; interp. a list of possible jumps, loj, which all have the same
;;         destination, to

;; Template: <(listof Jump)>
#; (define (fn-for-loj loj)
     (cond [(empty? loj) (...)]
           [else
            (... (fn-for-jump (first loj))
                 (fn-for-loj (rest loj)))]))

;; Template: <PossibleJumps>
#; (define (fn-for-possible-jumps pj)
     (... (possible-jumps-to pj)
          (fn-for-loj (possible-jumps-loj pj))))


;; =====================
;; Constant Definitions:

;; List of Positions:
(define POSITIONS (build-list 15 identity))

;; Rows:
(define ROWS (list (list 0)
                   (list 1 2)
                   (list 3 4 5)
                   (list 6 7 8 9)
                   (list 10 11 12 13 14)))


;; BOARDS:

;; Board 1:
(define BOARD-1 (cons false (build-list 14 (λ (n) true))))

;; Board 2:
(define BOARD-2 (cons true (cons false (build-list 13 (λ (n) true)))))

;; Board 3:
(define BOARD-3 (append (build-list 4 (λ (n) true)) (list false)
                        (build-list 10 (λ (n) true))))

;; Board 4:
(define BOARD-4 (append (build-list 3 (λ (n) true)) (list false)
                        (build-list 11 (λ (n) true))))

;; Solved Board-1:
(define BOARD-1s (list #false #false #false #false #false #false #false
                       #false #false #false #false #false #true #false #false))

;; Solved Board-2:
(define BOARD-2s (list #false #false #false #false #false #true #false
                       #false #false #false #false #false #false #false #false))

;; Solved Board-3:
(define BOARD-3s (list #false #false #false #false #false #false #false
                       #false #false #false #false #false #true #false #false))

;; Solved Board-4s:
(define BOARD-4s (list #false #false #false #true #false #false #false
                       #false #false #false #false #false #false #false #false))

;; Test Board:
(define TEST-BOARD (append (list false false) (build-list 13 (λ (n) true))))

;BOARD-1
;BOARD-2
;BOARD-3
;BOARD-4
;BOARD-1s
;BOARD-2s
;BOARD-3s
;BOARD-4s


;; JUMPS:

;; Possible jumps with destination in index 0:
(define JUMPS-0 (make-possible-jumps 0 (list (make-jump 3 1) (make-jump 5 2))))

;; Possible jumps with destination in index 1:
(define JUMPS-1 (make-possible-jumps 1 (list (make-jump 6 3) (make-jump 8 4))))

;; Possible jumps with destination in index 2:
(define JUMPS-2 (make-possible-jumps 2 (list (make-jump 7 4) (make-jump 9 5))))

;; Possible jumps with destination in index 3:
(define JUMPS-3 (make-possible-jumps 3 (list (make-jump 0 1) (make-jump 5 4)
                                             (make-jump 10 6) (make-jump 12 7))))

;; Possible jumps with destination in index 4:
(define JUMPS-4 (make-possible-jumps 4 (list (make-jump 11 7) (make-jump 13 8))))

;; Possible jumps with destination in index 5:
(define JUMPS-5 (make-possible-jumps 5 (list (make-jump 0 2) (make-jump 3 4)
                                             (make-jump 12 8) (make-jump 14 9))))

;; Possible jumps with destination in index 6:
(define JUMPS-6 (make-possible-jumps 6 (list (make-jump 1 3) (make-jump 8 7))))

;; Possible jumps with destination in index 7:
(define JUMPS-7 (make-possible-jumps 7 (list (make-jump 2 4) (make-jump 9 8))))

;; Possible jumps with destination in index 8:
(define JUMPS-8 (make-possible-jumps 8 (list (make-jump 1 4) (make-jump 6 7))))

;; Possible jumps with destination in index 9:
(define JUMPS-9 (make-possible-jumps 9 (list (make-jump 2 5) (make-jump 7 8))))

;; Possible jumps with destination in index 10:
(define JUMPS-10 (make-possible-jumps 10 (list (make-jump 3 6) (make-jump 12 11))))

;; Possible jumps with destination in index 11:
(define JUMPS-11 (make-possible-jumps 11 (list (make-jump 4 7) (make-jump 13 12))))

;; Possible jumps with destination in index 12:
(define JUMPS-12 (make-possible-jumps 12 (list (make-jump 3 7) (make-jump 5 8)
                                               (make-jump 10 11) (make-jump 14 13))))

;; Possible jumps with destination in index 13:
(define JUMPS-13 (make-possible-jumps 13 (list (make-jump 4 8) (make-jump 11 12))))

;; Possible jumps with destination in index 14:
(define JUMPS-14 (make-possible-jumps 14 (list (make-jump 5 9) (make-jump 12 13))))

;; All possible jumps:
(define ALL-JUMPS (list JUMPS-0 JUMPS-1 JUMPS-2 JUMPS-3
                        JUMPS-4 JUMPS-5 JUMPS-6 JUMPS-7
                        JUMPS-8 JUMPS-9 JUMPS-10 JUMPS-11
                        JUMPS-12 JUMPS-13 JUMPS-14))

;ALL-JUMPS


;; IMAGES:

;; Empty cell:
(define EMPTY-CELL (circle 12 "outline" "black"))

;; Full cell (with a peg):
(define FULL-CELL (overlay (circle 10 "solid" "blue") EMPTY-CELL))

;; Empty space between boards in (listof Board) rendering:
(define BETWEEN-BOARD-SPACING (rectangle 10 1 "solid" "transparent"))


;; =====================
;; Function Definitions:

;; Board Boolean -> Board | (listof Board) | false
;; produce the solution of given board, b, if it exists; otherwise produce false
;; if Boolean show, s, is true it will return all board states before being solved
;; ASSUME: in b there is only a single empty position - cell is false

;; Stub:
#; (define (solve b s) false)

;; Tests:
(check-expect (solve BOARD-1 false) BOARD-1s)
(check-expect (solve BOARD-2 false) BOARD-2s)
(check-expect (solve BOARD-3 false) BOARD-3s)
(check-expect (solve BOARD-4 false) BOARD-4s)

;; Template: <used template for backtracking on a recursively generated arbitrarity arity tree>
(define (solve b s)
  (local [;; Board -> Board | false

          ;; Template: <used template for generative recursion>
          (define (solve--board-hide b)
            (if (solved? b)
                b
                (solve--lob (next-boards b) solve--board-hide)))


          ;; Board -> (listof Board) | false

          ;; Template: <used template for generative recursion>
          (define (solve--board-show b)
            (if (solved? b)
                (cons b empty)
                (local [(define result (solve--lob (next-boards b) solve--board-show))]
                  (if (not (false? result))
                      (cons b result)
                      false))))


          ;; (listof Board) (Board -> Board | (listof Board) | false) -> Board | (listof Board) | false

          ;; Template: <used template for (listof Board)>
          (define (solve--lob lob fn)
            (cond [(empty? lob) false]
                  [else
                   (local [(define try (fn (first lob)))]
                     (if (not (false? try))
                         try
                         (solve--lob (rest lob) fn)))]))]
    
    (if s
        (solve--board-show b)
        (solve--board-hide b))))

;; Termination Argument:
;; each jump (move) remove one peg from the board, which start out being
;; 14 pegs, and the game ends, the recursion stops, when there is only
;; one peg left / it is not possible to remove anymore pegs


;; Board -> Boolean
;; produce true if given board, b, is solved; otherwise produce false
;; NOTE: solved means: the board has a single peg left

;; Stub:
#; (define (solved? b) false)

;; Tests:
(check-expect (solved? BOARD-1) false)
(check-expect (solved? BOARD-2) false)
(check-expect (solved? BOARD-3) false)
(check-expect (solved? BOARD-4) false)
(check-expect (solved? BOARD-1s) true)
(check-expect (solved? (list #false #false #false #false #false #true #false
                             #false #false #false #false #false #false #false #true)) false)

#; (define (solved? b)
     (local [;; (listof Position) -> Natural
             ;; produce the number of pegs, true cells, in given board, b
             ;; iterating over all positions in given list of positions, lop

             ;; Template: <used template for (listof Position)>
             #; (define (count-pegs lop)
                  (cond [(empty? lop) 0]
                        [else (if (false? (read-cell b (first lop)))
                                  (count-pegs (rest lop))
                                  (add1 (count-pegs (rest lop))))]))

             ;; or we can use the built-in abstract function "foldr":
          
             ;; Template: <used template for "foldr">
             (define (count-pegs lop)
               (foldr process-position 0 lop))

             ;; Position Natural -> Natural
             ;; given a position on board b, p, produce counter, c, + 1
             ;; if cell content of p is true; otherwise produce c

             ;; Template: <used template from Position>
             (define (process-position p c)
               (if (false? (read-cell b p))
                   c
                   (add1 c)))]

       (= (count-pegs POSITIONS) 1)))

;; or we can change this function to short-circuit

(define (solved? b)
  (local [;; Board Natural[0, 2] -> Boolean
          ;; produce true if the given counter, c, for the number of pegs
          ;; (true cells) in given board, b, is one; produce false if c > 1
          ;; NOTE: - although counter starts at 0; by the end of the traversal,
          ;;       counter would always be greater than or equal to 1
          ;;       - the function will short-circuit if it finds a
          ;;       second cell with value true

          ;; Template: <used template for Board>
          (define (count-pegs b c)
            (cond [(= c 2) false]
                  [(empty? b) true]
                  [else
                   (if (false? (first b))
                       (count-pegs (rest b) c)
                       (count-pegs (rest b) (add1 c)))]))]

    (count-pegs b 0)))


;; Board Position -> Cell
;; produce the cell content of the given board's, b, position, p
;; NOTE: p is always within b index bounds; therefore, b will
;;       not be empty during recursion
;;       0 <= p <= 14

;; Stub:
#; (define (read-cell b p) false)

;; Tests:
(check-expect (read-cell BOARD-1 0) false)
(check-expect (read-cell BOARD-2 2) true)

;; Template: <used template from Board>
#; (define (read-cell b p)
     (cond [(zero? p) (first b)]
           [else (read-cell (rest b) (sub1 p))]))

;; or using below created function: "index->value"

;; Template: <used template from Position>
(define (read-cell b p)
  (index->value b p))


;; Board -> (listof Board)
;; produce a list of all the valid boards that are one move distant
;; from the given board, b

;; Stub:
#; (define (next-boards b) empty)

;; Tests:
(check-expect (next-boards BOARD-1)
              (list (append (list true false true false)
                            (build-list 11 (λ (n) true)))
                    (append (list true true false true true false)
                            (build-list 9 (λ (n) true)))))
(check-expect (next-boards BOARD-2)
              (list (append (list true true true false true true false)
                            (build-list 8 (λ (n) true)))
                    (append (build-list 4 (λ (n) true))
                            (list false true true true false)
                            (build-list 6 (λ (n) true)))))

;; Template: <used template for function composition>
(define (next-boards b)
  (create-boards-from-possible-jumps
   b (filter-valid-jumps
      b (get-possible-jumps
         (filter-empty b 0)))))


;; Board (listof Position) -> (listof Position)
;; produce a list of all empty cell's positions on board, b
;; NOTE: empty cell has value false

;; Stub:
#; (define (find-empty b lop) empty)

;; Template: <used template for "filter">
#; (define (find-empty b lop)
     (filter (λ (p) (false? (read-cell b p))) lop))

;; or using template from Board

;; Board Position -> (listof Position)
;; produce a list of all empty cell's positions, p, on given board, b
;; ASSUME: the starter value for p is 0 

;; Stub:
#; (define (filter-empty b c) empty)

;; Tests:
(check-expect (filter-empty BOARD-1 0) (list 0))
(check-expect (filter-empty BOARD-2 0) (list 1))
(check-expect (filter-empty BOARD-3 0) (list 4))
(check-expect (filter-empty BOARD-4 0) (list 3))

;; Template: <used template from Board>
(define (filter-empty b c)
  (cond [(empty? b) empty]
        [else
         (if (false? (first b))
             (cons c (filter-empty (rest b) (add1 c)))
             (filter-empty (rest b) (add1 c)))]))


;; (listof Position) -> (listof PossibleJumps)
;; produce a list of possible jumps for every position in given
;; list of positions, lop
;; NOTE: for any position, p, the "to" key of its PossibleJumps
;;       is the same as its index in ALL-JUMPS list.
;;       This means: we can simply search for index p in ALL-JUMPS
;;                   in order to find its PossibleJumps
;; ASSUME: lop is not empty, since a board must always have, at least,
;;         an empty cell

;; Stub:
#; (define (get-possible-jumps lop) empty)

;; Tests:
(check-expect (get-possible-jumps (list 0)) (list JUMPS-0))
(check-expect (get-possible-jumps (list 3 7 8)) (list JUMPS-3 JUMPS-7 JUMPS-8))

;; Template: <used template for "map">
(define (get-possible-jumps lop)
  (map (λ (p) (index->value ALL-JUMPS p)) lop))


;; Board (listof PossibleJumps) -> (listof PossibleJumps)
;; produce a list of possible jumps, lopj, that only contain valid jumps
;; on given board, b
;; ASSUME: for every element of lopj, "to" position on b should be empty
;;         lopj is never empty

;; Stub:
#; (define (filter-valid-jumps b lopj) empty)

;; Tests:
(check-expect (filter-valid-jumps BOARD-1 (list JUMPS-0)) (list JUMPS-0))
(check-expect (filter-valid-jumps TEST-BOARD (list JUMPS-0 JUMPS-1))
              (list (make-possible-jumps 0 (list (make-jump 5 2))) JUMPS-1))

;; Template: <used template for (listof PossibleJumps)>
(define (filter-valid-jumps b lopj)
  (local [;; Jump -> Boolean
          ;; produce true if given jump is valid
          ;; NOTE: valid means both "from" and "over" positions
          ;;       in board b must have cell's value true

          ;; Stub:
          #; (define (valid? j) false)

          ;; Template: <used template from Jump>
          (define (valid? j)
            (and (read-cell b (jump-from j)) (read-cell b (jump-over j))))]

    (cond [(empty? lopj) empty]
          [else
           (cons (make-possible-jumps (possible-jumps-to (first lopj))
                                      (filter valid? (possible-jumps-loj (first lopj))))
                 (filter-valid-jumps b (rest lopj)))])))


;; Board (listof PossibleJumps) -> (listof Board)
;; produce a list of all the possible next move boards from the
;; given list of valid jumps, lopj, and given board, b

;; Stub:
#; (define (create-boards-from-possible-jumps b lopj) empty)

;; Tests:
(check-expect (create-boards-from-possible-jumps BOARD-1 (list JUMPS-0))
              (local [(define new-board-1 (replace-cell BOARD-1 0 true))]
                (list (replace-cell (replace-cell new-board-1 1 false) 3 false)
                      (replace-cell (replace-cell new-board-1 2 false) 5 false))))
(check-expect (create-boards-from-possible-jumps
               TEST-BOARD (filter-valid-jumps TEST-BOARD (list JUMPS-0 JUMPS-1)))
              (local [(define new-test-board-0 (replace-cell TEST-BOARD 0 true))
                      (define new-test-board-1 (replace-cell TEST-BOARD 1 true))]
                (list (replace-cell (replace-cell new-test-board-0 2 false) 5 false)
                      (replace-cell (replace-cell new-test-board-1 3 false) 6 false)
                      (replace-cell (replace-cell new-test-board-1 4 false) 8 false))))

;; Template: <used template for (listof PossibleJumps)>
(define (create-boards-from-possible-jumps b lopj)
  (local [;; (listof Jump) Board -> (listof Board)
          ;; given a list of valid jumps, loj, and a base board, b,
          ;; produce a list of new generated boards with each jump

          ;; Stub:
          #; (define (create-boards-jumps loj b) empty)

          ;; Template: <used template for "map">
          (define (create-boards-jumps loj b)
            (map (λ (j) (replace-cell (replace-cell b (jump-over j) false)
                                      (jump-from j) false)) loj))]

    (cond [(empty? lopj) empty]
          [else
           (append (create-boards-jumps (possible-jumps-loj (first lopj))
                                        (replace-cell b (possible-jumps-to (first lopj)) true))
                   (create-boards-from-possible-jumps b (rest lopj)))])))


;; (listof X) Natural -> X
;; produce the value of given list's, l, given index, i
;; ASSUME: 0 <= i < (length l); therefore, l will not
;;         be empty during recursion

;; Stub:
#; (define (index->value l i) ...)

;; Tests:
(check-expect (index->value ALL-JUMPS 0) JUMPS-0)
(check-expect (index->value ALL-JUMPS 7) JUMPS-7)
(check-expect (index->value ALL-JUMPS 14) JUMPS-14)

;; Template: <used template for (listof X)>
(define (index->value l i)
  (cond [(zero? i) (first l)]
        [else (index->value (rest l) (sub1 i))]))


;; Board Position Cell -> Board
;; replace cell value with c, in given board, b, at position, p

;; Stub:
#; (define (replace-cell b p c) empty)

;; Tests:
(check-expect (replace-cell BOARD-1 0 true)
              (build-list 15 (λ (n) true)))
(check-expect (replace-cell BOARD-2 12 false)
              (append (list true false)
                      (build-list 10 (λ (n) true))
                      (list false true true)))

;; Template:
(define (replace-cell b p c)
  (cond [(zero? p) (cons c (rest b))]
        [else
         (cons (first b)
               (replace-cell (rest b) (sub1 p) c))]))


;; (Board | (listof Board)) Boolean -> Image
;; produce a render of a given board, s, if list, l, Boolean
;; is false; otherwise produce a render of a list of board, s
;; ASSUME: if list, l, is false then s is Board; and if l is
;;         true than s is (listof Board)

;; Stub:
#; (define (render s l) empty-image)

;; Tests:
(check-expect (render BOARD-1 false)
              (above (beside EMPTY-CELL empty-image)
                     (beside FULL-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL FULL-CELL)))
(check-expect (render BOARD-2 false)
              (above (beside FULL-CELL empty-image)
                     (beside EMPTY-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL)
                     (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL FULL-CELL)))
(check-expect (render (list BOARD-1 BOARD-2) true)
              (beside (above (beside EMPTY-CELL empty-image)
                             (beside FULL-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL FULL-CELL))
                      BETWEEN-BOARD-SPACING
                      (above (beside FULL-CELL empty-image)
                             (beside EMPTY-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL)
                             (beside FULL-CELL FULL-CELL FULL-CELL FULL-CELL FULL-CELL))
                      BETWEEN-BOARD-SPACING))

(define (render s l)
  (local [;; Board (listof (listof Position)) -> Image
          ;; given a list of lists of positions representing all of given board's, b,
          ;; rows, lor, produce a render of the entire board, traversing through lor

          ;; Stub:
          #; (define (render--board b lor) empty-image)

          ;; Template: <used template for (listof (list of Position))>
          (define (render--board b lor)
            (cond [(empty? lor) empty-image]
                  [else (above (render-row b (first lor))
                               (render--board b (rest lor)))]))

          
          ;; (listof Board) -> Image
          ;; produce a render of all elements in given list of boards, lob

          ;; Stub:
          #; (define (render--lob lob) empty-image)

          ;; Template: <used template for "foldr">
          #; (define (render--lob lob)
               (foldr beside empty-image ;; missing BETWEEN-BOARD-SPACING
                      (map (λ (b) (render--board b ROWS)) lob)))

          ;; or using a template for one single pass in given lob

          ;; Template: <used template for (listof Board)>
          (define (render--lob lob)
            (cond [(empty? lob) empty-image]
                  [else
                   (beside (render--board (first lob) ROWS)
                           BETWEEN-BOARD-SPACING
                           (render--lob (rest lob)))]))
          

          ;; Board (listof Position) -> Image
          ;; given a list of positions representing a board's row, lop, produce
          ;; a render of given board's, b, row

          ;; Stub:
          #; (define (render-row b lop) empty-image)

          ;; Template: <used template for "foldr">
          #; (define (render-row b lop)
               (foldr beside empty-image
                      (map (λ (p) (if (false? (read-cell b p))
                                      EMPTY-CELL
                                      FULL-CELL)) lop)))

          ;; or using a template for one single pass in given row

          ;; Template: <used template for (listof Position)>
          (define (render-row b lop)
            (cond [(empty? lop) empty-image]
                  [else
                   (if (false? (read-cell b (first lop)))
                       (beside EMPTY-CELL (render-row b (rest lop)))
                       (beside FULL-CELL (render-row b (rest lop))))]))]

    (if l
        (render--lob s)
        (render--board s ROWS))))

