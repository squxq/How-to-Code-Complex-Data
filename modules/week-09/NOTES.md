# 9: Abstraction

## Module Overview

One of the things that separates good programmers from the other kind is taking the time to improve the structure of their code once it is written. This module covers abstraction, which is a technique for taking highly repetitive code and refactoring out the identical parts to leave behind a shared helper and just the different parts of the original code. The shared helper is called an abstract function because it is more general, or less detailed, than the original code.

Abstraction is a crucial technique for managing complexity in programs. One aspect of this is that it can make programs smaller if the abstract functions are used by many other functions in the system. Another aspect is that it helps separate knowledge domains more clearly in code.

Learning Goals:

- Be able to identify 2 or more functions that are candidates for abstraction.
- Be able to design an abstract function starting with 2 or more highly repetitive functions (or expressions).
- Be able to design an abstract fold function from a template.
- Be able to write signatures for abstract functions.
- Be able to write signatures that use type parameters.
- Be able to identify a function which would benefit from using a built-in abstract function
- Be able to use built-in abstract functions

## From Examples 1

[fromExamples1.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples1/fromExamples1.rkt)

If we have two expressions, that vary only in the position of some value (point of variance) - two highly repetitive expressions - we could take one of the expressions and wrap a function definition around it (in which the parameter stands for the varying value). 

```racket
(* pi (sqr 4)) ; area of circle radius 4
(* pi (sqr 6)) ; area of circle radius 6

(define (area r)
  (* pi (sqr r)))

(area 4) ; area of circle radius 4
(area 6) ; area of circle radius 6
```

Steps:

1. Identify two highly repetitive expressions;
2. Introduce a new function:
- around one copy of repetitive code;
- with a more general name;
- add a parameter for varying position;
- use parameter in varying position.
3. Replace specific expressions:
- with calls to abstract function;
- pass varying value.

This function is more abstract than the specific expressions because it is more general than the specific expressions.

We can do the same thing in these two functions, which only differ in the value they are looking for:

```racket
;; ListOfString -> Boolean
;; produce true if los includes "UBC"

;; Stub:
;(define (contains-ubc? los) false)

;; Tests:
(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? (cons "McGill" empty)) false)
(check-expect (contains-ubc? (cons "UBC" empty)) true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) true)

;; Template: <used template from ListOfString>

(define (contains-ubc? los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) "UBC")
             true
             (contains-ubc? (rest los)))]))

;; ListOfString -> Boolean
;; produce true if los includes "McGill"

;; Stubs:
;(define (contains-mcgill? los) false)

;; Tests:
(check-expect (contains-mcgill? empty) false)
(check-expect (contains-mcgill? (cons "UBC" empty)) false)
(check-expect (contains-mcgill? (cons "McGill" empty)) true)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) true)

;; Template: <used template from ListOfString>

(define (contains-mcgill? los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) "McGill")
             true
             (contains-mcgill? (rest los)))]))
```

Which will look like this, after applying the previous steps:

```racket
(define (contains-ubc? los)
  (contains? "UBC" los))

(define (contains-mcgill? los)
  (contains? "McGill" los))

(define (contains? s los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) s)
             true
             (contains? s (rest los)))]))
```

This function doesn’t have a signature, a purpose, or even tests. Because we started from working code and worked systematically this way, we ended up with working code. This way of arriving at a working function design is called “abstraction from examples”. We work backward, first is the function definition, then the tests, then the purpose, then the signature.

```racket
;; ListOfNumber -> ListOfNumber
;; produce list of sqr of every number in lon

;; Stub:
;(define (squares lon) empty)

;; Tests:
(check-expect (squares empty) empty)
(check-expect (squares (list 3 4)) (list 9 16))

;; Template: <used template from ListOfNumber>

(define (squares lon)
  (map2 sqr lon))

;; ListOfNumber -> ListOfNumber
;; produce list of sqrt of every number in lon

;; Stub:
;(define (square-roots lon) empty)

;; Tests:
(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

;; Template: <used template from ListOfNumber>

(define (square-roots lon)
  (map2 sqrt lon))

(define (map2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map2 fn (rest lon)))]))
```

“map2” is called a higher-order function, so it can: consume one or more functions as its arguments (callback functions); or produce a function. We can achieve something like this in almost every programming language. But there is no other programming language in which the notation for doing it is as simple as it is here.

### Question 21: Problem 1

[problem-01.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples1/problem-01.no-image.rkt)

> Consider the following two functions:
> 

```racket
;; ListOfNumber -> ListOfNumber
;; produce list with only postivie? elements of lon
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

;(define (positive-only lon) empty)   ;stub

(define (positive-only lon)
  (cond [(empty? lon) empty]
        [else 
         (if (positive? (first lon))
             (cons (first lon) 
                   (positive-only (rest lon)))
             (positive-only (rest lon)))]))
             
;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

;(define (negative-only lon) empty)   ;stub

(define (negative-only lon)
  (cond [(empty? lon) empty]
        [else 
         (if (negative? (first lon))
             (cons (first lon) 
                   (negative-only (rest lon)))
             (negative-only (rest lon)))]))
```

> Design an abstract function called filter2 based on these two functions.
> 

```racket
;; ListOfNumber -> ListOfNumber
;; produce list with only positive? elements of lon

;; Stub:
;(define (positive-only lon) empty)

;; Tests:
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

;; Template: <used template from ListOfNumber>

(define (positive-only lon)
  (filter2 positive? lon))

;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon

;; Stub:
;(define (negative-only lon) empty)

;; Tests:
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

;; Template: <used template from ListOfNumber>

(define (negative-only lon)
  (filter2 negative? lon))

(define (filter2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (if (fn (first lon))
             (cons (first lon)
                   (filter2 fn (rest lon)))
             (filter2 fn (rest lon)))]))
```

## From Examples 2

[fromExamples2.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples2/fromExamples2.rkt)

Functions can consume other functions as arguments. Letting us do that makes it possible to easily write abstract functions, which allows us to write other functions that are very short, and very simple to write. After writing the function body, we have to write the tests:

```racket
;; Tests:
(check-expect (contains? "UBC" empty) false)
(check-expect (contains? "UBC" (cons "McGill" empty)) false)
(check-expect (contains? "UBC" (cons "UBC" empty)) true)
(check-expect (contains? "UBC" (cons "McGill" (cons "UBC" empty))) true)
(check-expect (contains? "UBC" (cons "UBC" (cons "McGill" empty))) true)
(check-expect (contains? "Toronto" (cons "UBC" (cons "McGill" empty))) false)

(define (contains? s los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) s)
             true
             (contains? s (rest los)))]))
```

