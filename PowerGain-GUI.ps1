#requires -Version 5.1
<#
.SYNOPSIS Interface Windows PowerShell pour MP3Gain.
.DESCRIPTION MP3Gain effectue les analyses et modifie les fichiers MP3 sans réencodage.
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()
$global:MP3GainGUI_State=@{Language='en'; About=@{
    fr="PowerGain-GUI`r`nInterface de réglage du gain des fichiers MP3.`r`n`r`nCréée avec l'aide ChatGPT par KM0ST3RA.`r`n`r`nVersion 0.2 - 2026-11"
    en="PowerGain-GUI`r`nMP3 file gain adjustment interface.`r`n`r`nCreated with ChatGPT by KM0ST3RA.`r`n`r`nVersion 0.2 - 2026-11"
}; Texts=@{
    fr=@{
        Title='PowerGain-GUI - contrôle du volume MP3'; File='Fichier MP3'; Volume='Volume (dB)'; TrackGain='Gain piste (dB)'; AlbumGain='Gain album (dB)'; Peak='Amplitude max.'; Mp3Steps='Gain MP3 (pas)'; Clipping='Écrêtage'; State='État'
        AddFiles='Ajouter des MP3...'; AddFolder='Ajouter un dossier...'; RemoveSelected='Retirer la sélection'; Clear='Tout effacer'; Target='Volume cible (dB) :'; PreventClipping='Éviter l''écrêtage'
        AnalyzeTrack='Analyse piste'; AnalyzeAlbum='Analyse album'; ApplyTrack='Gain piste'; ApplyAlbum='Gain album'; Undo='Annuler le gain'; Constant='Gain constant...'; MaxAmplitude='Amplitude max.'; CheckTags='Vérifier les tags'; About='À propos'; AboutTitle='À propos de PowerGain-GUI'
        Log='Journal des opérations'; Ready='Prêt - les opérations de gain modifient les MP3 sans les réencoder.'; SelectMp3='Sélectionner mp3gain.exe'; Mp3Filter='MP3Gain (mp3gain.exe)|mp3gain.exe|Programmes (*.exe)|*.exe'
        AddFilesTitle='Ajouter des fichiers MP3'; FileFilter='Fichiers MP3 (*.mp3)|*.mp3'; ChooseFolder='Choisir un dossier contenant des fichiers MP3'; Language='Langue';
        AddFirst='Ajoutez au moins un fichier MP3.'; Confirm='Cette opération va modifier les MP3 listés. Continuer ?'; ConfirmTitle='Confirmer la modification'; ConstantPrompt='Gain à appliquer en dB (ex. -3 ou 1,5) :'; Pending='En attente'; Yes='Oui'; No='Non'; ErrorCode='Erreur (code {0})'; EngineMissing='mp3gain.exe introuvable.'; LanguageLabel='Langue';
        Executing='Exécution de MP3Gain :'; NoOutput='Aucun détail renvoyé par MP3Gain.'; Messages='Messages'; Complete='Opération terminée. Consultez le journal pour le détail.'; FailedCode='MP3Gain a renvoyé le code {0}. Consultez le journal.'; LaunchFailed='Échec du lancement de MP3Gain.'; Error='Erreur';
    }
    en=@{
        Title='PowerGain-GUI - MP3 volume control'; File='MP3 file'; Volume='Volume (dB)'; TrackGain='Track gain (dB)'; AlbumGain='Album gain (dB)'; Peak='Max amplitude'; Mp3Steps='MP3 gain (steps)'; Clipping='Clipping'; State='Status'
        AddFiles='Add MP3 files...'; AddFolder='Add folder...'; RemoveSelected='Remove selected'; Clear='Clear all'; Target='Target volume (dB):'; PreventClipping='Prevent clipping'
        AnalyzeTrack='Track analysis'; AnalyzeAlbum='Album analysis'; ApplyTrack='Track gain'; ApplyAlbum='Album gain'; Undo='Undo gain'; Constant='Constant gain...'; MaxAmplitude='Max amplitude'; CheckTags='Check tags'; About='About'; AboutTitle='About PowerGain-GUI'
        Log='Operation log'; Ready='Ready - gain changes adjust MP3 files without re-encoding.'; SelectMp3='Select mp3gain.exe'; Mp3Filter='MP3Gain (mp3gain.exe)|mp3gain.exe|Programs (*.exe)|*.exe'
        AddFilesTitle='Add MP3 files'; FileFilter='MP3 files (*.mp3)|*.mp3'; ChooseFolder='Choose a folder containing MP3 files'; Language='Language';
        AddFirst='Add at least one MP3 file.'; Confirm='This operation will modify the listed MP3 files. Continue?'; ConfirmTitle='Confirm changes'; ConstantPrompt='Gain to apply in dB (e.g. -3 or 1.5):'; Pending='Pending'; Yes='Yes'; No='No'; ErrorCode='Error (code {0})'; EngineMissing='mp3gain.exe was not found.'; LanguageLabel='Language';
        Executing='Running MP3Gain:'; NoOutput='MP3Gain returned no details.'; Messages='Messages'; Complete='Operation complete. See the log for details.'; FailedCode='MP3Gain returned exit code {0}. See the log.'; LaunchFailed='Could not start MP3Gain.'; Error='Error';
    }
}}
function T([string]$Key) {
    $state=$global:MP3GainGUI_State
    if($null -eq $state -or $null -eq $state.Texts){return $Key}
    return $state.Texts[$state.Language][$Key]
}
function Format-Invariant([double]$Number) { return $Number.ToString([Globalization.CultureInfo]::InvariantCulture) }

