<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>

	<!-- Group by Employee, CarReg (A50), and Reference -->
	<xsl:key name="transactions-by-employee-date"
             match="PROJECT_LEDGER_LINE"
             use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>

	<xsl:template match="/">
		<xsl:value-of select="'&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;'" />
		<xsl:value-of select="'&#13;&#10;'"/>
		<xsl:value-of select="'&lt;Ledger&gt;'"/>
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
			<xsl:value-of select="'&lt;Line&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			
			<xsl:value-of select="'&lt;Employee&gt;'"/>
			<xsl:value-of select="Employee/@VALUE"/>
			<xsl:value-of select="'&lt;/Employee&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			<xsl:value-of select="'&lt;LastDate&gt;'"/>
			<xsl:value-of select="substring($lastTrans, 9, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($lastTrans, 6, 2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($lastTrans, 1, 4)"/>
			<xsl:value-of select="'&lt;/LastDate&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			<xsl:value-of select="'&lt;A50&gt;'"/>
			<xsl:value-of select="A50"/>
			<xsl:value-of select="'&lt;/A50&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			<xsl:value-of select="'&lt;Reference&gt;'"/>
			<xsl:value-of select="Reference"/>
			<xsl:value-of select="'&lt;/Reference&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			<xsl:value-of select="'&lt;Description&gt;'"/>
			<xsl:value-of select="A01"/>
			<xsl:value-of select="'&lt;/Description&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>
			<xsl:value-of select="'&lt;/Line&gt;'"/>
			<xsl:value-of select="'&#13;&#10;'"/>

		</xsl:for-each>
		<xsl:value-of select="'&lt;/Ledger&gt;'"/>
		<xsl:value-of select="'&#13;&#10;'"/>

	</xsl:template>
</xsl:stylesheet>
