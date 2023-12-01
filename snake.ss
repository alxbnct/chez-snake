;;;; -*- mode: Scheme; -*-

;;;;
;;;;
;;;;

(import (sdl))


(sdl-set-main-ready!)

(sdl-init SDL-INIT-VIDEO
	  SDL-INIT-EVENTS
	  SDL-INIT-JOYSTICK
	  SDL-INIT-GAMECONTROLLER)

(define WINDOW-WIDTH 640)
(define WINDOW-HEIGHT 480)

(define *window*
  (sdl-create-window "chezscheme"
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
  (let ((square-size 30))
    (let* ((square-x (/ (- WINDOW-WIDTH square-size) 2))
          (square-y (/ (- WINDOW-HEIGHT square-size) 2))
          (update-square! (lambda ()
                           (sdl-set-render-draw-color! *renderer* 0 0 0 255)
                           (sdl-render-clear *renderer*)
                           (sdl-set-render-draw-color! *renderer* 255 0 0 255)
                           (sdl-render-fill-rects *renderer* (list (make-sdl-rect square-x square-y square-size square-size)))
                           (sdl-render-present *renderer*))))
      (let lp ()
        ;; Put a new event in the library.
        (sdl-poll-event)
        (cond
         ((sdl-event-none?)            (lp))
         ((sdl-event-quit?)            '())
         ((sdl-event-drop-text?)       (printf (sdl-event-drop-file))
          (lp))
         ((sdl-event-mouse-motion?)    (printf "Current mouse position: (~d,~d)~n"
				                                       (sdl-event-mouse-motion-x)
				                                       (sdl-event-mouse-motion-y))
          (lp))
         ((sdl-event-key-up? SDLK-A)   (printf "A is released.~n")
          (lp))
         ((sdl-event-key-down? SDLK-A) (printf "A is pressed.~n")
          (lp))
         ((sdl-event-key-down? SDLK-UP) (set! square-y (- square-y 10))
          (update-square!)
          (lp))
         ((sdl-event-key-down? SDLK-DOWN) (set! square-y (+ square-y 10))
          (update-square!)
          (lp))
         ((sdl-event-key-down? SDLK-LEFT) (set! square-x (- square-x 10))
          (update-square!)
          (lp))
         ((sdl-event-key-down? SDLK-RIGHT) (set! square-x (+ square-x 10))
          (update-square!)
          (lp))
         (else
          (lp)))))))


(event-loop)


(sdl-destroy-window *window*)
(sdl-quit)