The recipe lets us do the easiest things first; usually, that’s the signature, but in abstract functions, it’s not. The reason we’re going through the recipe backward is that. paradoxically, as we go back toward the signature each step gets harder and harder with abstract functions.

```racket
;; produce true if the given list of strings, los, includes the also given string, s
```

Here, the signature could be abstracted from the more precise signatures easily, but this is not always the case.

For the previously written function, “map2”:

```racket
;; produce list of sqr or sqrt of every number in the given list, lon ; not a good purpose, since the function is more abstract than this
;; given a function, fn, and a list (list n0 n1 ...), lon, produce (list (fn n0) (fn n1) ...)

;; Tests:
(check-expect (map2 sqr empty) empty)
(check-expect (map2 sqr (list 2 4)) (list 4 16))
(check-expect (map2 sqrt (list 16 9)) (list 4 3))
(check-expect (map2 abs (list 2 -3 4)) (list 2 3 4))
```

### Question 22: Problem 1

[problem-01.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples2/problem-01.no-image.rkt)

> From the previous section, we have the following:
> 

```racket
;; ListOfNumber -> ListOfNumber
;; produce list with only positive? elements of lon

;; Stub:
;(define (positive-only lon) empty)

;; Tests:
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

(define (positive-only lon) (filter2 positive? lon))

;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon

;; Stub:
;(define (negative-only lon) empty)

;; Tests:
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

(define (negative-only lon) (filter2 negative? lon))

(define (filter2 pred lon)
  (cond [(empty? lon) empty]
        [else
         (if (pred (first lon))
             (cons (first lon)
                   (filter2 pred (rest lon)))
             (filter2 pred (rest lon)))]))
```

> Continue working on the design of this abstract function by completing the purpose and “check-expects” for “filter2”.
> 

```racket
;; produce only the elements of the given list, lon, that satisfy the predicate, pred

;; Tests:
(check-expect (filter2 positive? empty) empty)
(check-expect (filter2 negative? (list 1 -2 3 -4)) (list -2 -4))
(check-expect (filter2 positive? (list -5 -513 875 -20835 094)) (list 875 094))

(define (filter2 pred lon)
  (cond [(empty? lon) empty]
        [else
         (if (pred (first lon))
             (cons (first lon)
                   (filter2 pred (rest lon)))
             (filter2 pred (rest lon)))]))
```

## From Examples 3

[fromExamples3.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples3/fromExamples3.rkt)

The signatures come last because with abstract functions they can sometimes be the hardest thing to do. The way the signatures are done is a bit different than the way they have been done before. I’m going to look at the code and read the signature off of it. Some programming languages do a thing like this automatically, and it’s called type inference. For the “contains?” function:

```racket
(define (contains? s los)
  (cond [(empty? los) false] ; here
        [else
         (if (string=? (first los) s)
             true ; here
             (contains? s (rest los)))]))
```

These are the only places where the function is producing a value. In the false part of the “if statement” it calls itself again. So, true and false are the only outputs. The function, therefore, produces a boolean.

We can also see that the first argument to “contains?”, s, is used as an argument to “string=”. “string=” requires both of its arguments to be strings. Therefore, s has to be a string.

If X is some type (i.e. String, Number, Image, etc):

```racket
; (listof X) is like ListOfX, where:
;; ListOfX is one of:
;; - empty
;; - (cons X ListOfX)
; except it is not needed the data definition for (listof X)
```

The signature of “contains?”:

```racket
;; String (listof String) -> Boolean
```

For the function “map2”. 

```racket
(define (map2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map2 fn (rest lon)))]))
```

The first argument, fn, is a function. In the signature of a higher order function, the type of a function parameter is that function’s signature wrapped in parentheses. 

We can also clearly see that the function produces a list. What do we know about the elements of the list? To figure that out, I should look for a place that calls “first” on the list. We can notice that only fn operates on “(first lon)”. “map2” itself never operates on it. The elements of the list, as far as “map2” is concerned, can be anything, but they have to be something that fn is prepared to accept.

We are going to use a type parameter, which, by convention are uppercase, single letters of the alphabet (i.e. X, Y, Z, A, B). “map2”, also, never really operates on what the function produces.

```racket
;; (X -> Y) (listof X) -> (listof Y)
```

The signature of “map2” says: give it a function that consumes X and produces Y. Give it a list of X, and it will give you a list of Y.

> Write a “check-expect” for “map2” using “string-length” as fn.
> 

```racket
(check-expect (map2 string-length (list "ajshdfgasf" "afsdguyoifavewyawegfaesfg" "hsf" "alusdgfauyosgvawueyigfvuaysedf"))
              (list 10 25 3 30))
```

So far, there have been introduced three new pieces of notation:

- The (listof X) type instead of ListOfX;
- When a function is passed as an argument, we write its signature in parentheses in the larger signature;
- Use of type parameters makes sure types are consistent where they need to be (remember: (listof X) just means (listof <some type>)).

For the “filter2” function:

```racket
;; (X -> Boolean) (listof X) -> (listof X)
```

That’s the process of inferring the signature for an abstract function by looking at the code for the abstract function, and, piece by piece, inferring what I can about the types of arguments the abstract function consumes and the type of result the abstract function produces.

### Question 23: Problem 1

[problem-01.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples3/problem-01.no-image.rkt)

> The following is a nearly completed design of an abstract function from two examples of repetitive code. All that's missing is the signature.
> 

```racket
;; ListOfNumber -> Boolean
;; produce true if every number in lon is positive

;; Tests:
(check-expect (all-positive? empty) true)
(check-expect (all-positive? (list 1 -2 3)) false)
(check-expect (all-positive? (list 1 2 3)) true)

(define (all-positive? lon) (andmap2 positive? lon))

;; ListOfNumber -> Boolean
;; produce true if every number in lon is negative

;; Tests:
(check-expect (all-negative? empty) true)
(check-expect (all-negative? (list 1 -2 3)) false)
(check-expect (all-negative? (list -1 -2 -3)) true)

(define (all-negative? lon) (andmap2 negative? lon))

;; (A -> Boolean) (listof A) -> Boolean
;;produce true if pred produces true for every element of the list

;; Tests:
(check-expect (andmap2 positive? empty) true)
(check-expect (andmap2 positive? (list 1 -2 3)) false)
(check-expect (andmap2 positive? (list 1 2 3)) true)
(check-expect (andmap2 negative? (list -1 -2 -3)) true)

(define (andmap2 pred lst)
  (cond [(empty? lst) true]
        [else 
         (and (pred (first lst))
              (andmap2 pred (rest lst)))]))
```

### Question 24: Abstract Sum

[abstract-sum-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples3/abstract-sum-starter.no-image.rkt)

