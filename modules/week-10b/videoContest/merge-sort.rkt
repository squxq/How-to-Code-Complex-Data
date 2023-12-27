;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname merge-sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Merge Sort

;; Merge sort is one of the most efficient sorting algorithms. It works on the
;; principle of Divide and Conquer based on the idea of breaking down a list
;; into several sub-lists until each sublist consists of a single element and
;; merging those sublists in a manner that results into a sorted list. It was
;; invented by John Von Neumann in 1945. A detailed description and analysis
;; of bottom-up merge sort appeared in a report by Goldstine and Von Neumann
;; as early as 1948.

;; The concept of Divide and Conquer involves three steps:
;;   1. Divide the problem into multiple subproblems.
;;   2. Solve the Sub Problems. The idea is to break down the problem into
;;      atomic subproblems, where they are actually solved.
;;   3. Combine the solutions of the subproblems to find the solution of the
;;      actual problem.

;; So, the merge sort working rule involves the following steps:
;;   1. Divide the unsorted array into subarray, each containing a single
;;      element.
;;   2. Take adjacent pairs of two single element array and merge them to form
;;      an array of two elements.
;;   3. Repeat the process till a single sorted array is obtained.

;; An array of size, n, is divided into two parts, n/2 size of each. Then those
;; arrays are further divided till we reach a single element. The base case here
;; is reaching one single elemtnt. When the base case is hit, we start merging
;; the left part and the right part and we get a sorted array at the end. Merge
;; sort repeatedly breaks down an array into several subarrays until each
;; subarray consists of a single element and merging those subarrays in a
;; manner that results in a sorted array.

;; Merge algorithms are a family of algorithms that take multiple sorted lists
;; as input and produce a single list as output, containing all the lements of
;; the inputs lists in sorted order.


;; =====================
;; Constant Definitions:

;; LISTS: <generated with the help of https://www.random.ort/sequences/>

;; List with length 1:
(define 1-LST (list 1))

;; List with length 2:
(define 2-LST (list 2  1))
(define 2s-LST (list 1  2))

;; List with length 4:
(define 4-LST (list 4  1  2  3))
(define 4s-LST (list 1  2  3  4))

;; List with length 7:
(define 7-LST (list 2  5  4  6  1  7  3))
(define 7s-LST (list 1  2  3  4  5  6  7))

;; List with length 10:
(define 10-LST (list 3   1   7   8  10   4   9   5   6   2))
(define 10s-LST (build-list 10 add1))

;; List with length 15:
(define 15-LST (list 12   5  11   4   6   8   3  10   1  14
                     9   13  15   2   7))
(define 15s-LST (build-list 15 add1))

;; List with length 20:
(define 20-LST (list 13  11  20   5  17  18  16  12  19  15
                     14   2   4   1   3  10   8   9   7   6))
(define 20s-LST (build-list 20 add1))

;; List with length 30:
(define 30-LST (list 6   18   9   4   2  28  25  24  19  22
                     1   27  10  15  20   7   8  21  29   5
                     16  14   3  26  30  13  17  12  23  11))
(define 30s-LST (build-list 30 add1))

;; List with length 40:
(define 40-LST (list 22   4  31  32  33  29  24  20  21  14
                     8   30  36  37  39   1  15   2  40  17
                     11   7  18  26  38  10  23  34  25  16
                     9    3  13  27  12   6  19  35   5  28))
(define 40s-LST (build-list 40 add1))

;; List with length 50:
(define 50-LST (list 33  21  36  12   7  49  19  38  37  16
                     42  25   4  24  44   1  46   5  28  35
                     15  10  34  39  40  11  22   6  31  43
                     3   47   8  13  26  48  18  30  29  41
                     2   23  50  45   9  27  17  14  20  32))
(define 50s-LST (build-list 50 add1))

;; List with length 75:
(define 75-LST (list 9   49  68  74  45  75  12  56  20  10
                     14  53  71  66  60  16  26   5  30   7
                     39  35  72  41  44   3   1  42  70   4
                     24   8  17  28  38  63  21  59  40  54
                     61  64  18  36   6  48  52  22  19  25
                     67  69  13  73  55  62  11  15  47  51
                     46  37  34  27  32   2  33  23  29  58
                     50  57  43  65  31))
(define 75s-LST (build-list 75 add1))

