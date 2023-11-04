;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname image-organizer-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; image-organizer-starter.rkt

;PROBLEM:
;
;Complete the design of a hierarchical image organizer.  The information and data
;for this problem are similar to the file system example in the fs-starter.rkt file. 
;But there are some key differences:
;  - this data is designed to keep a hierchical collection of images
;  - in this data a directory keeps its sub-directories in a separate list from
;    the images it contains
;  - as a consequence data and images are two clearly separate types
;  
;Start by carefully reviewing the partial data definitions below. 

;; =================
;; Constants:

(define FONT-SIZE 24)
(define FONT-COLOR "black")
(define VERTICAL-SPACE (rectangle 100 15 "solid" "transparent"))

;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String
;;                  ListOfDir --> Mutual Reference
;;                  ListOfImage) --> Reference
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir --> Mutual Reference
;;          ListOfDir) --> Self-Reference
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage) --> Self-Reference
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

;; Examples: <Image>
(define I1 (square 10 "solid" "red"))
(define I2 (square 10 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))

;; Examples: <Dir && ListOfDir>
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;PART A:
;
;Annotate the type comments with reference arrows and label each one to say 
;whether it is a reference, self-reference or mutual-reference.
;
;PART B:
;
;Write out the templates for Dir, ListOfDir and ListOfImage. Identify for each 
;call to a template function which arrow from part A it corresponds to.

;; Template: <Dir>
#;
(define (fn-for-dir d)
  (... (dir-name d)
       (fn-for-lod (dir-sub-dirs d)) ; --> Mutual Reference to "ListOfDir"
       (fn-for-loi (dir-images d)))) ; --> Reference to "ListOfImage"

;; Template: <ListOfDir>
#;
(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else (...
               (fn-for-dir (first lod))    ; --> Mutual Reference to "Dir"
               (fn-for-lod (rest lod)))])) ; --> Self-Reference to "ListOfDir"

;; Template: <ListOfImage>
#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else (...
               (first loi)
               (fn-for-loi (rest loi)))])) ; --> Self-Reference to "ListOfImage"

;; =================
;; Functions:
  
;PROBLEM B:
;
;Design a function to calculate the total size (width* height) of all the images 
;in a directory and its sub-directories.

;; Dir -> Natural (natural + (natural * natural) = natural)
;; ListOfDir -> Natural
;; ListOfImage -> Natural
;; calculate the total size (width * height) of all the images in a directory and its sub-directories

;; Stubs:
;(define (calculate-size--dir d) 0)
;(define (calculate-size--lod lod) 0)
;(define (calculate-size--loi loi) 0)

;; Tests:
(check-expect (calculate-size--lod empty) 0)
(check-expect (calculate-size--loi empty) 0)
(check-expect (calculate-size--dir D4) 200)
(check-expect (calculate-size--loi (list I3)) (* 13 14))
(check-expect (calculate-size--dir D5) (* 13 14))
(check-expect (calculate-size--loi (list I1 I2)) 200)
(check-expect (calculate-size--lod (list D4 D5)) (+ 200 (* 13 14)))
(check-expect (calculate-size--dir D6) (+ 200 (* 13 14)))

;; Template: <Dir>
(define (calculate-size--dir d)
  (+ (calculate-size--lod (dir-sub-dirs d))
      (calculate-size--loi (dir-images d))))

;; Template: <ListOfDir>
(define (calculate-size--lod lod)
  (cond [(empty? lod) 0]
        [else (+ (calculate-size--dir (first lod))
               (calculate-size--lod (rest lod)))]))

;; Template: <ListOfImage>
(define (calculate-size--loi loi)
  (cond [(empty? loi) 0]
        [else (+ (* (image-width (first loi)) (image-height (first loi)))
               (calculate-size--loi (rest loi)))]))


;; Image -> Natural
;; given an image, i, produce its area (width * height)

;; Stub:
#;
(define (image-area i) 0)

;; Tests:
(check-expect (image-area I1) 100)
(check-expect (image-area I2) 100)
(check-expect (image-area I3) (* 13 14))

;; Template:
#;
(define (image-area i)
  (... i))

(define (image-area i)
  (* (image-width i) (image-height i)))


;PROBLEM C:
;
;Design a function to produce rendering of a directory with its images. Keep it 
;simple and be sure to spend the first 10 minutes of your work with paper and 
;pencil!

;; Dir -> Image
;; ListOfDir -> Image
;; ListOfImage -> Image
;; produce the rendering of a directory with its images

;; Stubs:
;(define (render--dir d) empty-image)
;(define (render--lod lod) empty-image)
;(define (render--loi loi) empty-image)

;; Tests:
(check-expect (render--lod empty) empty-image)
(check-expect (render--loi empty) empty-image)
(check-expect (render--loi (list I1 I2))
              (beside I1 I2))
(check-expect (render--loi (list I3)) I3)
(check-expect (render--lod (list D4 D5))
              (beside (render--dir D4)
                      (render--dir D5)))
(check-expect (render--dir D4)
              (above (text "D4" FONT-SIZE FONT-COLOR)
                     (render--loi (list I1 I2))
                     VERTICAL-SPACE
                     (render--lod empty)))
(check-expect (render--dir D5)
              (above (text "D5" FONT-SIZE FONT-COLOR)
                     (render--loi (list I3))
                     VERTICAL-SPACE
                     (render--lod empty)))
(check-expect (render--dir D6)
              (above (text "D6" FONT-SIZE FONT-COLOR)
                     (render--loi empty)
                     VERTICAL-SPACE
                     (render--lod (list D4 D5))))

;; Template: <Dir>
(define (render--dir d)
  (above (text (dir-name d) FONT-SIZE FONT-COLOR)
         (render--loi (dir-images d))
         VERTICAL-SPACE
         (render--lod (dir-sub-dirs d))))

;; Template: <ListOfDir>
(define (render--lod lod)
  (cond [(empty? lod) empty-image]
        [else (beside
               (render--dir (first lod))
               (render--lod (rest lod)))]))

;; Template: <ListOfImage>
(define (render--loi loi)
  (cond [(empty? loi) empty-image]
        [else (beside
               (first loi)
               (render--loi (rest loi)))]))