;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accounts-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; accounts-starter.rkt

(define-struct node (id name bal l r))
;; Accounts is one of:
;;  - false
;;  - (make-node Natural String Integer Accounts Accounts)
;; interp. a collection of bank accounts
;;   false represents an empty collection of accounts.
;;   (make-node id name bal l r) is a non-empty collection of accounts such that:
;;    - id is an account identification number (and BST key)
;;    - name is the account holder's name
;;    - bal is the account balance in dollars CAD 
;;    - l and r are further collections of accounts
;; INVARIANT: for a given node:
;;     id is > all ids in its l(eft)  child
;;     id is < all ids in its r(ight) child
;;     the same id never appears twice in the collection

;; Examples:
(define ACT0 false)
(define ACT1 (make-node 1 "Mr. Rogers"  22 false false))
(define ACT4 (make-node 4 "Mrs. Doubtfire"  -3
                        false
                        (make-node 7 "Mr. Natural" 13 false false)))
(define ACT3 (make-node 3 "Miss Marple"  600 ACT1 ACT4))
(define ACT42 
  (make-node 42 "Mr. Mom" -79
             (make-node 27 "Mr. Selatcia" 40 
                        (make-node 14 "Mr. Impossible" -9 false false)
                        false)
             (make-node 50 "Miss 604"  16 false false)))
(define ACT10 (make-node 10 "Dr. No" 84 ACT3 ACT42))

;; Template:
#;
(define (fn-for-act act)
  (cond [(false? act) (...)]
        [else
         (... (node-id act)
              (node-name act)
              (node-bal act)
              (fn-for-act (node-l act))
              (fn-for-act (node-r act)))]))


;PROBLEM 1:
;
;Design an abstract function (including signature, purpose, and tests) 
;to simplify the remove-debtors and remove-profs functions defined below.
;
;Now re-define the original remove-debtors and remove-profs functions 
;to use your abstract function. Remember, the signature and tests should 
;not change from the original functions.

;; Accounts -> Accounts
;; remove all accounts with a negative balance

;; Stub:
#; (define (remove-debtors act) act)

;; Tests:
(check-expect (remove-debtors (make-node 1 "Mr. Rogers" 22 false false)) 
              (make-node 1 "Mr. Rogers" 22 false false))

(check-expect (remove-debtors (make-node 14 "Mr. Impossible" -9 false false))
              false)

(check-expect (remove-debtors
               (make-node 27 "Mr. Selatcia" 40
                          (make-node 14 "Mr. Impossible" -9 false false)
                          false))
              (make-node 27 "Mr. Selatcia" 40 false false))

(check-expect (remove-debtors 
               (make-node 4 "Mrs. Doubtfire" -3
                          false 
                          (make-node 7 "Mr. Natural" 13 false false)))
              (make-node 7 "Mr. Natural" 13 false false))

;; Template: <used template from Accounts>
#; (define (remove-debtors act)
     (cond [(false? act) false]
           [else
            (if (negative? (node-bal act))
                (join (remove-debtors (node-l act))
                      (remove-debtors (node-r act)))
                (make-node (node-id act)
                           (node-name act)
                           (node-bal act)
                           (remove-debtors (node-l act))
                           (remove-debtors (node-r act))))]))

;; Template:
#; (define (remove-debtors act)
     (remove-abs ... act))

(define (remove-debtors act)
  (local [(define (debtor? act) (negative? (node-bal act)))]
    (remove-abs debtor? act)))


;; Accounts -> Accounts
;; Remove all professors' accounts.

;; Stub:
#; (define (remove-profs act) act)

;; Tests:
(check-expect (remove-profs (make-node 27 "Mr. Smith" 100000 false false)) 
              (make-node 27 "Mr. Smith" 100000 false false))
(check-expect (remove-profs (make-node 44 "Prof. Longhair" 2 false false)) false)
(check-expect (remove-profs (make-node 67 "Mrs. Dash" 3000
                                       (make-node 9 "Prof. Booty" -60 false false)
                                       false))
              (make-node 67 "Mrs. Dash" 3000 false false))
(check-expect (remove-profs 
               (make-node 97 "Prof. X" 7
                          false 
                          (make-node 112 "Ms. Magazine" 467 false false)))
              (make-node 112 "Ms. Magazine" 467 false false))

;; Template: <used template from Accounts>
#;(define (remove-profs act)
    (cond [(false? act) false]
          [else
           (if (has-prefix? "Prof." (node-name act))
               (join (remove-profs (node-l act))
                     (remove-profs (node-r act)))
               (make-node (node-id act)
                          (node-name act)
                          (node-bal act)
                          (remove-profs (node-l act))
                          (remove-profs (node-r act))))]))

