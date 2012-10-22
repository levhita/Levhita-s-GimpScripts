;
; Reduce Frames in Animation
;
; Takes Odd or Even layers in document and delete them, to be used in animations
; to reduce the animation frames.
;
; Argel Arias (levhita@gmail.com)
; http://blog.levhita.net

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

; Version 0.01
; 

; Define the function:

(define (script-fu-reduce-frames	inImage
	inLayer
	inOdd
	inCopy
	)
(let* (
	(theImage 0)
	(theMethod 0)
	(layerId 0)
	(layerList 0)
	(number_of_layers 0)
	)

(set! theImage (if (= inCopy TRUE)
	(car (gimp-image-duplicate inImage))
	inImage)
)

		;Starts the undo queque
		(if 	(= inCopy FALSE)	
			(gimp-undo-push-group-start theImage)	
			()
			)
		
		(set! layerList (cadr (gimp-image-get-layers theImage)))
		(set! number_of_layers (vector-length layerList))
		(set! layerId 0)

		(while (< layerId number_of_layers) ; scan through all the layers
			(begin   
				(if (= inOdd FALSE)
					
            (if (= (modulo layerId 2)  0);Even
				      (gimp-image-remove-layer theImage (aref layerList layerId));Delete Layer
				      )
            
            (if (= (modulo (+ layerId 1) 2)  0);Odd
				      (gimp-image-remove-layer theImage (aref layerList layerId));Delete Layer
				      )
            )
				
				(set! layerId (+ layerId 1))
				)
			)

		;Final Cleanup
		(if 	(= inCopy TRUE)
			(begin 	(gimp-image-clean-all theImage)
				(gimp-display-new theImage)
				)
			()
			)
		
		;Ends the undo queque
		(if 	(= inCopy FALSE)	
			(gimp-undo-push-group-end theImage)	
			()
			)
		(gimp-displays-flush)
		)
)

;Register function on Gimp
(script-fu-register "script-fu-reduce-frames"
	_"_Reduce Frames in Animation..."
	"Deletes every given frame of the animation"
	"Argel Arias"
	"2012 at HackerGarage"
	"Oct 5 2012"
	"RGB* GRAY*"
	SF-IMAGE       "The image"	    		0
	SF-DRAWABLE    "The layer"    			0
	SF-TOGGLE     _"Delete Odd Frames"	TRUE
	SF-TOGGLE     _"Work on copy"       FALSE
	)

;Register function on menu structure
(script-fu-menu-register "script-fu-reduce-frames"
	_"<Image>/Levhita")
