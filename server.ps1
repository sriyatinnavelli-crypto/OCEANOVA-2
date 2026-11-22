# ==============================================================================
# THE DEEP SEA — Lightweight Localhost HTTP Server (PowerShell)
# Zero external dependencies required (Runs on native Windows .NET)
# ==============================================================================

param(
    [int]$Port = 8080
)

$baseDir = $PSScriptRoot
if (-not $baseDir) { $baseDir = Get-Location }

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   🌊 THE DEEP SEA — Localhost Web Server" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Serving files from: $baseDir" -ForegroundColor Gray

# MIME Types dictionary
$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".svg"  = "image/svg+xml"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".ico"  = "image/x-icon"
}

# Start TCP Listener
$endpoint = [System.Net.IPEndPoint]::new([System.Net.IPAddress]::Loopback, $Port)
$listener = [System.Net.Sockets.TcpListener]::new($endpoint)

try {
    $listener.Start()
} catch {
    Write-Warning "Port $Port is occupied. Finding an available alternative port..."
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 0)
    $listener.Start()
    $Port = $listener.LocalEndpoint.Port
}

$url = "http://localhost:$Port"
Write-Host ">> Server LIVE at: " -NoNewline -ForegroundColor Green
Write-Host "$url" -ForegroundColor Yellow
Write-Host ">> Open $url in your browser to explore The Deep Sea!" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server.`n" -ForegroundColor DarkGray

$buffer = New-Object byte[] 65536

while ($listener.Server.IsBound) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) {
            $client.Close()
            continue
        }

        $requestStr = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $bytesRead)
        $firstLine = ($requestStr -split "`r`n")[0]
        $tokens = $firstLine -split " "

        $method = $tokens[0]
        $path = $tokens[1]

        # Normalize path
        if ([string]::IsNullOrWhiteSpace($path) -or $path -eq "/") {
            $path = "/index.html"
        }
        
        # Remove query parameters if any
        if ($path.Contains("?")) {
            $path = $path.Substring(0, $path.IndexOf("?"))
        }

        # Safe local path resolution
        $relPath = $path.TrimStart("/").Replace("/", [System.IO.Path]::DirectorySeparatorChar)
        $filePath = [System.IO.Path]::Combine($baseDir, $relPath)

        # Handle API Save Request
        if ($method -eq "POST" -and $path -eq "/api/save") {
            try {
                $bodyIndex = $requestStr.IndexOf("`r`n`r`n")
                if ($bodyIndex -ge 0) {
                    $jsonBody = $requestStr.Substring($bodyIndex + 4)
                    $outJsonPath = Join-Path $baseDir "data\creatures.json"
                    [System.IO.File]::WriteAllText($outJsonPath, $jsonBody, [System.Text.Encoding]::UTF8)
                    
                    $responseBody = '{"status":"ok","message":"Saved successfully"}'
                    $header = "HTTP/1.1 200 OK`r`nContent-Type: application/json`r`nContent-Length: $($responseBody.Length)`r`nAccess-Control-Allow-Origin: *`r`n`r`n"
                    $respBytes = [System.Text.Encoding]::UTF8.GetBytes($header + $responseBody)
                    $stream.Write($respBytes, 0, $respBytes.Length)
                }
            } catch {
                $err = '{"status":"error","message":"' + $_.Exception.Message + '"}'
                $header = "HTTP/1.1 500 Internal Server Error`r`nContent-Type: application/json`r`nContent-Length: $($err.Length)`r`n`r`n"
                $respBytes = [System.Text.Encoding]::UTF8.GetBytes($header + $err)
                $stream.Write($respBytes, 0, $respBytes.Length)
            }
            $client.Close()
            continue
        }

        # Handle Static Files
        if ([System.IO.File]::Exists($filePath)) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = "application/octet-stream"
            if ($mimeTypes.ContainsKey($ext)) {
                $contentType = $mimeTypes[$ext]
            }

            $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
            $header = "HTTP/1.1 200 OK`r`nContent-Type: $contentType`r`nContent-Length: $($fileBytes.Length)`r`nConnection: close`r`nAccess-Control-Allow-Origin: *`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)

            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            $notFoundMsg = "404 Not Found: $path"
            $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain`r`nContent-Length: $($notFoundMsg.Length)`r`nConnection: close`r`n`r`n"
            $respBytes = [System.Text.Encoding]::UTF8.GetBytes($header + $notFoundMsg)
            $stream.Write($respBytes, 0, $respBytes.Length)
        }

        $client.Close()
    } catch {
        # Continue loop on aborted connection
    }
}
