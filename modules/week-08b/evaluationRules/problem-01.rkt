;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (foo x)
  (local [(define (bar y) (+ x y))]
          (+ x (bar (* 2 x)))))

; Evaluate the following expression:
(list (foo 2) (foo 3))

;; Step 1:
(list (local [(define (bar y) (+ 2 y))]
          (+ 2 (bar (* 2 2))))
      (foo 3))

;; Step 2:
(define (bar_0 y) (+ 2 y))
(list (+ 2 (bar_0 (* 2 2)))
      (foo 3))

;; Step 3:
(list (+ 2 (bar_0 4))
      (foo 3))

;; Step 4:
(list (+ 2 (+ 2 4))
      (foo 3))

;; Step 5:
(list (+ 2 6)
      (foo 3))

;; Step 6:
(list 8 (foo 3))

;; Step 7:
(list 8
      (local [(define (bar y) (+ 3 y))]
          (+ 3 (bar (* 2 3)))))

;; Step 8:
(define (bar_1 y) (+ 3 y))
(list 8
      (+ 3 (bar_1 (* 2 3))))

;; Step 9:
(list 8
      (+ 3 (bar_1 6)))

;; Step 10:
(list 8
      (+ 3 (+ 3 6)))

;; Step 11:
(list 8
      (+ 3 9))

;; Step 12:
(list 8 12)