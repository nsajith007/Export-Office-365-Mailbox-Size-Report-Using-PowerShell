$users = Get-Mailbox -ResultSize Unlimited

$results = @()

foreach ($user in $users) {
    $quota = (Get-MailboxStatistics $user.Identity).TotalItemSize
    $allocatedQuota = $user.ProhibitSendQuota

    $archiveState = if ($user.ArchiveStatus -eq "None") { "Off" } else { "On" }

    $results += [PSCustomObject]@{
        'Name'          = $user.DisplayName
        'UPN'           = $user.UserPrincipalName
        'AllocatedQuota'= $allocatedQuota
        'UsedQuota'     = $quota
        'ArchiveState'  = $archiveState
    }
}

$results | Export-CSV "C:\Temp\MailboxSizeReports.csv" -NoTypeInformation -Encoding UTF8