;; List with length 100:
(define 100-LST (list 28   88   33    3  100   66   31   57   72   97
                      83    5   21   74   73   95   10   94   71   59
                      30   12   85   79   86   92   91   89   62   52
                      55   24   44   36   39   18   27    9   65   96
                      49   29   38   37   56   19   80   98   42   61
                      48   50   13   60    7   54   43   23   70   32
                      2    76   26    6   14   34   45   82   47   53
                      68   69   81   46    8   84   41   35   75   77
                      78   16   64   11   17   22   20   99   58   15
                      1    25    4   90   51   67   40   63   87   93))
(define 100s-LST (build-list 100 add1))


;; =====================
;; Function Definitions:

;; (listof Number) -> (listof Number)
;; produce a list of all elements in given list of number, lon, put into
;; order - ascending numerical order - using merge sort

;; Stub:
#; (define (merge-sort lon) lon)

;; Tests:
(check-expect (merge-sort empty) empty)
(check-expect (merge-sort 1-LST) 1-LST)
(check-expect (merge-sort 2-LST) 2s-LST)
(check-expect (merge-sort 4-LST) 4s-LST)
(check-expect (merge-sort 7-LST) 7s-LST)
(check-expect (merge-sort 10-LST) 10s-LST)
(check-expect (merge-sort 15-LST) 15s-LST)
(check-expect (merge-sort 20-LST) 20s-LST)
(check-expect (merge-sort 30-LST) 30s-LST)
(check-expect (merge-sort 40-LST) 40s-LST)
(check-expect (merge-sort 50-LST) 50s-LST)
(check-expect (merge-sort 75-LST) 75s-LST)
(check-expect (merge-sort 100-LST) 100s-LST)

;; Template: <used template for generative recursion>
(define (merge-sort lon)
  (cond [(empty? lon) empty]
        [(empty? (rest lon)) lon]
        [else
         (local [(define half-length (ceiling (/ (length lon) 2)))]
           (merge (merge-sort (take half-length lon))
                  (merge-sort (drop half-length lon))))]))


;; (listof Number) (listof Number) -> (listof Number)
;; take two given lists of number, lon1 and lon2, and produce a single list
;; as output, containing all the elements of lon1 and lon2 in sorted order
;; ASSUME: both lon1 and lon2 are sorted
;; NOTE: using ascending numerical order

;; Stub:
#; (define (merge lon1 lon2) empty)

;; Tests:
(check-expect (merge empty empty) empty)
(check-expect (merge (cons 1 empty) empty) (cons 1 empty))
(check-expect (merge empty (cons 2 empty)) (cons 2 empty))
(check-expect (merge (list 5) (list 2)) (list 2 5))
(check-expect (merge (list 1 7) (list 3 6)) (list 1 3 6 7))

;; Cross Product of Type Comments Table
;;    lon1       lon2 |       empty        |   (list number2 ...)
;; -----------------------------------------------------------------
;;        empty       |            (list number2 ...)
;; -----------------------------------------------------------------
;; (list number1 ...) | (list number1 ...) | number1 > number2 ?
;;                                               number2 : number1

;; Template: <used template for two "one-of" type data>
(define (merge lon1 lon2)
  (cond [(empty? lon1) lon2]
        [(empty? lon2) lon1]
        [else
         (if (<= (first lon1) (first lon2))
             (cons (first lon1)
                     (merge (rest lon1) lon2))
             (cons (first lon2)
                     (merge lon1 (rest lon2))))]))


;; Natural (listof X) -> (listof X)
;; produce a list of all elements in given list, l, prior to given index, i
;; ASSUME: - 0 <= i < (length l)
;;         - l is not empty

;; Stub:
#; (define (take i l) empty)

;; Tests:
(check-expect (take 0 (list 1)) empty)
(check-expect (take 1 (list 1)) (list 1))
(check-expect (take 5 (build-list 10 add1))
              (build-list 5 add1))

;; Template: <used template for (listof X)>
(define (take i l)
  (cond [(zero? i) empty]
        [else
         (cons (first l) (take (sub1 i) (rest l)))]))


;; Natural (listof X) -> (listof X)
;; produce a list of all elements in given list, l, with index greater than
;; or equal to given index, i
;; ASSUME: - 0 <= i < (length l)

;; Stub:
#; (define (drop i l) empty)

;; Tests:
(check-expect (drop 0 empty) empty)
(check-expect (drop 1 (list 1)) empty)
(check-expect (drop 1 (list 2 5)) (list 5))
(check-expect (drop 5 (build-list 10 add1))
              (build-list 5 (λ (n) (+ n 6))))

;; Template: <used template for (listof X)>
(define (drop i l)
  (cond [(empty? l) empty]
        [(not (zero? i)) (drop (sub1 i) (rest l))]
        [else
         (cons (first l) (drop i (rest l)))]))