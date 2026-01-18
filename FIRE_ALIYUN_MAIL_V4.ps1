# ===============================
# FIRE ALIYUN MAIL - Vercel v4 DNS Injector
# ===============================

$VERCEL_TOKEN = "uir7LWJToAw0bpRq9OOtRNWx"
$TEAM_ID = "yishen-global-team"
$DOMAIN  = "yishenglobal.net"

$headers = @{
  "Authorization" = "Bearer $VERCEL_TOKEN"
  "Content-Type"  = "application/json"
}

function Call-Vercel($method, $url, $body = $null) {
  if ($body) {
    $json = $body | ConvertTo-Json -Depth 10
    return Invoke-RestMethod -Method $method -Uri $url -Headers $headers -Body $json
  } else {
    return Invoke-RestMethod -Method $method -Uri $url -Headers $headers
  }
}

function Add-Record($type,$name,$value,$priority) {
  $url = "https://api.vercel.com/v4/domains/$DOMAIN/records?teamId=$TEAM_ID"
  if ($type -eq "MX") {
    $body = @{ type=$type; name=$name; value=$value; priority=$priority }
  } else {
    $body = @{ type=$type; name=$name; value=$value }
  }
  Call-Vercel "POST" $url $body
}

$records = @(
  @{t="MX"; n="@"; v="mx1.qiye.aliyun.com"; p=5},
  @{t="MX"; n="@"; v="mx2.qiye.aliyun.com"; p=10},
  @{t="MX"; n="@"; v="mx3.qiye.aliyun.com"; p=15},
  @{t="CNAME"; n="POP3"; v="pop.qiye.aliyun.com"},
  @{t="CNAME"; n="IMAP"; v="imap.qiye.aliyun.com"},
  @{t="CNAME"; n="SMTP"; v="smtp.qiye.aliyun.com"},
  @{t="CNAME"; n="Mail"; v="qiye.aliyun.com"},
  @{t="TXT"; n="@"; v="v=spf1 include:spf.qiye.aliyun.com -all"},
  @{t="TXT"; n="_dmarc"; v="v=DMARC1; p=quarantine; rua=mailto:postmaster@yishenglobal.net; ruf=mailto:postmaster@yishenglobal.net"},
  @{t="TXT"; n="default._domainkey"; v="v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5Brv2kZ+lc8TwwuUfYquxxAdN211rusg/Ug7yY8VGMhbvWAmgh94yAopCT7VYkTgkARdK+7yaQlFR7wsoSDmfxP7T066I3j6EUZe5Oh4Ax8+0RbBZrG917Q5aWbtbv4gUXokMVIvN8cMRF7ERTiwE+pJ6XOk9a4GbjFHe3q4Q3sUq7cDoHIK9m2W3pAq/VgPnNSUWt5raAf9HksiXi5FpUBCc/1KxPYC4rAaL+UJhwSVXZy2It5inn6VWkT7YVA6nnXpWm+VpnYWCGirfdnltcn/lzod8Xhbh7DZdx+h+D+m9PUOipuwk5s27cs+PFMWBCtLsquv+3vpFGMcv1wRkwIDAQAB;"}
)

foreach ($r in $records) {
  Write-Host "ADDING $($r.t) $($r.n) -> $($r.v)"
  Add-Record $r.t $r.n $r.v $r.p
}

Write-Host "DNS injected. Wait 5 minutes then click DNS Check in Aliyun Mail."
