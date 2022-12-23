Class {
	#name : #A2STestSensorCreated,
	#superclass : #A2SSensorCreated,
	#traits : 'EDATTestEvent',
	#classTraits : 'EDATTestEvent classTrait',
	#category : #'A2S-Sensor-Domain-Tests-A2SSensor'
}

{ #category : #'generated-v1' }
A2STestSensorCreated class >> fromEvent: newEvent [


	| result |
	result := self new.
	result tenant: newEvent tenant.
	result id: '<ANYTHING>'.
	result commandId: newEvent commandId.
	result version: newEvent class latestVersion.
	result aggregateRootVersion: newEvent aggregateRootVersion.
	result timestamp: '<ANYTHING>'.
	result model: newEvent model.
	result sn: newEvent sn.
	result vendor: newEvent vendor.
	^ result
]

{ #category : #'generated-v1' }
A2STestSensorCreated >> = anInstance [

	^  (anInstance class isKindOf: A2SSensorCreated class) and: [
		(self attribute: self aggregateRootClass matches: anInstance aggregateRootClass) and: [
		(self attribute: self tenant matches: anInstance tenant) and: [
				(self attribute: self id named: 'id' matches: anInstance id) and: [
					(self attribute: self aggregateRootVersion matches: anInstance aggregateRootVersion) and: [
						(self attribute: self timestamp named: 'timestamp' matches: anInstance timestamp) and: [
							(self attribute: self commandId named: 'correlationId' matches: anInstance commandId) and: [
								 (self attribute: self model named: 'model' matches: anInstance model) and: [  (self attribute: self sn named: 'sn' matches: anInstance sn) and: [  (self attribute: self vendor named: 'vendor' matches: anInstance vendor) ] ]
						]
						]
					]
				]
			]
		]
	]

]
