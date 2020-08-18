(define-library (plist)
  (export plist-get
          plist-get/default
          plist-get-properties
          plist-put!
          plist-remove!
          plist-search!
          plist-size
          plist-map!
          plist-filter!
          plist-for-each
          plist->alist
          alist->plist)
  (import (scheme base)
          (scheme case-lambda))
  (begin
    (define (plist-memq key plist)
      (let f ((plist plist))
        (and (pair? plist)
             (if (eqv? key (car plist))
                 plist
                 (f (cddr plist))))))

    (define plist-get
      (case-lambda
        ((plist key)
         (plist-get plist
                    key
                    (lambda () (error "plist-get: key not found" key))
                    values))
        ((plist key failure)
         (plist-get plist key failure values))
        ((plist key failure success)
         (cond
          ((plist-memq key plist)
           => (lambda (tail)
                (success (cadr tail))))
          (else
           (failure))))))

    (define (plist-get/default plist key default)
      (plist-get plist key (lambda () default)))

    (define (plist-get-properties plist list-of-keys)
      (let f ((plist plist))
        (if (pair? plist)
            (if (memv (car plist) list-of-keys)
                (values (car plist) (cadr plist) (cddr plist))
                (f (cddr plist)))
            (values #f #f #f))))

    (define (plist-put! plist key value)
      (let-values (((plist obj)
                    (plist-search! plist
                                   key
                                   (lambda (insert ignore)
                                     (insert value #f))
                                   (lambda (old-key old-value update remove)
                                     (update key value #f)))))
        plist))

    (define (plist-remove! plist key)
      (let-values (((plist obj)
                    (plist-search! plist
                                   key
                                   (lambda (insert ignore)
                                     (ignore #f))
                                   (lambda (key value update remove)
                                     (remove #f)))))
        plist))

    (define (plist-search! plist key failure success)
      (let f! ((head #f) (tail plist))
        (cond
         ((null? tail)
          (failure (lambda (value obj)
                     (if head
                         (begin
                           (set-cdr! (cdr head) (list key value))
                           (values plist obj))
                         (values (list key value) obj)))
                   (lambda (obj)
                     (values plist obj))))
         ((eqv? key (car tail))
          (success (car tail)
                   (cadr tail)
                   (lambda (new-key new-value obj)
                     (set-car! tail new-key)
                     (set-car! (cdr tail) new-value)
                     (values plist obj))
                   (lambda (obj)
                     (cond
                      (head
                       (set-cdr! (cdr head) (cddr tail))
                       (values plist obj))
                      ((null? (cddr tail))
                       (values '() obj))
                      (else
                       (set-car! tail (car (cddr tail)))
                       (set-cdr! tail (cdr (cddr tail)))
                       (values plist obj))))))
         (else
          (f! tail (cddr tail))))))

    (define (plist-size plist)
      (/ (length plist) 2))

    (define (plist-map! proc plist)
      (do ((tail plist (cddr tail)))
          ((null? tail) plist)
        (set-car! (cdr tail) (proc (car tail) (cadr tail)))))

    (define (plist-filter! pred plist)
      (let f! ((plist plist))
        (if (null? plist)
            '()
            (let ((tail (f! (cddr plist))))
              (if (pred (car plist) (cadr plist))
                  (if (null? tail)
                      '()
                      (begin
                        (set-car! plist (car tail))
                        (set-cdr! plist (cdr tail))
                        plist))
                  (if (null? tail)
                      (begin
                        (set-cdr! (cdr plist) '())
                        plist)
                      plist))))))

    (define (plist-for-each proc plist)
      (do ((plist plist (cddr plist)))
          ((null? plist))
        (proc (car plist) (cadr plist))))

    (define (plist->alist plist)
      (let f ((plist plist))
        (if (null? plist)
            '()
            (cons (cons (car plist) (cadr plist))
                  (f (cddr plist))))))

    (define (alist->plist alist)
      (let f ((alist alist))
        (if (null? alist)
            '()
            (cons (caar alist) (cons (cdar alist) (f (cdr alist)))))))))
