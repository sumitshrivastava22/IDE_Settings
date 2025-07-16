# Define the XML to add
$roslynatorXml = @'
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
        
    # Use -replace with a regex that captures everything before and after the first match
    # and reconstruct the string.
    $pattern = '(?s)(.*?)(</ItemGroup>)(.*)' # (?s) enables single-line mode for . matching newlines
    
    if ($content -match $pattern) {
        $before = $Matches[1]
        $firstItemGroup = $Matches[2]
        $after = $Matches[3]
        
        # Insert the XML before the first </ItemGroup> and reconstruct
        $newContent = $before + $roslynatorXml + $firstItemGroup + $after
        
        Set-Content $_.FullName $newContent -NoNewline
        Write-Host "Added Roslynator references to $($_.FullName)"
    } else {
        Write-Host "Could not find </ItemGroup> in $($_.FullName) to insert references."
    }
  }
  else {
    Write-Host "Roslynator references already exist in $($_.FullName)"
  }
}