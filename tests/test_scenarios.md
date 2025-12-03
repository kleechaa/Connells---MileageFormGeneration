# Test Scenarios for MileageFormGenerationV4.xsl

## Overview

This document outlines test scenarios to validate the XSLT transformation logic.

---

## Test Scenario 1: Basic Grouping

**Purpose:** Verify that multiple transactions with the same Employee, A50, and Reference are grouped into a single output line.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-01-01</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Trip to London</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-01-02</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Trip to London</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-01-03</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Trip to London</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>03/01/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Trip to London</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] 3 input records produce 1 output line
- [ ] LastDate shows the maximum date (03/01/2025)
- [ ] Date format is DD/MM/YYYY

---

## Test Scenario 2: Multiple Employees

**Purpose:** Verify that transactions from different employees produce separate output lines.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-02-15</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Site Visit</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP002"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-02-16</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Site Visit</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>15/02/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Site Visit</Description>
    </Line>
    <Line>
        <Employee>EMP002</Employee>
        <LastDate>16/02/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Site Visit</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] 2 input records produce 2 output lines
- [ ] Each employee has their own line
- [ ] Output is sorted by Employee

---

## Test Scenario 3: Multiple Vehicles (A50)

**Purpose:** Verify that same employee with different vehicles produces separate lines.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-03-01</Trans_Date>
        <A50>CAR001</A50>
        <A01>Company Car</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-03-02</Trans_Date>
        <A50>CAR002</A50>
        <A01>Rental Car</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>01/03/2025</LastDate>
        <A50>CAR001</A50>
        <Reference>REF001</Reference>
        <Description>Company Car</Description>
    </Line>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>02/03/2025</LastDate>
        <A50>CAR002</A50>
        <Reference>REF001</Reference>
        <Description>Rental Car</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Different A50 values create separate lines
- [ ] Each line has correct vehicle registration

---

## Test Scenario 4: Multiple References

**Purpose:** Verify that same employee/vehicle with different references produces separate lines.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-04-10</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Project Alpha</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF002</Reference>
        <Trans_Date>2025-04-11</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Project Beta</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>10/04/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Project Alpha</Description>
    </Line>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>11/04/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF002</Reference>
        <Description>Project Beta</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Different Reference values create separate lines
- [ ] Output sorted by Reference within same Employee

---

## Test Scenario 5: Empty A50 Field

**Purpose:** Verify handling of empty vehicle registration.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-05-01</Trans_Date>
        <A50/>
        <A01>No vehicle</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-05-02</Trans_Date>
        <A50/>
        <A01>No vehicle</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>02/05/2025</LastDate>
        <A50></A50>
        <Reference>REF001</Reference>
        <Description>No vehicle</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Empty A50 is handled correctly
- [ ] Records with empty A50 are still grouped together
- [ ] Output contains empty A50 element

---

## Test Scenario 6: Empty Description (A01)

**Purpose:** Verify handling of empty description field.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-06-15</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01/>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>15/06/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description></Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Empty A01 produces empty Description element
- [ ] No errors occur with empty description

---

## Test Scenario 7: Special Characters in Description

**Purpose:** Verify that special XML characters are handled correctly.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-07-01</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Test &amp; Demo &lt;Project&gt;</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>01/07/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Test &amp; Demo &lt;Project&gt;</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Ampersand (&) is preserved/escaped correctly
- [ ] Less than (<) and greater than (>) are preserved/escaped
- [ ] Output is valid XML

---

## Test Scenario 8: Date Boundary - Year Transition

**Purpose:** Verify max date selection across year boundaries.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2024-12-31</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Year End</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-01-01</Trans_Date>
        <A50>AB12 CDE</A50>
        <A01>Year End</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>01/01/2025</LastDate>
        <A50>AB12 CDE</A50>
        <Reference>REF001</Reference>
        <Description>Year End</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] 2025-01-01 is correctly identified as later than 2024-12-31
- [ ] Date sorting works across year boundaries

---

## Test Scenario 9: Sorting Order Verification

**Purpose:** Verify output is sorted by Employee, then Reference, then A50.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP002"/>
        <Reference>REF002</Reference>
        <Trans_Date>2025-08-01</Trans_Date>
        <A50>ZZZ999</A50>
        <A01>Last</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF002</Reference>
        <Trans_Date>2025-08-01</Trans_Date>
        <A50>AAA111</A50>
        <A01>First</A01>
    </PROJECT_LEDGER_LINE>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="EMP001"/>
        <Reference>REF001</Reference>
        <Trans_Date>2025-08-01</Trans_Date>
        <A50>BBB222</A50>
        <A01>Second</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>01/08/2025</LastDate>
        <A50>BBB222</A50>
        <Reference>REF001</Reference>
        <Description>Second</Description>
    </Line>
    <Line>
        <Employee>EMP001</Employee>
        <LastDate>01/08/2025</LastDate>
        <A50>AAA111</A50>
        <Reference>REF002</Reference>
        <Description>First</Description>
    </Line>
    <Line>
        <Employee>EMP002</Employee>
        <LastDate>01/08/2025</LastDate>
        <A50>ZZZ999</A50>
        <Reference>REF002</Reference>
        <Description>Last</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] EMP001 appears before EMP002
- [ ] Within EMP001, REF001 appears before REF002
- [ ] Sorting is consistent and predictable

---

## Test Scenario 10: Single Record

**Purpose:** Verify handling of a single input record.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
    <PROJECT_LEDGER_LINE>
        <Employee VALUE="SOLO"/>
        <Reference>REF999</Reference>
        <Trans_Date>2025-09-15</Trans_Date>
        <A50>XY99 ABC</A50>
        <A01>Single Entry</A01>
    </PROJECT_LEDGER_LINE>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
    <Line>
        <Employee>SOLO</Employee>
        <LastDate>15/09/2025</LastDate>
        <A50>XY99 ABC</A50>
        <Reference>REF999</Reference>
        <Description>Single Entry</Description>
    </Line>
</Ledger>
```

### Validation Points
- [ ] Single record produces single output line
- [ ] All fields are correctly mapped

---

## Test Scenario 11: Empty Input

**Purpose:** Verify handling of no transaction records.

### Input
```xml
<?xml version="1.0" encoding="utf-8"?>
<TIMEATWORK>
</TIMEATWORK>
```

### Expected Output
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Ledger>
</Ledger>
```

### Validation Points
- [ ] Empty input produces empty Ledger element
- [ ] No errors occur
- [ ] Output is valid XML

---

## Test Scenario 12: Large Dataset Performance

**Purpose:** Verify performance with many records.

### Input
- 1000+ PROJECT_LEDGER_LINE records
- Mix of groupable and unique combinations

### Validation Points
- [ ] Transformation completes in reasonable time (<5 seconds)
- [ ] No memory issues
- [ ] Output is correct and complete

---

## Test Execution Checklist

| Scenario | Status | Date | Tester | Notes |
|----------|--------|------|--------|-------|
| 1. Basic Grouping | ⬜ | | | |
| 2. Multiple Employees | ⬜ | | | |
| 3. Multiple Vehicles | ⬜ | | | |
| 4. Multiple References | ⬜ | | | |
| 5. Empty A50 | ⬜ | | | |
| 6. Empty Description | ⬜ | | | |
| 7. Special Characters | ⬜ | | | |
| 8. Year Transition | ⬜ | | | |
| 9. Sorting Order | ⬜ | | | |
| 10. Single Record | ⬜ | | | |
| 11. Empty Input | ⬜ | | | |
| 12. Performance | ⬜ | | | |

---

*Document created: December 2025*
