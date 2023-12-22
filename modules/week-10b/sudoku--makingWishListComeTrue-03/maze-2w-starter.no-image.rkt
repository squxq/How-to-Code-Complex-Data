;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname maze-2w-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;In this problem set you will design a program to check whether a given simple maze is
;solvable.  Note that you are operating on VERY SIMPLE mazes, specifically:
;
;   - all of your mazes will be square
;   - the maze always starts in the upper left corner and ends in the lower right corner
;   - at each move, you can only move down or right
;
;Design a representation for mazes, and then design a function that consumes a maze and
;produces true if the maze is solvable, false otherwise.
;
;Solvable means that it is possible to start at the upper left, and make it all the way to
;the lower right.  Your final path can only move down or right one square at a time. BUT, it
;is permissible to backtrack if you reach a dead end.
;
;For example, the first three mazes below are solvable.  Note that the fourth is not solvable
;because it would require moving left. In this solver you only need to support moving down
;and right! Moving in all four directions introduces complications we are not yet ready for.
;
;    (open image file)
;
;
;Your function will of course have a number of helpers. Use everything you have learned so far
;this term to design this program. 
;
;One big hint. Remember that we avoid using an image based representation of information unless
;we have to. So the above are RENDERINGs of mazes. You should design a data definition that
;represents such mazes, but don't use images as your representation.
;
;For extra fun, once you are done, design a function that consumes a maze and produces a
;rendering of it, similar to the above images.


;; Solve Simple Maze

;; All of the mazes must be square
;; The maze always starts in the upper left corner and ends in the lower right corner
;; At each move, it is only possible to move down or right

;; Constants:

(define MAZE0 (list 0 1 1 1 1
                    0 0 1 0 0
                    1 0 1 1 1
                    0 0 1 1 1
                    0 0 0 0 0))

(define MAZE1 (list 0 0 0 0 0
                    0 1 1 1 0
                    0 1 1 1 0
                    0 1 1 1 0
                    0 1 1 1 0))

(define MAZE2 (list 0 0 0 0 0
                    0 1 1 1 1
                    0 1 1 1 1
                    0 1 1 1 1
                    0 0 0 0 0))

(define MAZE3 (list 0 0 0 0 0
                    0 1 1 1 0
                    0 1 0 0 0
                    0 1 0 1 1
                    1 1 0 0 0))

(define LENGTH-MAZES-0-3 25)

(define 0S (square 20 "solid" "white"))
(define 1S (square 20 "solid" "black"))


;; Data definitions:

;; Unit is Natural[0, 1]
;; interp. the value of a unit, or square, of the maze
;;         0 means open - so we can move through this
;;         1 means closed - we can't move through this

;; Template:
#; (define (fn-for-unit u)
     (... u))


;; Maze is (listof Unit)
;; interp. a maze is a n^2 array of units, where n is the maze's side
;;         length has a row and column number (r, c). But we represent 
;;         it as a single flat list, in which the rows are layed out 
;;         one after another in a linear fashion.

;; Template:
#; (define (fn-for-maze m)
     (cond [(empty? m) (...)]
           [else
            (... (fn-for-unit (first m))
                 (fn-for-maze (rest m)))]))


;; Index is Natural[0, (length m) - 1]
;; interp. the index of a unit on the maze, for a given index, i:
;;         row = (quotient i n)
;;         column = (remainder i n)
;;         where n is the maze's side length

;; Template:
#; (define (fn-for-index i)
     (... i))


;; Functions:

;; Maze -> Boolean
;; produce true if given maze, m, is solvable
;; solvable means: Solvable means that it is possible to start at the upper left,
;;                 and make it all the way to the lower right. The final path can
;;                 only move down or right one square at a time. But, it is
;;                 permissible to backtrack.
;; ASSUME: at index = 0 of m, unit = 0

;; Stub:
#; (define (solvable? m) false)

;; Tests:
(check-expect (solvable? MAZE0) true)
(check-expect (solvable? MAZE1) true)
(check-expect (solvable? MAZE2) true)
(check-expect (solvable? MAZE3) false)

;; Template:
(define (solvable? m)
  (local [(define maze-length (length m))

          ;; Index -> Boolean
          ;; produce true if given index, i is equal to last index
          ;; otherwise check if any of its children are

          ;; Stub:
          #; (define (solvable?--index i) false)

          ;; Template: <used template from Index>
          (define (solvable?--index i)
            (if (= i (- maze-length 1))
                true
                (solvable?--loi (next-indexes m i maze-length))))


          ;; (listof Index) -> Boolean
          ;; produce true if any of the indexes in given loi or their children
          ;; are equal to last index

          ;; Stub:
          #; (define (solvable?--loi loi) false)

          ;; Template: <used template from (listof Index)>
          (define (solvable?--loi loi)
            (cond [(empty? loi) false]
                  [else (or (solvable?--index (first loi))
                            (solvable?--loi (rest loi)))]))]
    (solvable?--index 0)))


