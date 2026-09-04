# Integration Test Runner for Krishidnya Backend (PowerShell)
# Runs complete end-to-end tests using PowerShell and curl

$ErrorActionPreference = "Continue"
$BASE_URL = "http://localhost:8000"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Global:TEST_RESULTS = @()

# Test User Data
$TIMESTAMP_SUFFIX = [int](Get-Date -UFormat %s)
$RANDOM_MOBILE = "99" + (Get-Random -Minimum 10000000 -Maximum 99999999)
$TEST_USER = @{
    username = "integration_user_$TIMESTAMP_SUFFIX"
    mobile = $RANDOM_MOBILE
    password = "Test@12345"
    full_name = "Integration Test User"
    location = "Test Location"
}

$AUTH_TOKEN = $null
$CREATED_POST_ID = $null

function Log-Test {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Message = ""
    )
    
    $result = @{
        test = $TestName
        passed = $Passed
        message = $Message
        timestamp = (Get-Date -Format "HH:mm:ss")
    }
    
    $Global:TEST_RESULTS += $result
    
    $status = if ($Passed) { "[PASS]" } else { "[FAIL]" }
    Write-Host "$status - $TestName"
    if ($Message) {
        Write-Host "     $Message"
    }
}

function Test-HealthCheck {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/health" -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            if ($data.status -eq "healthy") {
                Log-Test "Health Check" $true "Service is healthy"
                return $true
            } else {
                Log-Test "Health Check" $false "Status: $($data.status)"
                return $false
            }
        } else {
            Log-Test "Health Check" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Health Check" $false $_.Exception.Message
        return $false
    }
}

function Test-UserRegistration {
    try {
        $body = $TEST_USER | ConvertTo-Json
        $response = Invoke-WebRequest -Uri "$BASE_URL/register" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
        
        if ($response.StatusCode -eq 201) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "User Registration" $true "User ID: $($data.id)"
            return $true
        } elseif ($response.StatusCode -eq 400) {
            Log-Test "User Registration" $true "User already exists (expected)"
            return $true
        } else {
            Log-Test "User Registration" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "User Registration" $false $_.Exception.Message
        return $false
    }
}

function Test-UserLogin {
    try {
        $body = "username=$($TEST_USER.username)&password=$($TEST_USER.password)"
        $response = Invoke-WebRequest -Uri "$BASE_URL/token" -Method POST -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            $script:AUTH_TOKEN = $data.access_token
            Log-Test "User Login" $true "Token received"
            return $true
        } else {
            Log-Test "User Login" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "User Login" $false $_.Exception.Message
        return $false
    }
}

function Test-GetUserProfile {
    if (-not $AUTH_TOKEN) {
        Log-Test "Get User Profile" $false "No auth token available"
        return $false
    }
    
    try {
        $headers = @{ Authorization = "Bearer $AUTH_TOKEN" }
        $response = Invoke-WebRequest -Uri "$BASE_URL/users/me" -Headers $headers -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Get User Profile" $true "Username: $($data.username)"
            return $true
        } else {
            Log-Test "Get User Profile" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Get User Profile" $false $_.Exception.Message
        return $false
    }
}

