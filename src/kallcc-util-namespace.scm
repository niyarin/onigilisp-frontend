(define-library (kallcc util namespace)
  (import (scheme base) (scheme hash-table) (scheme comparator)
          (scheme list)
          (prefix (kallcc util namespace) kunamespace/))
  (export merge filter-keys filter-keys-alist)
  (begin
    (define (merge g1 g2)
      (let ((g (hash-table-copy g1 #t)))
        (hash-table-union! g g2)))

    (define (filter-keys-alist g keys)
      (filter-map (lambda (k)
                    (if (hash-table-contains? g k)
                      (cons k (hash-table-ref g k))
                      #f))
                  keys))

    (define (filter-keys g keys)
      (alist->hash-table (filter-keys-alist g keys)
                         (make-eq-comparator)))))
