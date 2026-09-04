# Test Chat Endpoint
$BASE_URL = "http://localhost:8000"

Write-Host "Testing Chat Endpoint..."

$chatRequest = @{
    message = "plan a grapes plantation for me in the month of december we've booked an crops for the 1 acer of land soil is black"
    conversation_history = @(
        @{ role = "user"; content = "hi" },
        @{ role = "assistant"; content = "Hello! How can I help you today?" }
    )
    model = "gemini"
} | ConvertTo-Json -Depth 10

try {
    $headers = @{
        "Content-Type" = "application/json"
    }
    
    Write-Host "Sending chat request to /api/chat..."
    $response = Invoke-WebRequest -Uri "$BASE_URL/api/chat" -Method POST -Body $chatRequest -Headers $headers -UseBasicParsing -TimeoutSec 60
    
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

Write-Host "`nTrying alternative endpoint /api/chat/gemini..."
try {
    $response = Invoke-WebRequest -Uri "$BASE_URL/api/chat/gemini" -Method POST -Body $chatRequest -Headers $headers -UseBasicParsing -TimeoutSec 60
    Write-Host "Response Status: $($response.StatusCode)"
    Write-Host "Response Content:"
    Write-Host $response.Content
} catch {
    Write-Host "Alternative endpoint also failed: $($_.Exception.Message)"
}
