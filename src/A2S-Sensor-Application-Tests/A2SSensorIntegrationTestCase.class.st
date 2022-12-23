Class {
	#name : #A2SSensorIntegrationTestCase,
	#superclass : #Object,
	#category : #'A2S-Sensor-Application-Tests-A2SSensor'
}

{ #category : #'generated-v1' }
A2SSensorIntegrationTestCase >> testAnnotateMeasure [

	| aggregateRootId previousEvents command commandMessage expectedEvent expectedMessage expectedRoutingKey previousA2SSensorCreated |
	previousEvents := OrderedCollection new.
	command := self buildAnnotateMeasureSampleCommand.
	commandMessage := self readAnnotateMeasureFromFile.
	aggregateRootId := command aggregateRootId.
	expectedEvent := self buildMeasureAnnotatedSampleEventWithId: aggregateRootId andCommandId: command commandId.
	expectedMessage := self readMeasureAnnotatedFromFile.
	expectedRoutingKey := 'measure.annotated'.
	previousA2SSensorCreated := self buildA2SSensorCreatedSampleEventWithId: aggregateRootId andCommandId: command commandId.
	previousA2SSensorCreated id: command aggregateRootId.
	previousEvents add: previousA2SSensorCreated.
	self
		givenPreviousEvents: previousEvents ofTenant: command tenant
		whenReceiveCommandMessage: commandMessage
		thenStoreEvent: expectedEvent
		andPublishEventMessage: expectedMessage
		withRoutingKey: expectedRoutingKey

]

{ #category : #'generated-v1' }
A2SSensorIntegrationTestCase >> testCreateSensor [

	| aggregateRootId previousEvents command commandMessage expectedEvent expectedMessage expectedRoutingKey |
	previousEvents := OrderedCollection new.
	command := self buildCreateSensorSampleCommand.
	commandMessage := self readCreateSensorFromFile.
	aggregateRootId := command aggregateRootId.
	expectedEvent := self buildSensorCreatedSampleEventWithId: aggregateRootId andCommandId: command commandId.
	expectedMessage := self readSensorCreatedFromFile.
	expectedRoutingKey := 'sensor.created'.
	"TODO: Add XXXCreated events to previousEvents collection,"
	"one for each dependency, if any. Do not forget to change "
	"protocol so the generator skips overriding your changes!"
	self flag: #TODO.
	self
		givenPreviousEvents: previousEvents ofTenant: command tenant
		whenReceiveCommandMessage: commandMessage
		thenStoreEvent: expectedEvent
		andPublishEventMessage: expectedMessage
		withRoutingKey: expectedRoutingKey

]