> Design an abstract function (including signature, purpose, and tests) to simplify the two sum-of functions.
> 

```racket
;; (listof Number) -> Number
;; produce the sum of the squares of the numbers in lon

;; Tests:
(check-expect (sum-of-squares empty) 0)
(check-expect (sum-of-squares (list 2 4)) (+ 4 16))

#; (define (sum-of-squares lon)
     (cond [(empty? lon) 0]
           [else
            (+ (sqr (first lon))
               (sum-of-squares (rest lon)))]))

;; (listof String) -> Number
;; produce the sum of the lengths of the strings in los

;; Tests:
(check-expect (sum-of-lengths empty) 0)
(check-expect (sum-of-lengths (list "a" "bc")) 3)

#; (define (sum-of-lengths los)
     (cond [(empty? los) 0]
           [else
            (+ (string-length (first los))
               (sum-of-lengths (rest los)))]))

;; (x -> Y) (listof X) -> (listof Y)
;; given a function, fn, and a list (list n0 n1 ...), l, produce (list (fn n0) (fn n1) ...)

;; Stub:
#; (define (map2 fn l) l)

;; Tests:
(check-expect (map2 sqr empty) 0)
(check-expect (map2 sqr (list 8 6)) 100)
(check-expect (map2 string-length (list "a" "bc" "def")) 6)

(define (map2 fn l)
  (cond [(empty? l) 0]
        [else
         (+ (fn (first l))
            (map2 fn (rest l)))]))
```

> Now re-define the original functions to use abstract-sum. Remember, the signature and tests should not change from the original functions.
> 

```racket
(define (sum-of-squares lon)
  (map2 sqr lon))

(define (sum-of-lengths los)
  (map2 string-length los))
```

### Question 25: Abstract Some

[abstract-some-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples3/abstract-some-starter.no-image.rkt)

> Design an abstract function called some-pred? (including signature, purpose, and tests) to simplify the following two functions. When you are done rewrite the original functions to use your new some-pred? function.
> 

```racket
;; ListOfNumber -> Boolean
;; produce true if some number in lon is positive

;; Tests:
(check-expect (some-positive? empty) false)
(check-expect (some-positive? (list 2 -3 -4)) true)
(check-expect (some-positive? (list -2 -3 -4)) false)

#;(define (some-positive? lon)
    (cond [(empty? lon) false]
          [else
           (or (positive? (first lon))
               (some-positive? (rest lon)))]))

;; ListOfNumber -> Boolean
;; produce true if some number in lon is negative

;; Tests:
(check-expect (some-negative? empty) false)
(check-expect (some-negative? (list 2 3 -4)) true)
(check-expect (some-negative? (list 2 3 4)) false)

#;(define (some-negative? lon)
    (cond [(empty? lon) false]
          [else
           (or (negative? (first lon))
               (some-negative? (rest lon)))]))

;; (X -> Boolean) (listof X) -> Boolean
;; produce true if any of elements of the given list, l, make the predicate, pred, true

;; Stub:
#; (define (some-pred? pred l) false)

;; Tests:
(check-expect (some-pred? positive? empty) false)
(check-expect (some-pred? negative? (list -32 93 -9)) true)
(check-expect (some-pred? positive? (list -32 -0 -9)) false)
(check-expect (some-pred? negative? (list -32 93 -9 4 72 8 -9)) true)

(define (some-pred? pred l)
  (cond [(empty? l) false]
        [else
         (or (pred (first l))
             (some-pred? pred (rest l)))]))

(define (some-positive? lon)
  (some-pred? positive? lon))

(define (some-negative? lon)
  (some-pred? negative? lon))
```

### Question 26: Accounts

[accounts-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/fromExamples3/accounts-starter.no-image.rkt)

> Design an abstract function (including signature, purpose, and tests) to simplify the remove-debtors and remove-profs functions defined below.
> 
> 
> Now re-define the original remove-debtors and remove-profs functions to use your abstract function. Remember, the signature and tests should not change from the original functions.
> 

```racket
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
```

> Using your new abstract function, design a function that removes from a given BST any account where the name of the account holder has an odd number of characters. Call it remove-odd-characters.
> 

```racket
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
```

> Design an abstract fold function for Accounts called fold-act.
> 
> 
> Use fold-act to design a function called charge-fee that decrements the balance of every account in a given collection by the monthly fee of 3 CAD.
> 

```racket
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
```

> Suppose you needed to design a function to look up an account based on its ID.
Would it be better to design the function using fold-act, or to design the
function using the fn-for-acts template?  Briefly justify your answer.
> 

```racket
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
```

## Using Built In Abstract Functions

[builtInAbstractFunctions.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/builtInAbstractFunctions.no-image.rkt)

“map” and “filter” are so useful that they’re built into the intermediate student language. It provides what are called built-in abstract list functions. How do we decide which built-in function is appropriate in a given situation and how do we set ourselves to use it properly?  Examples of the use of abstract functions are down below:

```racket
(check-expect (map positive? (list 1 -2 3 -4)) (list true false true false))
; here 'positive?' is the function
(check-expect (filter negative? (list 1 -2 3 -4)) (list -2 -4))
; here 'negative?' is the predicate

(check-expect (foldr + 0 (list 1 2 3)) (+ 1 2 3 0))   ; foldr is abstraction
(check-expect (foldr * 1 (list 1 2 3)) (* 1 2 3 1))   ; of sum and product
; here '*' is the conbination and '1' is the base-case result

(check-expect (build-list 6 identity) (list 0 1 2 3 4 5))
; here, the function 'identity' produces its argument, and build-list produces a list of given number - 1
(check-expect (build-list 4 sqr) (list 0 1 4 9))
```

Signatures of some built-in abstract functions:

- build-list: Natural → (listof X)
- filter: (listof X) → (listof X)
- map: (listof X) → (listof Y)
- andmap: (listof X) → Boolean
- ormap: (listof X) → Boolean
- foldr: Y (listof X) → Y
- foldl: Y (listof X) → Y

Note: X and Y don’t have to be different, they just can be different.

> Complete the design of the following functions by coding them using a built-in abstract list function.
> 

```racket
;; (listof Image) -> (listof Image)
;; produce list of only those images that are wide?

;; Stub:
#;
(define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

;; Template:
#;
(define (wide-only loi)
  (filter ... loi))

(define (wide-only loi)
  (filter wide? loi))
```

One of the things that is nice about using built-in abstract functions is that my function definitions get short. They get so short that it might be tempting to write them in one line. That can be called a one-liner. The base case test isn’t needed when using built-in abstract functions, since they are already thoroughly tested.

