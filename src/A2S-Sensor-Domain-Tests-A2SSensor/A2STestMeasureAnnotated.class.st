Class {
	#name : #A2STestMeasureAnnotated,
	#superclass : #A2SMeasureAnnotated,
	#traits : 'EDATTestEvent',
	#classTraits : 'EDATTestEvent classTrait',
	#category : #'A2S-Sensor-Domain-Tests-A2SSensor'
}

{ #category : #'generated-v1' }
A2STestMeasureAnnotated class >> fromEvent: newEvent [


	| result |
	result := self new.
	result tenant: newEvent tenant.
	result id: '<ANYTHING>'.
	result commandId: newEvent commandId.
	result version: newEvent class latestVersion.
	result aggregateRootVersion: newEvent aggregateRootVersion.
	result timestamp: '<ANYTHING>'.
	result measure: newEvent measure.
	result timestamp: newEvent timestamp.
	^ result
]

{ #category : #'generated-v1' }
A2STestMeasureAnnotated >> = anInstance [

	^  (anInstance class isKindOf: A2SMeasureAnnotated class) and: [
		(self attribute: self aggregateRootClass matches: anInstance aggregateRootClass) and: [
		(self attribute: self tenant matches: anInstance tenant) and: [
				(self attribute: self id named: 'id' matches: anInstance id) and: [
					(self attribute: self aggregateRootVersion matches: anInstance aggregateRootVersion) and: [
						(self attribute: self timestamp named: 'timestamp' matches: anInstance timestamp) and: [
							(self attribute: self commandId named: 'correlationId' matches: anInstance commandId) and: [
								 (self attribute: self measure named: 'measure' matches: anInstance measure)
						]
						]
					]
				]
			]
		]
	]

]
