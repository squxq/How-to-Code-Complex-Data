;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname render-bst-w-lines-faster-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; render-bst-w-lines-faster-starter.rkt

(require 2htdp/image)

;PROBLEM STATEMENT IS AT THE END OF THIS FILE.

;; Constants

(define TEXT-SIZE  14)
(define TEXT-COLOR "BLACK")

(define KEY-VAL-SEPARATOR ":")
(define Y-SEPARATOR (rectangle 1 2 "solid" "white"))
(define X-SEPARATOR (rectangle 10 1 "solid" "white"))
(define LINE-HEIGHT 20)

;; Data definitions:

(define-struct node (key val l r))
;; A BST (Binary Search Tree) is one of:
;;  - false
;;  - (make-node Integer String BST BST)
;; interp. false means no BST, or empty BST
;;         key is the node key
;;         val is the node val
;;         l and r are left and right subtrees
;; INVARIANT: for a given node:
;;     key is > all keys in its l(eft)  child
;;     key is < all keys in its r(ight) child
;;     the same key never appears twice in the tree

;(open image file)

;; Examples:
(define BST0 false)
(define BST1 (make-node 1 "abc" false false))
(define BST7 (make-node 7 "ruf" false false)) 
(define BST4 (make-node 4 "dcj" false (make-node 7 "ruf" false false)))
(define BST3 (make-node 3 "ilk" BST1 BST4))
(define BST42 
  (make-node 42 "ily"
             (make-node 27 "wit" (make-node 14 "olp" false false) false)
             (make-node 50 "dug" false false)))
(define BST10
  (make-node 10 "why" BST3 BST42))
(define BST100 
  (make-node 100 "large" BST10 false))

