Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$OFDI = New-Object System.Windows.Forms.OpenFileDialog
$OFDI.Title = "Select Input File"
$OFDI.Filter = "All Files (*.*)|*.*"

$RI = $OFDI.ShowDialog()

if ($RI -eq [System.Windows.Forms.DialogResult]::OK) {
    $IFP = $OFDI.FileName
    $SFDO = New-Object System.Windows.Forms.SaveFileDialog
    $SFDO.Title = "Save Output File"
    $SFDO.Filter = "All Files (*.*)|*.*"
    $RESPUT = $SFDO.ShowDialog()
    if ($RESPUT -eq [System.Windows.Forms.DialogResult]::OK) {
        $OFP = $SFDO.FileName
        $bytes = [System.IO.File]::ReadAllBytes($IFP)
        $bytes = $bytes[8..($bytes.Length - 1)] # slices like i dont know how to explain first 8 bites gets ykyk..
        $DC = [System.Text.Encoding]::UTF8.GetString($bytes)
        $AT = $DC.IndexOf('@')
        $MC = $DC.Insert($AT, 'echo ')
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($MC)
        
        [System.IO.File]::WriteAllBytes($OFP, $bytes)
        Start-Process "notepad.exe" -ArgumentList $OFP -Wait -WindowStyle Maximized
        return
    }
} else {
    [System.Windows.Forms.MessageBox]::Show("No input file selected idi...", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}
