Trait {
	#name : #A2SSensorTestHelper,
	#category : #'A2S-Sensor-Domain-Tests-A2SSensor'
}

{ #category : #'generated-v1' }
A2SSensorTestHelper classSide >> ofTenant: newTenant withAggregateId: newId commandId: newCommandId andAttributes: newAttributes [

	| result | 
	result := self new.
	result id: UUID new asString.
	result commandId: newCommandId.
	result timestamp: DateAndTime now asUTC.
	result model: (newAttributes at: 'model').
	result sn: (newAttributes at: 'sn').
	result vendor: (newAttributes at: 'vendor').
	^ result
]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildAnnotateMeasureSampleCommand [

    | commandMessage commandJson commandMeta commandBody cmdTenant cmdCommandId cmdVersion cmdContractVersion cmdAttributes result |
	commandMessage := self readAnnotateMeasureFromFile.
	commandJson := NeoJSONReader fromString: commandMessage.
	commandMeta := commandJson at: #meta.
	commandBody := commandJson at: #body.
	cmdTenant := commandBody at: 'tenant' ifPresent: [ :v | v ] ifAbsent: [ nil ].
	cmdCommandId := commandMeta at: 'id' ifPresent: [ :v | v ] ifAbsent: [ UUID new greaseString ].
	cmdAttributes := Dictionary new.
	cmdContractVersion := commandMeta at: 'version' ifAbsent: [ 1 ].
	cmdAttributes at: 'version' put: cmdContractVersion.
	cmdVersion := commandBody at: 'version' ifAbsent: [ 0 ].
	cmdAttributes at: 'aggregateRootVersion' put: cmdVersion.
	commandBody at: 'measure' ifPresent: [ :v | cmdAttributes at: 'measure' put: v ].
	commandBody at: 'sensorId' ifPresent: [ :v | cmdAttributes at: 'sensorId' put: v ].
	commandBody at: 'timestamp' ifPresent: [ :v | cmdAttributes at: 'timestamp' put: v ].
	result := A2SAnnotateMeasure ofTenant: cmdTenant withCommandId: cmdCommandId aggregateRootVersion: cmdVersion andAttributes: cmdAttributes.
	commandBody at: 'id' ifPresent: [ :v | result aggregateRootId: v ].
	result version: cmdContractVersion.
	result aggregateRootVersion: cmdVersion.
	^ result

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildCreateSensorSampleCommand [

    | commandMessage commandJson commandMeta commandBody cmdTenant cmdCommandId cmdVersion cmdContractVersion cmdAttributes result |
	commandMessage := self readCreateSensorFromFile.
	commandJson := NeoJSONReader fromString: commandMessage.
	commandMeta := commandJson at: #meta.
	commandBody := commandJson at: #body.
	cmdTenant := commandBody at: 'tenant' ifPresent: [ :v | v ] ifAbsent: [ nil ].
	cmdCommandId := commandMeta at: 'id' ifPresent: [ :v | v ] ifAbsent: [ UUID new greaseString ].
	cmdAttributes := Dictionary new.
	cmdContractVersion := commandMeta at: 'version' ifAbsent: [ 1 ].
	cmdAttributes at: 'version' put: cmdContractVersion.
	cmdVersion := commandBody at: 'version' ifAbsent: [ 0 ].
	cmdAttributes at: 'aggregateRootVersion' put: cmdVersion.
	commandBody at: 'model' ifPresent: [ :v | cmdAttributes at: 'model' put: v ].
	commandBody at: 'sn' ifPresent: [ :v | cmdAttributes at: 'sn' put: v ].
	commandBody at: 'tenant' ifPresent: [ :v | cmdAttributes at: 'tenant' put: v ].
	commandBody at: 'vendor' ifPresent: [ :v | cmdAttributes at: 'vendor' put: v ].
	result := A2SCreateSensor ofTenant: cmdTenant withCommandId: cmdCommandId aggregateRootVersion: cmdVersion andAttributes: cmdAttributes.
	commandBody at: 'id' ifPresent: [ :v | result aggregateRootId: v ].
	result version: cmdContractVersion.
	result aggregateRootVersion: cmdVersion.
	^ result

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildMeasureAnnotatedEventFromFile: aFile [

	| eventMessage eventJson eventMeta eventBody evtAttributes evtCommandId evtTenant evtId evtTimestamp |
	eventMessage := self readFile: aFile.
	eventJson := NeoJSONReader fromString: eventMessage.
	eventMeta := eventJson at: #meta.
	eventBody := eventJson at: #body.
	evtAttributes := Dictionary new.
	evtAttributes at: 'version' put: (eventMeta at: 'version').
	evtAttributes at: 'aggregateRootVersion' put: (eventBody at: 'version').
	evtTenant := eventBody at: 'tenant'.
	evtId := eventBody at: 'id'.
	evtCommandId := eventMeta at: 'correlationId' ifAbsent: [ 'missing' ].
	evtTimestamp := eventBody at: 'timestamp' ifAbsent: [ nil ].
	evtTimestamp ifNil: [ evtTimestamp := eventMeta at: 'timestamp' ifAbsent: [ nil ] ].
	evtTimestamp ifNotNil: [ :t | evtAttributes at: 'timestamp' put: evtTimestamp ].
	eventBody at: 'measure' ifPresent: [ :v | evtAttributes at: 'measure' put: v ].
	^ A2SMeasureAnnotated ofTenant: evtTenant withAggregateId: evtId commandId: evtCommandId andAttributes: evtAttributes

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildMeasureAnnotatedSampleEventWithId: evtId andCommandId: inputCommandId [

	| result |
	result := A2STestMeasureAnnotated fromEvent: (self buildMeasureAnnotatedEventFromFile: self readMeasureAnnotatedFromFile).
	result id: evtId.
	result commandId: inputCommandId.
	^ result

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildSensorCreatedEventFromFile: aFile [

	| eventMessage eventJson eventMeta eventBody evtAttributes evtCommandId evtTenant evtId evtTimestamp |
	eventMessage := self readFile: aFile.
	eventJson := NeoJSONReader fromString: eventMessage.
	eventMeta := eventJson at: #meta.
	eventBody := eventJson at: #body.
	evtAttributes := Dictionary new.
	evtAttributes at: 'version' put: (eventMeta at: 'version').
	evtAttributes at: 'aggregateRootVersion' put: (eventBody at: 'version').
	evtTenant := eventBody at: 'tenant'.
	evtId := eventBody at: 'id'.
	evtCommandId := eventMeta at: 'correlationId' ifAbsent: [ 'missing' ].
	evtTimestamp := eventBody at: 'timestamp' ifAbsent: [ nil ].
	evtTimestamp ifNil: [ evtTimestamp := eventMeta at: 'timestamp' ifAbsent: [ nil ] ].
	evtTimestamp ifNotNil: [ :t | evtAttributes at: 'timestamp' put: evtTimestamp ].
	eventBody at: 'model' ifPresent: [ :v | evtAttributes at: 'model' put: v ].
	eventBody at: 'sn' ifPresent: [ :v | evtAttributes at: 'sn' put: v ].
	eventBody at: 'vendor' ifPresent: [ :v | evtAttributes at: 'vendor' put: v ].
	^ A2SSensorCreated ofTenant: evtTenant withAggregateId: evtId commandId: evtCommandId andAttributes: evtAttributes

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> buildSensorCreatedSampleEventWithId: evtId andCommandId: inputCommandId [

	| result |
	result := A2STestSensorCreated fromEvent: (self buildSensorCreatedEventFromFile: self readSensorCreatedFromFile).
	result id: evtId.
	result commandId: inputCommandId.
	^ result

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> readAnnotateMeasureFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sensor' / 'contracts' / 'commands' / 'v1' / 'annotate-measure.example.json')

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> readCreateSensorFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sensor' / 'contracts' / 'commands' / 'v1' / 'create-sensor.example.json')

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> readMeasureAnnotatedFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sensor' / 'contracts' / 'events' / 'v1' / 'measure-annotated.example.json')

]

{ #category : #'generated-v1' }
A2SSensorTestHelper >> readSensorCreatedFromFile [

	^ self readFile: (FileSystem disk workingDirectory  / 'Sensor' / 'contracts' / 'events' / 'v1' / 'sensor-created.example.json')

]
