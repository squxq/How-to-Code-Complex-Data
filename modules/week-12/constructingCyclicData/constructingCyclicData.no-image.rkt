;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname constructingCyclicData.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; graphs-v2.rkt

;PROBLEM: 
;
;Imagine you are suddenly transported into a mysterious house, in which all
;you can see is the name of the room you are in, and any doors that lead OUT
;of the room.  One of the things that makes the house so mysterious is that
;the doors only go in one direction. You can't see the doors that lead into
;the room.
;
;Here are some examples of such a house:
;
;(open image file)
;(open image file)
;(open image file)
;(open image file)
;
;In computer science, we refer to such an information structure as a directed
;graph. Like trees, in directed graphs the arrows have direction. But in a
;graph it is  possible to go in circles, as in the second example above. It
;is also possible for two arrows to lead into a single node, as in the fourth
;example.
;
;   
;Design a data definition to represent such houses. Also provide example data
;for the four houses above.

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

;; Examples:
; (open image file)
(define H1 (make-room "A" (list (make-room "B" empty))))

; (open image file)
(define H2 (shared [(-0- (make-room
                          "A" (list (make-room
                                     "B" (list -0-)))))] -0-))

; (open image file)
#; (define H3 (shared [(-0- (make-room
                           "A" (list (make-room
                                      "B" (list (make-room
                                                 "C" (list -0-)))))))] -0-))

(define H3 (shared [(-A- (make-room "A" (list -B-)))
                    (-B- (make-room "B" (list -C-)))
                    (-C- (make-room "C" (list -A-)))]
             -A-))

; (open image file)
(define H4 (shared [(-A- (make-room "A" (list -B- -D-)))
                    (-B- (make-room "B" (list -C- -E-)))
                    (-C- (make-room "C" (list -B-)))
                    (-D- (make-room "D" (list -E-)))
                    (-E- (make-room "E" (list -F- -A-)))
                    (-F- (make-room "F" empty))]
             -A-))