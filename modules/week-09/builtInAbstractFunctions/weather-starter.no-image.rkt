;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname weather-starter.no-image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/file)

;; weather-starter.rkt

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


;PROBLEM:
;
;Complete the design of a function that takes a list of weather data
;and produces the sum total of rainfall in millimeters on days where
;the average temperature was greater than 15 degrees Celsius.
;
;The function that you design must make at least one call to 
;built-in abstract functions (there is a very nice solution that
;composes calls to three built-in abstract functions).

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


;If you would like to use the real daily weather data from Vancouver
; from 10/3/1987 to 10/24/2013, 
; place the weather.ss file in your current directory and uncomment
; the following definition and add the given check-expect to your
; examples.
;
;(define WEATHER-DATA 
;  (local [(define (data->weather d)
;            (make-weather (first d) (second d) (third d) (fourth d)
;                          (fifth d) (sixth d) (seventh d)))]
;    (map data->weather (file->value "weather.ss"))))
;
;(check-expect (total-warm-rain WEATHER-DATA) 2545.3)

(define WEATHER-DATA 
  (local [(define (data->weather d)
            (make-weather (first d) (second d) (third d) (fourth d)
                          (fifth d) (sixth d) (seventh d)))]
    (map data->weather (file->value "weather.ss"))))

(check-expect (total-warm-rain WEATHER-DATA) 2545.3)
