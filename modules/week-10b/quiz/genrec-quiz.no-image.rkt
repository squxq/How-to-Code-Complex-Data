;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname genrec-quiz.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;PROBLEM 1:
; 
; In the lecture videos we designed a function to make a Sierpinski triangle fractal. 
; 
; Here is another geometric fractal that is made of circles rather than triangles:
; 
; (open image file)
; 
; Design a function to create this circle fractal of size n and colour c.

;; =====================
;; Constant Definitions:

(define CUT-OFF 5)
(define CIRCLE-MODE "outline")


;; =====================
;; Function Definitions:

;; Natural String -> Image
;; produce a circle fractal of given size, n, and given colour, c

;; Stub:
#; (define (circle-fractal n c) empty-image)

;; Tests:
(check-expect (circle-fractal CUT-OFF "blue")
              (circle CUT-OFF CIRCLE-MODE "blue"))
(check-expect (circle-fractal (* CUT-OFF 2) "blue")
              (local [(define sub (circle CUT-OFF CIRCLE-MODE "blue"))]
                (overlay (beside sub sub)
                         (circle (* CUT-OFF 2) CIRCLE-MODE "blue"))))

;; Template: <used template for generative recursion>
(define (circle-fractal n c)
  (cond [(>= CUT-OFF n) (circle n CIRCLE-MODE c)]
        [else
         (local [(define sub (circle-fractal (/ n 2) c))]
           (overlay (beside sub sub)
                    (circle n CIRCLE-MODE c)))]))


; PROBLEM 2:
; 
; Below you will find some data definitions for a tic-tac-toe solver. 
; 
; In this problem we want you to design a function that produces all 
; possible filled boards that are reachable from the current board. 
; 
; In actual tic-tac-toe, O and X alternate playing. For this problem
; you can disregard that. You can also assume that the players keep 
; placing Xs and Os after someone has won. This means that boards that 
; are completely filled with X, for example, are valid.
; 
; Note: As we are looking for all possible boards, rather than a winning 
; board, your function will look slightly different than the solve function 
; you saw for Sudoku in the videos, or the one for tic-tac-toe in the 
; lecture questions. 

;; =================
;; Data Definitions:

;; Value is one of:
;; - false
;; - "X"
;; - "O"
;; interp. a square is either empty (represented by false) or has and "X" or an "O"

;; Template:
#; (define (fn-for-value v)
     (cond [(false? v) (...)]
           [(string=? v "X") (...)]
           [(string=? v "O") (...)]))


;; Board is (listof Value)
;; interp. a board is a list of 9 Values

;; Examples:
(define B0 (list false false false
                 false false false
                 false false false))

(define B1 (list false "X"   "O"   ; a partly finished board
                 "O"   "X"   "O"
                 false false "X")) 

(define B2 (list "X"  "X"  "O"     ; a board where X will win
                 "O"  "X"  "O"
                 "X" false "X"))

(define B3 (list "X" "O" "X"       ; a board where O will win
                 "O" "O" false
                 "X" "X" false))

;; Template:
#; (define (fn-for-board b)
     (cond [(empty? b) (...)]
           [else 
            (... (fn-for-value (first b))
                 (fn-for-board (rest b)))]))


;; Position is Natural[0, 8]
;; interp. position on a board - 0-indexed

;; Template:
#; (define (fn-for-position p)
     (... p))


(define-struct node (board x-board o-board))
;; PossibleBoards is one of: --> Binary Tree
;; - false
;; - (make-node Board PossibleBoards PossibleBoards)
;; interp. false means there are no more possible boards reachable from board,
;;         which essentially means, board is full
;;         - board is the node's original board
;;         - x-board is the next move's board, where
;;           the next empty square is replaced by an X
;;         - o-board is the next move's board, where
;;           the next empty square is replaced by an O
;; INVARIANT: for a given node:
;;            - the same board never appears twice in the tree

;; Template:
#; (define (fn-for-pb pb)
     (cond [(false? pb) (...)]
           [else
            (... (node-board pb)
                 (fn-for-pb (node-x-board pb))
                 (fn-for-pb (node-o-board pb)))]))


;; =====================
;; Constant Definitions:

;; BOARDS:

;; Filled Board:
(define BOARD-0 (list "X" "X" "X"
                      "X" "X" "X"
                      "X" "X" "X"))

;; Filled Board Alternative 1:
(define BOARD-0-1 (list "X" "X" "X"
                        "X" "X" "X"
                        "X" "X" "O"))

;; Filled Board Alternative 2:
(define BOARD-0-2 (list "X" "X" "X"
                        "X" "X" "X"
                        "X" "O" "X"))

;; Filled Board Alternative 3:
(define BOARD-0-3 (list "X" "X" "X"
                        "X" "X" "X"
                        "X" "O" "O"))

;; 1 Empty Square Board:
(define BOARD-1 (list "X" "X" "X"
                      "X" "X" "X"
                      "X" "X" false))

