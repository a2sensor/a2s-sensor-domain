Class {
	#name : #A2SSensorApplication,
	#superclass : #EDAApplication,
	#category : #'A2S-Sensor-Application'
}

{ #category : #accessing }
A2SSensorApplication class >> applicationName [

	^ 'Sensor'
]

{ #category : #accessing }
A2SSensorApplication class >> default [

	^ self
		  withName: self applicationName
		  description: 'A2S Sensor'
		  andIconName: #sensor
]

{ #category : #subclassresponsibility }
A2SSensorApplication >> commandClassPrefix [

	^ 'A2S'
]

{ #category : #subclassresponsibility }
A2SSensorApplication >> eventBaseClass [

	^ A2SSensorBaseEvent 
]

{ #category : #subclassresponsibility }
A2SSensorApplication >> eventClassPrefix [

	^ 'A2S'
]

{ #category : #'reset - events' }
A2SSensorApplication >> resetEventSubscriptions [
]

{ #category : #'setup - events' }
A2SSensorApplication >> setupEventSubscriptions [

	
]
