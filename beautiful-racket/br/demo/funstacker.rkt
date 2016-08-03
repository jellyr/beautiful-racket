#lang br/quicklang

(define (read-syntax path port)
  (define args (port->lines port))
  (define arg-datums (format-datums '~a args))
  (define module-datum `(module stacker-mod br/demo/funstacker
                          (handle-args ,@arg-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define (handle-args . args)
  (for/fold ([stack empty])
            ([arg (in-list (filter-not void? args))])
    (cond
      [(number? arg) (cons arg stack)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result (arg (first stack) (second stack)))
       (cons op-result (drop stack 2))])))
(provide handle-args)

(provide + *)

(module+ test 
  (require rackunit)
  (check-equal? (with-output-to-string (λ () (dynamic-require "funstacker-test.rkt" #f))) "36"))