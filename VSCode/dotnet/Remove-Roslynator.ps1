$pattern = [regex]::Escape('<PackageReference Include="Roslynator.Analyzers" Version="4.13.1">') + 
           '[\s\S]*?</PackageReference>\s*' +
           [regex]::Escape('<PackageReference Include="Roslynator.CodeFixes" Version="4.13.1">') + 
           '[\s\S]*?</PackageReference>\s*' +
           [regex]::Escape('<PackageReference Include="Roslynator.Refactorings" Version="4.13.1">') + 
           '[\s\S]*?</PackageReference>\s*'

Get-ChildItem -Recurse -Filter *.csproj | ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace $pattern, '' | 
    Set-Content $_.FullName -NoNewline
}