render
renderFrame: ogl
	| count |

	false ifFalse:[^ super renderFrame: ogl]. "Traditional rendering method - used for testing and picking"
	" something of a problem - Quadtrees do not lend themselves to standard picking using this method."

	ogl pushMatrix.
	count := self renderTree: ogl root: self root.
	ogl popMatrix.
"------ This is just test code to see where the quads really are. ------"
"	self alpha ifTrue: [ 
		space addAlpha: 
		(TRenderAlpha object: self 
			transform: space currentTransform clone
			distance: (ogl activeCamera globalPosition - space currentTranslation ) squaredLength
			parent: space currentParent).]."

	^ count.
