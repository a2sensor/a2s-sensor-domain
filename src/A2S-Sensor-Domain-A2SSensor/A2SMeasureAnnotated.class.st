Class {
	#name : #A2SMeasureAnnotated,
	#superclass : #EDACommandResultEvent,
	#instVars : [
		'measure'
	],
	#category : #'A2S-Sensor-Domain-A2SSensor-Events'
}

{ #category : #meta }
A2SMeasureAnnotated class >> aggregateRootClass [

	^ A2SA2SSensor

]

{ #category : #'generated-v1' }
A2SMeasureAnnotated class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
A2SMeasureAnnotated class >> ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs [

	| result | 
	result := super ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs.

	theAttrs at: 'measure' ifPresent: [ :v | result measure: v ].
	^ result
]

{ #category : #'generated-v1' }
A2SMeasureAnnotated >> measure [

	^ measure
]

{ #category : #'generated-v1' }
A2SMeasureAnnotated >> measure: newValue [

	measure := newValue
]

{ #category : #'generated-v1' }
A2SMeasureAnnotated >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self id = anInstance id and: [  self measure = anInstance measure and: [  self tenant = anInstance tenant and: [  self timestamp = anInstance timestamp and: [  self version = anInstance version and: [  self aggregateRootClass = anInstance aggregateRootClass ] ] ] ] ]] ].
]

{ #category : #'generated-v1' }
A2SMeasureAnnotated >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self id hash bitXor: (self measure hash bitXor: (self tenant hash bitXor: (self timestamp hash bitXor: (self version hash bitXor: self aggregateRootClass hash)))))))
]
