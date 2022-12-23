Class {
	#name : #A2SCreateSensor,
	#superclass : #EDACommand,
	#instVars : [
		'vendor',
		'sn',
		'model'
	],
	#category : #'A2S-Sensor-Domain-A2SSensor-Commands'
}

{ #category : #'generated-v1' }
A2SCreateSensor class >> aggregateRootClass [

	^ A2SSensor

]

{ #category : #'generated-v1' }
A2SCreateSensor class >> latestVersion [

	^ 1

]

{ #category : #'generated-v1' }
A2SCreateSensor class >> ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes [

	<sensorCommandName: #CREATE_SENSOR>
	| result |
	result := super ofTenant: theTenant withCommandId: theCommandId aggregateRootVersion: theVersion andAttributes: theAttributes.
	result version: 1.

	theAttributes at: 'vendor' ifPresent: [ :v | result vendor: v ].
	theAttributes at: 'sn' ifPresent: [ :v | result sn: v ].
	theAttributes at: 'model' ifPresent: [ :v | result model: v ].
	^ result
]

{ #category : #'generated-v1' }
A2SCreateSensor >> model [

	^ model
]

{ #category : #'generated-v1' }
A2SCreateSensor >> model: newValue [

	model := newValue
]

{ #category : #'generated-v1' }
A2SCreateSensor >> retrieveAggregateRootClass [

	^ self class aggregateRootClass

]

{ #category : #'generated-v1' }
A2SCreateSensor >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self model = anInstance model and: [  self sn = anInstance sn and: [  self tenant = anInstance tenant and: [  self vendor = anInstance vendor ] ] ]] ].
]

{ #category : #'generated-v1' }
A2SCreateSensor >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self model hash bitXor: (self sn hash bitXor: (self tenant hash bitXor: self vendor hash)))))
]

{ #category : #'generated-v1' }
A2SCreateSensor >> sn [

	^ sn
]

{ #category : #'generated-v1' }
A2SCreateSensor >> sn: newValue [

	sn := newValue
]

{ #category : #'generated-v1' }
A2SCreateSensor >> vendor [

	^ vendor
]

{ #category : #'generated-v1' }
A2SCreateSensor >> vendor: newValue [

	vendor := newValue
]
