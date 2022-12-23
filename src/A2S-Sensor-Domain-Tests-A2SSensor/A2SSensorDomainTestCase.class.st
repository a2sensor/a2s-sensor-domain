Class {
	#name : #A2SSensorDomainTestCase,
	#superclass : #BabyMock2TestCase,
	#traits : 'EDATDomainBDD + A2SSensorTestHelper',
	#classTraits : 'EDATDomainBDD classTrait + A2SSensorTestHelper classTrait',
	#category : #'A2S-Sensor-Domain-Tests-A2SSensor'
}

{ #category : #'generated-v1' }
A2SSensorDomainTestCase >> testAnnotateMeasure [

	| command event |
	command := self buildAnnotateMeasureSampleCommand.
	event := self buildMeasureAnnotatedSampleEventWithId: '<ANYTHING>' andCommandId: command commandId.
	event aggregateRootVersion: command aggregateRootVersion + 1.	self
		givenAggregate: #A2SA2SSensor
			withEvents: OrderedCollection new
			whenReceiveCommand: command
			thenEvent: event

]

{ #category : #'generated-v1' }
A2SSensorDomainTestCase >> testCreateSensor [

	| command event |
	command := self buildCreateSensorSampleCommand.
	event := self buildSensorCreatedSampleEventWithId: '<ANYTHING>' andCommandId: command commandId.
	event aggregateRootVersion: command aggregateRootVersion + 1.	self
		givenAggregate: #A2SA2SSensor
			withEvents: OrderedCollection new
			whenReceiveCommand: command
			thenEvent: event

]