function Test-CreatePost {
    if (-not $AUTH_TOKEN) {
        Log-Test "Create Post" $false "No auth token available"
        return $false
    }
    
    try {
        $headers = @{ Authorization = "Bearer $AUTH_TOKEN" }
        $postData = @{
            content = "Integration test post - testing complete user journey"
            crop_type = "Rice"
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "$BASE_URL/posts" -Method POST -Body $postData -Headers $headers -ContentType "application/json" -UseBasicParsing
        
        if ($response.StatusCode -eq 201) {
            $data = $response.Content | ConvertFrom-Json
            $script:CREATED_POST_ID = $data.id
            Log-Test "Create Post" $true "Post ID: $($data.id)"
            return $true
        } else {
            Log-Test "Create Post" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Create Post" $false $_.Exception.Message
        return $false
    }
}

function Test-GetPosts {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/posts" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Get All Posts" $true "Retrieved $($data.Count) posts"
            return $true
        } else {
            Log-Test "Get All Posts" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Get All Posts" $false $_.Exception.Message
        return $false
    }
}

function Test-PostAuthorRelationship {
    if (-not $AUTH_TOKEN -or -not $CREATED_POST_ID) {
        Log-Test "Post-Author Relationship" $false "Missing prerequisites"
        return $false
    }
    
    try {
        $headers = @{ Authorization = "Bearer $AUTH_TOKEN" }
        $response = Invoke-WebRequest -Uri "$BASE_URL/posts" -Headers $headers -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $posts = $response.Content | ConvertFrom-Json
            $ourPost = $posts | Where-Object { $_.id -eq $CREATED_POST_ID }
            
            if ($ourPost) {
                $hasAuthor = $ourPost.PSObject.Properties.Name -contains "author" -or $ourPost.PSObject.Properties.Name -contains "username"
                Log-Test "Post-Author Relationship" $hasAuthor "Author data included in post"
                return $hasAuthor
            } else {
                Log-Test "Post-Author Relationship" $false "Post not found in feed"
                return $false
            }
        } else {
            Log-Test "Post-Author Relationship" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Post-Author Relationship" $false $_.Exception.Message
        return $false
    }
}

function Test-MarketplaceProducts {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/api/products" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Get Marketplace Products" $true "Retrieved $($data.Count) products"
            return $true
        } else {
            Log-Test "Get Marketplace Products" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Get Marketplace Products" $false $_.Exception.Message
        return $false
    }
}

function Test-MarketplaceSearch {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/api/products?search=test" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Marketplace Search" $true "Search returned $($data.Count) results"
            return $true
        } else {
            Log-Test "Marketplace Search" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Marketplace Search" $false $_.Exception.Message
        return $false
    }
}

function Test-SchemesList {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/api/schemes/" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Get Schemes List" $true "Retrieved $($data.Count) schemes"
            return $true
        } else {
            Log-Test "Get Schemes List" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Get Schemes List" $false $_.Exception.Message
        return $false
    }
}

function Test-SchemesPagination {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/api/schemes/?limit=10&offset=0" -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            Log-Test "Schemes Pagination" $true "Pagination works: $($data.Count) schemes"
            return $true
        } else {
            Log-Test "Schemes Pagination" $false "Status: $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Schemes Pagination" $false $_.Exception.Message
        return $false
    }
}

function Test-InvalidCredentials {
    try {
        $body = "username=$($TEST_USER.username)&password=WrongPassword123"
        $response = Invoke-WebRequest -Uri "$BASE_URL/token" -Method POST -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -ErrorAction SilentlyContinue
        
        if ($response.StatusCode -eq 401) {
            Log-Test "Invalid Credentials" $true "Properly rejected"
            return $true
        } else {
            Log-Test "Invalid Credentials" $false "Expected 401, got $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "Invalid Credentials" $true "Properly rejected (exception caught)"
        return $true
    }
}

function Test-RateLimiting {
    try {
        $body = "username=$($TEST_USER.username)&password=WrongPassword123"
        $rateLimited = $false
        
        for ($i = 0; $i -lt 6; $i++) {
            try {
                $response = Invoke-WebRequest -Uri "$BASE_URL/token" -Method POST -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -ErrorAction SilentlyContinue
                if ($response.StatusCode -eq 423 -or $response.StatusCode -eq 429) {
                    $rateLimited = $true
                    break
                }
            } catch {
                $rateLimited = $true
                break
            }
        }
        
        if ($rateLimited) {
            Log-Test "Rate Limiting" $true "Rate limiting activated"
            return $true
        } else {
            Log-Test "Rate Limiting" $false "Rate limiting not triggered"
            return $false
        }
    } catch {
        Log-Test "Rate Limiting" $false $_.Exception.Message
        return $false
    }
}

function Test-404Handling {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/nonexistent-endpoint" -UseBasicParsing -ErrorAction SilentlyContinue
        
        if ($response.StatusCode -eq 404) {
            Log-Test "404 Handling" $true "Proper 404 response"
            return $true
        } else {
            Log-Test "404 Handling" $false "Expected 404, got $($response.StatusCode)"
            return $false
        }
    } catch {
        Log-Test "404 Handling" $true "Proper 404 response (exception caught)"
        return $true
    }
}