;; Template:
#; (define (remove-profs act)
     (remove-abs ... act))

(define (remove-profs act)
  (local [(define (prof? act) (has-prefix? "Prof." (node-name act)))]
    (remove-abs prof? act)))


;; (Accounts -> Boolean) Accounts -> Accounts
;; remove from the given accounts bst, act, the accounts that satisfy the given predicate, pred

;; Stub:
#; (define (remove-abs pred act) act)

;; Tests:
(check-expect (local [(define (debtor? act) (negative? (node-bal act)))]
                (remove-abs debtor? (make-node 1 "Mr. Rogers" 22 false false)))
              (make-node 1 "Mr. Rogers" 22 false false))
(check-expect (local [(define (debtor? act) (negative? (node-bal act)))]
                (remove-abs debtor? (make-node 14 "Mr. Impossible" -9 false false)))
              false)
(check-expect (local [(define (prof? act) (has-prefix? "Prof." (node-name act)))]
                (remove-abs prof? (make-node 27 "Mr. Smith" 100000 false false)))
              (make-node 27 "Mr. Smith" 100000 false false))
(check-expect (local [(define (prof? act) (has-prefix? "Prof." (node-name act)))]
                (remove-abs prof? (make-node 44 "Prof. Longhair" 2 false false)))
              false)

(define (remove-abs pred act)
  (cond [(false? act) false]
        [else
         (if (pred act)
             (join (remove-abs pred (node-l act))
                   (remove-abs pred (node-r act)))
             (make-node (node-id act)
                        (node-name act)
                        (node-bal act)
                        (remove-abs pred (node-l act))
                        (remove-abs pred (node-r act))))]))


;; String String -> Boolean
;; Determine whether pre is a prefix of str.

;; Tests:
(check-expect (has-prefix? "" "rock") true)
(check-expect (has-prefix? "rock" "rockabilly") true)
(check-expect (has-prefix? "blues" "rhythm and blues") false)

(define (has-prefix? pre str)
  (string=? pre (substring str 0 (string-length pre))))


;; Accounts Accounts -> Accounts
;; Combine two Accounts's into one
;; ASSUMPTION: all ids in act1 are less than the ids in act2

;; Tests:
(check-expect (join ACT42 false) ACT42)
(check-expect (join false ACT42) ACT42)
(check-expect (join ACT1 ACT4) 
              (make-node 4 "Mrs. Doubtfire" -3
                         ACT1
                         (make-node 7 "Mr. Natural" 13 false false)))
(check-expect (join ACT3 ACT42) 
              (make-node 42 "Mr. Mom" -79
                         (make-node 27 "Mr. Selatcia" 40
                                    (make-node 14 "Mr. Impossible" -9
                                               ACT3
                                               false)
                                    false)
                         (make-node 50 "Miss 604" 16 false false)))

(define (join act1 act2)
  (cond [(false? act2) act1]
        [else
         (make-node (node-id act2) 
                    (node-name act2)
                    (node-bal act2)
                    (join act1 (node-l act2))
                    (node-r act2))]))


;PROBLEM 2:
;
;Using your new abstract function, design a function that removes from a given
;BST any account where the name of the account holder has an odd number of
;characters. Call it remove-odd-characters.

;; Accounts -> Accounts
;; remove from the given bst, act, any account where the name of the account holder
;; has an odd number of characters

;; Stub:
#; (define (remove-odd-characters act) act)

;; Tests:
(check-expect (remove-odd-characters ACT0) false)
(check-expect (remove-odd-characters ACT1) ACT1)
(check-expect (remove-odd-characters ACT4)
              (make-node 4 "Mrs. Doubtfire" -3 false false))
(check-expect (remove-odd-characters ACT3)
              (make-node 4 "Mrs. Doubtfire" -3
                         (make-node 1 "Mr. Rogers" 22 false false) false))
(check-expect (remove-odd-characters ACT42)
              (make-node 50 "Miss 604" 16
                         (make-node 27 "Mr. Selatcia" 40
                                    (make-node 14 "Mr. Impossible" -9 false false) false) false))
(check-expect (remove-odd-characters ACT10)
              (make-node 10 "Dr. No" 84
                         (make-node 4 "Mrs. Doubtfire" -3
                                    (make-node 1 "Mr. Rogers" 22 false false) false)
                         (make-node 50 "Miss 604" 16
                                    (make-node 27 "Mr. Selatcia" 40
                                               (make-node 14 "Mr. Impossible" -9 false false) false) false)))

