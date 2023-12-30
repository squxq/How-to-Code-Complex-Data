;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; ta-solver-starter.rkt


;; Chirper is a Twitter like social network. Each Chirper user has a display name,
;; a username, which is unique for all users, an about note a website and a birth
;; date. On top of that, each user can be verified or not.

;; =================
;; Data Definitions:

;; DisplayName is String with length: Natural[1, 50]
;; interp. an user required display name which is not unique in the user network
;;         - there can be two or more people with the same display name
;;         - display name can be up to 50 characters long
;;         - display name cannot be empty - it needs at least another character
;;           besides space
;;         - display name is required for every user entry

;; Template: <for using display-name>
#; (define (fn-for-display-name dn)
     (... dn))

;; Template: <for creating/updating display-name>
#; (define (fn-for-display-name dn)
     (cond [(display-name-forbidden-length? dn)
            (error (... dn))]
           [(display-name-empty? dn)
            (error (... dn))]
           [else
            (... dn)]))


;; UserName is String with length: Natural[5, 15]
;; interp. an user required username which is unique in the user network
;;         - there cannot be two people with the same username
;;         - by changing an username, it goes back to being available to other
;;           users to choose, or change to
;;         - username must be more than 4 characters long and can be up to
;;           15 characters or less
;;         - username can only contain letters, numbers, and underscores - no
;;           spaces are allowed
;;         - username is required for every user entry

;; Template: <for using user-name>
#; (define (fn-for-user-name un)
     (... un))

;; Template: <for creating/updating user-name>
#; (define (fn-for-user-name un)
     (cond [(user-name-forbidden-length? un)
            (error (... un))]
           [(user-name-forbidden-characters? un)
            (error (... un))]
           [else
            (... un)]))


;; About is String with length: Natural[0, 160]
;; interp. an user optional about section
;;         - about can only be up to 160 characters long
;;         - about is not required for every user entry - to not have an
;;           about the user can leave this field as an empty string (""),
;;           since string with length 0 means this field is not being used

;; Template: <for using about>
#; (define (fn-for-about a)
     (... a))

;; Template: <for creating/updating about>
#; (define (fn-for-about a)
     (cond [(about-forbidden-length? a)
            (error (... a))]
           [else
            (... a)]))


;; Verified is Boolean
;; interp. represents if a given user is verified or not
;;         - true means the user is verified
;;         - false means the user is not verified
;;         - verified is required for every user entry

;; Template: <for using, creating/updating verified>
#; (define (fn-for-verified v)
     (... v))


;; Website is String with length: Natural [0, 100]
;; interp. an user optional website link
;;         - website can only be up to 160 characters long
;;         - website is not required for every user entry - to not have a
;;           website the user can leave this field as an empty string (""),
;;           since string with length 0 means this field is not being used
;;         - website can only be a valid URL

;; Template: <for using website>
#; (define (fn-for-website w)
     (...))

;; Template: <for creating/updating website>
#; (define (fn-for-website w)
     (cond [(website-forbidden-length? w)
            (error (... w))]
           [(website-forbidden-URL? w)
            (error (... w))]
           [else
            (... w)]))


;; Month is one of:
;; - "January"
;; - "February"
;; - "March"
;; - "April"
;; - "May"
;; - "June"
;; - "July"
;; - "August"
;; - "September"
;; - "October"
;; - "November"
;; - "December"
;; interp. a month of the year in the Gregorian calendar

;; Template: <for using month>
#; (define (fn-for-month m)
     (cond [(string=? "January" m) (...)]
           [(string=? "February" m) (...)]
           [(string=? "March" m) (...)]
           [(string=? "April" m) (...)]
           [(string=? "May" m) (...)]
           [(string=? "June" m) (...)]
           [(string=? "July" m) (...)]
           [(string=? "August" m) (...)]
           [(string=? "September" m) (...)]
           [(string=? "October" m) (...)]
           [(string=? "November" m) (...)]
           [else (...)])) ; (string=? "December" m)

;; Template: <for creating/updating month>
#; (define (fn-for-month m)
     (cond [(month-forbidden? m)
            (error ...)]
           [else
            (... m)]))


;; Day is Natural[1, 31]
;; interp. a day in a month in the Gregorian calendar
;;         - Natural[1, 28] are the days of February in a non-leap year
;;         - Natural[1, 29] are the days of February in a leap year
;;         - Natural[1, 30] are the days of April, June, September and November
;;         - Natural[1, 31] are the days of January, March, May, July, August,
;;           October and December

;; Template: <for using day>
#; (define (fn-for-day d)
     (... d))

;; Template: <for creating/updating day>
#; (define (fn-for-day d)
     (cond [(day-more-31? d)
            (error (... d))]
           [(and (day-month-30? m) (day-31? d))
            (error (... d))]
           [(day-month-february? m)
            (cond [(day-30? d)
                   (error (... d))]
                  [(and (not (leap-year? y)) (day-29? d))
                   (error (... d))])]
           [else
            (... d)]))


;; Year is Natural[1903, 2023]
;; interp. a year of the Gregorian calendar
;;         - starts at 1903, 120 years ago, at the time of writing
;;         - ends in 2023, the current year, at the time of writing

;; Template: <for using year>
#; (define (fn-for-year y)
     (... y))

;; Template: <for creating/updating year>
#; (define (fn-for-year y)
     (cond [(year-forbidden? y)
            (error (... y))]
           [else
            (... y)]))


(define-struct birth-date (month day year))
;; BirthDate is (make-birth-date Month Day Year)
;; interp. a date of birth with month, day and year

;; Template: <for uing birth-date>
#; (define (fn-for-birth-date bd)
     (... (fn-for-month (birth-date-month bd))
          (fn-for-day (birth-date-day bd))
          (fn-for-year (birth-date-year bd))))

;; Template: <for creating/updating birth-date>
#; (define (fn-for-birth-date m d y)
     (make-birth-date (fn-for-month m)
                      (fn-for-day d)
                      (fn-for-year y)))


(define-struct user (display-name user-name about verified website birth-date))
;; User is (make-user DisplayName UserName About Verified Website BirthDate)
;; interp. a Chisper user with:
;;         - display-name is the display name of the user
;;         - user-name is the unique user name that belongs to the user
;;         - about is the optional about section for the user
;;         - verified is true if the user is verified, otherwise is false
;;         - website is the optional user's website URL
;;         - birth-date is the user's birth date

;; Template: <for using user>
#; (define (fn-for-user u)
     (... (fn-for-display-name (user-display-name u))
          (fn-for-user-name (user-user-name u))
          (fn-for-about (user-about u))
          (fn-for-verified (user-verified u))
          (fn-for-website (user-website u))
          (fn-for-birth-rate (user-birth-date u))))

;; Template: <for creating/updating user>
#; (define (fn-for-user dn un a v w bd)
     (make-user (fn-for-display-name dn)
                (fn-for-user-name un)
                (fn-for-about a)
                (fn-for-verified v)
                (fn-for-website w)
                (fn-for-birth-date bd)))