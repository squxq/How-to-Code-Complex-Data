;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


;; ta-solver-starter.rkt


;; Chirper is a Twitter like social network. Each Chirper user has a display name,
;; a username, which is unique for all users, an about note a website and a birth
;; date. On top of that, each user can be verified or not.

;; =================
;; Data Definitions:

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
;;         - username must start with character "@"

;; Template: <for using user-name>
#; (define (fn-for-user-name un)
     (... un))

;; Template: <for creating/updating user-name>
#; (define (fn-for-user-name un)
     (cond [(user-name-no-@? un)
            (error (... un))]
           [(user-name-forbidden-length? un)
            (error (... un))]
           [(user-name-forbidden-characters? un)
            (error (... un))]
           [else
            (... un)]))


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
;;         - website can only be up to 100 characters long
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


(define-struct user (user-name verified website birth-date followers following))
;; User is (make-user UserName Verified Website BirthDate (listof User) (listof User))
;; interp. a Chirper user with:
;;         - user-name is the unique user name that belongs to the user
;;         - verified is true if the user is verified, otherwise is false
;;         - website is the optional user's website URL
;;         - birth-date is the user's birth date
;;         - followers is the list of users that follow user
;;         - following is a list of users that the user is following

;; Template: <for using user - 1>
#; (define (fn-for-user u)
     (... (fn-for-user-name (user-user-name u))
          (fn-for-verified (user-verified u))
          (fn-for-website (user-website u))
          (fn-for-birth-rate (user-birth-date u))
          (fn-for-lou (user-followers u))
          (fn-for-lou (user-following u))))

;; Template: <for using user - 2>
#; (define (fn-for-user u0)
     ;; computed is (listof UserName)
     ;; INVARIANT: a context-preserving accumulator; names of users already computed
     ;; ASSUME: a user's username is unique

     ;; todo is (listof User)
     ;; INVARIANT: a worklist accumulator
     
     (local [(define (fn-for--user u computed todo)
               (if (member (user-user-name u) computed)
                   (fn-for--lou computed todo)
                   (fn-for--lou (append computed (list (user-user-name u)))
                                (append (user-following u) todo))))

             (define (fn-for--lou computed todo)
               (cond [(empty? todo) (...)]
                     [else
                      (fn-for--user (first todo)
                                    computed
                                    (rest todo))]))]

       (fn-for--user u0 empty empty)))

;; Template: <for creating/updating user>
#; (define (fn-for-user un v w bd fi fo)
     (make-user (fn-for-user-name un) v
                (fn-for-website w) bd fi fo))


;; =====================
;; Constant Definitions:

