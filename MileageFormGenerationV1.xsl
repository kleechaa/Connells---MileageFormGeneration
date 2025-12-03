<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:key name="transactions-by-employee-date"
             match="PROJECT_LEDGER_LINE"
             use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>

	<xsl:template match="/">
		<xsl:text>Employee,TransactionDate,CarReg,Reference</xsl:text>
		<xsl:text>&#xa;</xsl:text>

		<xsl:for-each select="//PROJECT_LEDGER_LINE[generate-id() = generate-id(key('transactions-by-employee-date', concat(Employee/@VALUE, '|', A50, '|', Reference))[1])]">

			
			<xsl:sort select="Employee/@VALUE"/>
			<xsl:sort select="Reference"/>
			<xsl:sort select="A50"/>
			

			<xsl:value-of select="Employee/@VALUE"/>
			<xsl:text>,</xsl:text>
			<xsl:variable name="date" select="Trans_Date"/>
			<xsl:value-of select="substring($date, 9, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($date, 6, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($date, 1, 4)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="A50"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="Reference"/>
			<xsl:text>&#xa;</xsl:text>
			
			
		</xsl:for-each>
	</xsl:template>	

</xsl:stylesheet>