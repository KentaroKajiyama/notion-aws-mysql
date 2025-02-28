Get-Content ".\config\.env" | ForEach-Object {
  $name, $value = $_ -split "="
  Set-Variable -Name $name -Value $value
}