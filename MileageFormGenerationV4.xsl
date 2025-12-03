<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Group by Employee, CarReg (A50), and Reference -->
	<xsl:key name="transactions-by-group" 
	         match="PROJECT_LEDGER_LINE" 
	         use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>

	<xsl:template match="/">
		<Ledger>
			<!-- Iterate unique combinations using Muenchian grouping -->
			<xsl:for-each select="//PROJECT_LEDGER_LINE[generate-id() = generate-id(key('transactions-by-group', concat(Employee/@VALUE, '|', A50, '|', Reference))[1])]">
				<xsl:sort select="Employee/@VALUE"/>
				<xsl:sort select="Reference"/>
				<xsl:sort select="A50"/>

				<!-- Store current grouping key -->
				<xsl:variable name="groupKey" select="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>
				<xsl:variable name="group" select="key('transactions-by-group', $groupKey)"/>

				<!-- Find max date by sorting group by Trans_Date descending and taking first -->
				<xsl:variable name="maxDate">
					<xsl:for-each select="$group">
						<xsl:sort select="Trans_Date" order="descending"/>
						<xsl:if test="position() = 1">
							<xsl:value-of select="Trans_Date"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<Line>
					<Employee><xsl:value-of select="Employee/@VALUE"/></Employee>
					<LastDate>
						<xsl:value-of select="substring($maxDate, 9, 2)"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="substring($maxDate, 6, 2)"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="substring($maxDate, 1, 4)"/>
					</LastDate>
					<A50><xsl:value-of select="A50"/></A50>
					<Reference><xsl:value-of select="Reference"/></Reference>
					<Description><xsl:value-of select="A01"/></Description>
				</Line>
			</xsl:for-each>
		</Ledger>
	</xsl:template>
</xsl:stylesheet>
