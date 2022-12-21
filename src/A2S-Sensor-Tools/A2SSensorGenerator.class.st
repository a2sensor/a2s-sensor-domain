Class {
	#name : #A2SSensorGenerator,
	#superclass : #Object,
	#traits : 'EDATGenerationTool + EDACLogging + EDACLanguageHelper',
	#classTraits : 'EDATGenerationTool classTrait + EDACLogging classTrait + EDACLanguageHelper classTrait',
	#category : #'A2S-Sensor-Tools'
}

{ #category : #testing }
A2SSensorGenerator >> packages [

	^ OrderedCollection with: 'A2S-Sensor-Domain' with: 'A2S-Sensor-Domain-Tests'
]
