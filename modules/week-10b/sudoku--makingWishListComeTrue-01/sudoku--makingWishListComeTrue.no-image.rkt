;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sudoku--makingWishListComeTrue.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list) ;gets list-ref, take and drop
        
;; sudoku-starter.rkt

;;
;; Brute force Sudoku solver
;;
;; In Sudoku, the board is a 9x9 grid of SQUARES.
;; There are 9 ROWS and 9 COLUMNS, there are also 9
;; 3x3 BOXES.  Rows, columns and boxes are all UNITs.
;; So there are 27 units.
;;
;; The idea of the game is to fill each square with
;; a Natural[1, 9] such that no unit contains a duplicate
;; number.
;;

;; =================
;; Data definitions:

;; Val is Natural[1, 9]


;; Board is (listof Val|false)   that is 81 elements long
;; interp.
;;  Visually a board is a 9x9 array of squares, where each square
;;  has a row and column number (r, c).  But we represent it as a
;;  single flat list, in which the rows are layed out one after
;;  another in a linear fashion. (See interp. of Pos below for how
;;  we convert back and forth between (r, c) and position in a board.)


;; Pos is Natural[0, 80]
;; interp.
;;  the position of a square on the board, for a given p, then
;;    - the row    is (quotient p 9)
;;    - the column is (remainder p 9)

;; Convert 0-based row and column to Pos
(define (r-c->pos r c) (+ (* r 9) c))  ;helpful for writing tests


;; Unit is (listof Pos) of length 9
;; interp. 
;;  The position of every square in a unit. There are
;;  27 of these for the 9 rows, 9 columns and 9 boxes.


;; ==========
;; Constants:

(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B false) ;B stands for blank


;; Boards:

(define BD1 
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2 
  (list 1 2 3 4 5 6 7 8 9 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD3 
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD4                ;easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ;solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ;hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B 
        B B B B B 6 B B B 
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ;solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ;hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B 
        8 B B B B B B 2 B
        B 7 B B 1 B 5 B B 
        4 B B B B 5 3 B B
        B 1 B B 7 B B B 6
        B B 3 2 B B B 8 B
        B 6 B 5 B B B B 9
        B B 4 B B B B 3 B
        B B B B B 9 7 B B))

(define BD7                 ; no solution 
  (list 1 2 3 4 5 6 7 8 B 
        B B B B B B B B 2 
        B B B B B B B B 3 
        B B B B B B B B 4 
        B B B B B B B B 5
        B B B B B B B B 6
        B B B B B B B B 7
        B B B B B B B B 8
        B B B B B B B B 9))


;; Positions of all the rows, columns and boxes:

(define ROWS
  (list (list  0  1  2  3  4  5  6  7  8)
        (list  9 10 11 12 13 14 15 16 17)
        (list 18 19 20 21 22 23 24 25 26)
        (list 27 28 29 30 31 32 33 34 35)
        (list 36 37 38 39 40 41 42 43 44)
        (list 45 46 47 48 49 50 51 52 53)
        (list 54 55 56 57 58 59 60 61 62)
        (list 63 64 65 66 67 68 69 70 71)
        (list 72 73 74 75 76 77 78 79 80)))

(define COLS
  (list (list 0  9 18 27 36 45 54 63 72)
        (list 1 10 19 28 37 46 55 64 73)
        (list 2 11 20 29 38 47 56 65 74)
        (list 3 12 21 30 39 48 57 66 75)
        (list 4 13 22 31 40 49 58 67 76)
        (list 5 14 23 32 41 50 59 68 77)
        (list 6 15 24 33 42 51 60 69 78)
        (list 7 16 25 34 43 52 61 70 79)
        (list 8 17 26 35 44 53 62 71 80)))

(define BOXES
  (list (list  0  1  2  9 10 11 18 19 20)
        (list  3  4  5 12 13 14 21 22 23)
        (list  6  7  8 15 16 17 24 25 26)
        (list 27 28 29 36 37 38 45 46 47)
        (list 30 31 32 39 40 41 48 49 50)
        (list 33 34 35 42 43 44 51 52 53)
        (list 54 55 56 63 64 65 72 73 74)
        (list 57 58 59 66 67 68 75 76 77)
        (list 60 61 62 69 70 71 78 79 80)))

(define UNITS (append ROWS COLS BOXES))


;; =====================
;; Function Definitions:

;; Board Pos -> Val or false
;; Produce value at given position on board.

;; Tests:
(check-expect (read-square BD2 (r-c->pos 0 5)) 6)
(check-expect (read-square BD3 (r-c->pos 7 0)) 8)

;; "from scratch":
;; this: (r-c->pos 7 0), returns an index: Natural[0, 80]
;; IMPORTANT: board, bd, is never empty

;Function on 2 complex data: Board and Pos.
;We can assume that p is <= (length bd).
;
;              empty     (cons Val-or-False Board)
; 0             XXX         (first bd)
; 
; (add1 p)      XXX         <natural recursion>

#; (define (read-square bd p)
     (cond [(= p 0) (first bd)]
           [else
            (read-square (rest bd) (- p 1))]))

