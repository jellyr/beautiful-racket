#lang br/quicklang
(require "tokenizer.rkt" "parser.rkt")
(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module jsonic-module "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)