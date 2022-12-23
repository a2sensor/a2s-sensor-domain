Class {
	#name : #A2SSensorGenerator,
	#superclass : #Object,
	#traits : 'EDATGenerationTool + EDACLogging + EDACLanguageHelper',
	#classTraits : 'EDATGenerationTool classTrait + EDACLogging classTrait + EDACLanguageHelper classTrait',
	#category : #'A2S-Sensor-Tools'
}

{ #category : #testing }
A2SSensorGenerator >> packages [

	^ ((EDAAggregateRoot allSubclasses reject: [ :c | c = EDATestAggregateRoot ]) collect: [ :c | c package name ]) select: [ :p | (p beginsWithSubCollection: 'A2S-') and: [ ((p indexOf: '-Domain-') >= 0) or: [ (p endsWithSubCollection: '-Tests')] ] ]
]
