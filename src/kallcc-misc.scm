(define-library (kallcc misc)
  (import (scheme base)
          (scheme comparator)
          (scheme set)
          (onif symbol)
          (prefix (kallcc symbol) ksymbol/))
  (export kerror make-tconc tconc-head tconc-push! scm-expression->symbol-set find-in-expression
          rename-symbol-in-expression inverse-alist var?)
  (begin
    (define kerror error)

    (define (var? obj)
      (or (symbol? obj)
          (onif-symbol? obj)
          ;(ksymbol/kallcc-symbol? obj)
          ))

    (define-record-type <tconc>
      (%make-tconc head tail)
      tconc?
      (head %tconc-head %tconc-set-head!)
      (tail %tconc-tail %tconc-set-tail!))

    (define (make-tconc)
      (let ((cell (list #f)))
        (%make-tconc cell cell)))

    (define (tconc-head obj)
      (cdr (%tconc-head obj)))

    (define (tconc-push! tconc x)
       (set-cdr! (%tconc-tail tconc) (list x))
       (%tconc-set-tail! tconc (cdr (%tconc-tail tconc))))

    (define (find-in-expression expression proc)
      (let loop ((expression expression))
        (cond
          ((proc expression) (list expression))
          ((pair? expression)
           (append (loop (car expression))
                   (loop (cdr expression))))
          (else '()))))

    (define (scm-expression->symbol-set expression . symbol-procedure-opt)
      (let ((symbol-procedure (if (not (null? symbol-procedure-opt))
                                (car symbol-procedure-opt)
                                var?)))
        (list->set (make-eq-comparator)
                   (find-in-expression expression symbol-procedure))))

    (define (inverse-alist alist)
      (map (lambda (apair) (cons (cdr apair) (car apair)))
           alist))

    (define (rename-symbol-in-expression expression alist)
      (let loop ((expression expression))
        (cond
          ((pair? expression)
           (cons (loop (car expression))
                 (loop (cdr expression))))
          ((and (var? expression)
                (assq expression alist))
           => cdr)
          (else expression))))))
