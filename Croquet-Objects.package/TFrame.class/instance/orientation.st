transform
orientation
"This is used to return just the orientation part of the matrix.The translation part is 0.0."
	| mat |

	mat := localTransform shallowCopy.
	mat translationX: 0.0 y: 0.0 z: 0.0.
	^ mat.