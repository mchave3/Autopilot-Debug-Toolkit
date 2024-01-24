function Start-Window {
    Add-Type -AssemblyName PresentationFramework

    # Load XAML
    [xml]$xaml = Get-Content -Path ".\Private\Resources\Window.xaml" -Raw
    $xamlReader = New-Object System.Xml.XmlNodeReader $xaml
    $window = [Windows.Markup.XamlReader]::Load($xamlReader)

    # Create variables for each named element
    $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {
        # Verify that the element variable doesn't already exist
        if (Get-Variable -Name $_.Name -ErrorAction SilentlyContinue) {
            Set-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force | Out-Null
        }
        else {
            New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force | Out-Null
        }
    }
    
    # Add event handlers
    $Button_Test.Add_Click({
        # Change the background color of the window randomly
        $color = [Windows.Media.Color]::FromArgb((Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255))
        $brush = New-Object Windows.Media.SolidColorBrush($color)
        $Window.Background = $brush
    })
    
    # Show the window
    $Window.ShowDialog() | Out-Null
}

Export-ModuleMember -Function Start-Window