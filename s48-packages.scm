;;; -*- mode: scheme; scheme48-package: (config) -*-
;;;
;;; Scheme48 specific packages
;;;

(define-structure define-record-type*
    (export (define-record-type* :syntax)
            define-record-discloser)
  (open scheme define-record-types)
  (for-syntax (open scheme define-record-type*-expander))
  (begin (define-syntax define-record-type*
           expand-define-record-type*
           (BEGIN DEFINE DEFINE-RECORD-TYPE))))

(define-structure define-record-type*-expander
    (export expand-define-record-type*)
  (open scheme destructuring fluids signals receiving)
  (files s48-records))

(define-structure weak-pair
    (export weak-pair?
            weak-cons
            weak-pair/car?
            weak-car weak-set-car!
            weak-cdr weak-set-cdr!
            weak-memq)
  (open scheme define-record-type* weak)
  (files s48-weak-pair))

(define-structure fixnum
    (export fix:=
	    fix:< fix:> fix:<= fix:>=
	    fix:zero? fix:positive? fix:negative?
	    fix:+ fix:- fix:*
	    fix:quotient fix:remainder
	    fix:1+ fix:1-
	    fix:not fix:and fix:andc
	    fix:or fix:xor fix:lsh)
  (open scheme bitwise)
  (files s48-fixnum))

(define-structure errors
    (export error:bad-range-argument
	    error:datum-out-of-range
	    error:file-operation
	    error:wrong-type-argument)
  (open scheme signals)
  (files s48-errors))