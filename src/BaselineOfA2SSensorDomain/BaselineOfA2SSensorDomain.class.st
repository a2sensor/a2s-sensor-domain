Class {
	#name : #BaselineOfA2SSensorDomain,
	#superclass : #BaselineOf,
	#category : #BaselineOfA2SSensorDomain
}

{ #category : #meta }
BaselineOfA2SSensorDomain class >> declareGroupsIn: spec [

	spec
		group: 'core'
		with: #( #'A2S-Sensor-Application' #'A2S-Sensor-Domain' #'A2S-Sensor-Tools' );
		group: 'tests'
		with: #( #'A2S-Sensor-Domain-Tests' #'A2S-Sensor-Application-Tests' );
		group: 'publishing'
		with: #( 'core' 'tests' 'Pillar' 'PillarCore' 'PillarDocumentModel'
			   'PillarMicro' );
		group: 'default' with: #( 'core' 'tests' )
]

{ #category : #meta }
BaselineOfA2SSensorDomain class >> declarePackagesIn: spec [

	spec
		package: #'A2S-Sensor-Application'
		with: [ spec requires: #( 'PharoEDA' ) ];
		package: #'A2S-Sensor-Domain'
		with: [ spec requires: #( 'A2S-Sensor-Application'
				   'PharoEDA' ) ];
		package: #'A2S-Sensor-Domain-Tests'
		with: [ spec requires: #( 'A2S-Sensor-Domain' ) ];
		package: #'A2S-Sensor-Application-Tests' with: [ 
			spec requires:
					#( 'A2S-Sensor-Application' 'A2S-Sensor-Domain-Tests' ) ];
		package: #'A2S-Sensor-Tools'
		with: [ spec requires: #( 'PharoEDATools' ) ]
]

{ #category : #dependencies }
BaselineOfA2SSensorDomain class >> includePharoEDA: spec [

	spec
		baseline: 'PharoEDA'
		with: [ spec repository: 'github://rydnr/pharo-eda:settings' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfA2SSensorDomain class >> includePharoEDATools: spec [

	spec
		baseline: 'PharoEDATools'
		with: [ spec repository: 'github://rydnr/pharo-eda-tools:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfA2SSensorDomain class >> includePillar: spec [

	spec
		baseline: 'Pillar'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarCore'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarDocumentModel'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarExporter'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarMicro'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ];
		baseline: 'PillarApp'
		with: [ spec repository: 'github://pillar-markup/pillar:dev-8' ].
	^ spec
]

{ #category : #baselines }
BaselineOfA2SSensorDomain >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class
			includePharoEDA: spec;
			includePharoEDATools: spec;
			includePillar: spec;
			declarePackagesIn: spec;
			declareGroupsIn: spec ]
]

{ #category : #actions }
BaselineOfA2SSensorDomain >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'a2s-sensor-domain' ]) location.
	EDACIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