function Quote-Argument([string]$Value) {
    if ($Value -notmatch '[\s"]') { return $Value }
    return '"' + ($Value -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
}
function Get-Mp3GainPath {
    $candidates = @((Join-Path $PSScriptRoot 'mp3gain.exe'))
    $cmd = Get-Command mp3gain.exe -ErrorAction SilentlyContinue
    if ($cmd) { $candidates += $cmd.Source }
    foreach ($candidate in $candidates) { if (Test-Path -LiteralPath $candidate) { return $candidate } }
    $pick = New-Object System.Windows.Forms.OpenFileDialog
    $pick.Title = T 'SelectMp3'
    $pick.Filter = T 'Mp3Filter'
    if ($pick.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { return $pick.FileName }
    return $null
}

$form = New-Object System.Windows.Forms.Form
$form.Text = T 'Title'
$form.StartPosition = 'CenterScreen'; $form.Size = New-Object Drawing.Size(1080,720); $form.MinimumSize = $form.Size; $form.MaximumSize = $form.Size; $form.FormBorderStyle='FixedSingle'; $form.MaximizeBox=$false; $form.MinimizeBox=$true
$form.Font = New-Object Drawing.Font('Segoe UI',9)
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object Drawing.Point(12,12); $grid.Size = New-Object Drawing.Size(1040,330); $grid.Anchor = 'Top,Left,Right'
$grid.AllowUserToAddRows = $false; $grid.AllowUserToDeleteRows = $false; $grid.ReadOnly = $true; $grid.MultiSelect = $true
$grid.SelectionMode = 'FullRowSelect'; $grid.AutoSizeColumnsMode = 'None'; $grid.AllowUserToResizeColumns=$true; $grid.RowHeadersVisible = $false
[void]$grid.Columns.Add('File',(T 'File'))
[void]$grid.Columns.Add('Volume',(T 'Volume'))
[void]$grid.Columns.Add('TrackGain',(T 'TrackGain'))
[void]$grid.Columns.Add('AlbumGain',(T 'AlbumGain'))
[void]$grid.Columns.Add('Peak',(T 'Peak'))
[void]$grid.Columns.Add('Mp3Steps',(T 'Mp3Steps'))
[void]$grid.Columns.Add('Clipping',(T 'Clipping'))
[void]$grid.Columns.Add('Status',(T 'State'))
$grid.Columns['File'].Width=230; $grid.Columns['File'].MinimumWidth=180
$grid.Columns['Volume'].Width=105; $grid.Columns['TrackGain'].Width=125; $grid.Columns['AlbumGain'].Width=125; $grid.Columns['Peak'].Width=115; $grid.Columns['Mp3Steps'].Width=115; $grid.Columns['Clipping'].Width=90; $grid.Columns['Status'].Width=125
$form.Controls.Add($grid)
$script:buttons = @()
$script:actionButtons=@{}
$script:actionDefinitions=@()
$script:controls=@{}
function Add-Button([string]$Text,[int]$X,[int]$Y,[int]$W,[scriptblock]$Action) {
    $b = New-Object System.Windows.Forms.Button; $b.Text=$Text; $b.Location=New-Object Drawing.Point($X,$Y); $b.Size=New-Object Drawing.Size($W,32); $b.Anchor='Top,Left'
    $b.Add_Click($Action); $form.Controls.Add($b); $script:buttons += $b; return $b
}
[void](Add-Button (T 'AddFiles') 12 355 140 { Add-Files })
[void](Add-Button (T 'AddFolder') 158 355 150 { Add-Folder })
[void](Add-Button (T 'RemoveSelected') 314 355 145 { Remove-Selected })
[void](Add-Button (T 'Clear') 465 355 100 { $grid.Rows.Clear() })
$targetLabel=New-Object System.Windows.Forms.Label; $targetLabel.Text=(T 'Target'); $targetLabel.Location=New-Object Drawing.Point(590,362); $targetLabel.AutoSize=$true; $form.Controls.Add($targetLabel); $script:controls.TargetLabel=$targetLabel
$target=New-Object System.Windows.Forms.NumericUpDown; $target.Location=New-Object Drawing.Point(704,358); $target.Size=New-Object Drawing.Size(75,25); $target.DecimalPlaces=1; $target.Minimum=75; $target.Maximum=95; $target.Increment=0.5; $target.Value=89; $form.Controls.Add($target)
$noClip=New-Object System.Windows.Forms.CheckBox; $noClip.Text=(T 'PreventClipping'); $noClip.Checked=$true; $noClip.AutoSize=$true; $noClip.Location=New-Object Drawing.Point(796,361); $form.Controls.Add($noClip); $script:controls.NoClip=$noClip
#$languageLabel=New-Object System.Windows.Forms.Label; $languageLabel.Text=T 'LanguageLabel'; $languageLabel.Location=New-Object Drawing.Point(939,342); $languageLabel.AutoSize=$true; $form.Controls.Add($languageLabel)
$language=New-Object System.Windows.Forms.ComboBox; $language.DropDownStyle='DropDownList'; $language.Items.AddRange(@('Français','English')); if($global:MP3GainGUI_State.Language -eq 'en'){$language.SelectedIndex=1}else{$language.SelectedIndex=0}; $language.Location=New-Object Drawing.Point(915,360); $language.Size=New-Object Drawing.Size(84,25); $language.Anchor='Top,Right'; $form.Controls.Add($language)
$script:helpButton=Add-Button '?' 1026 358 26 { Show-About }; $script:helpButton.Anchor='Top,Right'; $script:helpButton.Location=New-Object Drawing.Point(1015,358); $script:helpButton.Size=New-Object Drawing.Size(26,27)
$actions = @(
    @{Key='AnalyzeTrack'; Args={ @('-o','-s','s','-d',(Format-Invariant ([double]$target.Value - 89))) }; X=12; W=130},
    @{Key='AnalyzeAlbum'; Args={ @('-o','-s','s','-d',(Format-Invariant ([double]$target.Value - 89))) }; X=148; W=130},
    @{Key='ApplyTrack'; Args={ $a=@('-r','-d',(Format-Invariant ([double]$target.Value - 89))); if($noClip.Checked){$a+='-k'}else{$a+='-c'}; $a }; X=284; W=120},
    @{Key='ApplyAlbum'; Args={ $a=@('-a','-d',(Format-Invariant ([double]$target.Value - 89))); if($noClip.Checked){$a+='-k'}else{$a+='-c'}; $a }; X=410; W=120},
    @{Key='Undo'; Args={ @('-u') }; X=536; W=125},
    @{Key='Constant'; Args={ $v=[Microsoft.VisualBasic.Interaction]::InputBox((T 'ConstantPrompt'),(T 'Constant'),'0'); $n=0.0; if([double]::TryParse($v,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::CurrentCulture,[ref]$n)){@('-g',(Format-Invariant $n))}else{@()} }; X=667; W=135},
    @{Key='MaxAmplitude'; Args={ @('-x') }; X=808; W=125},
    @{Key='CheckTags'; Args={ @('-s','c') }; X=939; W=113}
)
$script:actionDefinitions=$actions
foreach($item in $actions){
    $def=$item
    $click={ $a=& $def.Args; if($a.Count -gt 0){Invoke-Mp3Gain $a $def.Key} }.GetNewClosure()
    $script:actionButtons[$def.Key]=Add-Button (T $def.Key) $def.X 400 $def.W $click
}
$outLabel=New-Object System.Windows.Forms.Label; $outLabel.Text=(T 'Log'); $outLabel.Location=New-Object Drawing.Point(12,430); $outLabel.AutoSize=$true; $form.Controls.Add($outLabel); $script:controls.LogLabel=$outLabel
$log=New-Object System.Windows.Forms.TextBox; $log.Location=New-Object Drawing.Point(12,450); $log.Size=New-Object Drawing.Size(1040,200); $log.Anchor='Top,Bottom,Left,Right'; $log.Multiline=$true; $log.ReadOnly=$true; $log.WordWrap=$true; $log.ScrollBars='Vertical'; $log.Font=New-Object Drawing.Font('Consolas',9); $form.Controls.Add($log)
$status=New-Object System.Windows.Forms.Label; $status.Location=New-Object Drawing.Point(12,660); $status.Size=New-Object Drawing.Size(1040,22); $status.Anchor='Bottom,Left,Right'; $status.Text=(T 'Ready'); $form.Controls.Add($status)

function Set-Language([string]$Code) {
    $global:MP3GainGUI_State.Language=$Code
    $form.Text=T 'Title'
    foreach($key in @('File','Volume','TrackGain','AlbumGain','Peak','Mp3Steps','Clipping','Status')) { $grid.Columns[$key].HeaderText=T $key }
    $script:buttons[0].Text=T 'AddFiles'; $script:buttons[1].Text=T 'AddFolder'; $script:buttons[2].Text=T 'RemoveSelected'; $script:buttons[3].Text=T 'Clear'
    $script:controls.TargetLabel.Text=T 'Target'; $script:controls.NoClip.Text=T 'PreventClipping'; $script:controls.LogLabel.Text=T 'Log'; $status.Text=T 'Ready'
    foreach($key in $script:actionButtons.Keys) { $script:actionButtons[$key].Text=T $key }
}
$language.Add_SelectedIndexChanged({ if($language.SelectedIndex -eq 1){Set-Language 'en'}else{Set-Language 'fr'} })

function Add-Files {
    $d=New-Object System.Windows.Forms.OpenFileDialog; $d.Title=T 'AddFilesTitle'; $d.Filter=T 'FileFilter'; $d.Multiselect=$true
    if($d.ShowDialog() -eq 'OK'){ foreach($f in $d.FileNames){ Add-File $f } }
}
function Show-About {
    $body=$global:MP3GainGUI_State.About[$global:MP3GainGUI_State.Language]
    [System.Windows.Forms.MessageBox]::Show($body,(T 'AboutTitle'),[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
}
function Add-Folder {
    $d=New-Object System.Windows.Forms.FolderBrowserDialog; $d.Description=T 'ChooseFolder'; $d.ShowNewFolderButton=$false
    if($d.ShowDialog() -eq 'OK'){ Get-ChildItem -LiteralPath $d.SelectedPath -Filter '*.mp3' -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Add-File $_.FullName } }
}
function Add-File([string]$Path) {
    for($i=0;$i -lt $grid.Rows.Count;$i++){ if([string]::Equals($grid.Rows[$i].Cells[0].Value,$Path,[StringComparison]::OrdinalIgnoreCase)){return} }
    [void]$grid.Rows.Add($Path,'','','','','','',(T 'Pending'))
}
function Remove-Selected { foreach($r in @($grid.SelectedRows)){ if(-not $r.IsNewRow){$grid.Rows.Remove($r)} } }
function Set-GridValue([string]$Path,[string]$Column,[object]$Value) {
    for($i=0;$i -lt $grid.Rows.Count;$i++){
        if([string]::Equals([string]$grid.Rows[$i].Cells['File'].Value,$Path,[StringComparison]::OrdinalIgnoreCase)){
            $grid.Rows[$i].Cells[$Column].Value=$Value
            return
        }
    }
}
function Parse-Mp3GainOutput([string]$Output,[string[]]$Files,[string]$Operation,[int]$ExitCode) {
    foreach($line in ($Output -split "`r?`n")) {
        $fields=$line -split "`t"
        if($fields.Count -ge 6) {
            $name=$fields[0].Trim('"')
            $step=0.0; $gain=0.0; $peak=0.0
            $validStep=[double]::TryParse($fields[1],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$step)
            $validGain=[double]::TryParse($fields[2],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$gain)
            $validPeak=[double]::TryParse($fields[3],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$peak)
            if($name -eq 'Album') {
                foreach($path in $Files) { Set-GridValue $path 'AlbumGain' ('{0:N2}' -f $gain) }
            } elseif($validGain -and $name -in $Files) {
                $volume=[double]$target.Value - $gain
                $clip=T 'No'
                if($validPeak -and ($peak * [math]::Pow(2.0,$step/4.0)) -gt 32767.0) { $clip=T 'Yes' }
                Set-GridValue $name 'Volume' ('{0:N2}' -f $volume)
                Set-GridValue $name 'TrackGain' ('{0:N2}' -f $gain)
                if($validPeak){Set-GridValue $name 'Peak' ('{0:N0}' -f $peak)}
                if($validStep){Set-GridValue $name 'Mp3Steps' ('{0:N0}' -f $step)}
                Set-GridValue $name 'Clipping' $clip
            }
        }
    }
    foreach($line in ($Output -split "`r?`n")) {
        if($line -match 'Applying (?:auto-clipped )?mp3 gain change of (-?\d+) to (.+?)(?:\.\.\.)?$') {
            $steps=$Matches[1]; $path=$Matches[2].Trim()
            foreach($file in $Files){if([string]::Equals($file,$path,[StringComparison]::OrdinalIgnoreCase)){Set-GridValue $file 'Mp3Steps' $steps; Set-GridValue $file 'Status' $Operation}}
        } elseif($line -match 'Applying (?:auto-clipped )?mp3 gain change of (-?\d+) to album') {
            foreach($file in $Files){Set-GridValue $file 'Mp3Steps' $Matches[1]; Set-GridValue $file 'Status' $Operation}
        }
    }
    if($ExitCode -ne 0){foreach($file in $Files){Set-GridValue $file 'Status' ((T 'ErrorCode') -f $ExitCode)}}
    else {foreach($file in $Files){Set-GridValue $file 'Status' $Operation}}
}
function Invoke-Mp3Gain([string[]]$ArgsForGain,[string]$OperationName) {
    if($grid.Rows.Count -eq 0){[System.Windows.Forms.MessageBox]::Show((T 'AddFirst'),(T 'Title')) | Out-Null; return}
    $exe=Get-Mp3GainPath; if(-not $exe){$status.Text=T 'EngineMissing'; return}
    # Les opérations par piste suivent la sélection; les opérations album
    # regroupent toujours tous les fichiers chargés.
    $files=@()
    if($OperationName -in @('AnalyzeTrack','ApplyTrack') -and $grid.SelectedRows.Count -gt 0) {
        foreach($r in $grid.SelectedRows){$files += [string]$r.Cells['File'].Value}
    } else {
        foreach($r in $grid.Rows){$files += [string]$r.Cells['File'].Value}
    }
    $operation=($ArgsForGain -join ' '); $operationLabel=T $OperationName
    if($ArgsForGain[0] -notin @('-o','-x','-s') -and [System.Windows.Forms.MessageBox]::Show("$(T 'Confirm')`r`n`r`n$operationLabel",(T 'ConfirmTitle'),[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question) -ne [System.Windows.Forms.DialogResult]::Yes){return}
    $psi=New-Object Diagnostics.ProcessStartInfo; $psi.FileName=$exe; $all=@($ArgsForGain)+$files; $psi.Arguments=(($all | ForEach-Object { Quote-Argument ([string]$_) }) -join ' '); $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
    $p=New-Object Diagnostics.Process; $p.StartInfo=$psi
    try {
        $status.Text="$(T 'Executing') $operationLabel"; $form.UseWaitCursor=$true; foreach($b in $script:buttons){$b.Enabled=$false}; $form.Refresh()
        [void]$p.Start(); $stdoutTask=$p.StandardOutput.ReadToEndAsync(); $stderrTask=$p.StandardError.ReadToEndAsync(); $p.WaitForExit()
        $stdout=$stdoutTask.Result; $stderr=$stderrTask.Result; $text=$stdout; if($stderr){$text += "`r`n[$(T 'Messages')]`r`n$stderr"}; if(-not $text){$text=T 'NoOutput'}
        $displayText=$text -replace "`r`n|`r|`n",[Environment]::NewLine
        $displayText=$displayText -replace "`t",' | '
        $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $operationLabel — code $($p.ExitCode)`r`n$displayText`r`n`r`n")
        Parse-Mp3GainOutput $stdout $files $OperationName $p.ExitCode
        $status.Text=if($p.ExitCode -eq 0){T 'Complete'}else{(T 'FailedCode') -f $p.ExitCode}
    } catch { $log.AppendText("$(T 'Error'): $($_.Exception.Message)`r`n"); $status.Text=T 'LaunchFailed' }
    finally { $form.UseWaitCursor=$false; foreach($b in $script:buttons){$b.Enabled=$true}; $p.Dispose() }
}
[void]$form.ShowDialog()
Remove-Variable -Name MP3GainGUI_State -Scope Global -ErrorAction SilentlyContinue