```racket
;; (listof Image) -> Boolean
;; are all the images in loi tall?

;; Stub:
#;
(define (all-tall? loi) false)

;; Tests:
(check-expect (all-tall? LOI1) false)

;; Template:
#;
(define (all-tall? loi)
  (andmap ... loi))

(define (all-tall? loi)
  (andmap tall? loi))

;; (listof Number) -> Number
;; sum the elements of a list

;; Stub:
#;
(define (sum lon) 0)

;; Tests:
(check-expect (sum (list 1 2 3 4)) 10)

;; Template:
#;
(define (sum lon)
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))
```

Sometimes one built in abstract list function can’t do it all, but we can use function composition to get what we want.

```racket
;; Natural -> Natural
;; produce the sum of the first n natural numbers

;; Stub:
#;
(define (sum-to n) 0)

;; Tests:
(check-expect (sum-to 3) (+ 0 1 2))

;; Template:
#;
(define (sum-to n)
  (foldr ... ... (build-list ... ...)))

(define (sum-to n)
  (foldr + 0 (build-list n identity)))
```

This is a way of saying, let “foldr” do something to a bunch of natural numbers - that’s “build-list”’s role. In fact, lots of languages have something like this. Python has something called “range” which works exactly this way.

### Question 27: Wide Only

[wide-only-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/wide-only-starter.no-image.rkt)

> Use the built in version of filter to design a function called wide-only that consumes a list of images and produces a list containing only those images that are wider than they are tall.
> 

```racket
;; (listof Image) -> (listof Image)
;; given a list of images, loi, produce a list containing only
;; the images that are wider than they are tall (width > height)

;; Stub:
#; (define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list (square 10 "solid" "white"))) empty)
(check-expect (wide-only (list (rectangle 20 10 "solid" "white")))
              (list (rectangle 20 10 "solid" "white")))
(check-expect (wide-only (list (rectangle 10 20 "solid" "white"))) empty)
(check-expect (wide-only (list (rectangle 20 30 "solid" "white")
                               (rectangle 10 5 "solid" "blue")
                               (rectangle 15 45 "outline" "yellow")))
              (list (rectangle 10 5 "solid" "blue")))

;; Template:
#; (define (wide-only loi)
     (filter ... loi))

(define (wide-only loi)
     (local [(define (wide? i) (> (image-width i) (image-height i)))]
       (filter wide? loi)))
```

### Question 28: Photos

[photos-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/photos-starter.no-image.rkt)

> Design a function called to-frame that consumes an album name and a list of photos and produces a list of only those photos that are favourites and that belong to the given album. You must use built-in abstract functions wherever possible.
> 

```racket
;; =================
;; Data definitions:

(define-struct photo (location album favourite))
;; Photo is (make-photo String String Boolean)
;; interp. a photo having a location, belonging to an album and having a
;; favourite status (true if photo is a favourite, false otherwise)

;; Examples:
(define PHT1 (make-photo "photos/2012/june" "Victoria" true))
(define PHT2 (make-photo "photos/2013/birthday" "Birthday" true))
(define PHT3 (make-photo "photos/2012/august" "Seattle" true))

;; =================
;; Functions:

;; String (listof Photo) -> (listof Photo)
;; given an album name, n, and a list of photos, lop, filter the
;; non-favorite and different album lists from the given elements

;; Stub:
#; (define (to-frame n lop) empty)

;; Tests:
(check-expect (to-frame "Victoria" (list PHT2 PHT3)) empty)
(check-expect (to-frame "Victoria" (list PHT1 PHT3)) (list PHT1))
(check-expect (to-frame "Birthday" (list PHT2 PHT3
                (make-photo "photos/2017/january" "Birthday" false)))
              (list PHT2))
(check-expect (to-frame "Seattle" (list PHT1 PHT2 PHT3
                (make-photo "photos/2014/june" "Seattle" true)
                (make-photo "photos/2012/august" "Seattle" false)))
              (list PHT3 (make-photo "photos/2014/june" "Seattle" true)))

;; Template:
#; (define (to-frame n lop)
     (filter ... lop))

(define (to-frame n lop)
     (local [(define (fav-album p) (and (photo-favourite p) (string=? n (photo-album p))))]
       (filter fav-album lop)))
```

### Question 29: Ellipses

[ellipses-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/ellipses-starter.no-image.rkt)

[ellipses-starter.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/ellipses-starter.rkt)

> Use build-list to write an expression (an expression, not a function) to produce a list of 20 ellipses ranging in width from 0 to 19.
> 
> 
> NOTE: Assuming n refers to a number, the expression (ellipse n (* 2 n) "solid" "blue") will produce an ellipse twice as tall as it is wide.
> 

```racket
(define ELLIPSES (local [(define (create-ellipse n) (ellipse n (* 2 n) "solid" "blue"))]
  (build-list 20 create-ellipse)))
```

> Write an expression using one of the other built-in abstract functions to put the ellipses beside each other in a single image like this:
> 
> 
> (open image file)
> 
> HINT: If you are unsure how to proceed, first do part A, and then design a traditional function operating on lists to do the job. Then think about which abstract list function to use based on that.
> 

```racket
(define BLANK (square 0 "outline" "white"))

(foldr beside BLANK ELLIPSES)
```

> By just using a different built in list function write an expression to put the ellipses beside each other in a single image like this:
> 
> 
> (open image file)
> 

```racket
(foldl beside BLANK ELLIPSES)
```

### Question 30: Bag

[bag-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/bag-starter.no-image.rkt)

> Given the following partial data definitions:
> 

```racket
(define-struct bag (l w h))
;; Bag is (make-bag Number Number Number)
;; interp. a bag with a length, width and height in centimeters

;; Examples:
(define B1 (make-bag 19.5 10.0 6.5))
(define B2 (make-bag 23.0 11.5 7.0))
(define B3 (make-bag 18.0 9.5 5.5))

;; ListOfBag is one of:
;; - empty
;; - (cons Bag ListOfBag)
;; interp. a list of bags

;; Examples:
(define LOB1 empty)
(define LOB2 (list B1 B2 B3))
```

> The linear length of a bag is defined to be its length plus width plus height. Design the function linear-length-lob that consumes a list of bags and produces a list of the linear lengths of each of the bags in the list.
> 
> 
> Use at least one built-in abstract function and encapsulate any helper functions in a local expression.
> 

