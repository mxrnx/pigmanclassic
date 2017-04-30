(declare (unit communicate))
(declare (uses packages))

(define (accept-player port)
  ;(write-line (number->string (u8vector-ref (read-u8vector 1) 0))))
  (define pack (get-client-package))
  (if (eq? (u8vector-ref pack 0) #x00)
    (write-line "user sent 0 package")))

(define (communicate)
  (send-disconnect))