;; 1 Empty Square Board Alternative 1:
(define BOARD-1-1 (list "X" "X" "X"
                        "X" "X" "X"
                        "X" "O" false))

;; 2 Empty Squares Board:
(define BOARD-2 (list "X" "X" "X"
                      "X" "X" "X"
                      "X" false false))


;; =====================
;; Function Definitions:

;; Board -> (listof Board)
;; produce all possible filled boards that are reachable from the given board, b

;; Stub:
#; (define (fill b) empty)

;; Tests:
#; (check-expect (fill BOARD-0) (list BOARD-0))
#; (check-expect (fill BOARD-1) (list BOARD-0 BOARD-0-1))
#; (check-expect (fill BOARD-2) (list BOARD-0 BOARD-0-1
                                      BOARD-0-2 BOARD-0-3))

;; Template: <used template for function composition>
#; (define (fill b)
     (possible-boards->list-boards (generate-boards b)))

;; or in one pass

;; Template: <used template from PossibleBoards and for generative recursion>
#; (define (fill b)
     (cond [(filled? b) (cons b empty)]
           [else
            (local [(define next-empty (find-empty b 0))
                    (define x-board (replace-square b next-empty "X"))
                    (define o-board (replace-square b next-empty "O"))]
              (append
               (fill x-board)
               (fill o-board)))]))


;; Board -> PossibleBoards
;; produce a binary tree of all possible filled boards that follow given board, b

;; Stub:
#; (define (generate-boards b) false)

;; Tests:
(check-expect (generate-boards BOARD-0)
              (make-node BOARD-0 false false))
(check-expect (generate-boards BOARD-1)
              (make-node BOARD-1
                         (make-node BOARD-0 false false)
                         (make-node BOARD-0-1 false false)))
(check-expect (generate-boards BOARD-2)
              (make-node BOARD-2
                         (make-node BOARD-1
                                    (make-node BOARD-0 false false)
                                    (make-node BOARD-0-1 false false))
                         (make-node BOARD-1-1
                                    (make-node BOARD-0-2 false false)
                                    (make-node BOARD-0-3 false false))))

;; Template: <used template from PossibleBoards and for generative recursion>
(define (generate-boards b)
  (cond [(filled? b) (make-node b false false)]
        [else
         (local [(define next-empty (find-empty b 0))
                 (define x-board (replace-square b next-empty "X"))
                 (define o-board (replace-square b next-empty "O"))]
           (make-node
            b
            (generate-boards x-board)
            (generate-boards o-board)))]))


;; Board -> Boolean
;; produce true if given board is filled

;; Stub:
#; (define (filled? b) false)

;; Tests:
(check-expect (filled? BOARD-0) true)
(check-expect (filled? B3) false)
(check-expect (filled? BOARD-0-1) true)
(check-expect (filled? BOARD-2) false)

;; Template: <used template for built in abstract function "andmap">
(define (filled? b)
  (andmap (λ (v) (not (false? v))) b))


;; Board Natural -> Position
;; produce the first empty (value is false) position of the given board, b,
;; starting at the given position, p
;; ASSUME: board has at least one empty square; so, in recursion b is not empty
;;         position, p, always starts at 0

;; Stub:
#; (define (find-empty b p) 0)

;; Tests:
(check-expect (find-empty BOARD-1 0) 8)
(check-expect (find-empty BOARD-2 0) 7)
(check-expect (find-empty B1 0) 0)
(check-expect (find-empty B2 0) 7)
(check-expect (find-empty B3 0) 5)

;; Template: <used template from Board>
(define (find-empty b p)
  (cond [(false? (first b)) p]
        [else
         (find-empty (rest b) (add1 p))]))


;; Board Position Value -> Board
;; produce the given board, b, replacing the value of the square of given position, p,
;; by new value, v
;; ASSUME: since p is a position, during recursion b will never be empty

;; Stub:
#; (define (replace-square b p v) b)

;; Tests:
(check-expect (replace-square BOARD-1 8 "O") BOARD-0-1)
(check-expect (replace-square BOARD-2 7 "X") BOARD-1)

;; Template: <used template from Board>
(define (replace-square b p v)
  (cond [(zero? p) (cons v (rest b))]
        [else
         (cons (first b)
               (replace-square (rest b) (sub1 p) v))]))


;; PossibleBoards -> (listof Board)
;; produce a list of all boards in given possible boards, pb

;; Stub:
#; (define (possible-boards->list-boards pb) empty)

;; Tests:
(check-expect (possible-boards->list-boards false) empty)
(check-expect (possible-boards->list-boards (make-node BOARD-0 false false))
              (list BOARD-0))
(check-expect (possible-boards->list-boards (generate-boards BOARD-1))
              (list BOARD-0 BOARD-0-1))
