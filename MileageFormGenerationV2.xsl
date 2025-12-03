<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Output as proper XML -->
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Group key -->
    <xsl:key name="transactions-by-employee-date"
             match="PROJECT_LEDGER_LINE"
             use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>

    <xsl:template match="/">
        <SSC>
            <!-- Iterate unique groups -->
            <xsl:for-each 
                select="//PROJECT_LEDGER_LINE[
                    generate-id() = generate-id(
                        key('transactions-by-employee-date',
                            concat(Employee/@VALUE, '|', A50, '|', Reference)
                        )[1]
                    )
                ]">

                <!-- Sort groups -->
                <xsl:sort select="Employee/@VALUE"/>
                <xsl:sort select="Reference"/>
                <xsl:sort select="A50"/>

                <!-- Group items -->
                <xsl:variable name="group"
                    select="key('transactions-by-employee-date',
                                concat(Employee/@VALUE, '|', A50, '|', Reference))"/>

                <!-- Latest Trans_Date -->
                <xsl:variable name="lastTrans"
                    select="$group[not(Trans_Date < ../Trans_Date)][last()]/Trans_Date"/>

                <!-- Output XML record -->
                <Record>
                    <Employee>
                        <xsl:value-of select="Employee/@VALUE"/>
                    </Employee>
                    <Date>
                        <xsl:value-of select="concat(
                            substring($lastTrans, 9, 2), '/',
                            substring($lastTrans, 6, 2), '/',
                            substring($lastTrans, 1, 4)
                        )"/>
                    </Date>
                    <AccountCode>
                        <xsl:value-of select="A50"/>
                    </AccountCode>
                    <Reference>
                        <xsl:value-of select="Reference"/>
                    </Reference>
                </Record>

            </xsl:for-each>
        </SSC>
    </xsl:template>

</xsl:stylesheet>
