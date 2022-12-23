Class {
	#name : #A2SSensorCreated,
	#superclass : #EDACommandResultEvent,
	#instVars : [
		'vendor',
		'sn',
		'model'
	],
	#category : #'A2S-Sensor-Domain-A2SSensor-Events'
}

{ #category : #meta }
A2SSensorCreated class >> aggregateRootClass [

	^ A2SA2SSensor

]

{ #category : #'generated-v1' }
A2SSensorCreated class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
A2SSensorCreated class >> ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs [

	| result | 
	result := super ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs.

	theAttrs at: 'vendor' ifPresent: [ :v | result vendor: v ].
	theAttrs at: 'sn' ifPresent: [ :v | result sn: v ].
	theAttrs at: 'model' ifPresent: [ :v | result model: v ].
	^ result
]

{ #category : #'generated-v1' }
A2SSensorCreated >> model [

	^ model
]

{ #category : #'generated-v1' }
A2SSensorCreated >> model: newValue [

	model := newValue
]

{ #category : #'generated-v1' }
A2SSensorCreated >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self id = anInstance id and: [  self model = anInstance model and: [  self sn = anInstance sn and: [  self tenant = anInstance tenant and: [  self vendor = anInstance vendor and: [  self version = anInstance version and: [  self aggregateRootClass = anInstance aggregateRootClass ] ] ] ] ] ]] ].
]

{ #category : #'generated-v1' }
A2SSensorCreated >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self id hash bitXor: (self model hash bitXor: (self sn hash bitXor: (self tenant hash bitXor: (self vendor hash bitXor: (self version hash bitXor: self aggregateRootClass hash))))))))
]

{ #category : #'generated-v1' }
A2SSensorCreated >> sn [

	^ sn
]

{ #category : #'generated-v1' }
A2SSensorCreated >> sn: newValue [

	sn := newValue
]

{ #category : #'generated-v1' }
A2SSensorCreated >> vendor [

	^ vendor
]

{ #category : #'generated-v1' }
A2SSensorCreated >> vendor: newValue [

	vendor := newValue
]
