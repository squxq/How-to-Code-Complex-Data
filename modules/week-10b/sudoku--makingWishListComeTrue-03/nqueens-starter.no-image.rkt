;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname nqueens-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; nqueens-starter.rkt


;This project involves the design of a program to solve the n queens puzzle.
;
;This starter file explains the problem and provides a few hints you can use
;to help with the solution.
;
;The key to solving this problem is to follow the recipes! It is a challenging
;problem, but if you understand how the recipes lead to the design of a Sudoku
;solve then you can follow the recipes to get to the design for this program.
;  
;
;The n queens problem consists of finding a way to place n chess queens
;on a n by n chess board while making sure that none of the queens attack each
;other. 
;
;The BOARD consists of n^2 individual SQUARES arranged in 4 rows of 4 columns.
;The colour of the squares does not matter. Each square can either be empty
;or can contain a queen.
;
;A POSITION on the board refers to a specific square.
;
;A queen ATTACKS every square in its row, its column, and both of its diagonals.
;
;A board is VALID if none of the queens placed on it attack each other.
;
;A valid board is SOLVED if it contains n queens.
;
;
;There are many strategies for solving nqueens, but you should use the following:
;  
;  - Use a backtracking search over a generated arb-arity tree that
;    is trying to add 1 queen at a time to the board. If you find a
;    valid board with 4 queens produce that result.
;
;  - You should design a function that consumes a natural - N - and
;    tries to find a solution.
;    
;    
;    
;NOTE 1: You can tell whether two queens are on the same diagonal by comparing
;the slope of the line between them. If one queen is at row and column (r1, c1)
;and another queen is at row and column (r2, c2) then the slope of the line
;between them is: (/ (- r2 r1) (- c2 c1)).  If that slope is 1 or -1 then the
;queens are on the same diagonal.

;; The N-queens Problem

;; In the current file, we have a group of functions that solve and render the
;; solutions for a problem based on the game of chess. In chess, a queen can
;; attack horizontally, vertically, and diagonally. The N-queens problem asks:
;;  - How can N queens be placed on an NxN chessboard so that no two of them
;;    attack each other?

;; The board consists of n^2 individual squares arranged in n rows and n columns.
;; The color of the squares does not matter. Each square can either be empty or
;; can contain a queen. A position on the board refers to a specific square.
;; A queen attacks every square in its row, column, and both of its diagonals.
;; A board is valid if none of the queens placed on it attack each other.
;; A valid board is solved if it contains n queens.

;; For solving N-queens, backtracking, generative recursion, and arbitrarity
;; arity trees will be used. The function responsible for finding the solution
;; for this problem should consume a natural.

;; =================
;; Data Definitions:

;; Square is Boolean
;; interp. a square is a single space in the board which can be empty, represented
;;         with the Boolean false, or it can contain a queen, represented with
;;         the Boolean true. Each square has a position on the board (defined below).

;; Template:
#; (define (fn-for-square s)
     (... s))


;; Board is (listof Square)
;; interp. visually a board is a n^2 array of squares, where each square has a row
;;         and column number, (r, c). But we represent it as a single flat list,
;;         in which the rows are layed out one after another in a linear fashion.
;;         Any board's length is a perfect square, therefore it starts at 1, which
;;         means that no Board can be: empty.

;; Template:
#; (define (fn-for-board b)
     (cond [(empty? b) (...)]
           [else
            (... (fn-for-square (first b))
                 (fn-for-board (rest b)))]))


;; Position is Natural[0, n^2 - 1]
;; interp. the position of a square on the board. Since any boards length is n^2,
;;         the position range goes up to n^2, because it is 0-indexed. The row
;;         number is the quotient of the position, p, by n, the board's side length.
;;         The column number is the remainder of the division of p by n.

;; Template:
#; (define (fn-for-position p)
     (... p))


(define-struct coords (col row))
;; Coordinates is (make-coords Natural Natural)
;; interp. the coordinates of a square on the board. Both the col and row range from
;;         [0, n), because row and column are 0-indexed. See Position for how to
;;         convert Position to row and column indexes.