;; Template:
#;
(define (fn-for-bst t)
  (cond [(false? t) (...)]
        [else
         (... (node-key t)    ;Integer
              (node-val t)    ;String
              (fn-for-bst (node-l t))
              (fn-for-bst (node-r t)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic-distinct: false
;;  - compound: (make-node Integer String BST BST)
;;  - self reference: (node-l t) has type BST
;;  - self reference: (node-r t) has type BST

;; Functions:


;PROBLEM:
;
;Design a function that consumes a bst and produces a SIMPLE 
;rendering of that bst including lines between nodes and their 
;subnodes.

;; BST -> Image
;; produce SIMPLE rendering of bst
;; ASSUME BST is relatively well balanced

;; Stub:
;(define (render-bst bst) empty-image)

;; Tests:
(check-expect (render-bst false) empty-image)
(check-expect (render-bst BST1) (render-key-val 1 "abc"))
(check-expect (render-bst BST7) (render-key-val 7 "ruf"))
(check-expect (render-bst BST4)
              (local [(define render (render-bst BST7))
                      (define render-width (image-width render))]
                (above (render-key-val 4 "dcj")
                         Y-SEPARATOR (create-lines render-width false) Y-SEPARATOR render)))
(check-expect (render-bst BST3)
              (local [(define left-render (render-bst BST1))
                      (define right-render (render-bst BST4))
                      (define left-width (image-width left-render))
                      (define right-width (image-width right-render))]
                (above (render-key-val 3 "ilk")
                         Y-SEPARATOR (create-lines left-width right-width) Y-SEPARATOR
                         (beside/align "top" left-render X-SEPARATOR right-render))))
(check-expect (render-bst (make-node 14 "olp" false false)) (render-key-val 14 "olp"))
(check-expect (render-bst (make-node 50 "dug" false false)) (render-key-val 50 "dug"))
(check-expect (render-bst (make-node 27 "wit" (make-node 14 "olp" false false) false))
              (local [(define render (render-bst (make-node 14 "olp" false false)))
                      (define render-width (image-width render))]
                (above (render-key-val 27 "wit")
                         Y-SEPARATOR (create-lines render-width false) Y-SEPARATOR render)))
(check-expect (render-bst BST42)
              (local [(define left-render
                        (render-bst (make-node 27 "wit" (make-node 14 "olp" false false) false)))
                      (define right-render
                        (render-bst (make-node 50 "dug" false false)))
                      (define left-width (image-width left-render))
                      (define right-width (image-width right-render))]
                (above (render-key-val 42 "ily")
                         Y-SEPARATOR (create-lines left-width right-width) Y-SEPARATOR
                         (beside/align "top" left-render X-SEPARATOR right-render))))
(check-expect (render-bst BST10)
              (local [(define left-render (render-bst BST3))
                      (define right-render (render-bst BST42))
                      (define left-width (image-width left-render))
                      (define right-width (image-width right-render))]
                (above (render-key-val 10 "why")
                         Y-SEPARATOR (create-lines left-width right-width) Y-SEPARATOR
                         (beside/align "top" left-render X-SEPARATOR right-render))))
(check-expect (render-bst BST100)
              (local [(define render (render-bst BST10))
                      (define render-width (image-width render))]
                (above (render-key-val 100 "large")
                         Y-SEPARATOR (create-lines render-width false) Y-SEPARATOR render)))

;; Improved version:
(define (render-bst bst)
  (cond [(false? bst) empty-image]
        [(and (false? (node-l bst)) (false? (node-r bst)))
         (render-key-val (node-key bst) (node-val bst))]
        [else
         (local [(define left-render (render-bst (node-l bst)))
                 (define right-render (render-bst (node-r bst)))
                 (define left-width (image-width left-render))
                 (define right-width (image-width right-render))]
           (cond [(and (not (false? (node-l bst))) (not (false? (node-r bst))))
                  (above (render-key-val (node-key bst) (node-val bst))
                         Y-SEPARATOR (create-lines left-width right-width) Y-SEPARATOR
                         (beside/align "top" left-render X-SEPARATOR right-render))]
                 [(not (false? (node-l bst)))
                  (above (render-key-val (node-key bst) (node-val bst))
                         Y-SEPARATOR (create-lines left-width false) Y-SEPARATOR left-render)]
                 [else
                  (above (render-key-val (node-key bst) (node-val bst))
                         Y-SEPARATOR (create-lines right-width false) Y-SEPARATOR right-render)]))]))

;; Integer String -> Image
;; render key and value to form the body of a node

;; Stub:
;(define (render-key-val k v) empty-image)

;; Tests:
(check-expect (render-key-val 1 "abc")
              (text (string-append "1" KEY-VAL-SEPARATOR "abc") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 7 "ruf")
              (text (string-append "7" KEY-VAL-SEPARATOR "ruf") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 4 "dcj")
              (text (string-append "4" KEY-VAL-SEPARATOR "dcj") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 3 "ilk")
              (text (string-append "3" KEY-VAL-SEPARATOR "ilk") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 27 "wit")
              (text (string-append "27" KEY-VAL-SEPARATOR "wit") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 42 "ily")
              (text (string-append "42" KEY-VAL-SEPARATOR "ily") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 10 "why")
              (text (string-append "10" KEY-VAL-SEPARATOR "why") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 100 "large")
              (text (string-append "100" KEY-VAL-SEPARATOR "large") TEXT-SIZE TEXT-COLOR))
(check-expect (render-key-val 99 "foo") 
              (text (string-append "99" KEY-VAL-SEPARATOR "foo") TEXT-SIZE TEXT-COLOR))

(define (render-key-val k v)
  (text (string-append (number->string k) KEY-VAL-SEPARATOR v) TEXT-SIZE TEXT-COLOR))


;; Natural (Natural or false) -> Image
;; produce lines to l/r subtrees based on width of those subtrees, w1 and w2, (if they exist)
;; NOTE: if (false? w2) then there is only one child, otherwise there are two children

;; Stub:
;(define (create-lines w1 w2) empty-image)

;; Tests:
(check-expect (create-lines 30 false)
              (add-line (rectangle 30 LINE-HEIGHT "solid" "white")
                      15 0 15 LINE-HEIGHT "black"))
(check-expect (create-lines 60 130)
              (add-line (add-line (rectangle (+ 60 130) LINE-HEIGHT "solid" "white")
                                  (/ (+ 60 130) 2) 0
                                  (/ 60 2)         LINE-HEIGHT
                                  "black")
                        (/ (+ 60 130) 2) 0
                        (+ 60 (/ 130 2)) LINE-HEIGHT
                        "black"))

(define (create-lines w1 w2)
  (local [(define (create-line w)
            (add-line (rectangle w LINE-HEIGHT "solid" "white")
                      (/ w 2) 0 (/ w 2) LINE-HEIGHT "black"))
          (define (create-lines lw rw)
            (add-line (add-line (rectangle (+ lw rw) LINE-HEIGHT "solid" "white")
                                (/ (+ lw rw) 2)  0
                                (/ lw 2)         LINE-HEIGHT
                                "black")
                      (/ (+ lw rw) 2)  0
                      (+ lw (/ rw 2))  LINE-HEIGHT
                      "black"))]
    (if (false? w2)
        (create-line w1)
        (create-lines w1 w2))))


;; BST -> Natural
;; given a bst return its size (number of nodes)

;; Stub:
;(define (size-bst bst) 0)

;; Tests:
(check-expect (size-bst BST0) 0)
(check-expect (size-bst BST1) 1)
(check-expect (size-bst BST7) 1)
(check-expect (size-bst BST4) 2)
(check-expect (size-bst BST3) 4)
(check-expect (size-bst BST42) 4)
(check-expect (size-bst BST10) 9)
(check-expect (size-bst BST100) 10)

(define (size-bst bst)
  (cond [(false? bst) 0]
        [else
         (+ 1 (size-bst (node-l bst))
              (size-bst (node-r bst)))]))


;PROBLEM:
;
;Uncomment out the definitions and expressions below, and then
;construct a simple graph with the size of the tree on the
;x-axis and the time it takes to render it on the y-axis. How
;does the time it takes to render increase as a function of
;the size of the tree? If you can, improve the performance of  
;render-bst.
;
;There is also at least one other good way to use local in this 
;program. Try it. 


;;; These trees are NOT legal binary SEARCH trees.
;;; But for tests on rendering speed that won't matter.
;;; Just don't try searching in them!
;
;(define BSTA (make-node 100 "A" BST10 BST10))
;(define BSTB (make-node 101 "B" BSTA BSTA))
;(define BSTC (make-node 102 "C" BSTB BSTB))
;(define BSTD (make-node 103 "D" BSTC BSTC))
;(define BSTE (make-node 104 "E" BSTD BSTD))
;(define BSTF (make-node 105 "F" BSTE BSTE))
;
;(time (rest (list (render-bst BSTA))))
;(time (rest (list (render-bst BSTB))))
;(time (rest (list (render-bst BSTC))))
;(time (rest (list (render-bst BSTD))))
;(time (rest (list (render-bst BSTE))))

;; These trees are NOT legal binary SEARCH trees.
;; But for tests on rendering speed that won't matter.
;; Just don't try searching in them!

(define BSTA (make-node 101 "A" BST10 BST10))
(define BSTB (make-node 102 "B" BSTA BSTA))
(define BSTC (make-node 103 "C" BSTB BSTB))
(define BSTD (make-node 104 "D" BSTC BSTC))
(define BSTE (make-node 105 "E" BSTD BSTD))
(define BSTF (make-node 106 "F" BSTE BSTE))
(define BSTG (make-node 107 "G" BSTF BSTF))

"time:"
(time (rest (list (render-bst BSTA))))
(time (rest (list (render-bst BSTB))))
(time (rest (list (render-bst BSTC))))
(time (rest (list (render-bst BSTD))))
(time (rest (list (render-bst BSTE))))
(time (rest (list (render-bst BSTF))))
(time (rest (list (render-bst BSTG))))

"size:"
(size-bst BSTA)
(size-bst BSTB)
(size-bst BSTC)
(size-bst BSTD)
(size-bst BSTE)
(size-bst BSTF)
(size-bst BSTG)