;; Valid username characters:
(define VALID-USERNAME-CHARS
  (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m"
        "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
        "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M"
        "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
        "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "_"))


;; Valid months:
(define VALID-MONTHS
  (list "January" "February" "March" "April" "May" "June"
        "July" "August" "September" "October" "November" "December"))

;; 30-day months:
(define 30-DAY-MONTHS
  (list "April" "June" "September" "November"))


;; User Names - Invalid:

;; Username without character "@" at the start:
(define UN-NO@ "2983@")

;; Short username, length 4:
(define UN-SHORT "@abc")

;; Long username, length 16:
(define UN-LONG "@asdbnm123pqodje_")

;; Username that contains space:
(define UN-SPACE "@hello 02")

;; Username that contains "-":
(define UN-DASH "@some-user")

;; User Names - Valid:

(define UN0 "@sample_user123")
(define UN1 "@hell234_")


;; Verified - Invalid: <there is no invalid possible data>

;; Verified - Valid:

(define V0 true)
(define V1 false)


;; Website - Invalid:

;; Long website, length 101:
(define W-LONG
  "aaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaa
   aaaaaaaaaaaaaaaaaaaa")

;; Invalid URL website:
;; !!!

;; Website - Valid:

(define W0 "")
(define W1 "https://www.google.com/")


;; Month: <examples for enumerations are redundant>


;; Day - Invalid:

;; Any number that is greater than 31:
(define D-32 32)

;; Day - Valid:

(define D1 1)
(define D15 15)
(define D28 28)
(define D29 29)
(define D30 30)
(define D31 31)


;; Year - Invalid:

;; Any number less than 1903:
(define Y-1902 1902)

;; Any number greater than 2023:
(define Y-2024 2024)

;; Year - Valid:

(define Y1903 1903)
(define Y1963 1963)
(define Y2023 2023)


;; Birth Date:

(define BD0 (make-birth-date "July" 22 1974))
(define BD1 (make-birth-date "January" 10 1960))


;; Networks:

;; User 0:
(define U0 (make-user UN0 V0 W0 BD0 empty empty))

;; User 1:
(define U1 (shared [(-0- (make-user UN0 V0 W0 BD0 (list -1-) empty))
                    (-1- (make-user UN1 V1 W1 BD1 empty (list -0-)))]
             -1-))

;; Network 1:
(define N1 (shared [(-A- (make-user "@alice" true "https://www.alice.com/"
                                    (make-birth-date "January" 15 1990)
                                    empty
                                    (list -B- -C-)))
                    (-B- (make-user "@bob" false "https://www.bob.com/"
                                    (make-birth-date "March" 22 1985)
                                    (list -A- -C- -D-)
                                    empty))
                    (-C- (make-user "@charlie" true "https://www.charlie.com/"
                                    (make-birth-date "July" 10 1995)
                                    (list -A- -D-)
                                    (list -B- -E-)))
                    (-D- (make-user "@david" false ""
                                    (make-birth-date "December" 5 1988)
                                    (list -E-)
                                    (list -B- -C-)))
                    (-E- (make-user "@eve" false ""
                                    (make-birth-date "September" 30 1992)
                                    (list -C-)
                                    (list -D-)))]
             -A-))

;; Network 2:
(define N2 (shared [(-F- (make-user "@frank" false ""
                                    (make-birth-date "June" 18 1987)
                                    (list -H-)
                                    (list -G- -H-)))
                    (-G- (make-user "@grace" true "https://www.grace.com/"
                                    (make-birth-date "April" 25 1993)
                                    (list -F- -J-)
                                    (list -H-)))
                    (-H- (make-user "@hank" false ""
                                    (make-birth-date "November" 8 1998)
                                    (list -F- -G-)
                                    (list -F- -I-)))
                    (-I- (make-user "@ivy" false ""
                                    (make-birth-date "August" 2 1991)
                                    (list -H-)
                                    empty))
                    (-J- (make-user "@jack" false "https://www.jack.com/"
                                    (make-birth-date "December" 12 1984)
                                    (list -J-)
                                    (list -G- -J-)))]
             -J-))

;; Network 3:
(define N3 (shared [(-K- (make-user "@katie" true "https://www.katie.com/"
                                    (make-birth-date "September" 8 1996)
                                    empty
                                    (list -L-)))
                    (-L- (make-user "@liam" false ""
                                    (make-birth-date "March" 14 1990)
                                    (list -K- -N-)
                                    (list -M-)))
                    (-M- (make-user "@mia" false ""
                                    (make-birth-date "November" 20 1988)
                                    (list -L-)
                                    (list -O-)))
                    (-N- (make-user "@noah" false "https://www.noah.com/"
                                    (make-birth-date "June" 30 1994)
                                    (list -O-)
                                    (list -L-)))
                    (-O- (make-user "@olivia" true "https://www.olivia.com/"
                                    (make-birth-date "May" 03 1992)
                                    (list -M-)
                                    (list -N- -P-)))
                    (-P- (make-user "@parker" false ""
                                    (make-birth-date "July" 22 1986)
                                    (list -O-)
                                    empty))]
             -K-))

;; Network 4:
(define N4 (shared [(-Q- (make-user "@quinn" true "https://www.quinn.com/"
                                    (make-birth-date "April" 12 1997)
                                    (list -U-)
                                    (list -R- -S-)))
                    (-R- (make-user "@ryan" false ""
                                    (make-birth-date "August" 28 1991)
                                    (list -Q- -S-)
                                    (list -S- -T-)))
                    (-S- (make-user "@sofia" false ""
                                    (make-birth-date "December" 5 1989)
                                    (list -Q- -R-)
                                    (list -R- -T- -U-)))
                    (-T- (make-user "@theo" false ""
                                    (make-birth-date "February" 18 1995)
                                    (list -R- -S- -U-)
                                    (list -U- -W- -X-)))
                    (-U- (make-user "@uma" true "https://www.uma.com/"
                                    (make-birth-date "October" 15 1993)
                                    (list -S- -T- -W-)
                                    (list -Q- -T- -V- -Y- -Z-)))
                    (-V- (make-user "@violet" false ""
                                    (make-birth-date "June" 25 1987)
                                    (list -Q- -U-)
                                    (list -W- -Y-)))
                    (-W- (make-user "@wyatt" false ""
                                    (make-birth-date "March" 8 1999)
                                    (list -T- -V- -Y-)
                                    (list -U- -X-)))
                    (-X- (make-user "@xander" false "https://www.xander.com/"
                                    (make-birth-date "November" 2 1984)
                                    (list -T- -W-)
                                    (list -Y-)))
                    (-Y- (make-user "@yara" true "https://www.yara.com/"
                                    (make-birth-date "May" 20 1996)
                                    (list -U- -V- -X-)
                                    (list -W-)))
                    (-Z- (make-user "@zane" false ""
                                    (make-birth-date "September" 4 1990)
                                    (list -U- -Z-)
                                    (list -Z-)))]
             -Q-))


;; =====================
;; Function Definitions:

;; UserName Verified Website BirthDate (listof User) (listof User) -> User
;; produce a new user with given:
;; - unique username to this user only, un
;; - whether or not they are verified, v
;; - the user's optional website, w
;; - the user's birth date, bd
;; - the user's followers, as a list of users, fi
;; - the users the user is following, as a list of users, fo

;; Stub:
#; (define (create-user un v w bd fi fo) U0)

;; Tests:
(check-expect (create-user UN0 V0 W0 BD0 empty empty) U0)
(check-expect (create-user UN1 V1 W1 BD1 empty
                           (shared [(-0- (make-user UN0 V0 W0 BD0 (list -1-) empty))
                                    (-1- (make-user UN1 V1 W1 BD1 empty (list -0-)))]
                             (list -0-))) U1)
(check-expect (shared [(-A- (make-user "@alice" true "https://www.alice.com/"
                                       (make-birth-date "January" 15 1990)
                                       empty
                                       (list -B- -C-)))
                       (-B- (make-user "@bob" false "https://www.bob.com/"
                                       (make-birth-date "March" 22 1985)
                                       (list -A- -C- -D-)
                                       empty))
                       (-C- (make-user "@charlie" true "https://www.charlie.com/"
                                       (make-birth-date "July" 10 1995)
                                       (list -A- -D-)
                                       (list -B- -E-)))
                       (-D- (make-user "@david" false ""
                                       (make-birth-date "December" 5 1988)
                                       (list -E-)
                                       (list -B- -C-)))
                       (-E- (make-user "@eve" false ""
                                       (make-birth-date "September" 30 1992)
                                       (list -C-)
                                       (list -D-)))]
                (create-user "@alice" true "https://www.alice.com/"
                             (create-birth-date "January" 15 1990)
                             empty
                             (list -B- -C-))) N1)
(check-expect (shared [(-F- (make-user "@frank" false ""
                                       (make-birth-date "June" 18 1987)
                                       (list -H-)
                                       (list -G- -H-)))
                       (-G- (make-user "@grace" true "https://www.grace.com/"
                                       (make-birth-date "April" 25 1993)
                                       (list -F- -J-)
                                       (list -H-)))
                       (-H- (make-user "@hank" false ""
                                       (make-birth-date "November" 8 1998)
                                       (list -F- -G-)
                                       (list -F- -I-)))
                       (-I- (make-user "@ivy" false ""
                                       (make-birth-date "August" 2 1991)
                                       (list -H-)
                                       empty))
                       (-J- (make-user "@jack" false "https://www.jack.com/"
                                       (make-birth-date "December" 12 1984)
                                       (list -J-)
                                       (list -G- -J-)))]
                (create-user "@jack" false "https://www.jack.com/"
                             (create-birth-date "December" 12 1984)
                             (list -J-)
                             (list -G- -J-))) N2)

;; Template: <User>
(define (create-user un v w bd fi fo)
  (make-user (valid-user-name? un) v
             (valid-website? w) bd
             fi fo))


;; UserName -> UserName | Error
;; produce the given username, un, if it is valid; otherwise produce an error

;; Stub:
#; (define (valid-user-name? un) un)

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <UserName>
(define (valid-user-name? un)
  (local [;; Natural; given username, un, length
          (define un-length (string-length un))

          ;; (listof String) -> Boolean
          ;; produce true if the given list of characters (strings), loc, contains any
          ;; character, besides letters, numbers or underscores; otherwise false

          ;; Stub:
          #; (define (user-name-forbidden-characters? loc) false)

          ;; Template: <"ormap">
          (define (user-name-forbidden-characters? loc)
            (ormap not-letter-number-underscore? loc))


          ;; String -> Boolean
          ;; produce true if the given character (string), c, is not
          ;; a letter, a number or an underscore

          ;; Stub:
          #; (define (not-letter-number-underscore? c) false)

          ;; Template: <String>
          (define (not-letter-number-underscore? c)
            (not (member c VALID-USERNAME-CHARS)))]

    (cond [(not (string=? (string-ith un 0) "@"))
           (produce-error "username" un "All usernames must start with '@'.")]
          [(or (< un-length 5) (> un-length 15))
           (produce-error
            "username" un
            "All usernames must be more than 4 characters long and can be up to 15 characters or less.")]
          [(user-name-forbidden-characters? (rest (explode un)))
           (produce-error
            "username" un
            "All usernames must only contain letters, numbers, and underscores.")]
          [else un])))


;; Website -> Website | Error
;; produce the given website, w, if it is valid; otherwise produce an error

;; Stub:
#; (define (valid-website? w) w)

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <Website>
(define (valid-website? w)
  (local [;; Website -> Boolean
          ;; produce true if the given string, w, is a valid URL; otherwise false
          ;; ASSUME: a valid URL has a scheme and a host; no path or query
          ;; NOTE: this is a very simple URL validation function that doesn't use
          ;;       regular expressions, which are commonly used for this task

          ;; Stub:
          #; (define (website-forbidden-URL? w) false)

          ;; Template: <String>
          (define (website-valid-URL? w)
            (and (string-prefix? "https://" w)
                 (or (string-suffix? ".com/" w)
                     (string-suffix? ".org/" w)
                     (string-suffix? ".net/" w))))]
       
    (cond [(> (string-length w) 100)
           (produce-error
            "website" w
            "All websites can only be up to 160 characters long.")]
          [(and (> (string-length w) 0) (not (website-valid-URL? w)))
           (produce-error "website" w "All websites must be valid URLs.")]
          [else w])))


;; Month Day Year -> BirthDate
;; produce a new birth date with given month, m, day, d, and year, y

;; Stub:
#; (define (create-birth-date m d y) BD0)

;; Tests:
(check-expect (create-birth-date "July" 22 1974) BD0)
(check-expect (create-birth-date "January" 10 1960) BD1)
(check-expect (create-birth-date "February" 29 2000)
              (make-birth-date "February" 29 2000))
(check-expect (create-birth-date "February" 29 2020)
              (make-birth-date "February" 29 2020))

;; Template: <BirthDate>
(define (create-birth-date m d y)
  (make-birth-date (valid-month? m)
                   (valid-day? d m y)
                   (valid-year? y)))


;; Month -> Month | Error
;; produce the given month, m, if it is valid; otherwise produce an error

;; Stub:
#; (define (valid-month? m) m)

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <Month>
(define (valid-month? m)
  (cond [(not (member m VALID-MONTHS))
         (produce-error
          "month" m
          "All months must be months of the year in the Gregorian calendar.")]
        [else m]))


;; Day Month Year -> Day | Error
;; produce the given day, d, if it is valid; otherwise produce an error
;; with the help of given month and year, m and y, respectively
;; ASSUME: m is a valid month

;; Stub:
#; (define (valid-day? d m y) d)

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <Day>
(define (valid-day? d m y)
  (local [;; Year -> Boolean
          ;; produce true if the given year, y, is a leap year

          ;; Stub:
          #; (define (leap-year? y) false)

          ;; Template: <Natural>
          (define (leap-year? y)
            (cond [(= (remainder y 100) 0)
                   (= (remainder y 400) 0)]
                  [else
                   (= (remainder y 4) 0)]))]

    (cond [(< 31 d)
           (produce-error
            "day" (number->string)
            "All days must be numbers less than 31.")]
          [(and (member m 30-DAY-MONTHS) (= 31 d))
           (produce-error "day" "31" (string-append m " doens't have 31 days."))]
          [(string=? "February" m)
           (cond [(= 30 d)
                  (produce-error "day" "30" "February doesn't have 30 days.")]
                 [(and (not (leap-year? y)) (= 29 d))
                  (produce-error
                   "day" "29"
                   (string-append "Since year: '" y "' is not a leap year, February doesn't have 29 days."))]
                 [else d])]
          [else d])))


;; Year -> Year | Error
;; produce the given year, y, if it is valid; otherwise produce an error

;; Stub:
#; (define (valid-year? y) y)

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <Year>
(define (valid-year? y)
  (cond [(or (> 1903 y) (< 2023 y))
         (produce-error
          "year" (number->string y)
          "All years must be comprised between 1903 and 2023, inclusive.")]
        [else y]))


;; String String -> Boolean
;; produce true if the given string, s, has prefix, p

;; Stub:
#; (define (string-prefix? p s) false)

;; Tests:
(check-expect (string-prefix? "https://" W1) true)
(check-expect (string-prefix? "https://" "hello, how are you?") false)

;; Template: <String>
(define (string-prefix? p s)
  (local [(define prefix-length (string-length p))]
    (and (<= prefix-length (string-length s))
         (string=? (substring s 0 prefix-length) p))))


;; String String -> Boolean
;; produce true if the given string, s, has suffix, su

;; Stub:
#; (define (string-suffix? su s) false)

;; Tests:
(check-expect (string-suffix? ".com/" W1) true)
(check-expect (string-suffix? ".org/" "hello, how are you?") false)

;; Template: <String>
(define (string-suffix? su s)
  (local [(define suffix-length (string-length su))
          (define s-length (string-length s))]
    (and (<= suffix-length s-length)
         (string=? (substring s (- s-length suffix-length)) su))))


;; String String String -> Error
;; produce an error message with the given, keyword, k, data, d, and message, m

;; Stub:
#; (define (produce-error k d m) (error ""))

;; Tests: <it is not possible to write tests for this function,
;;         because its functionality is throwing out errors>

;; Template: <String>
(define (produce-error k d m)
  (error (string-append "Given " k ": '" d "', is not a valid " k ". " m)))


;; User -> User
;; given one user of a Chirper Network, u, produce the user with the most followers
;; NOTE: in case of a tie, produce the first user to be found

;; Stub:
#; (define (most-followers u) u)

;; Tests:
(check-expect (most-followers U0) U0)
(check-expect (most-followers U1)
              (first (user-following U1)))
(check-expect (most-followers N1)
              (first (user-following N1)))
(check-expect (most-followers N2)
              (first (user-following N2)))
(check-expect (most-followers N3)
              (first (user-following N3)))
(check-expect (most-followers N4)
              (second (user-following (first (user-following N4)))))

;; Template: <User>
(define (most-followers u0)
  ;; computed is (listof UserName)
  ;; INVARIANT: a context-preserving accumulator; names of users already computed
  ;; ASSUME: a user's username is unique

  ;; todo is (listof User)
  ;; INVARIANT: a worklist accumulator

  ;; rsf is (list of RSFE)
  ;; INVARIANT: a result-so-far accumulator; users already visited and their
  ;;            respective number of followers
  ;; NOTE: u0 is the the only node, that when visiting for the first time, doesn't
  ;;       count has being followed by another user - followers starts at 0, while
  ;;       all the other rsfe entries, followers starts at 1
     
  (local [(define-struct rsfe (user followers))
          ;; RSFE (result-so-far accumulator entry) is (make-rsfe User Natural)
          ;; interp. a result-so-far accumulator entry with a user and its
          ;;         number of followers
          ;;         NOTE: followers can only be greater than or equal to 0

          (define (fn-for--user u computed todo rsf)
            (if (member (user-user-name u) computed)
                (fn-for--lou computed
                             todo
                             (update-followers (user-user-name u) rsf))
                (fn-for--lou (append computed (list (user-user-name u)))
                             (append (user-following u) todo)
                             (append rsf (list (make-rsfe u 1))))))

          
          (define (fn-for--lou computed todo rsf)
            (cond [(empty? todo) (max-followers rsf)]
                  [else
                   (fn-for--user (first todo)
                                 computed
                                 (rest todo)
                                 rsf)]))


          ;; UserName (listof RSFE) -> (listof RSFE)
          ;; increase the followers count by one in the entry in given result-so-far
          ;; accumulator entries, rsf, with the user named given user name, un
          ;; ASSUME: the entry exists; so, during recursion, rsf will not be empty

          ;; Stub:
          #; (define (update-followers un rsf) rsf)

          ;; Template: <List>
          (define (update-followers un rsf)
            (local [(define user (rsfe-user (first rsf)))]
              (cond [(string=? (user-user-name user) un)
                     (cons (make-rsfe
                            user
                            (add1 (rsfe-followers (first rsf))))
                           (rest rsf))]
                    [else
                     (cons (first rsf) (update-followers un (rest rsf)))])))


          ;; (listof RSFE) -> User
          ;; produce the user of the entry with the most followers count, given
          ;; result-so-far accumulator entries, rsf
          ;; In case of a tie, produce the first one in rsf

          ;; Stub:
          #; (define (max-followers rsf) U0)

          ;; Template: <List>
          (define (max-followers rsf0)
            ;; result is RSFE
            ;; INVARIANT: the user with the highest follower count seen so far
            
            (local [(define (max-followers rsf result)
                      (cond [(empty? rsf) (rsfe-user result)]
                            [(> (rsfe-followers (first rsf))
                                (rsfe-followers result))
                             (max-followers (rest rsf) (first rsf))]
                            [else
                             (max-followers (rest rsf) result)]))]

              (max-followers (rest rsf0) (first rsf0))))]

    (fn-for--lou (cons (user-user-name u0) empty)
                 (user-following u0)
                 (cons (make-rsfe u0 0) empty))))

;; or by using the "followers" field:

;; Template: <User>
#; (define (most-followers u0)
     ;; computed is (listof UserName)
     ;; INVARIANT: a context-preserving accumulator; names of users already computed
     ;; ASSUME: a user's username is unique

     ;; todo is (listof User)
     ;; INVARIANT: a worklist accumulator

     ;; rsf is User
     ;; INVARIANT: the user with the most followers already visited
     
     (local [(define (fn-for--user u computed todo rsf)
               (local [(define new-rsf (if (> (length (user-followers u))
                                              (length (user-followers rsf)))
                                           u rsf))]
                 (if (member (user-user-name u) computed)
                     (fn-for--lou computed todo new-rsf)
                     (fn-for--lou (append computed (list (user-user-name u)))
                                  (append (user-following u) todo)
                                  new-rsf))))

             (define (fn-for--lou computed todo rsf)
               (cond [(empty? todo) rsf]
                     [else
                      (fn-for--user (first todo)
                                    computed
                                    (rest todo)
                                    rsf)]))]

       (fn-for--lou (cons (user-user-name u0) empty)
                    (user-following u0)
                    u0)))