```racket
;; ListOfBag -> (listof Number)
;; produce a list of the linear lengths of each of the elements in the list of bags
;; NOTE: the linear length of a bag is defined to be: length + width + height

;; Stub:
#; (define (linear-length-lob lob) empty)

;; Tests:
(check-expect (linear-length-lob (list B1))
              (list (+ 19.5 10.0 6.5)))
(check-expect (linear-length-lob (list B1 B2))
              (list (+ 19.5 10.0 6.5) (+ 23.0 11.5 7.0)))
(check-expect (linear-length-lob (list B1 B2 B3))
              (list (+ 19.5 10.0 6.5) (+ 23.0 11.5 7.0) (+ 18.0 9.5 5.5)))

;; Template:
#; (define (linear-length-lob lob)
     (map ... lob))

(define (linear-length-lob lob)
  (local [(define (linear-length b) (+ (bag-l b) (bag-w b) (bag-h b)))]
    (map linear-length lob)))
```

### Question 31: Sum N

[sum-n-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/sum-n-starter.no-image.rkt)

> Complete the design of the following function, by writing out the final function definition. Use at least one built in abstract function.
HINT: The first n odd numbers are contained in the first 2*n naturals. For example (list 0 1 2 3) contains the first 4 naturals and the first 2 odd numbers. Also remember that DrRacket has a build in predicate function called odd?
> 

```racket
;; Natural -> Natural
;; produce the sum of the first n odd numbers

;; Stub:
#; (define (sum-n-odds n) 0)

;; Tests:
(check-expect (sum-n-odds 0) 0)
(check-expect (sum-n-odds 1) (+ 0 1))
(check-expect (sum-n-odds 3) (+ 0 1 3 5))

;; Template:
#; (define (sum-n-odds n)
     (foldr ... ... (build-list ... ...)))

(define (sum-n-odds n)
  (local [(define (odd n) (+ (* 2 n) 1))]
     (foldr + 0 (build-list n odd))))
```

### Question 32: Weather

[weather-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/weather-starter.no-image.rkt)

[weather.ss](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/builtInAbstractFunctions/weather.ss)

> Complete the design of a function that takes a list of weather data and produces the sum total of rainfall in millimeters on days where the average temperature was greater than 15 degrees Celsius.
> 
> 
> The function that you design must make at least one call to built-in abstract functions (there is a very nice solution that composes calls to three built-in abstract functions).
> 

```racket
(define-struct weather (date max-tmp avg-tmp min-tmp rain snow precip))
;; Weather is (make-weather String Number Number Number Number Number Number)
;; interp. Data about weather in Vancouver on some date 
;; (make-weather date xt at nt r s p) means that
;; on the day indicated by date:
;; - the maximum temperature in Celsius was xt 
;; - the average temperature in Celsius was at
;; - the minimum temperature in Celsius was nt
;; - r millimeters of rain fell
;; - s millimeters of snow fell
;; - p millimeters of total precipitation fell

;; Examples:
(define W0 (make-weather "7/2/88" 21.9 17.7 13.4 0.2 0 0.2))

;; Template:
(define (fn-for-weather w)
  (... (weather-date w)
       (weather-max-tmp w)
       (weather-avg-tmp w)
       (weather-min-tmp w)
       (weather-rain w)
       (weather-snow w)
       (weather-precip w)))

;; (listOf Weather) -> Number
;; produce the total rainfall in millimeters of days with > 15 C average temp.

;; Stub:
#; (define (total-warm-rain low) 0)

;; Tests:
(check-expect (total-warm-rain (list W0)) 0.2)
(check-expect (total-warm-rain
               (list (make-weather "2/7/98" 19.3 14.2 9.5 0.41 0 0))) 0)
(check-expect (total-warm-rain
               (list (make-weather "12/6/04" 23.7 10.21 0.5 2.4 1.23 0.2)
                     W0 (make-weather "2/20/09" 32.2 16.2 2.31 4.6 0 0.4))) (+ 0.2 4.6))

;; Template:
#; (define (total-warm-rain low)
     (foldr ... ... (map ... (filter ... low))))

(define (total-warm-rain low)
  (local [(define (greater-15 w) (> (weather-avg-tmp w) 15))
          (define (rain-values w) (weather-rain w))]
     (foldr + 0 (map rain-values (filter greater-15 low)))))
```

> If you would like to use the real daily weather data from Vancouver from 10/3/1987 to 10/24/2013, place the weather.ss file in your current directory and uncomment the following definition and add the given check-expect to your examples.
> 

```racket
(define WEATHER-DATA 
  (local [(define (data->weather d)
            (make-weather (first d) (second d) (third d) (fourth d)
                          (fifth d) (sixth d) (seventh d)))]
    (map data->weather (file->value "weather.ss"))))

(check-expect (total-warm-rain WEATHER-DATA) 2545.3)
```

## Closures

[closures.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/closures/closures.no-image.rkt)

When the function passed to an abstract function requires access to a parameter of the enclosing function, it must be locally defined. Sometimes the function that we want to pass to an abstract function, the function we’re passing as an argument, doesn’t exist yet. In those cases, it can always be defined locally, if we want. But there is a very interesting subcase where we must define it with local.

```racket
;; (listof Image) -> (listof Image)
;; produce list of only those images that have width >= height

;; Stub:
#;
(define (wide-only loi) empty)

;; Tests:
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

;; Template:
#;
(define (wide-only loi) 
  (filter ... loi))

(define (wide-only loi)
  (local [(define (wide? i)
            (> (image-width i) (image-height i)))]
    (filter wide? loi)))
```

When the body of a function we want to pass to an abstract function refers to a parameter of the outer function, then the function we want to pass must be defined using local. It simply cannot be defined at top level.

```racket
;; Number (listof Image) -> (listof Image)
;; produce list of only those images in loi with width >= w

;; Stub:
#;
(define (wider-than-only w loi) empty)

;; Tests:
(check-expect (wider-than-only 40 LOI1) (list I4 I5))

;; Template:
#;
(define (wider-than-only w loi)
  (filter ... loi))

(define (wider-than-only w loi)
  (local [(define (wider-than? i) (> (image-width i) w))]
  (filter wider-than? loi)))
```

Here, notice “w” is not passed to “wider-than?”. “wider-than?” can only take one argument because of how “filter” works. The “w” comes from the enclosing function - it is not defined at top level. Since the local is within the scope of: “(define (wider-than-only w loi) …)”, we can refer to “w” and “loi” there because of lexical scoping, as we have been doing in all function bodies through the course.

“wider-than?” is called a “closure”, because it closes over the surrounding value of “w” passed to “wider-than-only”. Since through the evaluation of local functions will be renamed and lifted, by closing over “w”, we make a special version of “wider-than?” for each value of “w”.

In the first case, “wide?” takes in “i” and refers only to i in its body. There’s nothing special here. But in the second case, “wider-than?” takes in “i” but “w” is in its body as well. So it must be defined where “w” has meaning - in the definition of “wider-than-only”. And to define it within the definition, we need to use a local. This sort of function is called a closure.

