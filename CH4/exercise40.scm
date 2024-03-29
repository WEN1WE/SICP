(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require (distinct? (list baker cooper fletcher miller smith))) ;; 放到最后
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))


(baker (amb 1 2 3 4))
(cooper (amb 2 3 4 5))
(fletcher (amb 2 3 4))
(miller (amb 1 2 3 4 5))
(smith (amb 1 2 3 4 5))

(require (> miller cooper))  ; 这条语句排除1/2的选择
(require (not (= (abs (- smith fletcher)) 1)))  ; 这条语句排除1/5的选择
(require (not (= (abs (- fletcher cooper)) 1))) ; 这条语句排除1/5的选择
(require (distinct? (list baker cooper fletcher miller smith))) ;这条语句排除601/625的选择




(define (multiple-dwelling)
  (let ((miller (amb 1 2 3 4 5))
        (cooper (amb 2 3 4 5)))
    (require (> miller cooper))
      (let ((fletcher (amb 2 3 4)))
        (require (not (= (abs (- cooper fletcher)) 1)))
          (let ((smith (amb 1 2 3 4 5)))
            (require (not (= (abs (- smith fletcher)) 1)))
              (let ((baker (amb 1 2 3 4)))
                (require (distinct? (list baker cooper fletcher miller smith)))
                  (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))
              )
          )
      )

  )
)


