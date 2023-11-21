Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$openFileDialogInput = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialogInput.Title = "Select Input File"
$openFileDialogInput.Filter = "All Files (*.*)|*.*"

$resultInput = $openFileDialogInput.ShowDialog()

if ($resultInput -eq [System.Windows.Forms.DialogResult]::OK) {
    $inputFilePath = $openFileDialogInput.FileName
    $saveFileDialogOutput = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialogOutput.Title = "Save Output File"
    $saveFileDialogOutput.Filter = "All Files (*.*)|*.*"
    $resultOutput = $saveFileDialogOutput.ShowDialog()
    if ($resultOutput -eq [System.Windows.Forms.DialogResult]::OK) {
        $outputFilePath = $saveFileDialogOutput.FileName
        $bytes = [System.IO.File]::ReadAllBytes($inputFilePath)
        $bytes = $bytes[8..($bytes.Length - 1)] # slices like i dont know how to explain first 8 bites gets ykyk..
        $deobfuscatedCode = [System.Text.Encoding]::UTF8.GetString($bytes)
        $atIndex = $deobfuscatedCode.IndexOf('@')
        $modifiedCode = $deobfuscatedCode.Insert($atIndex, 'echo ')
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($modifiedCode)
        
        [System.IO.File]::WriteAllBytes($outputFilePath, $bytes)
        Start-Process "notepad.exe" -ArgumentList $outputFilePath -Wait -WindowStyle Maximized
        return
    }
} else {
    [System.Windows.Forms.MessageBox]::Show("No input file selected idi...", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}
