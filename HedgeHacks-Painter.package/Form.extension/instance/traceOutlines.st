*HedgeHacks-Painter
traceOutlines
	"Answer a collection of generalized polygons generated by tracing the edges in the receiver. Each polygon's first loop is the outer boundary, all following loops are inner boundaries."
	| pts outlines outer lineSet inner mask leftOver outerOffset innerOffset |
	outer := Form extent: self extent + 2 depth: 1.
	outer offset: self offset-1.
	(BitBlt toForm: outer)
		sourceForm: self;
		colorMap: (Color maskingMap: self depth);
		destOrigin: 1@1;
		combinationRule: Form over;
		copyBits.

	outlines := OrderedCollection new.
	[pts := outer traceOutline: Color white.
	pts isEmpty] whileFalse:[
		lineSet := OrderedCollection with: pts.
		mask := self traceRegionMask: pts.
		outerOffset := mask offset.
		mask offset: 0@0.
		inner := Form extent: mask extent depth: mask depth.
		"copy outer region to inner region"
		outer displayOn: inner at: outerOffset negated rule: Form over.
		"mask out remnants"
		mask displayOn: inner at: 0@0 rule: Form and.
		"now flood-fill inner region so previous 'outside area' vanishes"
		inner floodFill: Color black at: 0@0.
		"reverse inner form so it is inside-out"
		inner reverse.

		"clear the processed area"
		mask reverse.
		mask displayOn: outer at: outerOffset rule: Form and.
		"find the interior edges"
		[pts := inner traceOutline: Color white.
		pts isEmpty] whileFalse:[
			lineSet add: pts + outerOffset.
			mask := self traceRegionMask: pts.
			innerOffset := mask offset.
			mask offset: 0@0.

			"blt the left over portion of the region back onto outer"
			leftOver := Form extent: mask extent depth: mask depth.
			inner displayOn: leftOver at: innerOffset negated rule: Form over.
			mask displayOn: leftOver at: 0@0 rule: Form and.
			leftOver floodFill: Color black at: 0@0.
			leftOver reverse.
			leftOver displayOn: outer at: innerOffset + outerOffset rule: 7. "bitOr"

			"clear the processed area"
			mask reverse.
			mask displayOn: inner at: innerOffset rule: Form and.
		].
		outlines add: lineSet.
	].
	^outlines