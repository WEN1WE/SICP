(define (add-streams s1 s2) (stream-map + s1 s2))

(define (scale-stream stream factor) 
	(stream-map (lambda (x) (* x factor))
		stream))



(define (integral delayed-integrand initial-value dt) 
	(define int
		(cons-stream
			initial-value
				(let ((integrand (force delayed-integrand)))
       				(add-streams (scale-stream integrand dt) int))))
 	int)

(define (solve-2nd f dt y0 dy0)
	(define y (integral (delay dy) y0 dt)) 
	(define dy (integral (delay ddy) dy0 dt))
	(define ddy (stream-map f dy y))
	y
)