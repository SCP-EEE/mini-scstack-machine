(define buffer '())
(define history '())
(define view-past '())
(define (push a)
  (set! view-past (cons (list 'push a) view-past))
  (set! buffer (append (list a) buffer)))
(define (pop)
  (let ((a (car buffer)))
    (begin
      (set! view-past (cons 'pop view-past))
      (set! buffer (cdr buffer))
      (set! history (append (list a) history))
      (if (number? (car a))
	  a
	  (eval a (interaction-environment))))))
(define (add)
  (let ((a (car buffer))
	(b (cadr buffer))) (begin
			     (set! view-past (cons 'sub view-past))
			     (set! buffer (cddr buffer))
			     (push (+ b a)))))
(define (sub)
  (let ((a (car buffer))
	(b (cadr buffer))) (begin
			     (set! view-past (cons 'sub view-past))
			     (set! buffer (cddr buffer))
			     (push (- b a)))))
(define (div)
  (let ((a (car buffer))
	(b (cadr buffer))) (begin
			    (set! view-past (cons 'div view-past))
			    (set! buffer (cddr buffer))
			    (push (/ b a)))))
(define (times)
  (let ((a (car buffer))
	(b (cadr buffer))) (begin
			    (set! view-past (cons 'div view-past))
			    (set! buffer (cddr buffer))
			    (push (* b a)))))
(define (exch)
  (let ((a (car buffer))
	(b (cadr buffer))) (begin
			     (set! view-past (cons 'exch view-past))
			     (set! buffer (cddr buffer))
			     (push a)
			     (push b))))
(define (match-buffer a)
  (let loop ((i (- (length buffer) 1)))
    (if (= a (car buffer))
	(car buffer) (begin
		       (set! view-past (cons (list 'match-buffer a) view-past))
		       (set! buffer (cdr buffer))
		       (if (= i 0)
			   #f
			   (loop (- i 1)))))))
(define (clear)
  (begin
    (set! buffer '())
    (set! history '())))
(define (elt s) (list-ref buffer s))
(define (fib-buffer) (push (+ (car buffer) (cadr buffer))))
(define (type-check)
  (cond
   ((number? (car buffer)) (display "current is Number"))
   ((string? (car buffer)) (display "current is String"))))
(define (number-sequence a)
  (if (< a 1)
      (list a)
      (append (list a) (number-sequence (- a 1)))))
(define (previous-type) (let ((now-eval (lambda (x) (eval x (interaction-environment))))) (map now-eval view-past)))
(define (exch-list a) (cons (list-ref a (- (length a) 1)) (reverse (cdr (reverse a))))) 
(define (num-exch-list a n) (let loop ((x a)(j n)) (if (< j 1) x (loop (exch-list x) (- j 1)))))
