(require-extension byte-blob)
(require-extension z3)

(declare (unit packages))
(declare (uses config))

(define (read-u8string)
  (read-u8vector 64))

(define (read-u8short)
  (read-u8vector 2))

(define (padded-string in)
  (byte-blob-append (string->byte-blob in) (byte-blob-replicate (- 64 (string-length in)) #x20)))

(define (padded-data in)
  (if (>= (string-length in) 1024)
    (byte-blob-append (string->byte-blob in))
    (byte-blob-append (string->byte-blob in) (byte-blob-replicate (- 1024 (string-length in)) #x00))))

(define (get-client-package)
  (define id (read-byte))
  (cond
    ; player identification
    ((eq? id #x00)
     (byte-blob->u8vector (byte-blob-cons id (u8vector->byte-blob (read-u8vector (+ 1 64 64 1))))))

    ; set block
    ((eq? id #x05)
     (byte-blob->u8vector (byte-blob-cons id (u8vector->byte-blob (read-u8vector (+ 2 2 2 1 1))))))

    ; position and orientation
    ((eq? id #x08)
     (byte-blob->u8vector (byte-blob-cons id (u8vector->byte-blob (read-u8vector (+ 1 2 2 2 1 1))))))

    ; message
    ((eq? id #x0d)
     (byte-blob->u8vector (byte-blob-cons id (u8vector->byte-blob (read-u8vector (+ 1 64))))))

    ; unknown
    (else
      (u8vector id))))

(define (send-server-identification)
  (debug "[pigman] sending ident...")
  (define pack (byte-blob->u8vector (byte-blob-append (byte-blob-cons #x00 (byte-blob-cons #x07 (padded-string cfg-name))) (padded-string cfg-motd) (byte-blob-replicate 1 #x00))))
  (write-u8vector pack)
  (debug "done~%"))

(define (send-level-init)
  (debug "[pigman] sending level init...")
  (write-u8vector (u8vector #x02))
  (debug "done~%"))

(define (send-world)
  (debug "[pigman] sending level data:~%")
  (send-level-data-chunk (z3:encode-buffer (make-string (* 256 64 256) (integer->char #x00))))
  (debug "[pigman] all done sending level data~%"))

(define (send-level-data-chunk world)
  (debug "[pigman] sending level data chunk...")
  (define chunk (if (> (string-length world) 1024) (string-take world 1024) world))
  (write-u8vector (u8vector #x03))
  (write (s16vector (string-length chunk)))
  (write-u8vector (byte-blob->u8vector (padded-data chunk)))
  (write-u8vector (u8vector #x00))
  (debug "done~%")
  (if (> (string-length world) 1024) (send-level-data-chunk (string-drop world 1024))))

(define (send-level-finalize)
  (debug "[pigman] sending level finalize...")
  (write-u8vector (u8vector #x04))
  (write (s16vector 256 64 256))
  (debug "done~%"))

(define (send-disconnect)
  (define pack (byte-blob->u8vector (byte-blob-cons #x0e (padded-string "Disconnect"))))
  (write-u8vector pack))
