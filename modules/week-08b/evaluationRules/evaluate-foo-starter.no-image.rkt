;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname evaluate-foo-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; evaluate-foo-starter.rkt

;PROBLEM:
;
;Hand step the evaluation of (foo 3) given the definition of foo below. 
;We know that you can use the stepper to check your work - please go
;ahead and do that AFTER you try hand stepping it yourself.
;
;(define (foo n)
;  (local [(define x (* 3 n))]
;    (if (even? x)
;        n
;        (+ n (foo (sub1 n))))))

(define (foo n)
  (local [(define x (* 3 n))]
    (if (even? x)
        n
        (+ n (foo (sub1 n))))))

(foo 3)

;; Step 1:
(local [(define x (* 3 3))]
  (if (even? x)
      3
      (+ 3 (foo (sub1 3)))))

;; Step 2:
(define x_0 (* 3 3))
(if (even? x_0)
    3
    (+ 3 (foo (sub1 3))))

;; Step 4:
;(define x_0 9)
(if (even? x_0)
    3
    (+ 3 (foo (sub1 3))))

;; Step 5:
(if (even? 9)
    3
    (+ 3 (foo (sub1 3))))

;; Step 6:
(if #false
    3
    (+ 3 (foo (sub1 3))))

;; Step 7:
(+ 3 (foo (sub1 3)))

;; Step 8:
(+ 3 (foo 2))

;; Step 9:
(+ 3
   (local [(define x (* 3 2))]
     (if (even? x)
         2
         (+ 2 (foo (sub1 2))))))

;; Step 10:
(define x_1 (* 3 2))
(+ 3
   (if (even? x_1)
       2
       (+ 2 (foo (sub1 2)))))

;; Step 11:
;(define x_1 6)
(+ 3
   (if (even? x_1)
       2
       (+ 2 (foo (sub1 2)))))

;; Step 12:
(+ 3
   (if (even? 6)
       2
       (+ 2 (foo (sub1 2)))))

;; Step 12:
(+ 3
   (if #true
       2
       (+ 2 (foo (sub1 2)))))

;; Step 13:
(+ 3 2)

;; Step 14:
5