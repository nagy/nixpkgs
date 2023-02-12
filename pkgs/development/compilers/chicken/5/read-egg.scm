(import (chicken process-context)
        (chicken format)
        (chicken string))

(define env-var get-environment-variable)
(define ref alist-ref)

(define (safe-string maybe-symbol)
  (if (symbol? maybe-symbol)
    (symbol->string maybe-symbol)
    maybe-symbol))

(define egg
  (map (lambda (entry)
         (cons (safe-string (car entry)) (cdr entry)))
       (read)))

(printf "[~A]\n" (env-var "EGG_NAME"))

(define dependencies
  (map (lambda (dep)
         (safe-string (if (list? dep)
                        (car dep)
                        dep)))
       (ref "dependencies" egg equal? '())))
(printf "dependencies = [~A]\n"
        (string-intersperse (map (lambda (dep) (sprintf "~S" dep))
                                 dependencies)
                            ", "))

(define license (ref "license" egg equal?))
(printf "license = ~S\n"
        (if (not license)
          ""
          (string-translate (safe-string (car license))
                            "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
                            "abcdefghijklmnopqrstuvwxyz-")))

(printf "sha256 = ~S\n" (env-var "EGG_SHA256"))

(define synopsis (ref "synopsis" egg equal?))
(printf "synopsis = ~S\n"
        (if (not synopsis)
          ""
          (car synopsis)))

(printf "version = ~S\n" (env-var "EGG_VERSION"))
(print)
