# Test Runner for MileageFormGenerationV4.xsl
# Uses PowerShell's built-in XSLT capabilities

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$xslPath = Join-Path $scriptDir "..\MileageFormGenerationV4.xsl"
$testsDir = $scriptDir
$outputDir = Join-Path $scriptDir "output"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MileageFormGenerationV4.xsl Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testFiles = Get-ChildItem -Path $testsDir -Filter "test*.xml" | Sort-Object Name
$passed = 0
$failed = 0

foreach ($testFile in $testFiles) {
    $testName = $testFile.BaseName
    $outputFile = Join-Path $outputDir "$testName`_output.xml"
    
    Write-Host "Running: $testName" -NoNewline
    
    try {
        # Load the XSL
        $xsl = New-Object System.Xml.Xsl.XslCompiledTransform
        $xsl.Load((Resolve-Path $xslPath))
        
        # Use XmlReader instead of XmlDocument to support strip-space
        $readerSettings = New-Object System.Xml.XmlReaderSettings
        $readerSettings.DtdProcessing = [System.Xml.DtdProcessing]::Parse
        $reader = [System.Xml.XmlReader]::Create($testFile.FullName, $readerSettings)
        
        # Create output writer
        $writerSettings = New-Object System.Xml.XmlWriterSettings
        $writerSettings.Indent = $true
        $writer = [System.Xml.XmlWriter]::Create($outputFile, $writerSettings)
        
        # Transform
        $xsl.Transform($reader, $null, $writer)
        $reader.Close()
        $writer.Close()
        
        # Read and display output
        $output = Get-Content $outputFile -Raw
        
        Write-Host " - " -NoNewline
        Write-Host "PASSED" -ForegroundColor Green
        
        # Count output lines
        $lineCount = ([regex]::Matches($output, "<Line>")).Count
        Write-Host "   Output: $lineCount Line(s) generated" -ForegroundColor Gray
        
        $passed++
    }
    catch {
        Write-Host " - " -NoNewline
        Write-Host "FAILED" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Passed: $passed" -ForegroundColor Green
Write-Host "  Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })
Write-Host "  Total:  $($passed + $failed)" -ForegroundColor Cyan
Write-Host ""

if ($failed -eq 0) {
    Write-Host "All tests passed!" -ForegroundColor Green
} else {
    Write-Host "Some tests failed. Check the output above for details." -ForegroundColor Yellow
}
