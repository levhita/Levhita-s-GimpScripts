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

(define (script-fu-cinemagraph	inImage
	inLayer
	inDelay
	inWidth
	inHeight
	inOnlyVisible
	inCopy
	)
	(let* (
		(theImage 0)
		(layerId 0)
		(layerList 0)
		(currentLayer 0)
		(numberOfLayers 0)
		(counter 1)
		(theWidth 0)
		(theHeight 0)
		)

		(set! theImage (if (= inCopy TRUE)
			(car (gimp-image-duplicate inImage))
			inImage)
			)

		(set! theWidth (if (= inWidth 0)
			(car (gimp-image-width theImage))
				inWidth)
			)
		(set! theHeight (if (= inHeight 0)
			(car (gimp-image-height theImage))
				inHeight)
			)

		;Starts the undo queque
		(if 	(= inCopy FALSE)	
			(gimp-undo-push-group-start theImage)	
			()
			)
		(gimp-selection-invert theImage)	
		(set! layerList (cadr (gimp-image-get-layers theImage)))
		(set! numberOfLayers (vector-length layerList))
		(set! layerId (- numberOfLayers 2))
		(while (>= layerId 0) ; scan through all the layers except the last one
			(begin
				(set! currentLayer (aref layerList layerId))
				(if (and (= TRUE inOnlyVisible) (= FALSE (car (gimp-drawable-get-visible currentLayer))))
					()
					(begin
						(gimp-layer-add-alpha currentLayer)
		    			(gimp-edit-clear currentLayer)
						(gimp-drawable-set-name currentLayer
							(string-append
								"frame_" (number->string counter)
								"(" (number->string inDelay) "ms)(combine)"
								);Set the layer name
							)
						)
					)					
		    	(set! layerId (- layerId 1))
		    	(set! counter (+ counter 1))         ; decrement to the next
		    	)
			)

		(gimp-drawable-set-name (aref layerList (- numberOfLayers 1))
			(string-append
				"frame_0"
				"(" (number->string inDelay) "ms)(replace)"
				);Set the layer name
			)
			
		(gimp-image-scale theImage theWidth theHeight)
		;Final Cleanup
		(if 	(= inCopy TRUE)
			(begin 	(gimp-image-clean-all theImage)
				(gimp-display-new theImage)
				)
			()
			)
		(gimp-selection-invert theImage)
		;Ends the undo queque
		(if 	(= inCopy FALSE)	
			(gimp-undo-push-group-end theImage)	
			()
			)
		
		(gimp-displays-flush)

		(plug-in-animationplay 1 theImage 0)
		)
)

;Register function on Gimp
(script-fu-register "script-fu-cinemagraph"
	_"Cinemagraph..."
	"Creates a cinemagraph out of the current frames"
	"Argel Arias"
	"2012 at HackerGarage"
	"Oct 5 2012"
	"RGB* GRAY* INDEXED*"
	SF-IMAGE       "The image"			0
	SF-DRAWABLE    "The layer"			0
	SF-ADJUSTMENT _"Default Delay"  '(100 1 1000 1 10 0 1)
	SF-ADJUSTMENT _"Width (0 For current Width)"  '(0 0 5000 1 20 0 1)
	SF-ADJUSTMENT _"Height (0 For current Height)"  '(0 0 5000 1 20 0 1)
	SF-TOGGLE     _"Only in visible layers"	TRUE
	SF-TOGGLE     _"Work on copy"	FALSE
	)

;Register function on menu structure
(script-fu-menu-register "script-fu-cinemagraph"
	_"<Image>/Levhita")
