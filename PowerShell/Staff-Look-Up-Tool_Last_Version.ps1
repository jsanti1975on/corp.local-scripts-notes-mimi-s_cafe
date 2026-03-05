# ============================================
# MARINA DATA RETRIEVAL TOOL (Production)
# Script Name: Staff-Pick-Scripts.ps1
# Author: Jason
# Version: 1.0.0
# ============================================
# PURPOSE
# -------
# Staff tool for quickly locating marina records:
# - Lookup by tenant name
# - Lookup by slip number
# - Show open slips (Name = NOT LISTED)
# - Search .txt records with Out-GridView
# - Locate tenant documents (open slip folder)
# ============================================

Clear-Host

# -------- CONFIGURATION --------
$RootPath = "D:\01_CUSTOMER_SERVICE_SPECIALIST\01_marinaDB"
$SlipCSV  = Join-Path $RootPath "Weekly_Slip_Normalized.csv"

# -------- SAFETY CHECKS --------
if (!(Test-Path $RootPath)) {
    Write-Host "ERROR: RootPath not found: $RootPath" -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit
}

if (!(Test-Path $SlipCSV)) {
    Write-Host "ERROR: CSV not found: $SlipCSV" -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit
}

# -------- STAFF LEAD-IN --------
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "        MARINA DATA RETRIEVAL TOOL" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Welcome to the Marina Data Retrieval Tool."
Write-Host ""
Write-Host "Here you can:"
Write-Host " - Lookup by Tenant Name"
Write-Host " - Lookup by Slip Number"
Write-Host " - Lookup Open Slips (Name = NOT LISTED)"
Write-Host " - Lookup .txt Records (sortable grid view)"
Write-Host " - Locate Tenant Documents (opens slip folder)"
Write-Host ""
Write-Host "Tip: In the grid window you can sort by clicking column headers."
Write-Host ""
Read-Host "Press ENTER to continue"

# -------- MAIN LOOP --------
do {
    Clear-Host

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " MARINA SEARCH OPTIONS" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1 - Lookup Tenant by Name"
    Write-Host "2 - Lookup Slip by Number"
    Write-Host "3 - Show Open Slips"
    Write-Host "4 - Search Text Records (.txt)"
    Write-Host "5 - Locate Tenant Documents (Open Slip Folder)"
    Write-Host "Q - Quit"
    Write-Host ""

    $choice = Read-Host "Select Option"

    switch ($choice.ToUpper()) {

        # ----------------------------
        # 1) LOOKUP BY NAME
        # ----------------------------
        "1" {
            $name = Read-Host "Enter tenant name (partial ok)"
            $results = Import-Csv $SlipCSV |
                Where-Object { $_.Name -and ($_.Name.Trim() -ne "") } |
                Where-Object { $_.Name -like "*$name*" }

            if ($results) {
                $results | Out-GridView -Title "Tenant Lookup Results"
            } else {
                Write-Host "No tenant match found." -ForegroundColor Yellow
                Read-Host "Press ENTER"
            }
        }

        # ----------------------------
        # 2) LOOKUP BY SLIP NUMBER
        # ----------------------------
        "2" {
            $slip = Read-Host "Enter slip number (example: 33 or 033)"
            $slipClean = $slip.Trim()

            # Normalize common slip formats:
            # - if numeric and length < 3, pad to 3 (33 -> 033)
            if ($slipClean -match '^\d+$') {
                $slipClean = "{0:D3}" -f [int]$slipClean
            }

            $results = Import-Csv $SlipCSV |
                Where-Object { $_.SlipNumber -eq $slipClean -or $_.SlipNumber -eq $slip.Trim() }

            if ($results) {
                $results | Out-GridView -Title "Slip Lookup: $slipClean"
            } else {
                Write-Host "Slip not found in CSV." -ForegroundColor Yellow
                Read-Host "Press ENTER"
            }
        }

        # ----------------------------
        # 3) SHOW OPEN SLIPS
        # ----------------------------
        "3" {
            $open = Import-Csv $SlipCSV |
                Where-Object { $_.Name -eq "NOT LISTED" }

            if ($open) {
                $open | Out-GridView -Title "Open Slips (Name = NOT LISTED)"
            } else {
                Write-Host "No open slips found (Name = NOT LISTED)." -ForegroundColor Yellow
                Read-Host "Press ENTER"
            }
        }

        # ----------------------------
        # 4) SEARCH TXT RECORDS
        # ----------------------------
        "4" {
            Get-ChildItem -Path $RootPath -Recurse -Filter *.txt -ErrorAction SilentlyContinue |
                Select-Object LastWriteTime, Length, Name, Directory |
                Out-GridView -Title "Marina Text Records (.txt)"
        }

        # ----------------------------
        # 5) LOCATE TENANT DOCUMENTS
        #    Find tenant -> slip -> open folder
        # ----------------------------
        "5" {
            $name = Read-Host "Enter tenant name (partial ok)"
            $match = Import-Csv $SlipCSV |
                Where-Object { $_.Name -like "*$name*" } |
                Select-Object -First 1

            if ($match) {
                $slip = $match.SlipNumber

                # Normalize slip format for folder naming (001, 033, etc.)
                if ($slip -match '^\d+$') {
                    $slip = "{0:D3}" -f [int]$slip
                }

                $slipFolder = Join-Path $RootPath ("SLIP_" + $slip)

                if (Test-Path $slipFolder) {
                    Write-Host "Opening: $slipFolder" -ForegroundColor Green
                    Invoke-Item $slipFolder
                } else {
                    Write-Host "Slip folder not found: $slipFolder" -ForegroundColor Yellow
                }
            } else {
                Write-Host "Tenant not found." -ForegroundColor Yellow
            }

            Read-Host "Press ENTER"
        }

        # ----------------------------
        # QUIT
        # ----------------------------
        "Q" { break }

        default {
            Write-Host "Invalid option." -ForegroundColor Yellow
            Read-Host "Press ENTER"
        }
    }

} while ($true)

Clear-Host
Write-Host "Marina Data Retrieval Tool closed."