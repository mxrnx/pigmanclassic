(declare (unit communicate))
(declare (uses packages))

(define (accept-player port)
  ;(write-line (number->string (u8vector-ref (read-u8vector 1) 0))))
  (define pack (get-client-package))
  (if (not (eq? (u8vector-ref pack 0) #x00))
    (send-disconnect))

  (send-server-identification))

(define (communicate)
  (send-level-init)
  (send-world)
  (send-level-finalize))
  ;(send-disconnect))
