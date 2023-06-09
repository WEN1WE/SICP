(define (integers-starting-from n)
	(cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))


(define (add-streams s1 s2) (stream-map + s1 s2))

(define (partial-sums s)
	(cons-stream (stream-car s) (add-streams (partial-sums s) (stream-cdr s)))
)


#|

     1  2  3  4  5  6       s
        1  3  6 10          p
     1  3  6 10 15          p


|#