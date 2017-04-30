(require-extension byte-blob)

(declare (unit packages))

(define (read-u8string)
  (read-u8vector 64))

(define (read-u8short)
  (read-u8vector 2))

(define (get-client-package)
  (define id (read-byte))
  (cond
    ; player identification
    ((eq? id #x00)
     (u8vector id (read-byte) (read-u8string) (read-u8string) #x00))

    ; set block
    ((eq? id #x05)
     (u8vector id (read-u8short) (read-u8short) (read-u8short) (read-byte) (read-byte)))

    ; position and orientation
    ((eq? id #x08)
     (u8vector id (read-byte) (read-u8short) (read-u8short) (read-u8short) (read-byte) (read-byte)))

    ; message
    ((eq? id #x0d)
     (u8vector id (read-byte) (read-u8string)))

    ; unknown
    (else
      (u8vector id))))

(define (send-server-identification)
  (define pack (u8vector #x00 #x07 (string->u8vector "test name")))
  (write-u8vector pack))

(define (send-disconnect)
  (define pack (byte-blob->u8vector (byte-blob-append (byte-blob-cons #x0e (string->byte-blob "Disconnect")) (byte-blob-replicate 54 #x00))))
  (write-u8vector pack))
