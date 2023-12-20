;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname cantor-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; cantor-starter.rkt

;PROBLEM:
;
;A Cantor Set is another fractal with a nice simple geometry.
;The idea of a Cantor set is to have a bar (or rectangle) of
;a certain width w, then below that are two recursive calls each
;of 1/3 the width, separated by a whitespace of 1/3 the width.
;
;So this means that the
;  width of the whitespace   wc  is  (/ w 3)
;  width of recursive calls  wr  is  (/ (- w wc) 2)
;  
;To make it look better a little extra whitespace is put between
;the bars.
;
;
;Here are a couple of examples (assuming a reasonable CUTOFF)
;
;(cantor CUTOFF) produces:
;
;(open image file)
;
;(cantor (* CUTOFF 3)) produces:
;
;(open image file)
;
;And that keeps building up to something like the following. So
;as it goes it gets wider and taller of course.
;
;(open image file)
;
;
;PROBLEM A:
;
;Design a function that consumes a width and produces a cantor set of 
;the given width.
;
;
;PROBLEM B:
;
;Add a second parameter to your function that controls the percentage 
;of the recursive call that is white each time. Calling your new function
;with a second argument of 1/3 would produce the same images as the old 
;function.
;
;PROBLEM C:
;
;Now you can make a fun world program that works this way:
;  The world state should simply be the most recent x coordinate of the mouse.
;  
;  The to-draw handler should just call your new cantor function with the
;  width of your MTS as its first argument and the last x coordinate of
;  the mouse divided by that width as its second argument.

;; cantor set world program

;; ==========
;; Constants:

(define WIDTH 600)
(define HEIGHT 300)
(define MTS (empty-scene WIDTH HEIGHT))

(define CUTOFF 4)
(define R-HEIGHT 20)
(define V-HEIGHT (/ R-HEIGHT 2))

;; =================
;; Data Definitions:

;; X is Number
;; the current x-coordinate of the mouse

;; Examples:
(define X 0)
(define X1 20)
(define X2 539)

;; Template: <from atomic data: Number>
#; (define (fn-for-x x)
     (... x))

;; =====================
;; Function Definitions:

;; X -> X
;; start the world with: (main X)

(define (main x)
  (big-bang x ;; X
    (to-draw cantor-layer) ;; X -> Image
    (on-mouse update-x))) ;; X Integer Integer MouseEvent -> X


;; Number -> Image
;; layer function that calls cantor with the width of the MTS as its first argument
;; and the last x coordinate of the mouse divided by the width of the MTS as its second argument

;; Stub:
#; (define (cantor-layer x) empty-image)

;; Tests:
(check-expect (cantor-layer 300) (cantor WIDTH (/ 300 WIDTH)))
(check-expect (cantor-layer 20) (cantor WIDTH (/ 20 WIDTH)))

;; Template: <used template for atomic data: Number>

(define (cantor-layer x)
  (cantor WIDTH (/ x WIDTH)))


;; Number Number -> Image
;; produce a cantor set of the given width, w, with the whitespace separating the recursive calls being r * w
;; ASSUME: 0 <= r < 1

;; Stub:
#; (define (cantor w r) empty-image)

;; Tests:
(check-expect (cantor CUTOFF (/ 1 3))
              (rectangle CUTOFF R-HEIGHT "solid" "blue"))
(check-expect (cantor (* CUTOFF 3) (/ 1 3))
              (local [(define rectangle-b (rectangle CUTOFF R-HEIGHT "solid" "blue"))
                      (define gap (rectangle CUTOFF R-HEIGHT "solid" "transparent"))]
                (above (rectangle (* CUTOFF 3) R-HEIGHT "solid" "blue")
                       (rectangle (* CUTOFF 3) V-HEIGHT "solid" "transparent")
                       (beside rectangle-b gap rectangle-b))))
(check-expect (cantor (* CUTOFF 16) (/ 1 4))
              (local [(define wc-1 (* (* CUTOFF 16) (/ 1 4)))
                      (define wr-1 (/ (- (* CUTOFF 16) wc-1) 2))
                      (define rect-1 (rectangle wr-1 R-HEIGHT "solid" "blue"))
                      (define gap-1 (rectangle wc-1 R-HEIGHT "solid" "transparent"))
                      (define v-1 (rectangle wr-1 V-HEIGHT "solid" "transparent"))
                      (define wc-2 (* wr-1 (/ 1 4)))
                      (define wr-2 (/ (- wr-1 wc-2) 2))
                      (define rect-2 (rectangle wr-2 R-HEIGHT "solid" "blue"))
                      (define gap-2 (rectangle wc-2 R-HEIGHT "solid" "transparent"))
                      (define v-2 (rectangle wr-2 V-HEIGHT "solid" "transparent"))
                      (define wc-3 (* wr-2 (/ 1 4)))
                      (define wr-3 (/ (- wr-2 wc-3) 2))
                      (define rect-3 (rectangle wr-3 R-HEIGHT "solid" "blue"))
                      (define gap-3 (rectangle wc-3 R-HEIGHT "solid" "transparent"))
                      (define layer-1 (above rect-2 v-2 (beside rect-3 gap-3 rect-3)))
                      (define layer-2 (above rect-1 v-1 (beside layer-1 gap-2 layer-1)))]
                (above (rectangle (* CUTOFF 16) R-HEIGHT "solid" "blue")
                       (rectangle (* CUTOFF 16) V-HEIGHT "solid" "transparent")
                       (beside layer-2 gap-1 layer-2))))

;; Template: <used template for generative recursion>
(define (cantor w r)
  (local [(define width (abs w))] ; so the world program doesn't crash when hovering outside the screen on the right side
    (if (<= width CUTOFF)
        (rectangle width R-HEIGHT "solid" "blue")
        (local [(define wc (* width r))
                (define wr (/ (- width wc) 2))
                (define child (cantor wr r))
                (define gap (rectangle wc R-HEIGHT "solid" "transparent"))]
          (above (rectangle width R-HEIGHT "solid" "blue")
                 (rectangle width V-HEIGHT "solid" "transparent")
                 (beside child gap child))))))

;Three part termination argument for cantor:
;
;Base case: (<= width CUTOFF), width of the
;rectangle to be drawn is less than or equal CUTOFF.
;
;Reduction step: (/ (- width (* width r)) 2), from the
;difference of width and its product with r, 0 <= r < 1,
;divide by two. Multiplication by a number greater than 0
;and smaller than 1, has a reduction effect, aswell as
;dividind by 2.
;
;Argument: as long as CUTOFF > 0, and 0 <= r < 1, repeatedly
;multiplying by r and dividing by two will eventually
;reduce width to eventually reach the base case.


;; Number Integer Integer MouseEvent -> Number
;; update x coordinate of the mouse (world state) everytime the mouse moves

;; Stub:
#; (define (update-x ws x y me) ws)

;; Tests:
(check-expect (update-x 400 405 800 "move") 405)
(check-expect (update-x 400 500 800 "button-down") 400)
(check-expect (update-x 400 290 300 "move") 290)

;; Template: <used template for a mouse handler function>
(define (update-x ws x y me)
  (cond [(mouse=? me "move") x]
        [else ws]))
