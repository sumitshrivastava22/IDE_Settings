# Define the XML to add
$roslynatorXml = @'
    <PackageReference Include="Roslynator.Analyzers" Version="4.13.1">
            <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
            <PrivateAssets>all</PrivateAssets>
        </PackageReference>
        <PackageReference Include="Roslynator.CodeFixes" Version="4.13.1">
            <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
            <PrivateAssets>all</PrivateAssets>
        </PackageReference>
        <PackageReference Include="Roslynator.Refactorings" Version="4.13.1">
            <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
            <PrivateAssets>all</PrivateAssets>
        </PackageReference>
        <PackageReference Include="SonarAnalyzer.CSharp" Version="1.21.0">
            <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
            <PrivateAssets>all</PrivateAssets>
        </PackageReference>
    
'@

# Process all csproj files
Get-ChildItem -Recurse -Filter *.csproj | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
    
  # Only add if references don't already exist
  if (-not $content.Contains('Roslynator.Analyzers') -and 
      -not $content.Contains('Roslynator.CodeFixes') -and
    -not $content.Contains('Roslynator.Refactorings')) {
        
    # Insert before closing ItemGroup
    $newContent = $content -replace '(</ItemGroup>)', ($roslynatorXml + '$1')
    Set-Content $_.FullName $newContent -NoNewline
    Write-Host "Added Roslynator references to $($_.FullName)"
  }
  else {
    Write-Host "Roslynator references already exist in $($_.FullName)"
  }
}