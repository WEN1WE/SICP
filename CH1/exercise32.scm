(define (accumulate combiner null-value term a next b)
	(if (> a b)
		null-value
		(combiner (term a) (accumulate combiner null-value term (next a) next b))
	)
)

(define (accumulate-iter combiner null-value term a next b)
	(define (iter a result)
		(if (> a b)
			result
			(iter (next a) (combiner result (term a)))
		)

	)
	(iter a null-value)
)


(define (sum term a next b)
	(accumulate-iter + 0 term a next b)
)

(define (product term a next b)
	(accumulate * 1 term a next b)
)




(define (inc n) (+ n 1))
(define (f x) x)



#|
1 ]=> (sum f 1 inc 10)

;Value: 55

1 ]=> (product f 1 inc 5)

;Value: 120



|#