;; Maze Index Natural -> (listof Index)
;; produce all of the possible valid indexes that we can reach in one move
;; from given index, i, in maze, m, with length, l
;; NOTES: resulting list of indexes, result, is: 0 <= (length result) <= 2
;;        valid means it is zero: (zero? some-index)

;; Stub:
#; (define (next-indexes m i l) empty)

;; Tests:
(check-expect (next-indexes MAZE0 0 LENGTH-MAZES-0-3) (list 5))
(check-expect (next-indexes MAZE0 8 LENGTH-MAZES-0-3) (list 9))
(check-expect (next-indexes MAZE0 9 LENGTH-MAZES-0-3) empty)
(check-expect (next-indexes MAZE1 20 LENGTH-MAZES-0-3) empty)
(check-expect (next-indexes MAZE2 2 LENGTH-MAZES-0-3) (list 3))
(check-expect (next-indexes MAZE3 15 LENGTH-MAZES-0-3) empty)

(define (next-indexes m i l)
  (local [(define side-length (sqrt l))

          ;; Index (Index -> Boolean) -> (listof Index)
          ;; produce a list of given index, i, if (pred i) is false and the unit in i of m is zero
          ;; otherwise produce empty

          ;; Stub:
          #; (define (valid? i pred) empty)

          ;; Template: <used template from Index>
          (define (valid? i pred)
            (if (and (not (pred i))
                     (zero? (read-index m i)))
                (list i)
                empty))
          
          (define list-1 (valid? (+ 1 i)
                                 (λ (i) (= (remainder i side-length) 0))))
          (define list-2 (valid? (+ side-length i)
                                 (λ (i) (>= i l))))]
    (append list-1 list-2)))


;; Maze Index -> Unit
;; produce the unit of given maze's, m, index, i
;; ASSUME: maze, m, is not, initially, empty
;;         0 <= index, i < (length m)

;; Stub:
#; (define (read-index m i) 0)

;; Tests:
(check-expect (read-index MAZE0 1) 1)
(check-expect (read-index MAZE1 20) 0)
(check-expect (read-index MAZE2 5) 0)

;; Template: <used template from Maze>
(define (read-index m i)
  (cond [(zero? i) (first m)]
        [else (read-index (rest m) (sub1 i))]))


;; Maze -> Image
;; produce a rendering of given maze, m

;; Stub:
#; (define (render m) empty-image)

;; Tests:
(check-expect (render MAZE0)
              (above (beside 0S 1S 1S 1S 1S)
                     (beside 0S 0S 1S 0S 0S)
                     (beside 1S 0S 1S 1S 1S)
                     (beside 0S 0S 1S 1S 1S)
                     (beside 0S 0S 0S 0S 0S)))
(check-expect (render MAZE1)
              (above (beside 0S 0S 0S 0S 0S)
                     (beside 0S 1S 1S 1S 0S)
                     (beside 0S 1S 1S 1S 0S)
                     (beside 0S 1S 1S 1S 0S)
                     (beside 0S 1S 1S 1S 0S)))
(check-expect (render MAZE2)
              (above (beside 0S 0S 0S 0S 0S)
                     (beside 0S 1S 1S 1S 1S)
                     (beside 0S 1S 1S 1S 1S)
                     (beside 0S 1S 1S 1S 1S)
                     (beside 0S 0S 0S 0S 0S)))
(check-expect (render MAZE3)
              (above (beside 0S 0S 0S 0S 0S)
                     (beside 0S 1S 1S 1S 0S)
                     (beside 0S 1S 0S 0S 0S)
                     (beside 0S 1S 0S 1S 1S)
                     (beside 1S 1S 0S 0S 0S)))

(define (render m)
  (local [(define maze-length (length m))
          (define side-length (sqrt maze-length))

          ;; (listof Natural) -> Image
          ;; produce a list of row images for each element, n, in given lon

          ;; Stub:
          #; (define (render--lor lon) empty-image)

          (define (render--lor lon)
            (map (λ (n) (render--row (process-row n))) lon))


          ;; Natural -> Image
          ;; given the index of a row, i, produce its list of unit indexes

          ;; Stub:
          #; (define (process-row i) empty)

          (define (process-row i)
            (build-list side-length (λ (n) (+ n (* side-length i)))))
          

          ;; (listof Index) -> Image
          ;; produce image of row with indexes in given loi

          ;; Stub:
          #; (define (render--row loi) empty-image)

          (define (render--row loi)
            (cond [(empty? loi) empty-image]
                  [else
                   (beside (render-index (first loi))
                           (render--row (rest loi)))]))

          
          ;; Index -> Image
          ;; produce 0S if unit of given index, i, in m is zero; otherwise produce 1S

          ;; Stub:
          #; (define (render-index i) empty-image)
          
          (define (render-index i)
            (if (zero? (read-index m i)) 0S 1S))]
    
    (foldr above empty-image (render--lor (build-list side-length identity)))))