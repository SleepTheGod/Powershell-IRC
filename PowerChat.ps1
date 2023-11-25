param(
    [string]$IRCServer = "irc.efnet.org",
    [string]$Channel = "#testchannel"
)

# Check if PSIRC module is installed
$module = Get-Module -Name PSIRC -ListAvailable

# Install PSIRC module if not found
if (!$module) {
    Write-Host "Installing PSIRC module..."
    Install-Module -Name PSIRC -Force -Scope CurrentUser -Repository PSGallery -AcceptLicense
}

# Verify PSIRC module is loaded
$module = Get-Module -Name PSIRC -ListAvailable
if (!$module) {
    Write-Error "PSIRC module failed to load or install. Please check PowerShell configuration."
    exit
}

# Initialize IRC client object
$ircClient = New-Object -TypeName PSIRC.Client

# Attempt to connect to the IRC server
try {
    $connectionSuccessful = $ircClient.Connect($IRCServer, 6667)
} catch {
    Write-Error "Failed to connect to IRC server. Please check server details and network connectivity."
    exit
}

# Check if connection succeeded
if (!$connectionSuccessful) {
    Write-Error "Failed to connect to IRC server. Please check server details and network connectivity."
    exit
}

# Join the specified channel (assuming connection succeeded)
$ircClient.JoinChannel($Channel)

# Welcome message and instructions for the user
Write-Host "Connected to $Channel. You can start chatting!"
Write-Host "Type your messages below. To exit, type 'exit' and press Enter."

# Start chatting
while ($true) {
    $message = Read-Host
    if ($message -eq "exit") {
        # Exit the chat
        break
    }

    # Send message to the channel
    $ircClient.SendMessage($Channel, $message)
}

# Disconnect from the IRC server
$ircClient.Disconnect()
