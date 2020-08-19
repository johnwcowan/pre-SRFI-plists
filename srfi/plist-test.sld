(define-library (plist-test)
  (export run-tests)

  (import (scheme base)
          (srfi 64)
          (plist))

  (begin
    (define (run-tests)

      (test-begin "plists")

      (test-group "plist-get"

        (test-error #t (plist-get '() 'a))
        (test-error #t (plist-get '(a 1) 'b))
        (test-eqv 3 (plist-get '(a 1) 'b (lambda () 3)))
        (test-eqv 1 (plist-get '(a 1 b 2) 'a))
        (test-eqv 2 (plist-get '(a 1 b 2) 'b))
        (test-eqv 4 (plist-get '(a 1 b 2) 'b (lambda () #f) (lambda (x) (* x x))))

        )


      (test-group "plist-get/default"

        (test-eqv 1 (plist-get/default '(a 1 b 2) 'a #t))
        (test-eqv #t (plist-get/default '(a 1 b 2) 'c #t))

        )


      (test-group "plist-get-properties"

        (define tail '(b 2))

        (test-equal `(a 1 ,tail)
          (let-values ((res (plist-get-properties `(a 1 . ,tail) '(c a))))
            res))

        (test-equal '(#f #f #f)
          (let-values ((res (plist-get-properties '(a 1) '(b c))))
            res))

        )


      (test-group "plist-put!"

        (define head (list 'a 1))

        (test-equal '(a 1)
          (plist-put! '() 'a 1))
        (test-eq head (plist-put! head 'b 2))
        (test-equal '(a 1 b 2) head)
        (test-eq head (plist-put! head 'a 3))
        (test-equal '(a 3 b 2) head)
        (test-eq head (plist-put! head 'b 4))
        (test-equal '(a 3 b 4) head)

        )


      (test-group "plist-remove!"

        (define head (list 'a 1 'b 2 'c 3))

        (test-eq '() (plist-remove! '() 'a))
        (test-eq '() (plist-remove! '(a 1) 'a))
        (test-eq head (plist-remove! head 'c))
        (test-equal '(a 1 b 2) head)
        (test-eq head (plist-remove! head 'a))
        (test-equal '(b 2) head)
        (test-eq head (plist-remove! head 'c))
        (test-equal head '(b 2))
        (test-eq '() (plist-remove! head 'b))

        )


      (test-group "plist-search!"

        (define head (list 'a 1 'b 2))

        (test-equal '((a 3 b 2) #t)
          (let-values ((res (plist-search! head 'a
                                           (lambda (insert ignore)
                                                     (error "failure called"))
                                           (lambda (key value update remove)
                                             (update key 3 #t)))))
            res))
        (test-equal '((b 2) #t)
          (let-values ((res (plist-search! head 'a
                                           (lambda (insert ignore)
                                             (error "failure called"))
                                           (lambda (key value update remove)
                                             (remove #t)))))
            res))
        (test-equal '((b 2 a 1) #t)
          (let-values ((res (plist-search! head 'a
                                           (lambda (insert ignore)
                                             (insert 1 #t))
                                           (lambda (key value update remove)
                                             (error "success called")))))
            res))
        (test-equal '((b 2 a 1) #t)
          (let-values ((res (plist-search! head 'c
                                           (lambda (insert ignore)
                                             (ignore #t))
                                           (lambda (key value update remove)
                                             (error "success called")))))
            res))

        )


      (test-group "plist-size"

        (test-eqv 0 (plist-size '()))
        (test-eqv 2 (plist-size '(a 1 b 2)))

        )


      (test-group "plist-map!"

        (define plist (list 'a 1 'b 2))

        (test-eq plist (plist-map! (lambda (key value)
                                    (* value 2))
                                  plist))
        (test-equal '(a 2 b 4) plist)

        )


      (test-group "plist-filter!"

        (define plist (list 'a 1 'b 2 'c 3))

        (test-equal '() (plist-filter! (lambda (key value) #t) '()))
        (test-equal '() (plist-filter! (lambda (key value) #t) '(a 1)))
        (test-eq plist (plist-filter! (lambda (key value) (odd? value)) plist))
        (test-equal '(b 2) plist)

        )

      (test-group "plist-for-each"

        (test-equal '((b . 2) (a . 1))
          (let ((acc '()))
            (plist-for-each (lambda (key value)
                              (set! acc (cons (cons key value) acc)))
                            '(a 1 b 2))
            acc))

        )

      (test-group "plist->alist"

        (test-equal '((a . 1) (b . 2)) (plist->alist '(a 1 b 2)))

      )

      (test-group "alist->plist"

        (test-equal '(a 1 b 2) (alist->plist '((a . 1) (b . 2))))

        )

      (test-end "plists"))))
