<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="profili">
	<xs:complexType>
		<xs:sequence>
			<xs:element name="profilo">
				<xs:complexType>
					<xs:sequence>
						<xs:element name="username" type="xs:string"/>
						<xs:element name="password" type="xs:string"/>
						<xs:element name="nome" type="xs:string"/>
						<xs:element name="cognome" type="xs:string"/>
						<xs:element name="telefono" type="xs:positiveInteger"/>
					</xs:sequence>
				</xs:complexType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
</xs:element>
</xs:schema>
