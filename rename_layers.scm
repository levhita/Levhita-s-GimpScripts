;
; Rename Layers to Animation
;
; Takes all the layers of the image and rename them to animation friendly format
; soo edition is simplified to just edit the text
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

(define (script-fu-rename-layers	inImage
				inLayer
				inBaseName
				inDelay
				inMethod
				inCopy
	)
	(let* (
		(theImage 0)
		(theBaseName 0)
		(theDelay 0)
		(theMethod 0)
		(layerId 0)
		(layerList 0)
		(number_of_layers 0)
		(counter 0)
		)
	
		(gimp-selection-all inImage)
		(set! theImage (if (= inCopy TRUE)
				   (car (gimp-image-duplicate inImage))
						   inImage)
			)
		
		;Starts the undo queque
		(if 	(= inCopy FALSE)	
			(gimp-undo-push-group-start theImage)	
			()
		)
		(gimp-selection-none theImage)
		
		(set! layerList (cadr (gimp-image-get-layers theImage)))
		(set! number_of_layers (vector-length layerList))
		(set! layerId (- number_of_layers 1))

		(while (>= layerId 0) ; scan through all the layers
		  (begin           
		    (gimp-drawable-set-name (aref layerList layerId)
			(string-append
				inBaseName (number->string counter)
				"(" (number->string inDelay) "ms)"
				"(replace)"
			)
		    );Set the layer name
		    (set! layerId (- layerId 1))
		    (set! counter (+ counter 1))         ; decrement to the next
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
(script-fu-register "script-fu-rename-layers"
		    _"_Rename Layers to Animation style..."
		    "Takes all the layers of the image and rename them to animation friendly format soo edition is simplified to just edit the text"
		    "Argel Arias"
		    "2012 at HackerGarage"
		    "Oct 5 2012"
		    "RGB* GRAY*"
		    SF-IMAGE       "The image"			0
		    SF-DRAWABLE    "The layer"			0
		    SF-STRING      "Prefix for the Layer's name"	"frame_"
		    SF-ADJUSTMENT _"Default Delay"  '(100 1 300 1 10 0 1)
		    SF-TOGGLE     _"Use Replace as Animation method"	TRUE		    
		    SF-TOGGLE     _"Work on copy"	FALSE
		    
)

;Register function on menu structure
(script-fu-menu-register "script-fu-rename-layers"
			 _"<Image>/Filters/Animation")