(define (read-square bd p)
  (list-ref bd p))               


;; Board Pos Val -> Board
;; produce new board with val at given position

;; Tests:
(check-expect (fill-square BD1 (r-c->pos 0 0) 1)
              (cons 1 (rest BD1)))

;; "from scratch":
;; IMPORTANT: board, bd, is never empty

;Function on 2 complex data, Board and Pos.
;We can assume that p is <= (length bd).
;
;              empty     (cons Val-or-False Board)
; 0             XXX         (cons nv (rest bd))
; 
; (add1 p)      XXX         (cons (first bd) <natural recursion>)

#; (define (fill-square bd p nv)
     (cond [(= p 0) (cons nv (rest bd))]
           [else (cons (first bd)
                       (fill-square (rest bd) (- p 1) nv))]))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))


;; Board -> Board|false
;; produces a solution a solution for board, bd; or false if board is unsolvable
;; ASSUME: bd is valid

;; Stub:
#; (define (solve bd) false)

;; Tests:
(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)
(check-expect (solve BD7) false)

(define (solve bd)
  (local [(define (solve--board bd)
            (if (solved? bd) ; trivial?
                bd
                (solve--lobd (next-boards bd)))) ; next-problem

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--board (first lobd)))] 
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd))))]))]
    
    (solve--board bd)))


;; Board -> Boolean
;; produce true if board, bd, is solved
;; NOTE: board is valid, so it is solved if it is full

;; Stub:
#; (define (solved? bd) false)

;; Tests:
(check-expect (solved? BD1) false)
(check-expect (solved? BD2) false)
(check-expect (solved? BD4) false)
(check-expect (solved? BD4s) true)
(check-expect (solved? BD5) false)
(check-expect (solved? BD5s) true)
(check-expect (solved? BD6) false)

;; Template:
#; (define (solved? bd)
     (cond [(empty? bd) (...)]
           [else (and (is (first bd) not B - blank)
                      (solved? (rest bd)))]))
;; this is possible because, in Racket, the 'and' function short-circuits its evaluation
;; this means that if any of its arguments evaluates '#f', it immediately returns '#f'

#;(define (solved? bd)
    (cond [(empty? bd) true]
          [else(and (not (false? (read-square bd 0)))
                    (solved? (rest bd)))]))

;; or we can use a built-in abstract function

;; Template:
#; (define (solved? bd)
     (andmap ... bd))

(define (solved? bd)
  (local [(define (predicate s) (not (false? s)))]
    (andmap predicate bd)))


;; Board -> (listof Board)
;; produce list of valid next boards from board, bd
;; finds first empty square, fills it with Natural[1, 9], keeps only the valid boards

;; Stub:
#; (define (next-boards bd) empty)

;; Tests:
(check-expect (next-boards BD1)
              (list (cons 1 (rest BD1)) (cons 2 (rest BD1))
                    (cons 3 (rest BD1)) (cons 4 (rest BD1))
                    (cons 5 (rest BD1)) (cons 6 (rest BD1))
                    (cons 7 (rest BD1)) (cons 8 (rest BD1))
                    (cons 9 (rest BD1))))
(check-expect (next-boards BD2)
              (local [(define auxiliary-BD
                        (list B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B
                              B B B B B B B B B))]
                (list (append (list 1 2 3 4 5 6 7 8 9) (cons 4 auxiliary-BD))
                      (append (list 1 2 3 4 5 6 7 8 9) (cons 5 auxiliary-BD))
                      (append (list 1 2 3 4 5 6 7 8 9) (cons 6 auxiliary-BD))
                      (append (list 1 2 3 4 5 6 7 8 9) (cons 7 auxiliary-BD))
                      (append (list 1 2 3 4 5 6 7 8 9) (cons 8 auxiliary-BD))
                      (append (list 1 2 3 4 5 6 7 8 9) (cons 9 auxiliary-BD)))))
(check-expect (next-boards BD4)
              (list (list 2 7 4 6 9 1 B B 5
                          1 B B 5 B B B 9 B
                          6 B B B B 3 2 8 B
                          B B 1 9 B B B B 8
                          B B 5 1 B B 6 B B
                          7 B B B 8 B B B 3
                          4 B 2 B B B B B 9
                          B B B B B B B 7 B
                          8 B B 3 4 9 B B B)
                    (list 2 7 4 8 9 1 B B 5
                          1 B B 5 B B B 9 B
                          6 B B B B 3 2 8 B
                          B B 1 9 B B B B 8
                          B B 5 1 B B 6 B B
                          7 B B B 8 B B B 3
                          4 B 2 B B B B B 9
                          B B B B B B B 7 B
                          8 B B 3 4 9 B B B)))
