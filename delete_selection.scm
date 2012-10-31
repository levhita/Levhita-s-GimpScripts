;
; Delete The Selection From All Frames
;
; Takes all the frames of the image and deletes the current selection
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

(define (script-fu-delete-selection	inImage
	inLayer
	inOnlyVisible
	inCopy
	)
(let* (
	(theImage 0)
	(layerId 0)
	(layerList 0)
	(currentLayer 0)
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
		(set! layerId (- number_of_layers 1))
		(while (>= layerId 0); scan through all the layers
			(begin           
		    	(set! currentLayer (aref layerList layerId))
		    	(if (and (= TRUE inOnlyVisible) (= FALSE (car (gimp-drawable-get-visible currentLayer))))
					()
					(begin
		    			(gimp-edit-clear currentLayer)
		    			)
					)
		    	(set! layerId (- layerId 1))
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
(script-fu-register "script-fu-delete-selection"
	_"_Delete The Selection From All Frames..."
	"Takes all the frames of the image and deletes the current selection"
	"Argel Arias"
	"2012 at HackerGarage"
	"Oct 5 2012"
	"RGB* GRAY*"
	SF-IMAGE       "The image"			0
	SF-DRAWABLE    "The layer"			0
	SF-TOGGLE     _"Delete only in visible layers"	TRUE
	SF-TOGGLE     _"Work on copy"	FALSE
	)

;Register function on menu structure
(script-fu-menu-register "script-fu-delete-selection"
	_"<Image>/Levhita")
