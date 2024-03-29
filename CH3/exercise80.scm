(define (integral delayed-integrand initial-value dt) 
	(define int
		(cons-stream
			initial-value
				(let ((integrand (force delayed-integrand)))
       				(add-streams (scale-stream integrand dt) int))))
 	int)



(define (RLC R L C dt)
	(define (helper vc0 il0)
		(define vc (integral (delay dvc) vc0 dt))
		(define il (integral (delay dil) il0 dt))
		(define dvc (scale-stream il (/ -1 C)))
		(define dil (add-streams (scale-stream il (/ (* -1 R) L)) (scale-stream vc (/ 1 L))))
		(cons vc il)
	)
	helper
)