;; Template:
#; (define (fn-for-coords c)
     (... (coords-col c)
          (coords-row c)))


;; =====================
;; Constant Definitions:

;; BOARDS:

;; Board 1:
(define 1-QUEENS (list false))

;; Board 2:
(define 2-QUEENS (build-list (sqr 2) (λ (n) false)))

;; Board 3:
(define 3-QUEENS (build-list (sqr 3) (λ (n) false)))

;; Board 4:
(define 4-QUEENS (build-list (sqr 4) (λ (n) false)))

;; Board 1 Solution:
(define 1s-QUEENS (list true))

;; Board 2 Solution (there is no solution):
(define 2s-QUEENS false)

;; Board 3 Solution (there is no solution):
(define 3s-QUEENS false)

;; Board 4 Solution:
(define 4s-QUEENS (list false true false false
                        false false false true
                        true false false false
                        false false true false))

;; Board 4 Incomplete version 1:
(define 4i-QUEENS-1 (append (list false true false false)
                            (build-list 12 (λ (n) false))))

;; Board 4 Incomplete version 2:
(define 4i-QUEENS-2 (append (list false true false false
                                  false false false true)
                            (build-list 8 (λ (n) false))))

;; Board 4 Incomplete version 3:
(define 4i-QUEENS-3 (append (list false true false false
                                  false false false true
                                  true false false false)
                            (build-list 4 (λ (n) false))))

;; Board 4 Incomplete version 4:
(define 4i-QUEENS-4 (append (list true false false false
                                  false false true false)
                            (build-list 8 (λ (n) false))))

;; Board 4 Incomplete version 5:
(define 4i-QUEENS-5 (append (list true)
                            (build-list 15 (λ (n) false))))

;; Board 4 Incomplete and Invalid version 6:
(define 4i-QUEENS-6 (append (list true false false false
                                  false true false false)
                            (build-list 8 (λ (n) false))))

;; Board 4 Incomplete and Invalid version 7:
(define 4i-QUEENS-7 (append (list true false false false
                                  true false false false)
                            (build-list 8 (λ (n) false))))