### Question 33: Problem 1

[problem.01.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/closures/problem.01.no-image.rkt)

> Complete the design of the two function definitions below:
> 

```racket
;; (listof Number) -> (listof Number)
;; produce list of each number in lon cubed

;; Stub:
#;
(define (cube-all lon) empty)

;; Tests:
(check-expect (cube-all (list 1 2 3)) (list (* 1 1 1) (* 2  2 2) (* 3 3 3)))

;; Template:
#;
(define (cube-all lon)
  (map ... lon))

(define (cube-all lon)
  (local [(define (cube n) (* n n n))]
  (map cube lon)))

;; String (listof String) -> (listof String)
;; produce list of all elements of los prefixed by p

;; Stub:
#;
(define (prefix-all p los) empty)

;; Tests:
(check-expect (prefix-all "accio " (list "portkey" "broom"))
              (list "accio portkey" "accio broom"))

;; Template:
#;
(define (prefix-all p los)
  (map ... los))

(define (prefix-all p los)
  (local [(define (prefix s) (string-append p s))]
  (map prefix los)))
```

## Fold Functions

[foldFunctions.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/foldFunctions.no-image.rkt)

[foldFunctions.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/foldFunctions.rkt)

For the information determine the type of comments. Type comments determine the template. The template determines the form of the functions. When we have repetitive functions, we can abstract them into an abstract function. Could there be a way to shorten that route?

```racket
;; At this point in the course, the type (listof X) means:

;; ListOfX is one of:
;; - empty
;; - (cons X ListOfX)
;; interp. a list of X

;; and the template for (listof X) is:

(define (fn-for-lox lox)
  (cond [(empty? lox) (...)]
        [else
         (... (first lox)
              (fn-for-lox (rest lox)))]))
```

> Design an abstract fold function for (listof X).
> 

A fold function is an abstract function based directly on the template (or templates in the case of mutual reference).

```racket
(define (fold fn b lox)
  (cond [(empty? lox) b] ; base case result
        [else
         (fn (first lox) ; the combination function (combines (first lox) 
              (fn-for-lox (rest lox)))])) ; and the natural recursion on (rest lox))
```

It's a convention to place the function arguments first when designing abstract functions. Can this function only output numbers? Where is its output determined? Is it the type of the elements in the list that determines the type of the output? The function’s output will be the result of the inner function call.

```racket
;; (X Y -> Y) Y (listof X) -> Y
;; the abstract fold function for (listof X)

;; Tests:
(check-expect (fold + 0 (list 1 2 3)) 6)
(check-expect (fold * 1 (list 1 2 3)) 6)
(check-expect (fold string-append "" (list "a" "bc" "def")) "abcdef")
```

“fold” is the abstract function for the (listof X) type, based on its template so most of the functions we’ve made based on this template can be implemented using “fold”.

> Design an abstract fold function for Element (and (listof Element)).
> 

```racket
(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

; (open image file)

;; Examples:
(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

;; Template:
#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ;String
                 (elt-data e)    ;Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))

;; (String Integer Y -> X) (X Y -> Y) Y Element -> X
;; the abstract fold function for Element

;; Tests:
(check-expect (local [(define (c1 n d los) (cons n los))]
                (fold-element c1 append empty D6))
              (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (fold-element c1 c2 b e)
  (local [(define (fn-for-element e)                 ; X
            (c1 (elt-name e)                         ; String
                 (elt-data e)                        ; Integer
                 (fn-for-loe (elt-subs e))))         ; Y 

          (define (fn-for-loe loe)                   ; Y
            (cond [(empty? loe) b]                   ; Y
                  [else                              
                   (c2 (fn-for-element (first loe))  ; X
                        (fn-for-loe (rest loe)))]))] ; Y
    (fn-for-element e)))
```

### Question 34: Problem 1

[problem-01.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/problem-01.no-image.rkt)

> Complete the function definition for sum using foldr.
> 

```racket
;; (listof Number) -> Number
;; add up all numbers in list

;; Stub:
#;
(define (sum lon) 0)

;; Tests:
(check-expect (sum empty) 0)
(check-expect (sum (list 2 3 4)) 9)

;; Template:
#;
(define (sum lon)
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))
```

> Complete the function definition for juxtapose using foldr.
> 

```racket
;; (listof Image) -> Image
;; juxtapose all images beside each other

;; Stub:
#;
(define (juxtapose loi) (square 0 "solid" "white"))

;; Tests:
(check-expect (juxtapose empty) (square 0 "solid" "white"))
(check-expect (juxtapose (list (triangle 6 "solid" "yellow")
                               (square 10 "solid" "blue")))
              (beside (triangle 6 "solid" "yellow")
                      (square 10 "solid" "blue")
                      (square 0 "solid" "white")))

;; Template:
#;
(define (juxtapose loi)
  (foldr ... ... loi))

(define (juxtapose loi)
  (foldr beside (square 0 "solid" "white") loi))
```

> Complete the function definition for copy-list using foldr.
> 

```racket
;; (listof X) -> (listof X)
;; produce copy of list

;; Stub:
#;
(define (copy-list lox) empty)

;; Tests:
(check-expect (copy-list empty) empty)
(check-expect (copy-list (list 1 2 3)) (list 1 2 3))

;; Template:
#;
(define (copy-list lox)
  (foldr ... ... lox))

(define (copy-list lox)
  (foldr cons empty lox))
```

### Question 35: Problem 2

[problem-02.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/problem-02.no-image.rkt)

[problem-02.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/problem-02.rkt)

> Complete the design of sum-data that consumes Element and produces the sum of all the data in the element and its subs.
> 

```racket
(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

; (open image file)

;; Examples:
(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

;; Template:
#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ;String
                 (elt-data e)    ;Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))

;; (String Integer Y -> X) (X Y -> Y) Y Element -> X
;; the abstract fold function for Element

;; Tests:
(check-expect (local [(define (c1 n d los) (cons n los))]
                (fold-element c1 append empty D6))
              (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (fold-element c1 c2 b e)
  (local [(define (fn-for-element e)                 ; X
            (c1 (elt-name e)                         ; String
                 (elt-data e)                        ; Integer
                 (fn-for-loe (elt-subs e))))         ; Y 

          (define (fn-for-loe loe)                   ; Y
            (cond [(empty? loe) b]                   ; Y
                  [else                              
                   (c2 (fn-for-element (first loe))  ; X
                        (fn-for-loe (rest loe)))]))] ; Y
    (fn-for-element e)))

;; Element -> Integer
;; produce the sum of all the data in element (and its subs)

;; Stub:
#;
(define (sum-data e) 0)

;; Tests:
(check-expect (sum-data F1) 1)
(check-expect (sum-data D5) 3)
(check-expect (sum-data D4) (+ 1 2))
(check-expect (sum-data D6) (+ 1 2 3))

;; Template:
#;
(define (sum-data e)
  (fold-element ... ... ... e))

(define (sum-data e)
  (local [(define (c1 n d los) (+ d los))]
    (fold-element c1 + 0 e)))
```

