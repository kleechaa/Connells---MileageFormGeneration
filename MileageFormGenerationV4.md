# MileageFormGenerationV4.xsl Documentation

## Overview

`MileageFormGenerationV4.xsl` is an XSLT 1.0 stylesheet that transforms project ledger transaction data from the TimeAtWork system into a consolidated XML format. The transformation groups multiple transaction records by employee, vehicle registration, and reference number, producing a summary output with the latest transaction date for each unique combination.

## Purpose

The stylesheet is designed to:
- Consolidate multiple mileage/expense transaction records
- Group transactions by employee, car registration (A50), and reference number
- Extract the most recent transaction date from each group
- Generate a clean, structured XML output for further processing or reporting

## Input Format

### Source XML Structure

The input XML is expected to have the following structure:

```xml
<TIMEATWORK server="..." database="...">
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="employee_id"/>
        <Reference>reference_number</Reference>
        <Trans_Date>YYYY-MM-DD</Trans_Date>
        <A50>car_registration</A50>
        <A01>description</A01>
        <ExportSequence/>
        <ExportSequenceNo>0</ExportSequenceNo>
    </PROJECT_LEDGER_LINE>
    <!-- Additional PROJECT_LEDGER_LINE elements -->
</TIMEATWORK>
```

### Input Field Descriptions

| Field | Description | Example |
|-------|-------------|---------|
| `Employee/@VALUE` | Employee identifier | `101`, `Admin 2`, `ZZZ-003` |
| `Reference` | Transaction reference number | `0000000016` |
| `Trans_Date` | Transaction date (ISO format) | `2024-10-07` |
| `A50` | Vehicle registration number | `BD5I AXZ`, `JY7U SJY` |
| `A01` | Description field | `test &` |
| `ExportSequence` | Export sequence identifier | (typically empty) |
| `ExportSequenceNo` | Export sequence number | `0` |

## Output Format

### Generated XML Structure

```xml
<Ledger>
    <Line>
        <Employee>employee_id</Employee>
        <LastDate>DD/MM/YYYY</LastDate>
        <A50>car_registration</A50>
        <Reference>reference_number</Reference>
        <Description>description_text</Description>
    </Line>
    <!-- Additional Line elements -->
</Ledger>
```

### Output Field Descriptions

| Field | Description | Source |
|-------|-------------|--------|
| `Employee` | Employee identifier | `Employee/@VALUE` |
| `LastDate` | Latest transaction date in UK format | Derived from `Trans_Date` (reformatted) |
| `A50` | Vehicle registration number | `A50` |
| `Reference` | Transaction reference number | `Reference` |
| `Description` | Transaction description | `A01` |

## Transformation Logic

### 1. Grouping Mechanism

The stylesheet uses the **Muenchian grouping method** to group transactions by three criteria:

```xslt
<xsl:key name="transactions-by-employee-date"
         match="PROJECT_LEDGER_LINE"
         use="concat(Employee/@VALUE, '|', A50, '|', Reference)"/>
```

This creates a composite key combining:
- Employee identifier
- Car registration (A50)
- Reference number

### 2. Unique Record Selection

Using `generate-id()`, the stylesheet selects only the first occurrence of each unique combination:

```xslt
<xsl:for-each select="//PROJECT_LEDGER_LINE[generate-id() = 
    generate-id(key('transactions-by-employee-date', 
    concat(Employee/@VALUE, '|', A50, '|', Reference))[1])]">
```

### 3. Sorting

Output records are sorted by:
1. Employee (primary sort)
2. Reference (secondary sort)
3. A50/Car Registration (tertiary sort)

### 4. Date Extraction and Formatting

The latest transaction date from each group is determined and reformatted from ISO format (`YYYY-MM-DD`) to UK format (`DD/MM/YYYY`):

```xslt
<xsl:value-of select="substring($lastTrans, 9, 2)"/>  <!-- Day -->
<xsl:text>/</xsl:text>
<xsl:value-of select="substring($lastTrans, 6, 2)"/>  <!-- Month -->
<xsl:text>/</xsl:text>
<xsl:value-of select="substring($lastTrans, 1, 4)"/>  <!-- Year -->
```

## Usage Example

### Sample Input

```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK server="example.database.windows.net" database="EAW_Connells">
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="101"/>
        <Reference>0000000075</Reference>
        <Trans_Date>2025-01-06</Trans_Date>
        <A50>BD5I AXZ</A50>
        <A01>Business Travel</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="101"/>
        <Reference>0000000075</Reference>
        <Trans_Date>2025-01-12</Trans_Date>
        <A50>BD5I AXZ</A50>
        <A01>Business Travel</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Sample Output

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>101</Employee>
        <LastDate>12/01/2025</LastDate>
        <A50>BD5I AXZ</A50>
        <Reference>0000000075</Reference>
        <Description>Business Travel</Description>
    </Line>
</Ledger>
```

## Technical Specifications

| Specification | Value |
|--------------|-------|
| XSLT Version | 1.0 |
| Output Method | XML |
| Output Encoding | UTF-8 |
| Indentation | Yes |

## Dependencies

- Requires an XSLT 1.0 compatible processor
- Input must conform to the TimeAtWork `TIMEATWORK` schema

## Known Limitations

1. **Date Comparison Logic**: The current implementation uses string comparison for finding the latest date (`Trans_Date < ../Trans_Date`), which may not always produce accurate results for date comparisons.

2. **Description Field**: Only the description (`A01`) from the first record in each group is used; descriptions from subsequent records in the same group are ignored.

3. **Empty Fields**: If `A50` or `A01` fields are empty in the source data, they will appear as empty elements in the output.

## Version History

| Version | File | Description |
|---------|------|-------------|
| V1 | `MileageFormGenerationV1.xsl` | Initial version |
| V2 | `MileageFormGenerationV2.xsl` | Second iteration |
| V3 | `MileageFormGenerationV3.xsl` | Third iteration |
| V4 | `MileageFormGenerationV4.xsl` | Current version with Muenchian grouping |

## Related Files

- `input.xml` - Sample input data from TimeAtWork system
- `MileageFormGenerationV4.xml` - Sample output generated by this stylesheet
- `output.xml` - Alternative output file

## Author

Developed for Connells Group mileage form generation process.

---

*Documentation created: December 2025*
