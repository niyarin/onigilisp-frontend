(include "../src/onif-symbol.scm")
(include "../src/kallcc-symbol.scm")
(include "../src/kallcc-misc.scm")

(import (scheme base)
        (srfi 64)
        (scheme set)
        (scheme comparator)
        (prefix (kallcc misc) kmisc/)
        (prefix (kallcc symbol) ksymbol/))

(begin;;tconc-test
   (test-begin "test-tconc")
   (let ((tconc (kmisc/make-tconc)))
     (kmisc/tconc-push! tconc 1)
     (test-equal (kmisc/tconc-head tconc) '(1))
     (kmisc/tconc-push! tconc 2)
     (test-equal (kmisc/tconc-head tconc) '(1 2)))
   (test-end "test-tconc"))

(begin;;scm-expression->symbol-set-test
   ;kallcc-symbol の考慮はいるのか
   (test-begin "test-scm-expression->symbol-set")
   (test-assert
      (set=? (kmisc/scm-expression->symbol-set '(list 1 2 a b "c"))
             (set (make-eq-comparator) 'list 'a 'b)))
   (let ((tmp-symbol (ksymbol/kallcc-symbol 'piyo)))
     (test-assert
        (set=? (kmisc/scm-expression->symbol-set '(list 1 tmp-symbol a b "c"))
                 (set (make-eq-comparator) 'list 'a 'b 'tmp-symbol))))
   (test-assert
      (set=? (kmisc/scm-expression->symbol-set '(list (cons a b) (list c d)))
             (set (make-eq-comparator) 'list 'cons 'a 'b 'c 'd)))
   (test-end "test-scm-expression->symbol-set"))

;(begin ;;rename-symbol-in-expression-test
;   (test-begin "test-rename-symbol-in-expression")
;   (test-end "test-rename-symbol-in-expression")
;  )