(check-expect (next-boards BD5)
              (list (list 5 2 B B B 4 B 7 B
                          B 1 B B 5 B 6 B B
                          B B 4 9 B B B B B
                          B 9 B B B 7 5 B B
                          1 8 B 2 B B B B B 
                          B B B B B 6 B B B 
                          B B 3 B B B B B 8
                          B 6 B B 8 B B B 9
                          B B 8 B 7 B B 3 1)
                    (list 5 3 B B B 4 B 7 B
                          B 1 B B 5 B 6 B B
                          B B 4 9 B B B B B
                          B 9 B B B 7 5 B B
                          1 8 B 2 B B B B B 
                          B B B B B 6 B B B 
                          B B 3 B B B B B 8
                          B 6 B B 8 B B B 9
                          B B 8 B 7 B B 3 1)))
(check-expect (next-boards BD6)
              (list (cons 1 (rest BD6))
                    (cons 2 (rest BD6))
                    (cons 6 (rest BD6))
                    (cons 9 (rest BD6))))
(check-expect (next-boards BD7) empty)
(check-expect (next-boards (cons 1 (rest BD1)))
              (local [(define rest-board (rest (rest BD1)))
                      (define (create-board n)
                        (cons 1 (cons n rest-board)))]
                (list (create-board 2)
                      (create-board 3)
                      (create-board 4)
                      (create-board 5)
                      (create-board 6)
                      (create-board 7)
                      (create-board 8)
                      (create-board 9))))

;; these tests don't make sense because in "solved" we are checking if
;; the board isn't already solved before calling this function
;(check-expect (next-boards BD4s) empty)
;(check-expect (next-boards BD5s) empty)

#; (define (next-boards bd)
     (local [;; Pos -> Pos
             ;; find the first empty square of bd; if it doesn't exist produce empty
             ;; ASSUME: p, the Pos argument, always starts at 0
             ;;         there is an empty space

             ;; Stub:
             #; (define (find-empty p) empty)
             
             (define (find-empty p)
               (cond [(false? (read-square bd p)) p]
                     [else (find-empty (add1 p))]))
             

             (define empty-pos (find-empty 0))
          
             (define p-row (quotient empty-pos 9))
             (define p-col (remainder empty-pos 9))

             (define row-pos (list-ref ROWS p-row))
             (define col-pos (list-ref COLS p-col))
             (define box-pos
               (list-ref BOXES (+ (* (quotient p-row 3) 3)
                                  (quotient p-col 3))))

                    
             ;; Val -> (listof Board)
             ;; produce valid boards with from given bd
             ;; ASSUME: v, the Val argument, always starts at 1

             ;; Stub:
             #; (define (generate-boards v) empty)
             
             (define (generate-boards v)
               (cond [(= v 10) empty]
                     [else (if (valid? v)
                               (cons (fill-square bd empty-pos v)
                                     (generate-boards (add1 v)))
                               (generate-boards (add1 v)))]))

             
             ;; Val Number[0,8] -> Boolean
             ;; produce true if given val, v, in given p on given bd is valid;
             ;; otherwise produce false
             ;; ASSUME: argument c, Number[0,8] always startsat 0

             ;; Stub:
             #; (define (valid? v c) false)

             ;; Template:
             #; (define (valid? v c)
                  (cond [(= c 9) true]
                        [else
                         (row-pos[c] !== v && col-pos[c] !== v &&
                                 box-pos[c] !== v && (valid? v (add1 c)))]))

             #; (define (valid? v c)
                  (cond [(= c 9) true]
                        [else
                         (local [(define row-val (read-square bd (list-ref row-pos c)))
                                 (define col-val (read-square bd (list-ref col-pos c)))
                                 (define box-val (read-square bd (list-ref box-pos c)))]
                           (and (or (false? row-val) (not (= row-val v)))
                                (or (false? col-val) (not (= col-val v)))
                                (or (false? box-val) (not (= box-val v)))
                                (valid? v (add1 c))))]))

             ;; or we can use built-in abstract functions

             ;; Val -> Boolean
             ;; version of previous function; therefore, they share the purpose

             ;; Stub:
             #; (define (valid? v) false)

             ;; Template:
             #; (define (valid? v)
                  (andmap ... (build-list 9 identity))) ;; Natural[0,8]

             (define (valid? v)
               (local [(define (predicate i)
                         (local [(define row-val (read-square bd (list-ref row-pos i)))
                                 (define col-val (read-square bd (list-ref col-pos i)))
                                 (define box-val (read-square bd (list-ref box-pos i)))]
                           (and (or (false? row-val) (not (= row-val v)))
                                (or (false? col-val) (not (= col-val v)))
                                (or (false? box-val) (not (= box-val v))))))]
                 (andmap predicate (build-list 9 identity))))]
       
       (generate-boards 1)))

;; or we can use function composition - this option having worst performance

(define (next-boards bd)
  (keep-only-valid (fill-with-1-9 (find-blank bd) bd)))


;; Board -> Pos
;; produces the position of the first blank square
;; ASSUME: the board has at least one blank square
;; !!!

;; Stub:
(define (find-blank bd) 0)


;; Pos Board -> (listof Board)
;; produce 9 boards, with blank filled with Natural[1, 9]
;; !!!

;; Stub:
(define (fill-with-1-9 p bd) empty)


;; (listof Board) -> (listof Board)
;; produce list containing only valid boards
;; !!!

;; Stub:
(define (keep-only-valid lobd) empty)