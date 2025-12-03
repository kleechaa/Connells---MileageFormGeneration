<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<!-- Group by Employee, CarReg (A50), and Reference -->
	<xsl:key name="transactions-by-employee-date"
             match="PROJECT_LEDGER_LINE"
             use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>

	<xsl:template match="/">
		<Ledger>
		<xsl:value-of select="'&#13;&#10;'"/>

		<!-- Iterate unique combinations -->
		<xsl:for-each select="//PROJECT_LEDGER_LINE[generate-id() = generate-id(key('transactions-by-employee-date', concat(Employee/@VALUE, '|', A50, '|', Reference))[1])]">

			<!-- Sort the group -->
			<xsl:sort select="Employee/@VALUE"/>
			<xsl:sort select="Reference"/>
			<xsl:sort select="A50"/>

			<!-- Find the last (latest) Trans_Date in the group -->
			<xsl:variable name="group" select="key('transactions-by-employee-date', concat(Employee/@VALUE, '|', A50, '|', Reference))"/>
			<xsl:variable name="lastTrans" select="$group[not(Trans_Date &lt; ../Trans_Date)][last()]/Trans_Date"/>

			<!-- Output the record -->
			<Line>
			<xsl:value-of select="'&#13;&#10;'"/>
			
			<Employee>
			<xsl:value-of select="Employee/@VALUE"/>
			</Employee>
			<xsl:value-of select="'&#13;&#10;'"/>
			<LastDate>
			<xsl:value-of select="substring($lastTrans, 9, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($lastTrans, 6, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($lastTrans, 1, 4)"/>
			</LastDate>
			<xsl:value-of select="'&#13;&#10;'"/>
			<A50>
			<xsl:value-of select="A50"/>
			</A50>
			<xsl:value-of select="'&#13;&#10;'"/>
			<Reference>
			<xsl:value-of select="Reference"/>
			</Reference>
			<xsl:value-of select="'&#13;&#10;'"/>
			<Description>
			<xsl:value-of select="A01"/>
			</Description>
			<xsl:value-of select="'&#13;&#10;'"/>
			</Line>
			<xsl:value-of select="'&#13;&#10;'"/>

		</xsl:for-each>
		</Ledger>
		<xsl:value-of select="'&#13;&#10;'"/>

	</xsl:template>
</xsl:stylesheet>