;; Template:
#; (define (remove-odd-characters act)
     (remove-abs ... act))

(define (remove-odd-characters act)
  (local [(define (odd-characters? act) (odd? (string-length (node-name act))))]
    (remove-abs odd-characters? act)))


;Problem 3:
;
;Design an abstract fold function for Accounts called fold-act. 
;
;Use fold-act to design a function called charge-fee that decrements
;the balance of every account in a given collection by the monthly fee of 3 CAD.

;; (Natural String Integer X X -> X) X Accounts -> X
;; the abstract fold function for Accounts

;; Stub:
#; (define (fold-act c b act) X)

;; Tests:
(check-expect (local [(define (decrement id name bal l r) (make-node id name (- bal 3) l r))]
                (fold-act decrement false ACT10))
              (make-node 10 "Dr. No" 81
                         (make-node 3 "Miss Marple"  597
                                    (make-node 1 "Mr. Rogers"  19 false false)
                                    (make-node 4 "Mrs. Doubtfire"  -6
                                               false
                                               (make-node 7 "Mr. Natural" 10 false false)))
                         (make-node 42 "Mr. Mom" -82
                                    (make-node 27 "Mr. Selatcia" 37 
                                               (make-node 14 "Mr. Impossible" -12 false false)
                                               false)
                                    (make-node 50 "Miss 604" 13 false false))))

;; Template: <took template from Accounts>
(define (fold-act c b act)
  (cond [(false? act) b]
        [else
         (c (node-id act)
            (node-name act)
            (node-bal act)
            (fold-act c b (node-l act))
            (fold-act c b (node-r act)))]))


;; Accounts -> Accounts
;; given a collection of bank accounts, act, decrement the balance if every account by 3

;; Stub:
#; (define (charge-fee act) act)

;; Tests:
(check-expect (charge-fee ACT0) false)
(check-expect (charge-fee ACT1)
              (make-node 1 "Mr. Rogers" 19 false false))
(check-expect (charge-fee ACT4)
              (make-node 4 "Mrs. Doubtfire"  -6
                         false
                         (make-node 7 "Mr. Natural" 10 false false)))
(check-expect (charge-fee ACT3)
              (make-node 3 "Miss Marple"  597
                         (make-node 1 "Mr. Rogers"  19 false false)
                         (make-node 4 "Mrs. Doubtfire"  -6
                                    false
                                    (make-node 7 "Mr. Natural" 10 false false))))
(check-expect (charge-fee ACT42)
              (make-node 42 "Mr. Mom" -82
                         (make-node 27 "Mr. Selatcia" 37 
                                    (make-node 14 "Mr. Impossible" -12 false false)
                                    false)
                         (make-node 50 "Miss 604" 13 false false)))
(check-expect (charge-fee ACT10)
              (make-node 10 "Dr. No" 81
                         (make-node 3 "Miss Marple"  597
                                    (make-node 1 "Mr. Rogers"  19 false false)
                                    (make-node 4 "Mrs. Doubtfire"  -6
                                               false
                                               (make-node 7 "Mr. Natural" 10 false false)))
                         (make-node 42 "Mr. Mom" -82
                                    (make-node 27 "Mr. Selatcia" 37 
                                               (make-node 14 "Mr. Impossible" -12 false false)
                                               false)
                                    (make-node 50 "Miss 604" 13 false false))))

;; Template:
#; (define (charge-fee act)
     (fold-act ... ... act))

(define (charge-fee act)
  (local [(define (decrement id name bal l r)
            (make-node id name (- bal 3) l r))]
    (fold-act decrement false act)))


;PROBLEM 4:
;
;Suppose you needed to design a function to look up an account based on its ID.
;Would it be better to design the function using fold-act, or to design the
;function using the fn-for-acts template?  Briefly justify your answer.

;A fold function, also known as a reduce function, is typically used for aggregating values in a collection,
;such as summing up elements or finding the maximum value. It might not be the most suitable choice for a
;simple account lookup, which is more of a search operation rather than an aggregation.
;
;The choice of design template depends on the nature of the operation you're performing. For account
;lookup, data structures tailored for efficient retrieval are likely to be more suitable than fold functions,   
;which are better suited for aggregation operations.
;
;In the context of searching for an account, it is ideal to stop the search as soon as the target directory
;has been found, which is known as short-circuit behavior. Fold functions do not support short-circuiting
;because they process all elements regardless of the intermediate result.
