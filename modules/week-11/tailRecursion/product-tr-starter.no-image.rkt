;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname product-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; product-tr-starter.rkt

;PROBLEM:
;
;(A) Consider the following function that consumes a list of numbers and produces  
;    the product of all the numbers in the list. Use the stepper to analyze the
;    behavior of this function as the list gets larger and larger. 
;    
;(B) Use an accumulator to design a tail-recursive version of product.

;; (listof Number) -> Number
;; produce product of all elements of lon

;; Stub:
#; (define (produce lon) 0)

;; Tests:
(check-expect (product empty) 1)
(check-expect (product (list 2 3 4)) 24)

;; Template: <used template for list>
#; (define (product lon)
     (cond [(empty? lon) 1]
           [else
            (* (first lon)
               (product (rest lon)))]))


#; (product (list 2 3 4))
;; produces this: (* 2 (* 3 (* 4 1)))

;The primary issue with the behavior of a non-tail-recursive function as the data
;gets larger and larger is the potential for stack overflow. In non-tail-recursive
;functions, each recursive call adds a new frame to the call stack. As the recursion
;deepens, the stack grows, and if the depth of the recursion becomes too large, it
;can lead to a stack overflow.
;
;When a stack overflow occurs, it means that the call stack has exceeded its
;available memory, and the program typically crashes. This limitation is inherent
;in many programming languages that rely on a call stack to manage function calls.
;
;Tail-recursive functions, on the other hand, have a special property called tail-call
;optimization (TCO). In a tail-recursive function, the recursive call is the last
;operation performed in the function, and TCO allows the compiler to optimize away
;the need for additional stack frames. This optimization essentially converts the
;recursion into an iterative process, preventing the stack from growing indefinitely
;and mitigating the risk of a stack overflow.
;
;In summary, the problem with non-tail-recursive functions, especially when dealing
;with large datasets, is the potential for stack overflow due to the accumulation
;of stack frames. Tail-recursive functions, with proper optimization, address this
;issue by eliminating the need for additional stack frames in each recursive call.

;; Template: <used template for list and for result-so-far accumulator>
(define (product lon0)
  ;; prod is Number
  ;; INVARIANT: product of all visited numbers of lon0; prod = prod * (first lon)
  
  (local [(define (product lon prod)
            (cond [(empty? lon) prod]
                  [else
                   (product (rest lon)
                            (* prod (first lon)))]))]
    (product lon0 1)))
