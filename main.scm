(require-extension r7rs)

(require-extension tcp-server posix)

(declare (uses communicate))
(declare (uses packages))

(define totalplayers 0)

(define (listener)
  (accept-player (current-input-port))
  (communicate))

((make-tcp-server 
   (tcp-listen 25565) 
   listener)
 #t)
