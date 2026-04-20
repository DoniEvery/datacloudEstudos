Set-Location "c:\Users\Adonikan Filho\Documents\PROJETOS\datacloudEstudos"
$ErrorActionPreference = 'Stop'
$targetOrg = 'DATACLOUDestudos'
$donidoneId = '0DBfj0000020enVGAQ'
$partnerHubId = '0DBfj000001yctFGAQ'
$username = 'adonikan+donidone@gmail.com'
$email = 'adonikan@gmail.com'
$profileOrder = @('Gold Partner User','Silver Partner User','Partner Community Login User','Partner Community User','Partner User')

function Invoke-SfJsonQuery([string]$soql) {
  $raw = (& sf data query --target-org $targetOrg --query $soql --json 2>&1) -join "`n"
  if ($LASTEXITCODE -ne 0) { throw $raw }
  return ($raw | ConvertFrom-Json)
}

function Invoke-SfJsonCreate([string]$sobject, [string]$values) {
  $raw = (& sf data create record --target-org $targetOrg --sobject $sobject --values $values --json 2>&1) -join "`n"
  if ($LASTEXITCODE -ne 0) { throw $raw }
  return ($raw | ConvertFrom-Json)
}

$contact = @( (Invoke-SfJsonQuery "SELECT Id, CreatedDate FROM Contact WHERE Email = 'adonikan@gmail.com' AND LastName = 'PartnerDonidone' AND AccountId = '001fj00000oIRugAAG' ORDER BY CreatedDate DESC LIMIT 1").result.records )[0]
$profiles = @( (Invoke-SfJsonQuery "SELECT Id, Name, UserType FROM Profile WHERE Name IN ('Gold Partner User','Silver Partner User','Partner Community Login User','Partner Community User','Partner User')").result.records ) | Sort-Object { [Array]::IndexOf($profileOrder, $_.Name) }

$result = [ordered]@{
  ContactId = $contact.Id
  Attempts = @()
  UserId = $null
  Username = $username
  Email = $email
  ProfileName = $null
  ProfileId = $null
  CommunityNickname = $null
}

foreach ($profile in $profiles) {
  $profileId = $profile.Id
  $profileName = $profile.Name
  $existingGroups = @( (Invoke-SfJsonQuery "SELECT Id, NetworkId FROM NetworkMemberGroup WHERE ParentId = '$profileId'").result.records )
  $donidoneGroup = $existingGroups | Where-Object { $_.NetworkId -eq $donidoneId } | Select-Object -First 1
  if (-not $donidoneGroup) {
    $donidoneGroup = (Invoke-SfJsonCreate 'NetworkMemberGroup' "NetworkId=$donidoneId ParentId=$profileId").result
  }
  $nickname = 'adondoni' + (Get-Date -Format 'yyyyMMddHHmmssfff')
  $userValues = "Username=$username Email=$email LastName=PartnerDonidone Alias=adondoni TimeZoneSidKey=America/Sao_Paulo LocaleSidKey=pt_BR EmailEncodingKey=UTF-8 LanguageLocaleKey=pt_BR CommunityNickname=$nickname ContactId=$($contact.Id) ProfileId=$profileId IsActive=true"
  try {
    $userCreate = Invoke-SfJsonCreate 'User' $userValues
    $result.UserId = $userCreate.result.id
    $result.ProfileName = $profileName
    $result.ProfileId = $profileId
    $result.CommunityNickname = $nickname
    $result.Attempts += [pscustomobject]@{ Profile = $profileName; NetworkMemberGroupId = $donidoneGroup.id; Outcome = 'CREATED'; Details = $userCreate.result.id }
    break
  } catch {
    $result.Attempts += [pscustomobject]@{ Profile = $profileName; NetworkMemberGroupId = $donidoneGroup.id; Outcome = 'FAILED'; Details = $_.Exception.Message }
  }
}

$result | ConvertTo-Json -Depth 6
