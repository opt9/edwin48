;;; -*- Mode: Scheme; scheme48-package: keystroke -*-
;;;
;;; also defined for-syntax, see packages.scm
;;;
(define *keystroke-modifiers* '())
(define *keystroke-prefix*    'keystroke-modifier:)

(define-syntax define-keystroke-modifier
  (lambda (form rename compare)
    (let* ((form      (cdr form))
           (name      (car form))
           (offset    (cadr form))
           (full-name (symbol-append *keystroke-prefix* name))
           (%define   (rename 'define)))
      (if (not (assq name *keystroke-modifiers*))
          (set! *keystroke-modifiers* (alist-cons name offset *keystroke-modifiers*)))
      `(,%define ,full-name ,offset))))

(define-keystroke-modifier meta    1)
(define-keystroke-modifier control 2)
(define-keystroke-modifier super   4)
(define-keystroke-modifier hyper   8)

(define-record-type* simple-keystroke
  (make-named-keystroke
   ;;
   ;; Stores the character value of the keystroke
   ;;
   value
   ;;
   ;; modifiers must be one of the defined keystroke modifiers, listed
   ;; above. The representation is just a list (set) of symbols, it
   ;; could be optimized to use a bit offsets.
   ;;
   modifiers)
  ())

(define-record-type* named-keystroke
  (make-named-keystroke
   ;;
   ;; a string containing a escape sequence
   ;;
   value
   ;;
   ;; see above
   ;;
   modifiers
   ;;
   ;; a symbol containing the name of the keystroke (i.e. up, down, left, right)
   ;;
   name)
  ())

(define (keystroke? k)
  (or (simple-keystroke? k)
      (named-keystroke?  k)))

(define (keystroke-value k)
  (cond ((simple-keystroke? k) (simple-keystroke-value k))
        ((named-keystroke?  k) (named-keystroke-value  k))
        (else (error "not a keystroke" k))))

(define (keystroke-modifiers k)
  (cond ((simple-keystroke? k) (simple-keystroke-modifiers k))
        ((named-keystroke?  k) (named-keystroke-modifiers  k))
        (else (error "not a keystroke" k))))

(define (keystroke-name k)
  (cond ((simple-keystroke? k) (char->name   (simple-keystroke-value  k)))
        ((named-keystroke?  k) (symbol->string (named-keystroke-name  k)))
        (else (error "not a keystroke" k))))

(define* (make-keystroke value (modifiers '()) (name #f))
  (cond
   ((number? value) (make-simple-keystroke (ascii->char value) modifiers))
   ((char? value)   (make-simple-keystroke value modifiers))
   ((string? value)
    (cond
     ((string? name) (make-named-keystroke value modifiers name))
     ((not (zero? (string-length value))) (make-simple-keystroke value modifiers))
     (else "invalid string input" value)))
   (else (error "invalid input" value))))

(define-syntax kbd
  (lambda (form rename compare)
    (let ((%keystroke (rename 'make-keystroke))
          (r          rename)
          (form       (cdr form))) ;; discard the first token, 'KBD'
      (define (parse-kbd-form form)
        (cond
         ((char? form)
          `(,%keystroke (,(r 'string) ,form) '()))
         ((string? form)
          (if (= 1 (string-length form))
              `(,%keystroke ,form '())
              `(,(r 'map) (,(r 'lambda) (c) (,%keystroke (,(r 'string) c) '()))
                (,(r 'string->list) ,form))))
         ((list? form)
          (let* ((form      (reverse form))
                 (key       (car form))
                 (modifiers (cdr form)))
            ;; if all the modifiers are valid
            (if (lset<= compare
                        (map rename modifiers)
                        (map (lambda (x) (rename (car x))) *keystroke-modifiers*))
                `(,%keystroke ,key (,(r 'delete-duplicates) ',modifiers))
                (syntax-error "contains invalid modifier" modifiers))))))
      (if (= 1 (length form))
          (parse-kbd-form (car form))
          (map parse-kbd-form form)))))

