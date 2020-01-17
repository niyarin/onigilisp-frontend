(include "./onif-symbol.scm")
(include "./onif-idebug.scm")
(include "./onif-misc.scm")

(define-library (onif meta-lambda)
   (import (scheme base)
           (onif idebug)
           (onif misc)
           (onif symbol))
   (export onif-meta-lambda-conv
           onif-meta-lambda-test-%make-meta-info)

   (begin
     (define (%lambda-operator? operator onif-symbol-hash)
        (cond
          ((not (onif-symbol? operator)) #f)
          ((eq? (onif-misc/onif-symbol-hash-ref onif-symbol-hash 'lambda)
                operator))
          (else #f)))

     (define (%if-operator? operator onif-symbol-hash)
        (cond
          ((not (onif-symbol? operator)) #f)
          ((eq? (onif-misc/onif-symbol-hash-ref onif-symbol-hash 'if)
                operator))
          (else #f)))

     (define (%make-meta-info . options)
         (let ((stack 
                 (cond ((assq 'stack options) => cadr)(else '())))
               (base 
                 (cond ((assq 'base options) => cadr)(else #f)))
               (formals 
                 (cond ((assq 'formals options) => cadr )(else '()))))

            (list 
              (list 'bind-names 
                    (append (apply append stack)
                            formals)))))

     (define (%conv-meta-lambda cps-code onif-symbol-hash stk onif-expand-env)
       (cond 
         ((not (pair? cps-code)) cps-code)
         ((%lambda-operator? (car cps-code) onif-symbol-hash)
          (let ((new-stk (cons (cadr cps-code) stk)))
            `(,(onif-misc/onif-symbol-hash-ref onif-symbol-hash 'lambda-META)
             ,(cadr cps-code)
             ,(%make-meta-info 
               `(stack ,stk)
               `(formals ,(cadr cps-code)))
             .
             ,(map 
               (lambda (body)
                 (%conv-meta-lambda body onif-symbol-hash new-stk onif-expand-env))
               (cddr cps-code)))))
         (else 
           (map 
              (lambda (x)
                (%conv-meta-lambda x onif-symbol-hash stk onif-expand-env))
              cps-code))
         ))

     (define (onif-meta-lambda-conv  cps-code onif-symbol-hash onif-expand-env-with-name-id)
       (%conv-meta-lambda
         cps-code
         onif-symbol-hash
         '()
         onif-expand-env-with-name-id))))
