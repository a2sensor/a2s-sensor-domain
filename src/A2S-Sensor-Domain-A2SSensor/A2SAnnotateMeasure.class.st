Class {
	#name : #A2SAnnotateMeasure,
	#superclass : #EDACommand,
	#instVars : [
		'timestamp',
		'measure',
		'sensorId'
	],
	#category : #'A2S-Sensor-Domain-A2SSensor-Commands'
}

{ #category : #'generated-v1' }
A2SAnnotateMeasure class >> aggregateRootClass [

	^ A2SSensor

]

{ #category : #'generated-v1' }
A2SAnnotateMeasure class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
A2SAnnotateMeasure class >> ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes [

	<sensorCommandName: #ANNOTATE_MEASURE>
	| result |
	result := super ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes.
	result version: 1.

	theAttributes at: 'timestamp' ifPresent: [ :v | result timestamp: v ].
	theAttributes at: 'measure' ifPresent: [ :v | result measure: v ].
	theAttributes at: 'sensorId' ifPresent: [ :v | result sensorId: v ].
	^ result
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> measure [

	^ measure
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> measure: newValue [

	measure := newValue
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> retrieveAggregateRootClass [

	^ self class aggregateRootClass

]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self measure = anInstance measure and: [  self sensorId = anInstance sensorId and: [  self timestamp = anInstance timestamp ] ]] ].
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self measure hash bitXor: (self sensorId hash bitXor: self timestamp hash))))
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> sensorId [

	^ sensorId
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> sensorId: newValue [

	sensorId := newValue
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> timestamp [

	^ timestamp
]

{ #category : #'generated-v1' }
A2SAnnotateMeasure >> timestamp: newValue [

	timestamp := newValue
]