;; Board 5 Solution:
(define 5-QUEENS (list #true #false #false #false #false
                       #false #false #true #false #false
                       #false #false #false #false #true
                       #false #true #false #false #false
                       #false #false #false #true #false))

;; Board 6 Solution:
(define 6-QUEENS (list #false #true #false #false #false #false
                       #false #false #false #true #false #false
                       #false #false #false #false #false #true
                       #true #false #false #false #false #false
                       #false #false #true #false #false #false
                       #false #false #false #false #true #false))

;; Board 7 Solution:
(define 7-QUEENS (list #true #false #false #false #false #false #false
                       #false #false #true #false #false #false #false
                       #false #false #false #false #true #false #false
                       #false #false #false #false #false #false #true
                       #false #true #false #false #false #false #false
                       #false #false #false #true #false #false #false
                       #false #false #false #false #false #true #false))

;; Board 8 Solution:
(define 8-QUEENS (list #true #false #false #false #false #false #false #false
                       #false #false #false #false #true #false #false #false
                       #false #false #false #false #false #false #false #true
                       #false #false #false #false #false #true #false #false
                       #false #false #true #false #false #false #false #false
                       #false #false #false #false #false #false #true #false
                       #false #true #false #false #false #false #false #false
                       #false #false #false #true #false #false #false #false))

;; Board 9 Solution:
(define 9-QUEENS (list #true #false #false #false #false #false #false #false #false
                       #false #false #true #false #false #false #false #false #false
                       #false #false #false #false #false #true #false #false #false
                       #false #false #false #false #false #false #false #true #false
                       #false #true #false #false #false #false #false #false #false
                       #false #false #false #true #false #false #false #false #false
                       #false #false #false #false #false #false #false #false #true
                       #false #false #false #false #false #false #true #false #false
                       #false #false #false #false #true #false #false #false #false))

;; Board 10 Solution:
(define 10-QUEENS (list #true #false #false #false #false #false #false #false #false #false
                        #false #false #true #false #false #false #false #false #false #false
                        #false #false #false #false #false #true #false #false #false #false
                        #false #false #false #false #false #false #false #true #false #false
                        #false #false #false #false #false #false #false #false #false #true
                        #false #false #false #false #true #false #false #false #false #false
                        #false #false #false #false #false #false #false #false #true #false
                        #false #true #false #false #false #false #false #false #false #false
                        #false #false #false #true #false #false #false #false #false #false
                        #false #false #false #false #false #false #true #false #false #false))


;; IMAGES:

;; White Empty Square:
(define W-E (square 20 "solid" "white"))

;; Black Empty Square:
(define B-E (square 20 "solid" "black"))

;; White Square's Queen:
(define W-Q (overlay (circle 5 "solid" "black") W-E))

;; Black Square's Queen:
(define B-Q (overlay (circle 5 "solid" "white") B-E))


;; =====================
;; Function Definitions:

;; Natural -> Board | false
;; produce a solution for the n-queens problem, using given natural, n, as side length
;; if there exists one; otherwise produce false
;; ASSUME: n >= 1

;; Stub:
#; (define (solve n) false)

;; Tests:
(check-expect (solve 1) 1s-QUEENS)
(check-expect (solve 2) 2s-QUEENS)
(check-expect (solve 3) 3s-QUEENS)
(check-expect (solve 4) 4s-QUEENS)
(check-expect (solve 5) 5-QUEENS)
(check-expect (solve 6) 6-QUEENS)
(check-expect (solve 7) 7-QUEENS)
(check-expect (solve 8) 8-QUEENS)
(check-expect (solve 9) 9-QUEENS)
(check-expect (solve 10) 10-QUEENS)

;; Template: <used template for backtracking, generative recursion and arbitrary arity trees>
(define (solve n)
  (local [;; (listof (listof Position))
          ;; list of rows in generated board with side length n
          ;; NOTE: a row is a list of 0-indexed positions with length n
          
          (define ROWS (generate-rows n))
          

          ;; Board Natural -> Board | false
          ;; same purpose as main function
          ;; ASSUME: given natural, n, that represents the current row index always
          ;;         starts at 0

          ;; Stub:
          #; (define (solve--board b i) false)

          ;; Template: <used template for generative recursion>
          (define (solve--board b i)
            (if (v2-solved? i n) ;; (v1-solved? b LAST-ROW) -> old solved? function
                b
                (solve--lob (next-boards b n (index->value ROWS i) (current-rows ROWS i)) (add1 i))))


          ;; (listof Board) Natural -> Board | false
          ;; same purpose as main function

          ;; Stub:
          #; (define (solve--lob lob i) false)

          ;; Template: <used template for list>
          (define (solve--lob lob i)
            (cond [(empty? lob) false]
                  [else
                   (local [(define try (solve--board (first lob) i))]
                     (if (not (false? try))
                         try
                         (solve--lob (rest lob) i)))]))]

    (solve--board (generate-board n) 0)))

;; Termination argument:
;;  - the initial board has no queens and each move a queen is added to a row.
;;  - the problem is solved when all the rows contain a queen. Being the side
;;    length and numberof rows, n, the minimum amout of moves is n.
;;  - Since, by nature, of the solve function, we start adding queens from row
;;    0 to row n - 1: if the last row, n - 1, has a queen, all the privious
;;    rows also contain a queen.


;; Natural -> Board
;; produce an empty board with given natural, n, as its side length
;; NOTE: - empty board means all the board's squares are empty
;;       - board must have length: n^2
;; ASSUME: n >= 1

;; Stub
#; (define (generate-board n) (list false))

;; Tests:
(check-expect (generate-board 1)
              (build-list (sqr 1) (λ (n) false)))
(check-expect (generate-board 2)
              (build-list (sqr 2) (λ (n) false)))
(check-expect (generate-board 3)
              (build-list (sqr 3) (λ (n) false)))
(check-expect (generate-board 4)
              (build-list (sqr 4) (λ (n) false)))

;; Template: <used template for built-in abstract function "build-list">
(define (generate-board n)
  (build-list (sqr n) (λ (n) false)))


;; Natural -> (listof (listof Position))
;; produce a list of rows in generated board with side length n
;; NOTE: a row is a list of 0-indexed positions with length n
;; ASSUME: n >= 1

;; Stub:
#; (define (generate-rows n) (list (list 0)))

;; Tests:
(check-expect (generate-rows 1)
              (list (list 0)))
(check-expect (generate-rows 2)
              (list (list 0 1) (list 2 3)))
(check-expect (generate-rows 3)
              (list (list 0 1 2) (list 3 4 5) (list 6 7 8)))
(check-expect (generate-rows 4)
              (list (list 0 1 2 3) (list 4 5 6 7) (list 8 9 10 11)
                    (list 12 13 14 15)))

;; Template: <used template for built-in abstract function "build-list">
(define (generate-rows n)
  (local [;; Natural[0, n) -> (listof Position)
          ;; given an index of a row in a n^2 board, i, produce the list
          ;; of positions that define the cells of that row

          ;; Stub:
          #; (define (generate-row i) (list 0))

          ;; Template: <used template for built-in abstract function "build-list">
          (define (generate-row i)
            (build-list n (λ (index) (+ index (* i n)))))]

    (build-list n generate-row)))


;; (listof X) Natural -> X
;; produce the value of given list's, l, given index, i
;; ASSUME: 0 <= i < (length l); therefore, l will not be empty during recursion

;; Stub:
#; (define (index->value l i) ...)

;; Tests:
(check-expect (index->value (list 1 2 3) 0) 1)
(check-expect (index->value (list 1 2 3) 1) 2)
(check-expect (index->value (list 1 2 6) 2) 6)

;; Template: <used template for list>
(define (index->value l i)
  (cond [(zero? i) (first l)]
        [else
         (index->value (rest l) (sub1 i))]))


;; Board (listof Position) -> Boolean
;; produce true if given board, b, of side-length n, is solved
;; we can do that by checking if any of the squares with positions in
;; given list of positions, lop, has a queen
;; NOTE: a board is solved if all its rows contain a queen, but we know that
;;       if the last row, of index n - 1 (n being the number of rows or the
;;       side length of the board), contains a queen, then all the previous
;;       rows also do.

;; Stub:
#; (define (v1-solved? b lop) false)

;; Tests:
(check-expect (v1-solved? 1s-QUEENS (list 0)) true)
(check-expect (v1-solved? 4-QUEENS (list 12 13 14 15)) false)
(check-expect (v1-solved? 4i-QUEENS-1 (list 12 13 14 15)) false)
(check-expect (v1-solved? 4i-QUEENS-2 (list 12 13 14 15)) false)
(check-expect (v1-solved? 4i-QUEENS-3 (list 12 13 14 15)) false)
(check-expect (v1-solved? 4s-QUEENS (list 12 13 14 15)) true)

;; Template: <used template for list>
(define (v1-solved? b lop)
  (cond [(empty? lop) false]
        [else
         (if (false? (index->value b (first lop)))         
             (v1-solved? b (rest lop))
             true)]))

;; or

;; Natural Natural -> Boolean
;; produce true if a board of given side-length, n, is solved
;; NOTE: a board is solved if the current row index, i, where the next move
;;       will be made, is equal to n, because for i to be n, due to the
;;       nature of the implementation of solve, all its rows with previous
;;       indexes contain a queen

;; Stub:
#; (define (v2-solved? i n) false)

;; Tests: <used the same tests as v1, but with inputs adapted to this function>
(check-expect (v2-solved? 1 1) true)
(check-expect (v2-solved? 0 4) false)
(check-expect (v2-solved? 1 4) false)
(check-expect (v2-solved? 2 4) false)
(check-expect (v2-solved? 3 4) false)
(check-expect (v2-solved? 4 4) true)

;; Template: <used template for Natural>
(define (v2-solved? i n)
  (= i n))


;; Board Natural (listof Position) (listof Position) -> (listof Board)
;; produce the list of all the valid boards that are one move distant from given board, b,
;; given the list of positions of current row index, lop, where the next queen placement
;; (move) will happen, a list of positions from the start to the current row, lor, and b's
;; side length, n
;; NOTE: this function may return empty - there can be boards with no possible next moves;
;;       therefore, we need to backtrack

;; Stub:
#; (define (next-boards b n lop lor) empty)

;; Tests:
(check-expect (next-boards 4-QUEENS 4 (list 0 1 2 3) (list 0 1 2 3))
              (list (replace-index 4-QUEENS 0 true)
                    (replace-index 4-QUEENS 1 true)
                    (replace-index 4-QUEENS 2 true)
                    (replace-index 4-QUEENS 3 true)))
(check-expect (next-boards 4i-QUEENS-1 4 (list 4 5 6 7) (build-list 8 identity))
              (list (replace-index 4i-QUEENS-1 7 true)))
(check-expect (next-boards 4i-QUEENS-2 4 (list 8 9 10 11) (build-list 12 identity))
              (list (replace-index 4i-QUEENS-2 8 true)))
(check-expect (next-boards 4i-QUEENS-3 4 (list 12 13 14 15) (build-list 16 identity))
              (list (replace-index 4i-QUEENS-3 14 true)))
(check-expect (next-boards 4i-QUEENS-4 4 (list 8 9 10 11) (build-list 12 identity)) empty)

(define (next-boards b n lop lor)
  (filter-valid-boards n (generate-boards b lop) lor))


;; (listof X) Natural X -> (listof X)
;; produce a new list of any element, X, changing index, i, of given list, l, to value, v
;; ASSUME: 0 <= i < (length l) - which means that while recursing, l will never be empty

;; Stub:
#; (define (replace-index l i v) empty)

;; Tests:
(check-expect (replace-index 4-QUEENS 0 true)
              (append (list true)
                      (build-list 15 (λ (n) false))))
(check-expect (replace-index 4i-QUEENS-1 4 true)
              (append (list false true false false true)
                      (build-list 11 (λ (n) false))))
(check-expect (replace-index 4i-QUEENS-3 14 true)
              (list false true false false
                    false false false true
                    true false false false
                    false false true false))

;; Template: <used template for list>
(define (replace-index l i v)
  (cond [(zero? i) (cons v (rest l))]
        [else
         (cons (first l)
               (replace-index (rest l) (sub1 i) v))]))


;; Board (listof Position) -> (listof Board)
;; produce a list of all possible boards that result from placing a queen on
;; given row positions, lop, on given board b
;; ASSUME: lop has at least length 1, before any recursive calls, so the
;;         function cannot produce empty

;; Stub:
#; (define (generate-boards b lop) (list (list true)))

;; Tests:
(check-expect (generate-boards 4-QUEENS (list 0 1 2 3))
              (list (replace-index 4-QUEENS 0 true)
                    (replace-index 4-QUEENS 1 true)
                    (replace-index 4-QUEENS 2 true)
                    (replace-index 4-QUEENS 3 true)))
(check-expect (generate-boards 4i-QUEENS-1 (list 4 5 6 7))
              (list (replace-index 4i-QUEENS-1 4 true)
                    (replace-index 4i-QUEENS-1 5 true)
                    (replace-index 4i-QUEENS-1 6 true)
                    (replace-index 4i-QUEENS-1 7 true)))

;; Template: <used template for list>
#; (define (generate-boards b lop)
     (cond [(empty? lop) empty]
           [else
            (cons (replace-index b (first lop) true)
                  (generate-boards b (rest lop)))]))

;; or

;; Template: <used template for built-in abstract function "map">
(define (generate-boards b lop)
  (local [(define (process-position p)
            (replace-index b p true))]
    (map process-position lop)))


;; Natural (listof Board) (listof Position) -> (listof Board)
;; produce a filtered list of valid boards from given list of boards, lob,
;; all the previous positions until current row, lor, and b's side length, n
;; ASSUME: no boards could be valid, so the function can return empty     

;; Stub:
#; (define (filter-valid-boards n lob lor) empty)

;; Tests:
(check-expect (filter-valid-boards 4 (generate-boards 4-QUEENS (list 0 1 2 3))
                                   (list 0 1 2 3))
              (generate-boards 4-QUEENS (list 0 1 2 3)))
(check-expect (filter-valid-boards 4 (generate-boards 4i-QUEENS-1 (list 4 5 6 7))
                                   (build-list 8 identity))
              (list (replace-index 4i-QUEENS-1 7 true)))
(check-expect (filter-valid-boards 4 (generate-boards 4i-QUEENS-2 (list 8 9 10 11))
                                   (build-list 12 identity))
              (list (replace-index 4i-QUEENS-2 8 true)))
(check-expect (filter-valid-boards 4 (generate-boards 4i-QUEENS-3 (list 12 13 14 15))
                                   (build-list 16 identity))
              (list (replace-index 4i-QUEENS-3 14 true)))
(check-expect (filter-valid-boards 4 (generate-boards 4i-QUEENS-4 (list 8 9 10 11))
                                   (build-list 12 identity)) empty)
(check-expect (filter-valid-boards 4 (generate-boards 4i-QUEENS-5 (list 4 5 6 7))
                                   (build-list 8 identity))
              (list (replace-index 4i-QUEENS-5 6 true)
                    (replace-index 4i-QUEENS-5 7 true)))

;; Template: <used template for built-in abstract function "filter">
(define (filter-valid-boards n lob lor)
  (filter (λ (b) (valid? b n lor)) lob))


;; (listof X) Index -> (listof X)
;; produce all elements of given list, l, with index less than or equal to given index, i
;; ASSUME: 0 <= i < (length l)

;; Stub:
#; (define (index->current l i) empty)

;; Tests:
(check-expect (index->current 4-QUEENS 4)
              (build-list 5 (λ (n) false)))
(check-expect (index->current 4i-QUEENS-1 6)
              (list false true false false
                    false false false))
(check-expect (index->current (list 1 2 3 4 5 6 7 8) 5)
              (list 1 2 3 4 5 6))
(check-expect (index->current (list (list 0 1 2 3)
                                    (list 4 5 6 7)
                                    (list 8 9 10 11)) 2)
              (list (list 0 1 2 3)
                    (list 4 5 6 7)
                    (list 8 9 10 11)))

;; Template: <used template for list>
(define (index->current l i)
  (cond [(zero? i) (cons (first l) empty)]
        [else
         (cons (first l)
               (index->current (rest l) (sub1 i)))]))


;; (listof (listof Position)) Natural -> (listof Position)
;; produce a list of all positions from the start to row's given index, i, positions
;; from all the rows positions, rows
;; ASSUME: 0 <= i < (length rows)

;; Stub:
#; (define (current-rows rows i) empty)

;; Tests:
(check-expect (current-rows (list (list 0 1)
                                  (list 2 3)) 0) (list 0 1))
(check-expect (current-rows (generate-rows 4) 3) (build-list 16 identity))

;; Template: <used template for built-in abstract function "foldr">
#; (define (current-rows rows i)
     (foldr append empty (index->current rows i)))

;; or

;; Template: <used template for list>
(define (current-rows rows i)
  (cond [(zero? i) (first rows)]
        [else
         (append (first rows)
                 (current-rows (rest rows) (sub1 i)))]))


;; Board Natural (listof Position) -> Boolean
;; produce true if given board, b, is valid; otherwise produce false, given the
;; previous positions until the current row, lor, and the board's side length, n

;; Stub:
#; (define (valid? b n lor) false)

;; Tests:
(check-expect (valid? 4-QUEENS 1 (list 0 1 2 3)) true)
(check-expect (valid? 4i-QUEENS-5 4 (build-list 8 identity)) true)
(check-expect (valid? 4i-QUEENS-6 4 (build-list 12 identity)) false)
(check-expect (valid? 4i-QUEENS-7 4 (build-list 12 identity)) false)

#; (define (valid? b n lor)
     (local [;; (listof Position)
             ;; list of positions of all queens in given board, b

             (define ALL-QUEENS (filter-queens-positions b lor))


             ;; Board (listof Position) -> Boolean
             ;; produce true if all queens of given list of queen's positions, loq, do not attack each other;
             ;; otherwise produce false
             ;; NOTE: a queen attacks every square in its row, its column, and both of its diagonals

             ;; Stub:
             #; (define (valid-queens b loq) false)

             ;; Template: <used template for list>
             (define (valid--loq? b loq)
               (cond [(empty? loq) true]
                     [else
                      (and (valid--queen? b (first loq) ALL-QUEENS)
                           (valid--loq? b (rest loq)))]))


             ;; Board Position (listof Position) -> Boolean
             ;; produce true if given queen position, q, is not attacking the other queens in given
             ;; list of queen's positions, loq
             ;; NOTE: a queen attacks every square in its row, its column, and both of its diagonals
          
             ;; Stub:
             #; (define (valid--queen? b q loq) false)

             ;; Template: <used template for (listof Position)>
             (define (valid--queen? b q loq)
               (cond [(= q (first loq)) true]
                     [(empty? loq) true]
                     [else
                      (and (queens-attack? q (first loq) n)
                           (valid--queen? b q (rest loq)))]))]
    
       (valid--loq? b ALL-QUEENS)))

;; or by only checking if the last queen is valid instead of all of them
;; since the validity of all the previous queens has already been verified

(define (valid? b n lor)
  (local [;; (listof Position)
          ;; list of positions of all queens in given board, b
          ;; NOTE: if this constant is empty then the board is valid, because there are no queens

          (define ALL-QUEENS (filter-queens-positions b lor))


          ;; Board Position (listof Position) -> Boolean
          ;; produce true if no queen from given list of queen's positions, loq, on given board, b,
          ;; is being attacked by the queen at given position, q
          ;; ASSUME: since q is the last position of loq, during recursion loq will never be empty
          ;; NOTE: a queen attacks every square in its row, its column, and both of its diagonals

          ;; Stub:
          #; (define (valid-queen? b q loq) false)

          ;; Template: <used template for (listof Position)>
          (define (valid-queen? b q loq)
            (cond [(= q (first loq)) true]
                  [else
                   (and (queens-attack? q (first loq) n)
                        (valid-queen? b q (rest loq)))]))]

    (if (empty? ALL-QUEENS)
        true
        (valid-queen? b (index->value ALL-QUEENS (- (length ALL-QUEENS) 1))
                      ALL-QUEENS))))


;; Board (listof Position) -> (listof Position)
;; produce a list of all queens positions on a given board's, b, positions, lor
;; ASSUME: given board has at least one queen by the time this function is called;
;;         therefore, lor can never be empty

;; Stub:
#; (define (filter-queens-positions b lor) empty)

;; Tests:
(check-expect (filter-queens-positions 4i-QUEENS-1 (list 0 1 2 3)) (list 1))
(check-expect (filter-queens-positions 4i-QUEENS-2 (build-list 8 identity)) (list 1 7))
(check-expect (filter-queens-positions 4i-QUEENS-3 (build-list 12 identity)) (list 1 7 8))
(check-expect (filter-queens-positions 4s-QUEENS (build-list 16 identity)) (list 1 7 8 14))

;; Template: <used template for built-in abstract function "filter">
(define (filter-queens-positions b lor)
  (local [;; Board Position -> Boolean
          ;; produce true if given position, p, represents a square with a queen on given board, b

          ;; Stub:
          #; (define (queen? b p) false)

          ;; Template: <used template from Position>
          (define (queen? b p)
            (not (false? (index->value b p))))]
    
    (filter (λ (p) (queen? b p)) lor)))


;; Position Position Natural -> Boolean
;; produce true if the two queens on a given board, b, with side length, n, with positions,
;; q1 and q2, do not attack each other
;; NOTE: a queen attacks every square in its row, its column, and both of its diagonals

;; Stub:
#; (define (queens-attack? q1 q2 n))

;; Template: <used template from Position>
#; (define (queens-attack? q1 q2 n)
     (local [(define q1-coords (make-coords (remainder q1 n) (quotient q1 n)))
             (define q2-coords (make-coords (remainder q2 n) (quotient q2 n)))]
       (not (or (= (coords-col q1-coords) (coords-col q2-coords))
                (or (= (/ (- (coords-row q1-coords) (coords-row q2-coords))
                          (- (coords-col q1-coords) (coords-col q2-coords))) 1)
                    (= (/ (- (coords-row q1-coords) (coords-row q2-coords))
                          (- (coords-col q1-coords) (coords-col q2-coords))) -1))))))

;; or avoiding slope recomputation

;; Template: <used template for Position>
(define (queens-attack? q1 q2 n)
  (local [(define q1-coords (make-coords (remainder q1 n) (quotient q1 n)))
          (define q2-coords (make-coords (remainder q2 n) (quotient q2 n)))]
    (and (not (= (coords-col q1-coords) (coords-col q2-coords)))
         (not (same-diagonal? q1-coords q2-coords)))))


;; Coordinates Coordinates -> Boolean
;; produce true if the two given coordinates on a board, c1 and c2, share the same diagonal
;; ASSUME: (coords-col c1) is different than (coords-col c2); therefore, there will not be division by 0
;; NOTE: two queens are on the same diagonal if the slope between them is 1 or -1

;; Stub:
#; (define (same-diagonal? c1 c2) false)

;; Tests:
(check-expect (same-diagonal? (make-coords 1 0) (make-coords 3 2)) true)
(check-expect (same-diagonal? (make-coords 3 0) (make-coords 0 2)) false)
(check-expect (same-diagonal? (make-coords 2 3) (make-coords 0 1)) true)

;; Template: <used template from Coordinates>
(define (same-diagonal? c1 c2)
  (local [(define slope (/ (- (coords-row c2) (coords-row c1))
                           (- (coords-col c2) (coords-col c1))))]
    (or (= slope 1) (= slope -1))))


;; Board | false -> Image
;; produce a render of a given board, b, if it exists; otherwise empty-image

;; Stub:
#; (define (render b) empty-image)

;; Tests:
(check-expect (render false) empty-image)
(check-expect (render 4s-QUEENS)
              (above (beside W-E B-Q W-E B-E)
                     (beside B-E W-E B-E W-Q)
                     (beside W-Q B-E W-E B-E)
                     (beside B-E W-E B-Q W-E)))
(check-expect (render 5-QUEENS)
              (above (beside W-Q B-E W-E B-E W-E)
                     (beside B-E W-E B-Q W-E B-E)
                     (beside W-E B-E W-E B-E W-Q)
                     (beside B-E W-Q B-E W-E B-E)
                     (beside W-E B-E W-E B-Q W-E)))

(define (render b)
  (local [;; (listof (listof Position)) Natural -> Image
          ;; produce an image of all the rows in given list of row's positions, lor,
          ;; in b using the given row index, i
          ;; ASSUME: when the function is called for the first time, i is always 0

          ;; Stub:
          #; (define (render--lor lor i) empty-image)

          ;; Template: <used template for (listof (listof Position))>
          (define (render--lor lor i)
            (cond [(empty? lor) empty-image]
                  [else
                   (above (render--row (first lor) (= (remainder i 2) 0))
                          (render--lor (rest lor) (add1 i)))]))


          ;; (listof Position) Boolean -> Image
          ;; produce an image of all the squares in b with position in given
          ;; list of positions, lop, and color white if given boolean, w, is true; otherwise black

          ;; Stub:
          #; (define (render--row lop w) empty-image)

          ;; Template: <used template for (listof Position)>
          (define (render--row lop w)
            (cond [(empty? lop) empty-image]
                  [else
                   (beside (render--square (first lop) w)
                           (render--row (rest lop) (false? w)))]))


          ;; Position Boolean -> Image
          ;; produce an image of square of given position, p, of b in white if
          ;; given boolean, w, is true; otherwise in black

          ;; Stub:
          #; (define (render-square p w) empty-image)

          ;; Template: <used template from Position>
          (define (render--square p w)
            (if (false? (index->value b p))
                (if w W-E B-E)
                (if w W-Q B-Q)))]

    (if (false? b)
        empty-image
        (render--lor (generate-rows (sqrt (length b))) 0))))