> Complete the design of all-names that consumes Element and produces a list of the names of all the elements in the tree.
> 

```racket
;; Element -> ListOfString
;; produce list of the names of all the elements in the tree

;; Stub:
#;
(define (all-names e) empty)

;; Tests:
(check-expect (all-names F1) (list "F1"))
(check-expect (all-names D5) (list "D5" "F3"))
(check-expect (all-names D4) (list "D4" "F1" "F2"))
(check-expect (all-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

;; Template:
#;
(define (all-names e)
  (fold-element ... ... ... e))

(define (all-names e)
  (local [(define (c1 n d los) (cons n los))]
    (fold-element c1 append empty e)))
```

### Question 36: Problem 3

[problem-03.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/problem-03.no-image.rkt)

[problem-03.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/problem-03.rkt)

> If the tree is very large, then fold-element is not a good way to implement the find function from last week. Why? If you aren't sure then discover the answer by implementing find using fold-element and then step the two versions with different arguments.
> 

```racket
(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

;(open image file)

;; Examples:
(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

;; Template:
#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ;String
                 (elt-data e)    ;Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))

;; (String Integer Y -> X) (X Y -> Y) Y Element -> X
;; the abstract fold function for Element

;; Tests:
(check-expect (local [(define (c1 n d los) (cons n los))]
                (fold-element c1 append empty D6))
              (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (fold-element c1 c2 b e)
  (local [(define (fn-for-element e)                 ; X
            (c1 (elt-name e)                         ; String
                (elt-data e)                         ; Integer
                (fn-for-loe (elt-subs e))))          ; Y 

          (define (fn-for-loe loe)                   ; Y
            (cond [(empty? loe) b]                   ; Y
                  [else                              
                   (c2 (fn-for-element (first loe))  ; X
                       (fn-for-loe (rest loe)))]))]  ; Y
    (fn-for-element e)))

;; String -> Integer or false
;; search the given tree, e, for an element with the given name, s, produce data if found; false otherwise

;; Stub:
#;(define (find-fold-version s e) false)
#;(define (find-first-version s e) false)

;; Tests:
(check-expect (find-fold-version "F3" F1) false)
(check-expect (find-fold-version "F3" F3) 3)
(check-expect (find-fold-version "F3" D4) false)
(check-expect (find-fold-version "F1" D4) 1)
(check-expect (find-fold-version "F2" D4) 2)
(check-expect (find-fold-version "D4" D4) 0)
(check-expect (find-fold-version "D6" D6) 0)
(check-expect (find-fold-version "F1" D6) 1)
(check-expect (find-fold-version "F3" D5) 3)

(check-expect (find-first-version "F3" F1) false)
(check-expect (find-first-version "F3" F3) 3)
(check-expect (find-first-version "F3" D4) false)
(check-expect (find-first-version "F1" D4) 1)
(check-expect (find-first-version "F2" D4) 2)
(check-expect (find-first-version "D4" D4) 0)
(check-expect (find-first-version "D6" D6) 0)
(check-expect (find-first-version "F1" D6) 1)
(check-expect (find-first-version "F3" D5) 3)

;; Template:
#;(define (find-fold-version s e)
    (fold-element ... ... ... e))
;; <used template from Element and (listof Element)>

(define (find-fold-version s e)
  (local [(define (c1 n d loe)
            (if (string=?  s n) d loe))
          (define (c2 e loe)
            (if (not (false? e)) e loe))]
    (fold-element c1 c2 false e)))

(define (find-first-version s e)
  (local [(define (fn-for-element e)
            (if (string=? s (elt-name e))
                (elt-data e)
                (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) false]
                  [else
                   (local [(define find--element (fn-for-element (first loe)))]
                     (if (not (false? find--element))
                         find--element
                         (fn-for-loe (rest loe))))]))]
    (fn-for-element e)))

;The primary issue with the fold-version (or fold-element version) lies in the fact that it continues folding
;even after the target element has been found. This can lead to unnecessary traversals of the tree, which is
;inefficient, especially in the context of large trees.
;
;In the fold-version, the folding functions (c1 and c2) do not have a mechanism to signal that the target element
;has been found and further folding is unnecessary. As a result, the entire tree is traversed even after finding
;the target element, and the folding functions are applied to every element.
;
;On the other hand, in the find-first-version, a recursive approach is used, and as soon as the target element is
;found, the recursion stops, preventing unnecessary traversal.
;
;In summary, the missing aspect in the fold-version is a mechanism to terminate the folding process once the target
;element is found. The find-first-version addresses this by using recursion and returning the result as soon as the  
;target element is located.
```

### Question 37: Fold Dir

[fold-dir-starter.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/foldFunctions/fold-dir-starter.no-image.rkt)

> In this exercise you will be need to remember the following DDs for an image organizer.
> 

```racket
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
```

> Design an abstract fold function for Dir called fold-dir.
> 

```racket
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
```

> Design a function that consumes a Dir and produces the number of images in the directory and its sub-directories. Use the fold-dir abstract function.
> 

```racket
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
```

> Design a function that consumes a Dir and a String. The function looks in dir and all its sub-directories for a directory with the given name. If it finds such a directory it should produce true, if not it should produce false. Use the fold-dir abstract function.
> 

```racket
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
```

> Is fold-dir really the best way to code the function from part C? Why or why not?
> 

```racket
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
```

## Quiz

