# Test Crop Scan Endpoint
$BASE_URL = "http://localhost:8000"
$TEST_IMAGE_PATH = "C:\Users\Krishidnya\Desktop\Krishidnya\test_crop.jpg"

# Create a simple test image if it doesn't exist
if (-not (Test-Path $TEST_IMAGE_PATH)) {
    Write-Host "Creating test image..."
    # For testing, we'll create a simple colored image using PowerShell
    # This is a basic placeholder - in real testing you'd use an actual crop image
    $bitmap = New-Object -TypeName System.Drawing.Bitmap -ArgumentList 400, 300
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.Clear([System.Drawing.Color]::Green)
    $graphics.Dispose()
    $bitmap.Save($TEST_IMAGE_PATH, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bitmap.Dispose()
    Write-Host "Test image created at: $TEST_IMAGE_PATH"
}

Write-Host "Testing crop scan endpoint..."
Write-Host "Image: $TEST_IMAGE_PATH"

try {
    # Get file bytes
    $fileBytes = [System.IO.File]::ReadAllBytes($TEST_IMAGE_PATH)
    $fileBase64 = [System.Convert]::ToBase64String($fileBytes)
    
    # Create multipart form data
    $boundary = [System.Guid]::NewGuid().ToString()
    $bodyLines = @()
    
    $bodyLines += "--$boundary"
    $bodyLines += "Content-Disposition: form-data; name=`"file`"; filename=`"test_crop.jpg`""
    $bodyLines += "Content-Type: image/jpeg"
    $bodyLines += ""
    $bodyLines += $fileBase64
    $bodyLines += "--$boundary"
    $bodyLines += "Content-Disposition: form-data; name=`"language`""
    $bodyLines += ""
    $bodyLines += "en"
    $bodyLines += "--$boundary--"
    
    $body = $bodyLines -join "`r`n"
    
    $headers = @{
        "Content-Type" = "multipart/form-data; boundary=$boundary"
    }
    
    Write-Host "Sending request to $BASE_URL/scan-crop..."
    $response = Invoke-WebRequest -Uri "$BASE_URL/scan-crop" -Method POST -Body $body -Headers $headers -UseBasicParsing -TimeoutSec 60
    
    Write-Host "Response Status: $($response.StatusCode)"
    Write-Host "Response Content:"
    Write-Host $response.Content
    
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
        Write-Host "Response: $($_.Exception.Response.StatusDescription)"
    }
}
