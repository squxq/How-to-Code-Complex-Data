;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname contains-key-tr-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; bt-contains-tr-starter.rkt

;Problem:
;
;Starting with the following data definition for a binary tree (not a binary search tree) 
;design a tail-recursive function called contains? that consumes a key and a binary tree 
;and produces true if the tree contains the key.

;; =================
;; Data Definitions:

(define-struct node (k v l r))
;; BT is one of:
;;  - false
;;  - (make-node Integer String BT BT)
;; Interp. A binary tree, each node has a key, value and 2 children

;; Examples:
(define BT1 false)
(define BT2 (make-node 1 "a"
                       (make-node 6 "f"
                                  (make-node 4 "d" false false)
                                  false)
                       (make-node 7 "g" false false)))

;; Template:
#; (define (fn-for-bt bt)
     (cond [(false? bt) (...)]
           [else
            (... (node-k bt)
                 (node-v bt)
                 (fn-for-bt (node-l bt))
                 (fn-for-bt (node-r bt)))]))


;; =====================
;; Function Definitions:

;; Integer BT -> Boolean
;; produce true if given binary tree, bt, contains given key, k; otherwise false

;; Stub:
#; (define (contains? k bt) false)

;; Tests:
(check-expect (contains? 34 BT1) false)
(check-expect (contains? 34 BT2) false)
(check-expect (contains? 1 BT2) true)
(check-expect (contains? 4 BT2) true)
(check-expect (contains? 7 BT2) true)

;; Template: <used template from BT and for worklist accumulator>
(define (contains? k bt0)
  ;; todo is (listof BT)
  ;; INVARIANT: worklist accumulator - not yet visited nodes in bt0
  
  (local [(define (contains? bt todo)
            (cond [(false? bt)
                   (fn-for-todo todo)]
                  [else
                   (if (= (node-k bt) k)
                       true
                       (contains? (node-l bt) (cons (node-r bt) todo)))]))

          (define (fn-for-todo todo)
            (cond [(empty? todo) false]
                  [else
                   (contains? (first todo) (rest todo))]))]

    (contains? bt0 empty)))
