
(define (make-serializer) 
	(let ((mutex (make-mutex)))
		(lambda (p)
			(define (serialized-p . args)
				(mutex 'acquire)
				(let ((val (apply p args)))
          			(mutex 'release)
          			val))
      	serialized-p)))



(define (make-mutex)
	(let ((cell (list false)))
		(define (the-mutex m) 
			(cond ((eq? m 'acquire)
						(if (test-and-set! cell) 
							(the-mutex 'acquire))) ; retry
            	  ((eq? m 'release) (clear! cell))))
        the-mutex))

(define (clear! cell) (set-car! cell false))


(define (test-and-set! cell)
	(if (car cell) 
		true (begin (set-car! cell true) false)))



(define (make-account balance) 
	(define (withdraw amount) 
		(if (>= balance amount)
			(begin (set! balance (- balance amount)) 
				balance)
			"Insufficient funds")) 
	(define (deposit amount)
		(set! balance (+ balance amount))
		balance)
	(let ((protected (make-serializer)))
		(let ((protected-withdraw (protected withdraw)) 
			  (protected-deposit (protected deposit)))
			(define (dispatch m)
				(cond ((eq? m 'withdraw) protected-withdraw)
					  ((eq? m 'deposit) protected-deposit) 
					  ((eq? m 'balance) balance)
					  (else
                       (error "Unknown request: MAKE-ACCOUNT"
                            m))))
			dispatch)))





(a 'withdraw)
                                 (b 'withdraw)


(test-and-set! cell)

                               (test-and-set! cell)
(set-car! cell true)

                              (set-car! cell true)

false

                             false






















