;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fold-dir-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; fold-dir-starter.rkt

;In this exercise you will be need to remember the following DDs 
;for an image organizer.

;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

;; Examples:
(define I1 (square 10 "solid" "red"))
(define I2 (square 12 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;; =================
;; Functions:

;PROBLEM A:
;
;Design an abstract fold function for Dir called fold-dir.

;; (String Y Z -> X) (X Y -> Y) (Image Z -> Z) Y Z Dir -> X 
;; the abstract fold function for Dir

;; Stub:
#; (define (fold-dir c1 c2 c3 b1 b2 d) X)

;; Tests:
(check-expect (local [(define (c1 name sub-dirs images)
                        (cons images sub-dirs))]
                (fold-dir c1 cons cons empty empty D4))
              (list (list I1 I2)))
(check-expect (local [(define (c1 name sub-dirs images)
                        (cons images sub-dirs))]
                (fold-dir c1 cons cons empty empty (make-dir "D5" empty (list I3))))
              (list (list I3)))
(check-expect (local [(define (c1 name sub-dirs images)
                        (cons images sub-dirs))]
                (fold-dir c1 cons cons empty empty D6))
              (list empty (list (list I1 I2)) (list (list I3))))

;; Template: <used template from Dir>

(define (fold-dir c1 c2 c3 b1 b2 d)
  (local [(define (fn-for-dir d)                     ; X
            (c1 (dir-name d)                         ; String
                (fn-for-lod (dir-sub-dirs d))        ; Y
                (fn-for-loi (dir-images d))))        ; Z
          
          (define (fn-for-lod lod)                   ; Y
            (cond [(empty? lod) b1]                  ; Y
                  [else
                   (c2 (fn-for-dir (first lod))      ; X
                       (fn-for-lod (rest lod)))]))   ; Y
          
          (define (fn-for-loi loi)                   ; Z
            (cond [(empty? loi) b2]                  ; Z
                  [else
                   (c3 (first loi)                   ; Image
                       (fn-for-loi (rest loi)))]))]  ; Z
    (fn-for-dir d)))


;PROBLEM B:
;
;Design a function that consumes a Dir and produces the number of 
;images in the directory and its sub-directories. 
;Use the fold-dir abstract function.

;; Dir -> Natural
;; given a directory in the organizer, dir, produce the number of images in itself and its sub-directories

;; Stub:
#; (define (n-images d) 0)

;; Tests:
(check-expect (n-images D4) 2)
(check-expect (n-images D5) 1)
(check-expect (n-images D6) 3)

;; Template:
#; (define (n-images d)
     (fold-dir ... ... ... ... ... d))

(define (n-images d)
  (local [(define (c1 name sub-dirs images) (+ sub-dirs images))
          (define (c3 i loi) (add1 loi))]
    (fold-dir c1 + c3 0 0 d)))


;PROBLEM C:
;
;Design a function that consumes a Dir and a String. The function looks in
;dir and all its sub-directories for a directory with the given name. If it
;finds such a directory it should produce true, if not it should produce false. 
;Use the fold-dir abstract function.

;; Dir String -> Boolean
;; look for a directory or sub-directory of the given directory, dir, with the given name, n

;; Stub:
#; (define (find-name d n) false)

;; Tests:
(check-expect (find-name D4 "D5") false)
(check-expect (find-name D5 "D5") true)
(check-expect (find-name D6 "D4") true)
(check-expect (find-name D6 "D5") true)

;; Template:
#; (define (find-name d n)
     (fold-dir ... ... ... ... ... d))

(define (find-name d n)
  (local [(define (c1 name sub-dirs images)
            (if (string=? n name) true sub-dirs))
          (define (c2 d lod) (or d lod))]
    (fold-dir c1 c2 cons false empty d)))
;; NOTE: c3 and b2 are not needed

;PROBLEM D:
;
;Is fold-dir really the best way to code the function from part C? Why or 
;why not?

;The fold functions (such as 'foldr' or 'foldl') operate by iterating over a data
;structure and applying a folding function to combine elements in a specific way.
;When it comes to searching for a specific element, like findind a directory with
;the right name, using a fold operation doesn't allow for early termination because
;the fold function processes all elements in the data structure.
;
;In the context of searching for a directory, it is ideal to stop the search as soon
;as the target directory has been found, which is known as short-circuit behavior.
;Fold functions do not support short-circuiting because they process all elements
;regardless of the intermediate result.