(check-expect (possible-boards->list-boards (generate-boards BOARD-2))
              (list BOARD-0 BOARD-0-1
                    BOARD-0-2 BOARD-0-3))

;; Template: <used template from Possible Boards>
(define (possible-boards->list-boards pb)
  (cond [(false? pb) empty]
        [(and (false? (node-x-board pb))
              (false? (node-o-board pb)))
         (cons (node-board pb) empty)]
        [else
         (append (possible-boards->list-boards
                  (node-x-board pb))
                 (possible-boards->list-boards
                  (node-o-board pb)))]))


;PROBLEM 3:
; 
; Now adapt your solution to filter out the boards that are impossible if 
; X and O are alternating turns. You can continue to assume that they keep 
; filling the board after someone has won though. 
; 
; You can assume X plays first, so all valid boards will have 5 Xs and 4 Os.
; 
; NOTE: make sure you keep a copy of your solution from problem 2 to answer 
; the questions on edX.

;; Board -> (listof Board)
;; produce all possible filled boards that are reachable from the given board, b,
;; filtering out the boards that are impossible if X and O are alternating turns
;; ASSUME: - X plays first; therefore, all valid boards will have 5 Xs and 4 Os
;;         - given board doesn't have more than 5 Xs or more than 4 Os 

;; Stub:
#; (define (fill b) empty)

;; Tests:
(check-expect (fill B2) (list (replace-square B2 7 "O")))
(check-expect (fill (replace-square B3 5 "X"))
              (list (replace-square (replace-square B3 5 "X") 8 "O")))
(check-expect (fill B3)
              (list (replace-square (replace-square B3 5 "X") 8 "O")
                    (replace-square (replace-square B3 5 "O") 8 "X")))
(check-expect (fill B1)
              (list
               (list "X" "X" "O" "O" "X" "O" "X" "O" "X")
               (list "X" "X" "O" "O" "X" "O" "O" "X" "X")
               (list "O" "X" "O" "O" "X" "O" "X" "X" "X")))

;; Template: <used template for function composition>
#; (define (fill b)
     (filter-valid-boards (possible-boards->list-boards (generate-boards b))))

;; or in one pass

;; Template: <used template from PossibleBoards and for generative recursion>
#;(define (fill b)
    (cond [(filled? b)
           (if (valid? b 0)
               (cons b empty)
               empty)]
          [else
           (local [(define next-empty (find-empty b 0))
                   (define x-board (replace-square b next-empty "X"))
                   (define o-board (replace-square b next-empty "O"))]
             (append
              (fill x-board)
              (fill o-board)))]))

;; or without computing unnecessary boards

;; Template: <used template from PossibleBoards and for generative recursion>
(define (fill b)
  (cond [(filled? b) (cons b empty)]
        [else
         (local [(define next-empty (find-empty b 0))
                 (define x-board (replace-square b next-empty "X"))
                 (define o-board (replace-square b next-empty "O"))]
           (append
            (if (valid? x-board 0 0) (fill x-board) empty)
            (if (valid? o-board 0 0) (fill o-board) empty)))]))


;; (listof Board) -> (listof Board)
;; produce the valid boards from the given list of boards, lob
;; ASSUME: every board of lob is full

;; Stub:
#; (define (filter-valid-boards lob) empty)

;; Tests:
(check-expect (filter-valid-boards (list (replace-square B2 7 "X")
                                         (replace-square B2 7 "O")))
              (list (replace-square B2 7 "O")))
(check-expect (filter-valid-boards
               (list (replace-square (replace-square B3 5 "X") 8 "X")
                     (replace-square (replace-square B3 5 "X") 8 "O")))
              (list (replace-square (replace-square B3 5 "X") 8 "O")))

;; Template: <used template for built-in abstract function "filter">
(define (filter-valid-boards lob)
  (filter (λ (b) (valid? b 0 0)) lob))


;; Board Natural -> Boolean
;; produce true if given board, b, is valid, using the counter
;; of "X" occurences, x, and the counter of "O" occurrences, o
;; ASSUME: - x and c always start at 0
;; NOTE: valid means - b has less than 5 Xs and less than 4 Os

;; Stub:
#; (define (valid? b x o) false)

;; Tests:
(check-expect (valid? BOARD-0 0 0) false)
(check-expect (valid? (list "X" "X" "X" "O" "X" "O" "X" "O" "X") 0 0) false)
(check-expect (valid? (replace-square (replace-square B3 5 "X") 8 "O") 0 0) true)
(check-expect (valid? B3 0 0) true)

;; Template: <used template from Board>
(define (valid? b x o)
  (cond [(empty? b) (and (<= x 5) (<= o 4))]
        [(or (> x 5) (> o 4)) false]
        [else
         (if (string? (first b))
             (if (string=? (first b) "X") 
                 (valid? (rest b) (add1 x) o)
                 (valid? (rest b) x (add1 o)))
             (valid? (rest b) x 0))]))