[abstraction-quiz.no-image.rkt](https://github.com/squxq/How-to-Code-Complex-Data/blob/week-09/modules/week-09/quiz/abstraction-quiz.no-image.rkt)

> Design an abstract function called arrange-all to simplify the above-all and beside-all functions defined below. Rewrite above-all and beside-all using your abstract function.
> 

```racket
;; (listof Image) -> Image
;; combines a list of images into a single image, each image above the next one

;; Stub
#; (define (above-all loi) empty-image)

;; Tests:
(check-expect (above-all empty) empty-image)
(check-expect (above-all (list (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
              (above (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
(check-expect (above-all (list (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))

#;
(define (above-all loi)
  (cond [(empty? loi) empty-image]
        [else
         (above (first loi)
                (above-all (rest loi)))]))

(define (above-all loi)
  (arrange-all above empty-image loi))

;; (listof Image) -> Image
;; combines a list of images into a single image, each image beside the next one

;; Stub:
#; (define (beside-all loi) empty-image)

;; Tests:
(check-expect (beside-all empty) (rectangle 0 0 "solid" "white"))
(check-expect (beside-all (list (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
              (beside (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
(check-expect (beside-all (list (circle 10 "outline" "red") (circle 20 "outline" "blue") (circle 10 "outline" "yellow")))
              (beside (circle 10 "outline" "red") (circle 20 "outline" "blue") (circle 10 "outline" "yellow")))

#;
(define (beside-all loi)
  (cond [(empty? loi) (rectangle 0 0 "solid" "white")]
        [else
         (beside (first loi)
                 (beside-all (rest loi)))]))

(define (beside-all loi)
  (arrange-all beside (rectangle 0 0 "solid" "white") loi))

;; (X Y -> Y) Y (listof X) -> Y
;; given a function, fn, and a list (list n0 n1 ...), l, produce (list (fn n0) (fn n1) ...), with given base case, b

;; Stub:
#; (define (arrange-all fn b l) Y)

;; Tests:
(check-expect (arrange-all above empty-image empty) empty-image)
(check-expect (arrange-all beside (rectangle 0 0 "solid" "white")
                           (list (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
              (beside (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
(check-expect (arrange-all above empty-image
                           (list (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))

;; Template: <used template from above-all & beside-all>
(define (arrange-all fn b l)
  (cond [(empty? l) b]
        [else
         (fn (first l)
             (arrange-all fn b (rest l)))]))
```

> Finish the design of the following functions, using built-in abstract functions.
> 

```racket
;; Function 1
;; ==========

;; (listof String) -> (listof Natural)
;; produces a list of the lengths of each string in los

;; Stub:
#; (define (lengths lst) empty)

;; Tests:
(check-expect (lengths empty) empty)
(check-expect (lengths (list "apple" "banana" "pear")) (list 5 6 4))

;; Template:
#; (define (lengths lst)
     (map ... lst))

(define (lengths lst)
  (map string-length lst))

;; Function 2
;; ==========

;; (listof Natural) -> (listof Natural)
;; produces a list of just the odd elements of lon

;; Stub:
#; (define (odd-only lon) empty)

;; Tests:
(check-expect (odd-only empty) empty)
(check-expect (odd-only (list 1 2 3 4 5)) (list 1 3 5))

;; Template:
#; (define (odd-only lon)
     (filter ... lon))

(define (odd-only lon)
  (filter odd? lon))

;; Function 3
;; ==========

;; (listof Natural -> Boolean
;; produce true if all elements of the list are odd

;; Stub:
#; (define (all-odd? lon) empty)

;; Tests:
(check-expect (all-odd? empty) true)
(check-expect (all-odd? (list 1 2 3 4 5)) false)
(check-expect (all-odd? (list 5 5 79 13)) true)

;; Template:
#; (define (all-odd? lon)
     (andmap ... lon))

(define (all-odd? lon)
  (andmap odd? lon))

;; Function 4
;; ==========

;; (listof Natural) -> (listof Natural)
;; subtracts n from each element of the list

;; Stub:
#; (define (minus-n lon n) empty)

;; Tests:
(check-expect (minus-n empty 5) empty)
(check-expect (minus-n (list 4 5 6) 1) (list 3 4 5))
(check-expect (minus-n (list 10 5 7) 4) (list 6 1 3))

;; Template:
#; (define (minus-n lon n)
     (map ... lon))

(define (minus-n lon n)
  (local [(define (remove-n num) (- num n))]
    (map remove-n lon)))
```

> Consider the data definition below for Region. Design an abstract fold function for region, and then use it do design a function that produces a list of all the names of all the regions in that region.
> 
> 
> For consistency when answering the multiple choice questions, please order the arguments in your fold function with combination functions first, then bases, then region. Please number the bases and combination functions in order of where they appear in the function.
> 
> So (all-regions CANADA) would produce
> (list "Canada" "British Columbia" "Vancouver" "Victoria" "Alberta" "Calgary" "Edmonton")
> 

```racket
(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

;; Examples:
(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

;; Template:
#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))
          
          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))
          
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else 
                   (... (fn-for-region (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))

;; (String Y Z -> X) (X Z -> Z) Y Y Y Y Y Z -> X
;; abstract fold function for Region

;; Stub:
#; (define (fold-region c1 c2 b1 b2 b3 b4 b5 b6 r))

;; Tests:
(check-expect (local [(define (c1 name type lor) (cons name lor))]
                (fold-region c1 append false false false false false empty CANADA)) ; b1, b2, b3, b4, b5 are not being used
              (list "Canada" "British Columbia" "Vancouver" "Victoria" "Alberta" "Calgary" "Edmonton"))

;; Template: <used template from Region>
(define (fold-region c1 c2 b1 b2 b3 b4 b5 b6 r)
  (local [(define (fn-for-region r)                  ; X
            (c1 (region-name r)                      ; String
                (fn-for-type (region-type r))        ; Y
                (fn-for-lor (region-subregions r)))) ; Z
          
          (define (fn-for-type t)                    ; Y
            (cond [(string=? t "Continent") b1]      ; Y
                  [(string=? t "Country") b2]        ; Y
                  [(string=? t "Province") b3]       ; Y
                  [(string=? t "State") b4]          ; Y
                  [(string=? t "City") b5]))         ; Y
          
          (define (fn-for-lor lor)                   ; Z
            (cond [(empty? lor) b6]                  ; Z
                  [else 
                   (c2 (fn-for-region (first lor))   ; X
                       (fn-for-lor (rest lor)))]))]  ; Z
    (fn-for-region r)))

;; Region -> (listof String)
;; produce the list of names of all regions in the given region, r

;; Stub:
#; (define (all-regions r) empty)

;; Tests:
(check-expect (all-regions VANCOUVER) (list "Vancouver"))
(check-expect (all-regions VICTORIA) (list "Victoria"))
(check-expect (all-regions BC)
              (list "British Columbia" "Vancouver" "Victoria"))
(check-expect (all-regions CALGARY) (list "Calgary"))
(check-expect (all-regions EDMONTON) (list "Edmonton"))
(check-expect (all-regions ALBERTA)
              (list "Alberta" "Calgary" "Edmonton"))
(check-expect (all-regions CANADA)
              (list "Canada" "British Columbia" "Vancouver" "Victoria" "Alberta" "Calgary" "Edmonton"))

;; Template:
#; (define (all-regions r)
     (fold-region ... ... ... ... ... ... ... ... r))

(define (all-regions r)
  (local [(define (c1 name type lor) (cons name lor))]
    (fold-region c1 append false false false false false empty r)))
```