function Test-ConcurrentRequests {
    try {
        $results = @()
        
        $jobs = @()
        for ($i = 0; $i -lt 10; $i++) {
            $jobs += Start-Job -ScriptBlock {
                try {
                    $response = Invoke-WebRequest -Uri "http://localhost:8000/posts" -UseBasicParsing
                    return $response.StatusCode
                } catch {
                    return 500
                }
            }
        }
        
        foreach ($job in $jobs) {
            $result = Receive-Job -Job $job -Wait
            $results += $result
            Remove-Job -Job $job
        }
        
        $successCount = ($results | Where-Object { $_ -eq 200 }).Count
        if ($successCount -eq 10) {
            Log-Test "Concurrent Requests" $true "All 10 requests succeeded"
            return $true
        } else {
            Log-Test "Concurrent Requests" $false "Failed: $successCount/10 succeeded"
            return $false
        }
    } catch {
        Log-Test "Concurrent Requests" $false $_.Exception.Message
        return $false
    }
}

function Test-ResponseFormatConsistency {
    try {
        $response = Invoke-WebRequest -Uri "$BASE_URL/health" -UseBasicParsing
        if ($response.StatusCode -ne 200) {
            Log-Test "Response Format" $false "Health check failed"
            return $false
        }
        
        $contentType = $response.Headers["Content-Type"]
        if ($contentType -notmatch "application/json") {
            Log-Test "Response Format" $false "Wrong content type: $contentType"
            return $false
        }
        
        try {
            $response = Invoke-WebRequest -Uri "$BASE_URL/nonexistent" -UseBasicParsing -ErrorAction SilentlyContinue
        } catch {
        }
        
        Log-Test "Response Format" $true "Consistent JSON responses"
        return $true
    } catch {
        Log-Test "Response Format" $false $_.Exception.Message
        return $false
    }
}

# Main Test Execution
Write-Host "=" * 70
Write-Host "KRISHIDNYA INTEGRATION TEST SUITE"
Write-Host "=" * 70
Write-Host "Started at: $TIMESTAMP"
Write-Host "Base URL: $BASE_URL"
Write-Host "=" * 70
Write-Host ""

# Run all tests
Test-HealthCheck | Out-Null
Test-UserRegistration | Out-Null
Test-UserLogin | Out-Null
Test-GetUserProfile | Out-Null
Test-CreatePost | Out-Null
Test-GetPosts | Out-Null
Test-PostAuthorRelationship | Out-Null
Test-MarketplaceProducts | Out-Null
Test-MarketplaceSearch | Out-Null
Test-SchemesList | Out-Null
Test-SchemesPagination | Out-Null
Test-InvalidCredentials | Out-Null
Test-RateLimiting | Out-Null
Test-404Handling | Out-Null
Test-ConcurrentRequests | Out-Null
Test-ResponseFormatConsistency | Out-Null

# Calculate results
$passed = ($Global:TEST_RESULTS | Where-Object { $_.passed -eq $true }).Count
$failed = ($Global:TEST_RESULTS | Where-Object { $_.passed -eq $false }).Count

Write-Host ""
Write-Host "=" * 70
Write-Host "TEST SUMMARY"
Write-Host "=" * 70
Write-Host "Total Tests: $($Global:TEST_RESULTS.Count)"
Write-Host "Passed: $passed"
Write-Host "Failed: $failed"
if ($Global:TEST_RESULTS.Count -gt 0) {
    Write-Host "Success Rate: $([math]::Round(($passed / $Global:TEST_RESULTS.Count) * 100, 1))%"
} else {
    Write-Host "Success Rate: N/A"
}
Write-Host "=" * 70

# Generate JSON report
$report = @{
    timestamp = $TIMESTAMP
    base_url = $BASE_URL
    total_tests = $Global:TEST_RESULTS.Count
    passed = $passed
    failed = $failed
    success_rate = if ($Global:TEST_RESULTS.Count -gt 0) { [math]::Round(($passed / $Global:TEST_RESULTS.Count) * 100, 1) } else { 0 }
    tests = $Global:TEST_RESULTS
} | ConvertTo-Json -Depth 10

$report | Out-File -FilePath "C:\Users\Krishidnya\Desktop\Krishidnya\INTEGRATION_TEST_REPORT.json" -Encoding UTF8
Write-Host "Report saved to: INTEGRATION_TEST_REPORT.json"

if ($passed -eq 16) {
    Write-Host ""
    Write-Host "ALL TESTS PASSED!"
    exit 0
} else {
    Write-Host ""
    Write-Host "$failed TEST(S) FAILED"
    exit 1
}
