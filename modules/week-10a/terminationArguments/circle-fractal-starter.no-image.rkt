;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname circle-fractal-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; circle-fractal-starter.rkt

;PROBLEM :
;
;Design a function that will create the following fractal:
;
;            (open image file)
;
;            
;
;Each circle is surrounded by circles that are two-fifths smaller. 
;
;You can build these images using the convenient beside and above functions
;if you make your actual recursive function be one that just produces the
;top leaf shape. You can then rotate that to produce the other three shapes.
;
;You don't have to use this structure if you are prepared to use more
;complex place-image functions and do some arithmetic. But the approach
;where you use the helper is simpler.
;
;Include a termination argument for your design.

;; =================
;; Constants:

(define STEP (/ 2 5))
(define TRIVIAL-SIZE 5)

;; Number -> Image
;; produce a circle fractal of the given size, s

;; Stub:
#; (define (circle-fractal s) empty-image)

;; Tests
(check-expect (circle-fractal TRIVIAL-SIZE)
              (circle TRIVIAL-SIZE "solid" "blue"))
(check-expect (circle-fractal (/ TRIVIAL-SIZE STEP))
              (local [(define leaf (circle TRIVIAL-SIZE "solid" "blue"))]
                (above leaf
                       (beside leaf (circle (/ TRIVIAL-SIZE STEP) "solid" "blue") leaf)
                       leaf)))
(check-expect (circle-fractal (/ TRIVIAL-SIZE (sqr STEP)))
              (local [(define big-leaf (circle (/ TRIVIAL-SIZE STEP) "solid" "blue"))
                      (define small-leaf (circle TRIVIAL-SIZE "solid" "blue"))
                      (define top (above small-leaf
                                         (beside small-leaf big-leaf small-leaf)))]
                (above top
                       (beside (rotate 90 top) (circle (/ TRIVIAL-SIZE (sqr STEP)) "solid" "blue") (rotate -90 top))
                       (rotate 180 top))))
(check-expect (circle-fractal (/ TRIVIAL-SIZE (* STEP STEP STEP)))
              (local [(define center (circle (/ TRIVIAL-SIZE (* STEP STEP STEP)) "solid" "blue"))
                      (define big-leaf (circle (/ TRIVIAL-SIZE (sqr STEP)) "solid" "blue"))
                      (define medium-leaf (circle (/ TRIVIAL-SIZE STEP) "solid" "blue"))
                      (define small-leaf (circle TRIVIAL-SIZE "solid" "blue"))
                      (define top-small (above small-leaf
                                               (beside small-leaf medium-leaf small-leaf)))
                      (define top-big (above top-small
                                             (beside (rotate 90 top-small) big-leaf (rotate -90 top-small))))]
                (above top-big
                       (beside (rotate 90 top-big) center (rotate -90 top-big))
                       (rotate 180 top-big))))

(define (circle-fractal s)
  (local [(define center (circle s "solid" "blue"))
          (define top (create-top (* s STEP)))]
    (if (<= s TRIVIAL-SIZE)
        center
        (above top
               (beside (rotate 90 top) center (rotate -90 top))
               (rotate 180 top)))))


;; Number -> Image
;; produce top leaf image of center, with given size n

;; Stub:
#; (define (create-top n) empty-image)

;; Tests:
(check-expect (create-top TRIVIAL-SIZE)
              (circle TRIVIAL-SIZE "solid" "blue"))
(check-expect (create-top (/ TRIVIAL-SIZE STEP))
              (local [(define small-leaf (circle TRIVIAL-SIZE "solid" "blue"))]
                (above small-leaf
                       (beside small-leaf (circle (/ TRIVIAL-SIZE STEP) "solid" "blue") small-leaf))))
(check-expect (create-top (/ TRIVIAL-SIZE (sqr STEP)))
              (local [(define leaf (circle TRIVIAL-SIZE "solid" "blue"))
                      (define top (above leaf
                                         (beside leaf (circle (/ TRIVIAL-SIZE STEP) "solid" "blue") leaf)))]
                (above top
                       (beside (rotate 90 top) (circle (/ TRIVIAL-SIZE (sqr STEP)) "solid" "blue") (rotate -90 top)))))

;; Template: <used template for generative recursion>
(define (create-top n)
  (if (<= n TRIVIAL-SIZE)
      (circle n "solid" "blue")
      (local [(define center (circle n "solid" "blue"))
              (define previous-top (create-top (* n STEP)))]
        (above previous-top
               (beside (rotate 90 previous-top) center (rotate -90 previous-top))))))


;Three part termination argument for create-top:
;
;Base case: (<= n TRIVIAL-SIZE)
;
;Reduction step: (* n STEP)
;
;Argument that repeated application of reduction step will eventually
;reach the base case: as long as TRIVIAL-SIZE > 0 & n > 0 repeated
;multiplication by (/ 2 5) will eventually be less than TRIVIAL-SIZE.

