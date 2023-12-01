;;;; -*- mode: Scheme; -*-

(import (sdl))


(sdl-set-main-ready!)

(sdl-init SDL-INIT-VIDEO
	  SDL-INIT-EVENTS
	  SDL-INIT-JOYSTICK
	  SDL-INIT-GAMECONTROLLER)

(define WINDOW-WIDTH 640)
(define WINDOW-HEIGHT 480)
(define SQUARE-SIZE 30)
(define FRAME-RATE 20)

(define *window*
  (sdl-create-window "chezsnake"
		     SDL-WINDOWPOS-UNDEFINED
		     SDL-WINDOWPOS-UNDEFINED
		     WINDOW-WIDTH
		     WINDOW-HEIGHT
		     SDL-WINDOW-ALLOW-HIGHDPI))

(define *renderer*
  (sdl-create-renderer *window*
		                   -1
		                   SDL-RENDERER-ACCELERATED))

(define (event-loop)
  (let* ((square-x (/ (- WINDOW-WIDTH SQUARE-SIZE) 2))
         (square-y (/ (- WINDOW-HEIGHT SQUARE-SIZE) 2))
         (update-square! (lambda ()
                           (sdl-set-render-draw-color! *renderer* 0 0 0 255)
                           (sdl-render-clear *renderer*)
                           (sdl-set-render-draw-color! *renderer* 255 0 0 255)
                           (sdl-render-fill-rects *renderer* (list (make-sdl-rect square-x square-y SQUARE-SIZE SQUARE-SIZE)))
                           (sdl-render-present *renderer*))))
    (update-square!)
    (call/cc (lambda (quit)
               (let lp ()
                 ;; Put a new event in the library.
                 (sdl-poll-event)
                 (cond
                  ((sdl-event-quit?)            (quit))
                  ((sdl-event-key-down? SDLK-UP)
                   (set! square-y (- square-y 10))
                   (update-square!))
                  ((sdl-event-key-down? SDLK-DOWN) (set! square-y (+ square-y 10))
                   (update-square!)
                   )
                  ((sdl-event-key-down? SDLK-LEFT) (set! square-x (- square-x 10))
                   (update-square!)
                   )
                  ((sdl-event-key-down? SDLK-RIGHT) (set! square-x (+ square-x 10))
                   (update-square!)
                   ))
                 (sdl-delay `,(inexact->exact (round (* 1000 (exact->inexact (/ 1 FRAME-RATE))))))
                 (lp))))))


(event-loop)


(sdl-destroy-window *window*)
(sdl-quit)
