;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname problem-01.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Construct a three part termination argument for scarpet.

;Three part termination argument for scarpet.
;
;Base case: (<= s CUTOFF)
;
;Reduction step: (/ s 3)
;
;Argument that repeated application of reduction step will eventually 
;reach the base case: as long as the CUTOFF is > 0 and s starts >= 0
;repeated division by 3 will eventually be less than CUTOFF.