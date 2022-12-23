Class {
	#name : #A2SSensor,
	#superclass : #EDAAggregateRoot,
	#instVars : [
		'vendor',
		'timestamp',
		'measure',
		'sn',
		'model'
	],
	#category : #'A2S-Sensor-Domain-A2SSensor'
}

{ #category : #'generated-v1' }
A2SSensor >> applyMeasureAnnotatedv1: anEvent [

	self id: anEvent id.
	self measure: anEvent measure.

]

{ #category : #'generated-v1' }
A2SSensor >> applySensorCreatedv1: anEvent [

	self id: anEvent id.
	self model: anEvent model.
	self sn: anEvent sn.
	self vendor: anEvent vendor.

]

{ #category : #'generated-v1' }
A2SSensor >> handleAnnotateMeasure: aCommand [
	<useAsCommandHandlerFor: #A2SAnnotateMeasure>

	| theTenant theId theCommandId theAttrs |
	theId := UUID new greaseString.
	theTenant := aCommand tenant.
	theCommandId := aCommand commandId.
	theAttrs := self class buildCommonArgsForCommand: aCommand.
	aCommand measure ifNotNil: [ :v | theAttrs at: 'measure' put: v ].
	aCommand sensorId ifNotNil: [ :v | theAttrs at: 'sensorId' put: v ].
	^ A2SMeasureAnnotated
		ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs

]

{ #category : #'generated-v1' }
A2SSensor >> handleCreateSensor: aCommand [
	<useAsCommandHandlerFor: #A2SCreateSensor>

	| theTenant theId theCommandId theAttrs |
	theId := UUID new greaseString.
	theTenant := aCommand tenant.
	theCommandId := aCommand commandId.
	theAttrs := self class buildCommonArgsForCommand: aCommand.
	aCommand vendor ifNotNil: [ :v | theAttrs at: 'vendor' put: v ].
	aCommand sn ifNotNil: [ :v | theAttrs at: 'sn' put: v ].
	aCommand model ifNotNil: [ :v | theAttrs at: 'model' put: v ].
	^ A2SSensorCreated
		ofTenant: theTenant withAggregateId: theId commandId: theCommandId andAttributes: theAttrs

]

{ #category : #'generated-v1' }
A2SSensor >> measure [

	^ measure
]

{ #category : #'generated-v1' }
A2SSensor >> measure: newValue [

	measure := newValue
]

{ #category : #'generated-v1' }
A2SSensor >> model [

	^ model
]

{ #category : #'generated-v1' }
A2SSensor >> model: newValue [

	model := newValue
]

{ #category : #'generated-v1' }
A2SSensor >> retrieveA2SSensorRepository [

	^ A2SSensorRepository uniqueInstance

]

{ #category : #'generated-v1' }
A2SSensor >> semanticEquals: anInstance [

	^ self class = anInstance class and: [ self id = anInstance id and: [ self sn = anInstance sn and: [  self version = anInstance version and: [  self timestamp = anInstance timestamp and: [  self model = anInstance model and: [  self vendor = anInstance vendor and: [  self tenant = anInstance tenant and: [  self measure = anInstance measure and: [  self id = anInstance id ] ] ] ] ] ] ]] ].
]

{ #category : #'generated-v1' }
A2SSensor >> semanticHash [

    ^ self class greaseString hash bitXor:( self id hash bitXor: ((self sn hash bitXor: (self version hash bitXor: (self timestamp hash bitXor: (self model hash bitXor: (self vendor hash bitXor: (self tenant hash bitXor: (self measure hash bitXor: self id hash)))))))))
]

{ #category : #'generated-v1' }
A2SSensor >> sn [

	^ sn
]

{ #category : #'generated-v1' }
A2SSensor >> sn: newValue [

	sn := newValue
]

{ #category : #'generated-v1' }
A2SSensor >> timestamp [

	^ timestamp
]

{ #category : #'generated-v1' }
A2SSensor >> timestamp: newValue [

	timestamp := newValue
]

{ #category : #'generated-v1' }
A2SSensor >> vendor [

	^ vendor
]

{ #category : #'generated-v1' }
A2SSensor >> vendor: newValue [

	vendor := newValue
]
