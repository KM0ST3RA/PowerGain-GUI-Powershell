#requires -Version 5.1
<#
.SYNOPSIS Interface Windows PowerShell pour MP3Gain.
.DESCRIPTION MP3Gain effectue les analyses et modifie les fichiers MP3 sans réencodage.
.VERSION 0.6 - 2026-11
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()
$global:MP3GainGUI_State=@{Language='en'; About=@{
    fr="PowerGain-GUI`r`nInterface de réglage du gain des fichiers MP3.`r`n`r`nCréée avec l'aide ChatGPT par KM0ST3RA.`r`n`r`nVersion 0.6 - 2026-11"
    en="PowerGain-GUI`r`nMP3 file gain adjustment interface.`r`n`r`nCreated with ChatGPT by KM0ST3RA.`r`n`r`nVersion 0.6 - 2026-11"
}; Texts=@{
    fr=@{
        Title='PowerGain-GUI - contrôle du volume MP3'; File='Fichier MP3'; Volume='Volume (dB)'; TrackGain='Gain piste (dB)'; AlbumGain='Gain album (dB)'; Peak='Amplitude max.'; Mp3Steps='Gain MP3 (pas)'; Clipping='Écrêtage'; State='État'
        AddFiles='Ajouter des MP3...'; AddFolder='Ajouter un dossier...'; RemoveSelected='Retirer la sélection'; Clear='Tout effacer'; Target='Volume cible (dB) :'; PreventClipping='Éviter l''écrêtage'; AlbumByFolder='Un album par dossier'
        AnalyzeTrack='Analyse piste'; AnalyzeAlbum='Analyse album'; ApplyTrack='Gain piste'; ApplyAlbum='Gain album'; Undo='Annuler le gain'; Constant='Gain constant...'; MaxAmplitude='Amplitude max.'; CheckTags='Vérifier les tags'; ChannelGain='Gain canal...'; DeleteTags='Supprimer tags'; RecalculateTags='Recalculer tags'; Advanced='Options avancées...'; EngineHelp='Aide MP3Gain'; About='À propos'; AboutTitle='À propos de PowerGain-GUI'
        Log='Journal des opérations'; Ready='Prêt - les opérations de gain modifient les MP3 sans les réencoder.'; SelectMp3='Sélectionner mp3gain.exe'; Mp3Filter='MP3Gain (mp3gain.exe)|mp3gain.exe|Programmes (*.exe)|*.exe'
        AddFilesTitle='Ajouter des fichiers MP3'; FileFilter='Fichiers MP3 (*.mp3)|*.mp3'; ChooseFolder='Choisir un dossier contenant des fichiers MP3'; Language='Langue';
        AddFirst='Ajoutez au moins un fichier MP3.'; Confirm='Cette opération va modifier les MP3 listés. Continuer ?'; ConfirmTitle='Confirmer la modification'; ConstantPrompt='Gain à appliquer en dB (arrondi au pas MP3 le plus proche, environ 1,5 dB) :'; AdvancedTitle='Options MP3Gain'; PreserveTimestamp='Préserver la date du fichier (-p)'; QuietMode='Mode silencieux (-q)'; QuietNote='Le mode silencieux masque certains détails; le niveau de précision de la progression varie selon l''opération.'; AssumeMpeg2='Forcer MPEG 2 Layer III (-f)'; WrapGain='Autoriser le bouclage du gain (-w)'; WrapWarning='Attention : le bouclage peut produire de très grands changements de gain.'; ExtraDb='Correction dB après le volume cible (-d) :'; ExtraSteps='Correction supplémentaire en pas MP3 (-m) :'; TagFormat='Format des tags de gain'; ApeTag='APE (par défaut)'; Id3Tag='ID3v2'; TempModeInfo='Les gains utilisent des fichiers temporaires (-t) pour permettre l''annulation; prévoir de l''espace disque.'; Save='Enregistrer'; Apply='Appliquer'; ChannelLabel='Canal :'; LeftChannel='Gauche (0)'; RightChannel='Droite (1)'; ChannelDialogTitle='Gain d''un canal'; ChannelGainLabel='Gain à appliquer en dB (arrondi au pas MP3 le plus proche) :'; ChannelGainNote='Fonctionne avec les MP3 stéréo, pas le Joint Stereo. Le gain est direct et ne passe pas par l''analyse ni la prévention d''écrêtage.'; SettingsSaved='Options enregistrées.'; Pending='En attente'; InProgress='En cours'; Done='Terminé'; Cancel='Annuler'; Cancelling='Annulation en cours...'; Cancelled='Opération annulée.'; CancelledFile='Annulé'; RecoveredTemp='Fichier temporaire restauré'; TempLeft='Fichier temporaire conservé'; ProgressText='{0} — fichier {1}/{2} : {3} ({4} %)'; Waiting='Veuillez attendre la fin de l''opération avant de fermer.'; EngineDetected='MP3Gain détecté'; EngineNotFound='mp3gain.exe introuvable (dossier du script ou PATH).'; EngineReady='MP3Gain prêt — version {0}'; VersionUnknown='version inconnue'; Yes='Oui'; No='Non'; ErrorCode='Erreur (code {0})'; EngineMissing='mp3gain.exe introuvable.'; LanguageLabel='Langue';
        Executing='Exécution de MP3Gain :'; NoOutput='Aucun détail renvoyé par MP3Gain.'; Messages='Messages'; Complete='Opération terminée. Consultez le journal pour le détail.'; FailedCode='MP3Gain a renvoyé le code {0}. Consultez le journal.'; LaunchFailed='Échec du lancement de MP3Gain.'; Error='Erreur';
    }
    en=@{
        Title='PowerGain-GUI - MP3 volume control'; File='MP3 file'; Volume='Volume (dB)'; TrackGain='Track gain (dB)'; AlbumGain='Album gain (dB)'; Peak='Max amplitude'; Mp3Steps='MP3 gain (steps)'; Clipping='Clipping'; State='Status'
        AddFiles='Add MP3 files...'; AddFolder='Add folder...'; RemoveSelected='Remove selected'; Clear='Clear all'; Target='Target volume (dB):'; PreventClipping='Prevent clipping'; AlbumByFolder='One album per folder'
        AnalyzeTrack='Track analysis'; AnalyzeAlbum='Album analysis'; ApplyTrack='Track gain'; ApplyAlbum='Album gain'; Undo='Undo gain'; Constant='Constant gain...'; MaxAmplitude='Max amplitude'; CheckTags='Check tags'; ChannelGain='Channel gain...'; DeleteTags='Delete tags'; RecalculateTags='Recalculate tags'; Advanced='Advanced options...'; EngineHelp='MP3Gain help'; About='About'; AboutTitle='About PowerGain-GUI'
        Log='Operation log'; Ready='Ready - gain changes adjust MP3 files without re-encoding.'; SelectMp3='Select mp3gain.exe'; Mp3Filter='MP3Gain (mp3gain.exe)|mp3gain.exe|Programs (*.exe)|*.exe'
        AddFilesTitle='Add MP3 files'; FileFilter='MP3 files (*.mp3)|*.mp3'; ChooseFolder='Choose a folder containing MP3 files'; Language='Language';
        AddFirst='Add at least one MP3 file.'; Confirm='This operation will modify the listed MP3 files. Continue?'; ConfirmTitle='Confirm changes'; ConstantPrompt='Gain to apply in dB (rounded to the nearest MP3 step, about 1.5 dB):'; AdvancedTitle='MP3Gain options'; PreserveTimestamp='Preserve file timestamp (-p)'; QuietMode='Quiet mode (-q)'; QuietNote='Quiet mode hides some details; progress detail varies by operation.'; AssumeMpeg2='Assume MPEG 2 Layer III (-f)'; WrapGain='Allow gain wrapping (-w)'; WrapWarning='Warning: wrapping can produce very large gain changes.'; ExtraDb='dB adjustment after target volume (-d):'; ExtraSteps='Additional MP3 step adjustment (-m):'; TagFormat='Gain tag format'; ApeTag='APE (default)'; Id3Tag='ID3v2'; TempModeInfo='Gain changes use temporary files (-t) to support cancellation; allow enough disk space.'; Save='Save'; Apply='Apply'; ChannelLabel='Channel:'; LeftChannel='Left (0)'; RightChannel='Right (1)'; ChannelDialogTitle='Channel gain'; ChannelGainLabel='Gain to apply in dB (rounded to the nearest MP3 step):'; ChannelGainNote='Works with stereo MP3, not Joint Stereo. This direct gain bypasses analysis and clipping prevention.'; SettingsSaved='Options saved.'; Pending='Pending'; InProgress='In progress'; Done='Done'; Cancel='Cancel'; Cancelling='Cancelling...'; Cancelled='Operation cancelled.'; CancelledFile='Cancelled'; RecoveredTemp='Recovered temporary file'; TempLeft='Temporary file kept'; ProgressText='{0} — file {1}/{2}: {3} ({4}%)'; Waiting='Wait for the operation to finish before closing.'; EngineDetected='MP3Gain detected'; EngineNotFound='mp3gain.exe not found (script folder or PATH).'; EngineReady='MP3Gain ready — version {0}'; VersionUnknown='version unknown'; Yes='Yes'; No='No'; ErrorCode='Error (code {0})'; EngineMissing='mp3gain.exe was not found.'; LanguageLabel='Language';
        Executing='Running MP3Gain:'; NoOutput='MP3Gain returned no details.'; Messages='Messages'; Complete='Operation complete. See the log for details.'; FailedCode='MP3Gain returned exit code {0}. See the log.'; LaunchFailed='Could not start MP3Gain.'; Error='Error';
    }
}}
function T([string]$Key) {
    $state=$global:MP3GainGUI_State
    if($null -eq $state -or $null -eq $state.Texts){return $Key}
    return $state.Texts[$state.Language][$Key]
}
$script:mp3GainPath=$null
$script:mp3GainVersion=''
$script:mp3GainVersionLabel=''
$script:gainOptions=@{ PreserveTimestamp=$false; QuietMode=$false; AssumeMpeg2=$false; WrapGain=$false; ExtraDb=0.0; ExtraSteps=0; TagFormat='i' }
function Format-Invariant([double]$Number) { return $Number.ToString([Globalization.CultureInfo]::InvariantCulture) }
function Convert-DecibelsToSteps([double]$Decibels) {
    $steps=$Decibels/(5.0*[math]::Log10(2.0))
    return [int][math]::Round($steps,0,[MidpointRounding]::AwayFromZero)
}
function Get-TargetDbAdjustment { return ([double]$target.Value - 89.0 + [double]$script:gainOptions.ExtraDb) }
function Get-Mp3GainPreferenceArgs([switch]$IncludeTagFormat) {
    $a=@()
    if($script:gainOptions.PreserveTimestamp){$a+='-p'}
    if($script:gainOptions.QuietMode){$a+='-q'}
    if($script:gainOptions.AssumeMpeg2){$a+='-f'}
    if($script:gainOptions.WrapGain){$a+='-w'}
    if($IncludeTagFormat) { $a+=@('-s',[string]$script:gainOptions.TagFormat) }
    return $a
}
function Get-Mp3GainSuggestionArgs {
    $a=@('-d',(Format-Invariant (Get-TargetDbAdjustment)))
    if([int]$script:gainOptions.ExtraSteps -ne 0){$a+=@('-m',[string][int]$script:gainOptions.ExtraSteps)}
    return $a
}

function Quote-Argument([string]$Value) {
    if ($Value -notmatch '[\s"]') { return $Value }
    return '"' + ($Value -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
}
function Find-Mp3GainPath {
    $candidates=@()
    if($PSScriptRoot){$candidates += (Join-Path $PSScriptRoot 'mp3gain.exe')}
    $cmd=Get-Command mp3gain.exe -ErrorAction SilentlyContinue
    if($cmd -and $cmd.Source){$candidates += $cmd.Source}
    foreach($candidate in $candidates) {
        if(Test-Path -LiteralPath $candidate -PathType Leaf) {
            try{return (Resolve-Path -LiteralPath $candidate).Path}catch{return $candidate}
        }
    }
    return $null
}
function Get-Mp3GainPath {
    if($script:mp3GainPath -and (Test-Path -LiteralPath $script:mp3GainPath -PathType Leaf)){return $script:mp3GainPath}
    $found=Find-Mp3GainPath
    if($found){$script:mp3GainPath=$found; Write-Mp3GainEngineInfo $found; return $found}
    $pick = New-Object System.Windows.Forms.OpenFileDialog
    $pick.Title = T 'SelectMp3'
    $pick.Filter = T 'Mp3Filter'
    if ($pick.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:mp3GainPath=$pick.FileName
        Write-Mp3GainEngineInfo $pick.FileName
        return $pick.FileName
    }
    return $null
}

$form = New-Object System.Windows.Forms.Form
$form.Text = T 'Title'
$form.StartPosition = 'CenterScreen'; $form.Size = New-Object Drawing.Size(1200,820); $form.MinimumSize = $form.Size; $form.FormBorderStyle='Sizable'; $form.MaximizeBox=$true; $form.MinimizeBox=$true
$form.Font = New-Object Drawing.Font('Segoe UI',9)
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object Drawing.Point(12,12); $grid.Size = New-Object Drawing.Size(($form.ClientSize.Width - 24),370); $grid.Anchor = 'Top,Left,Right'
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
$grid.Columns['File'].Width=280; $grid.Columns['File'].MinimumWidth=210
$grid.Columns['Volume'].Width=105; $grid.Columns['TrackGain'].Width=120; $grid.Columns['AlbumGain'].Width=120; $grid.Columns['Peak'].Width=115; $grid.Columns['Mp3Steps'].Width=115; $grid.Columns['Clipping'].Width=90; $grid.Columns['Status'].Width=120
$grid.Columns['Status'].MinimumWidth=105
foreach($column in $grid.Columns){$column.FillWeight=$column.Width}
$grid.AutoSizeColumnsMode='Fill'
$form.Controls.Add($grid)
$script:buttons = @()
$script:actionButtons=@{}
$script:actionDefinitions=@()
$script:controls=@{}
function Add-Button([string]$Text,[int]$X,[int]$Y,[int]$W,[scriptblock]$Action) {
    $b = New-Object System.Windows.Forms.Button; $b.Text=$Text; $b.Location=New-Object Drawing.Point($X,$Y); $b.Size=New-Object Drawing.Size($W,32); $b.Anchor='Top,Left'
    $b.Add_Click($Action); $form.Controls.Add($b); $script:buttons += $b; return $b
}
[void](Add-Button (T 'AddFiles') 12 395 150 { Add-Files })
[void](Add-Button (T 'AddFolder') 168 395 160 { Add-Folder })
[void](Add-Button (T 'RemoveSelected') 334 395 160 { Remove-Selected })
[void](Add-Button (T 'Clear') 500 395 110 { $grid.Rows.Clear() })
$targetLabel=New-Object System.Windows.Forms.Label; $targetLabel.Text=(T 'Target'); $targetLabel.Location=New-Object Drawing.Point(630,402); $targetLabel.AutoSize=$true; $form.Controls.Add($targetLabel); $script:controls.TargetLabel=$targetLabel
$target=New-Object System.Windows.Forms.NumericUpDown; $target.Location=New-Object Drawing.Point(740,398); $target.Size=New-Object Drawing.Size(75,25); $target.DecimalPlaces=1; $target.Minimum=75; $target.Maximum=95; $target.Increment=0.5; $target.Value=89; $form.Controls.Add($target)
$noClip=New-Object System.Windows.Forms.CheckBox; $noClip.Text=(T 'PreventClipping'); $noClip.Checked=$true; $noClip.AutoSize=$true; $noClip.Location=New-Object Drawing.Point(835,401); $form.Controls.Add($noClip); $script:controls.NoClip=$noClip
$albumByFolder=New-Object System.Windows.Forms.CheckBox; $albumByFolder.Text=(T 'AlbumByFolder'); $albumByFolder.Checked=$true; $albumByFolder.AutoSize=$true; $albumByFolder.Location=New-Object Drawing.Point(850,440); $form.Controls.Add($albumByFolder); $script:controls.AlbumByFolder=$albumByFolder
#$languageLabel=New-Object System.Windows.Forms.Label; $languageLabel.Text=T 'LanguageLabel'; $languageLabel.Location=New-Object Drawing.Point(939,342); $languageLabel.AutoSize=$true; $form.Controls.Add($languageLabel)
$language=New-Object System.Windows.Forms.ComboBox; $language.DropDownStyle='DropDownList'; $language.Items.AddRange(@('Français','English')); if($global:MP3GainGUI_State.Language -eq 'en'){$language.SelectedIndex=1}else{$language.SelectedIndex=0}; $language.Location=New-Object Drawing.Point(($form.ClientSize.Width - 174),400); $language.Size=New-Object Drawing.Size(95,25); $language.Anchor='Top,Right'; $form.Controls.Add($language)
$script:helpButton=Add-Button '?' ($form.ClientSize.Width - 44) 398 26 { Show-About }; $script:helpButton.Anchor='Top,Right'; $script:helpButton.Location=New-Object Drawing.Point(($form.ClientSize.Width - 44),398); $script:helpButton.Size=New-Object Drawing.Size(26,27)
$actions = @(
    @{Key='AnalyzeTrack'; Args={ @('-o','-e','-s','s') + @(Get-Mp3GainPreferenceArgs) + @(Get-Mp3GainSuggestionArgs) }; X=12; Y=440; W=130},
    @{Key='AnalyzeAlbum'; Args={ @('-o','-s','s') + @(Get-Mp3GainPreferenceArgs) + @(Get-Mp3GainSuggestionArgs) }; X=148; Y=440; W=130},
    @{Key='ApplyTrack'; Args={ $a=@('-r','-t') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) + @(Get-Mp3GainSuggestionArgs); if($noClip.Checked){$a+='-k'}else{$a+='-c'}; $a }; X=298; Y=440; W=125},
    @{Key='ApplyAlbum'; Args={ $a=@('-a','-t') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) + @(Get-Mp3GainSuggestionArgs); if($noClip.Checked){$a+='-k'}else{$a+='-c'}; $a }; X=431; Y=440; W=125},
    @{Key='Undo'; Args={ @('-o','-u','-t') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) }; X=564; Y=440; W=120},
    @{Key='Constant'; Args={ $v=[Microsoft.VisualBasic.Interaction]::InputBox((T 'ConstantPrompt'),(T 'Constant'),'0'); $n=0.0; if([double]::TryParse($v,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::CurrentCulture,[ref]$n)){ @('-t') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) + @('-g',[string](Convert-DecibelsToSteps $n)) }else{@()} }; X=692; Y=440; W=145},
    @{Key='MaxAmplitude'; Args={ @('-o','-x','-s','s') + @(Get-Mp3GainPreferenceArgs) }; X=12; Y=476; W=130},
    @{Key='CheckTags'; Args={ @('-o','-s','c') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) }; X=148; Y=476; W=150},
    @{Key='ChannelGain'; Args={ Get-ChannelGainArgs }; X=308; Y=476; W=145},
    @{Key='DeleteTags'; Args={ @('-o','-s','d','-t') + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat) }; X=463; Y=476; W=130},
    @{Key='RecalculateTags'; Args={ $a=@('-o','-s','r','-t') + @(Get-Mp3GainPreferenceArgs); if($script:gainOptions.TagFormat -eq 'i'){$a+=@('-s','i')}; $a+=@(Get-Mp3GainSuggestionArgs); $a }; X=601; Y=476; W=170},
    @{Key='Advanced'; Args={ @() }; X=779; Y=476; W=170},
    @{Key='EngineHelp'; Args={ @('-?') }; X=957; Y=476; W=170}
)
$script:actionDefinitions=$actions
$actionClick={
    param($sender,$eventArgs)
    if($global:PowerGainGUI_ActiveOperation){Request-Mp3GainCancel; return}
    $definition=$sender.Tag
    if($definition.Key -eq 'Advanced'){Show-AdvancedOptions; return}
    $argsForGain=& $definition.Args
    if($argsForGain.Count -gt 0){Invoke-Mp3Gain $argsForGain $definition.Key $sender}
}
foreach($item in $actions){
    $actionButton=Add-Button (T $item.Key) $item.X $item.Y $item.W $actionClick
    $actionButton.Tag=$item
    $script:actionButtons[$item.Key]=$actionButton
}
$outLabel=New-Object System.Windows.Forms.Label; $outLabel.Text=(T 'Log'); $outLabel.Location=New-Object Drawing.Point(12,516); $outLabel.AutoSize=$true; $form.Controls.Add($outLabel); $script:controls.LogLabel=$outLabel
$log=New-Object System.Windows.Forms.TextBox; $log.Location=New-Object Drawing.Point(12,536); $log.Size=New-Object Drawing.Size(($form.ClientSize.Width - 24),204); $log.Anchor='Top,Bottom,Left,Right'; $log.Multiline=$true; $log.ReadOnly=$true; $log.WordWrap=$true; $log.ScrollBars='Vertical'; $log.Font=New-Object Drawing.Font('Consolas',9); $form.Controls.Add($log)
$progressBar=New-Object System.Windows.Forms.ProgressBar; $progressBar.Location=New-Object Drawing.Point(12,760); $progressBar.Size=New-Object Drawing.Size(300,18); $progressBar.Anchor='Bottom,Left'; $progressBar.Minimum=0; $progressBar.Maximum=1; $progressBar.Value=0; $form.Controls.Add($progressBar)
$status=New-Object System.Windows.Forms.Label; $status.Location=New-Object Drawing.Point(322,760); $status.Size=New-Object Drawing.Size(($form.ClientSize.Width - 334),20); $status.Anchor='Bottom,Left,Right'; $status.Text=(T 'Ready'); $form.Controls.Add($status)

function Update-WindowTitle {
    $baseTitle=T 'Title'
    if($script:mp3GainVersionLabel){$form.Text="$baseTitle ($($script:mp3GainVersionLabel))"}
    else {$form.Text=$baseTitle}
}
function Get-Mp3GainVersion([string]$Path) {
    $output=''
    $process=New-Object Diagnostics.Process
    $psi=New-Object Diagnostics.ProcessStartInfo
    $psi.FileName=$Path; $psi.Arguments='-v'; $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
    $process.StartInfo=$psi
    try {
        if($process.Start()) {
            $stdoutTask=$process.StandardOutput.ReadToEndAsync(); $stderrTask=$process.StandardError.ReadToEndAsync()
            if($process.WaitForExit(2500)) { $output=$stdoutTask.Result+"`r`n"+$stderrTask.Result }
            else { try {$process.Kill(); [void]$process.WaitForExit(1000)}catch{} }
        }
    } catch {} finally { $process.Dispose() }
    if($output -match '(?i)\bversion\s*v?([0-9]+(?:\.[0-9]+){1,3}(?:[-+][A-Za-z0-9._-]+)?)') { return $Matches[1] }
    if($output -match '(?i)\bv([0-9]+(?:\.[0-9]+){1,3}(?:[-+][A-Za-z0-9._-]+)?)\b') { return $Matches[1] }
    try {
        $info=[Diagnostics.FileVersionInfo]::GetVersionInfo($Path)
        if($info.FileVersion){return $info.FileVersion.Trim()}
        if($info.ProductVersion){return $info.ProductVersion.Trim()}
    } catch {}
    return $null
}
function Write-Mp3GainEngineInfo([string]$Path) {
    if(-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        $script:mp3GainPath=$null; $script:mp3GainVersion=''; $script:mp3GainVersionLabel=''
        Update-WindowTitle
        $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $(T 'EngineNotFound')`r`n")
        $status.Text=T 'EngineNotFound'
        return
    }
    $script:mp3GainPath=$Path
    $script:mp3GainVersion=Get-Mp3GainVersion $Path
    if(-not $script:mp3GainVersion){$script:mp3GainVersion=T 'VersionUnknown'}
    $script:mp3GainVersionLabel="MP3Gain $($script:mp3GainVersion)"
    Update-WindowTitle
    $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $(T 'EngineDetected'): $Path ($($script:mp3GainVersion))`r`n")
    $status.Text=(T 'EngineReady') -f $script:mp3GainVersion
}
function Set-Language([string]$Code) {
    $global:MP3GainGUI_State.Language=$Code
    Update-WindowTitle
    foreach($key in @('File','Volume','TrackGain','AlbumGain','Peak','Mp3Steps','Clipping')) { $grid.Columns[$key].HeaderText=T $key }
    $grid.Columns['Status'].HeaderText=T 'State'
    $script:buttons[0].Text=T 'AddFiles'; $script:buttons[1].Text=T 'AddFolder'; $script:buttons[2].Text=T 'RemoveSelected'; $script:buttons[3].Text=T 'Clear'
    $script:controls.TargetLabel.Text=T 'Target'; $script:controls.NoClip.Text=T 'PreventClipping'; $script:controls.AlbumByFolder.Text=T 'AlbumByFolder'; $script:controls.LogLabel.Text=T 'Log'; if($script:mp3GainPath){$status.Text=(T 'EngineReady') -f $script:mp3GainVersion}else{$status.Text=T 'EngineNotFound'}
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
function Show-AdvancedOptions {
    $dialog=New-Object System.Windows.Forms.Form
    $dialog.Text=T 'AdvancedTitle'; $dialog.StartPosition='CenterParent'; $dialog.FormBorderStyle='FixedDialog'; $dialog.MaximizeBox=$false; $dialog.MinimizeBox=$false; $dialog.ShowInTaskbar=$false; $dialog.ClientSize=New-Object Drawing.Size(520,420); $dialog.Font=$form.Font

    $preserve=New-Object System.Windows.Forms.CheckBox; $preserve.Text=T 'PreserveTimestamp'; $preserve.Checked=$script:gainOptions.PreserveTimestamp; $preserve.Location=New-Object Drawing.Point(16,14); $preserve.AutoSize=$true; $dialog.Controls.Add($preserve)
    $quiet=New-Object System.Windows.Forms.CheckBox; $quiet.Text=T 'QuietMode'; $quiet.Checked=$script:gainOptions.QuietMode; $quiet.Location=New-Object Drawing.Point(16,42); $quiet.AutoSize=$true; $dialog.Controls.Add($quiet)
    $quietNote=New-Object System.Windows.Forms.Label; $quietNote.Text=T 'QuietNote'; $quietNote.Location=New-Object Drawing.Point(36,67); $quietNote.Size=New-Object Drawing.Size(466,32); $dialog.Controls.Add($quietNote)
    $mpeg=New-Object System.Windows.Forms.CheckBox; $mpeg.Text=T 'AssumeMpeg2'; $mpeg.Checked=$script:gainOptions.AssumeMpeg2; $mpeg.Location=New-Object Drawing.Point(16,104); $mpeg.AutoSize=$true; $dialog.Controls.Add($mpeg)
    $wrap=New-Object System.Windows.Forms.CheckBox; $wrap.Text=T 'WrapGain'; $wrap.Checked=$script:gainOptions.WrapGain; $wrap.Location=New-Object Drawing.Point(16,132); $wrap.AutoSize=$true; $dialog.Controls.Add($wrap)
    $wrapNote=New-Object System.Windows.Forms.Label; $wrapNote.Text=T 'WrapWarning'; $wrapNote.ForeColor=[Drawing.Color]::DarkRed; $wrapNote.Location=New-Object Drawing.Point(36,157); $wrapNote.Size=New-Object Drawing.Size(466,36); $dialog.Controls.Add($wrapNote)

    $dbLabel=New-Object System.Windows.Forms.Label; $dbLabel.Text=T 'ExtraDb'; $dbLabel.Location=New-Object Drawing.Point(16,204); $dbLabel.Size=New-Object Drawing.Size(310,24); $dialog.Controls.Add($dbLabel)
    $db=New-Object System.Windows.Forms.NumericUpDown; $db.Location=New-Object Drawing.Point(354,201); $db.Size=New-Object Drawing.Size(145,24); $db.DecimalPlaces=1; $db.Increment=0.1; $db.Minimum=-30; $db.Maximum=30; $db.Value=[decimal]$script:gainOptions.ExtraDb; $dialog.Controls.Add($db)
    $stepsLabel=New-Object System.Windows.Forms.Label; $stepsLabel.Text=T 'ExtraSteps'; $stepsLabel.Location=New-Object Drawing.Point(16,240); $stepsLabel.Size=New-Object Drawing.Size(310,24); $dialog.Controls.Add($stepsLabel)
    $steps=New-Object System.Windows.Forms.NumericUpDown; $steps.Location=New-Object Drawing.Point(354,237); $steps.Size=New-Object Drawing.Size(145,24); $steps.Minimum=-50; $steps.Maximum=50; $steps.Value=[decimal]$script:gainOptions.ExtraSteps; $dialog.Controls.Add($steps)
    $tagLabel=New-Object System.Windows.Forms.Label; $tagLabel.Text=T 'TagFormat'; $tagLabel.Location=New-Object Drawing.Point(16,276); $tagLabel.Size=New-Object Drawing.Size(310,24); $dialog.Controls.Add($tagLabel)
    $tagFormat=New-Object System.Windows.Forms.ComboBox; $tagFormat.DropDownStyle='DropDownList'; [void]$tagFormat.Items.Add((T 'ApeTag')); [void]$tagFormat.Items.Add((T 'Id3Tag')); $tagFormat.SelectedIndex=if($script:gainOptions.TagFormat -eq 'i'){1}else{0}; $tagFormat.Location=New-Object Drawing.Point(354,273); $tagFormat.Size=New-Object Drawing.Size(145,24); $dialog.Controls.Add($tagFormat)
    $tempInfo=New-Object System.Windows.Forms.Label; $tempInfo.Text=T 'TempModeInfo'; $tempInfo.Location=New-Object Drawing.Point(16,310); $tempInfo.Size=New-Object Drawing.Size(486,40); $dialog.Controls.Add($tempInfo)

    $save=New-Object System.Windows.Forms.Button; $save.Text=T 'Save'; $save.Location=New-Object Drawing.Point(322,368); $save.Size=New-Object Drawing.Size(86,30); $save.DialogResult=[System.Windows.Forms.DialogResult]::OK; $dialog.Controls.Add($save)
    $cancel=New-Object System.Windows.Forms.Button; $cancel.Text=T 'Cancel'; $cancel.Location=New-Object Drawing.Point(414,368); $cancel.Size=New-Object Drawing.Size(86,30); $cancel.DialogResult=[System.Windows.Forms.DialogResult]::Cancel; $dialog.Controls.Add($cancel); $dialog.AcceptButton=$save; $dialog.CancelButton=$cancel
    if($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:gainOptions=@{ PreserveTimestamp=$preserve.Checked; QuietMode=$quiet.Checked; AssumeMpeg2=$mpeg.Checked; WrapGain=$wrap.Checked; ExtraDb=[double]$db.Value; ExtraSteps=[int]$steps.Value; TagFormat=$(if($tagFormat.SelectedIndex -eq 1){'i'}else{'a'}) }
        $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $(T 'SettingsSaved')`r`n")
    }
    $dialog.Dispose()
}
function Get-ChannelGainArgs {
    $dialog=New-Object System.Windows.Forms.Form
    $dialog.Text=T 'ChannelDialogTitle'; $dialog.StartPosition='CenterParent'; $dialog.FormBorderStyle='FixedDialog'; $dialog.MaximizeBox=$false; $dialog.MinimizeBox=$false; $dialog.ShowInTaskbar=$false; $dialog.ClientSize=New-Object Drawing.Size(480,220); $dialog.Font=$form.Font
    $channelLabel=New-Object System.Windows.Forms.Label; $channelLabel.Text=T 'ChannelLabel'; $channelLabel.Location=New-Object Drawing.Point(16,18); $channelLabel.AutoSize=$true; $dialog.Controls.Add($channelLabel)
    $channel=New-Object System.Windows.Forms.ComboBox; $channel.DropDownStyle='DropDownList'; [void]$channel.Items.Add((T 'LeftChannel')); [void]$channel.Items.Add((T 'RightChannel')); $channel.SelectedIndex=0; $channel.Location=New-Object Drawing.Point(170,14); $channel.Size=New-Object Drawing.Size(270,25); $dialog.Controls.Add($channel)
    $gainLabel=New-Object System.Windows.Forms.Label; $gainLabel.Text=T 'ChannelGainLabel'; $gainLabel.Location=New-Object Drawing.Point(16,55); $gainLabel.Size=New-Object Drawing.Size(420,24); $dialog.Controls.Add($gainLabel)
    $gain=New-Object System.Windows.Forms.NumericUpDown; $gain.Location=New-Object Drawing.Point(170,82); $gain.Size=New-Object Drawing.Size(110,25); $gain.DecimalPlaces=1; $gain.Increment=0.5; $gain.Minimum=-30; $gain.Maximum=30; $gain.Value=0; $dialog.Controls.Add($gain)
    $note=New-Object System.Windows.Forms.Label; $note.Text=T 'ChannelGainNote'; $note.Location=New-Object Drawing.Point(16,116); $note.Size=New-Object Drawing.Size(445,48); $dialog.Controls.Add($note)
    $save=New-Object System.Windows.Forms.Button; $save.Text=T 'Apply'; $save.Location=New-Object Drawing.Point(276,174); $save.Size=New-Object Drawing.Size(80,30); $save.DialogResult=[System.Windows.Forms.DialogResult]::OK; $dialog.Controls.Add($save)
    $cancel=New-Object System.Windows.Forms.Button; $cancel.Text=T 'Cancel'; $cancel.Location=New-Object Drawing.Point(364,174); $cancel.Size=New-Object Drawing.Size(80,30); $cancel.DialogResult=[System.Windows.Forms.DialogResult]::Cancel; $dialog.Controls.Add($cancel); $dialog.AcceptButton=$save; $dialog.CancelButton=$cancel
    $result=@()
    if($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $channelIndex=[string]$channel.SelectedIndex
        $gainSteps=[string](Convert-DecibelsToSteps ([double]$gain.Value))
        $result=@('-t','-l',$channelIndex,$gainSteps) + @(Get-Mp3GainPreferenceArgs -IncludeTagFormat)
    }
    $dialog.Dispose()
    return $result
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
function Parse-Mp3GainOutput([string]$Output,[string[]]$Files,[string]$OperationName) {
    foreach($line in ($Output -split '[\r\n]+')) {
        $fields=$line -split "`t"
        if($fields.Count -lt 6 -or $fields[0] -eq 'File'){ continue }
        $name=$fields[0].Trim('"')
        $step=0.0; $gain=0.0; $peak=0.0
        $validStep=[double]::TryParse($fields[1],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$step)
        $validGain=[double]::TryParse($fields[2],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$gain)
        $validPeak=[double]::TryParse($fields[3],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$peak)
        if($OperationName -eq 'MaxAmplitude') {
            if($name -ne 'Album' -and $validPeak -and $name -in $Files) { Set-GridValue $name 'Peak' ('{0:N0}' -f $peak) }
            continue
        }
        if($name -eq 'Album') {
            foreach($path in $Files) {
                Set-GridValue $path 'AlbumGain' ('{0:N2}' -f $gain)
                if($validPeak){Set-GridValue $path 'Peak' ('{0:N0}' -f $peak)}
            }
        } elseif($validGain -and $name -in $Files) {
            $volume=[double]$target.Value - $gain
            $clip=T 'No'
            if($validPeak -and ($peak * [math]::Pow(2.0,$step/4.0)) -gt 32767.0) { $clip=T 'Yes' }
            Set-GridValue $name 'Volume' ('{0:N2}' -f $volume)
            Set-GridValue $name 'TrackGain' ('{0:N2}' -f $gain)
            if($validPeak){Set-GridValue $name 'Peak' ('{0:N0}' -f $peak)}
            if($validStep){Set-GridValue $name 'Mp3Steps' ('{0:N0}' -f $step)}
            Set-GridValue $name 'Clipping' $clip
            if($fields.Count -ge 8) {
                $albumGain=0.0
                if([double]::TryParse($fields[7],[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$albumGain)) {
                    Set-GridValue $name 'AlbumGain' ('{0:N2}' -f $albumGain)
                }
            }
        }
    }
}
function Find-OperationFile([hashtable]$Operation,[string]$Path) {
    $clean=$Path.Trim().Trim('"')
    foreach($file in $Operation.Files) {
        if([string]::Equals($file,$clean,[StringComparison]::OrdinalIgnoreCase)){return $file}
        try { if([string]::Equals([IO.Path]::GetFullPath($file),[IO.Path]::GetFullPath($clean),[StringComparison]::OrdinalIgnoreCase)){return $file} } catch {}
    }
    return $null
}
function Update-ProgressDisplay([hashtable]$Operation) {
    $done=$Operation.CompletedFiles.Count
    $progressValue=$done*100
    if($Operation.CurrentFile){$progressValue+=$Operation.CurrentPercent}
    $progressBar.Value=[math]::Min($progressValue,$progressBar.Maximum - 1)
    $current=$Operation.CurrentFile
    if(-not $current) {
        foreach($candidate in $Operation.BatchFiles) {
            if(-not $Operation.CompletedFiles.Contains($candidate)) { $current=$candidate; break }
        }
    }
    if($current) {
        $index=[array]::IndexOf([string[]]$Operation.Files,[string]$current)+1
        $status.Text=(T 'ProgressText') -f $Operation.Label,$index,$Operation.Files.Count,$current,$Operation.CurrentPercent
    } else {
        $status.Text="$(T 'Executing') $($Operation.Label) — $done/$($Operation.Files.Count)"
    }
}
function Complete-OperationFile([hashtable]$Operation,[string]$Path) {
    $file=Find-OperationFile $Operation $Path
    if(-not $file){return}
    if($Operation.CompletedFiles.Add($file)) { Set-GridValue $file 'Status' (T 'Done') }
    if([string]::Equals($Operation.CurrentFile,$file,[StringComparison]::OrdinalIgnoreCase)) { $Operation.CurrentFile=$null }
    Update-ProgressDisplay $Operation
}
function Start-OperationFile([hashtable]$Operation,[string]$Path) {
    $file=Find-OperationFile $Operation $Path
    if(-not $file -or $Operation.CompletedFiles.Contains($file)){return}
    if($Operation.CurrentFile -and -not $Operation.CompletedFiles.Contains($Operation.CurrentFile)) {
        Complete-OperationFile $Operation $Operation.CurrentFile
    }
    $Operation.CurrentFile=$file
    $Operation.CurrentPercent=0
    Set-GridValue $file 'Status' (T 'InProgress')
    Update-ProgressDisplay $Operation
}
function Start-NextOperationFile([hashtable]$Operation) {
    foreach($file in $Operation.BatchFiles) {
        if(-not $Operation.CompletedFiles.Contains($file)) { Start-OperationFile $Operation $file; return }
    }
}
function Handle-Mp3GainOutputLine([hashtable]$Operation,[string]$Line,[bool]$IsError) {
    $line=$Line.Trim()
    if(-not $line){return}
    if($line -match '(?i)Applying gain change of (-?\d+) to CHANNEL [01] of (.+?)(?:\.\.\.)?$') {
        $file=Find-OperationFile $Operation $Matches[2]
        if($file) { Set-GridValue $file 'Mp3Steps' $Matches[1]; Start-OperationFile $Operation $file }
        return
    }
    if($line -match '(?i)Applying (?:(?:auto-clipped )?mp3 )?gain change of (-?\d+) to (.+?)(?:\.\.\.)?$') {
        $file=Find-OperationFile $Operation $Matches[2]
        if($file) { Set-GridValue $file 'Mp3Steps' $Matches[1]; Start-OperationFile $Operation $file }
        return
    }
    if($line -match '(?i)Undoing mp3gain changes .* to (.+?)(?:\.\.\.)?$') { Start-OperationFile $Operation $Matches[1]; return }
    if($line -match '(?i)No changes to (.+?) are necessary') { Complete-OperationFile $Operation $Matches[1]; Start-NextOperationFile $Operation; return }
    if($line -match '(?i)Writing tag information for (.+)$') { Start-OperationFile $Operation $Matches[1]; return }
    if($IsError -and $line -match '^\[(\d+)\s*/\s*\d+\]\s*(\d{1,3})% of .* analyzed') {
        $index=[int]$Matches[1]-1; $percent=[math]::Min(100,[int]$Matches[2])
        if($index -ge 0 -and $index -lt $Operation.BatchFiles.Count) { Start-OperationFile $Operation $Operation.BatchFiles[$index] }
        $Operation.CurrentPercent=$percent; Update-ProgressDisplay $Operation; return
    }
    if($IsError -and $Operation.BatchFiles.Count -eq 1 -and $line -match '^(\d{1,3})% of .* analyzed') {
        $Operation.CurrentPercent=[math]::Min(100,[int]$Matches[1]); Update-ProgressDisplay $Operation; return
    }
    if($IsError -and $line -match "(?i)Can't open (.+?) for reading") {
        $file=Find-OperationFile $Operation $Matches[1]
        if($file) { Set-GridValue $file 'Status' (T 'Error'); [void]$Operation.CompletedFiles.Add($file); Update-ProgressDisplay $Operation }
        return
    }
    if(-not $IsError) {
        $fields=$line -split "`t"
        if($Operation.OperationName -eq 'Undo' -and $fields.Count -ge 3) {
            $file=Find-OperationFile $Operation $fields[0]
            if($file) { Complete-OperationFile $Operation $file; Start-NextOperationFile $Operation }
            return
        }
        if($fields.Count -ge 6 -and $fields[0] -ne 'File') {
            $file=Find-OperationFile $Operation $fields[0]
            if($file) { Complete-OperationFile $Operation $file; Start-NextOperationFile $Operation }
        } else {
            $file=Find-OperationFile $Operation $line
            if($file -and $Operation.CurrentFile -ne $file) { Start-OperationFile $Operation $file }
        }
    }
}
function New-ProcessReadState($Reader) {
    $buffer=[char[]]::new(8192)
    return @{ Reader=$Reader; Buffer=$buffer; Task=$Reader.ReadAsync($buffer,0,$buffer.Length); Pending=''; Closed=$false; Text=New-Object System.Text.StringBuilder }
}
function Read-Mp3GainStream([hashtable]$Stream,[hashtable]$Operation,[bool]$IsError) {
    if($Stream.Closed){return}
    for($iteration=0;$iteration -lt 16;$iteration++) {
        $task=$Stream.Task
        if(-not $task.IsCompleted){break}
        $count=$task.GetAwaiter().GetResult()
        if($count -le 0) {
            $Stream.Closed=$true
            if($Stream.Pending) { Handle-Mp3GainOutputLine $Operation $Stream.Pending $IsError; $Stream.Pending='' }
            break
        }
        $chunk=[string]::new($Stream.Buffer,0,$count)
        [void]$Stream.Text.Append($chunk)
        $combined=$Stream.Pending+$chunk
        $parts=[regex]::Split($combined,"`r`n|`r|`n")
        $endsWithBreak=$combined.EndsWith("`r") -or $combined.EndsWith("`n")
        if($endsWithBreak) { $lineCount=$parts.Length; $Stream.Pending='' }
        else { $lineCount=$parts.Length-1; $Stream.Pending=$parts[$parts.Length-1] }
        for($i=0;$i -lt $lineCount;$i++) { Handle-Mp3GainOutputLine $Operation $parts[$i] $IsError }
        $Stream.Task=$Stream.Reader.ReadAsync($Stream.Buffer,0,$Stream.Buffer.Length)
    }
}
function Get-Mp3GainTempPath([string]$Path) {
    if([IO.Path]::GetExtension($Path) -ieq '.TMP') { return "$Path.TMP" }
    return [IO.Path]::ChangeExtension($Path,'.TMP')
}
function Repair-Mp3GainTemporaryFile([hashtable]$Operation) {
    if($Operation.OperationName -notin @('ApplyTrack','ApplyAlbum','Undo','Constant','ChannelGain','DeleteTags','RecalculateTags') -or -not $Operation.CancelFile){return}
    $original=$Operation.CancelFile; $temporary=Get-Mp3GainTempPath $original
    $originalName=[IO.Path]::GetFileName($original); $temporaryName=[IO.Path]::GetFileName($temporary)
    if(-not (Test-Path -LiteralPath $temporary)){return}
    try {
        if(Test-Path -LiteralPath $original) {
            Remove-Item -LiteralPath $temporary -Force -ErrorAction Stop
        } else {
            Move-Item -LiteralPath $temporary -Destination $original -ErrorAction Stop
            $log.AppendText("$(T 'RecoveredTemp'): $originalName`r`n")
        }
    } catch {
        $log.AppendText("$(T 'TempLeft'): $temporaryName — $($_.Exception.Message)`r`n")
    }
}
function Request-Mp3GainCancel {
    $operation=$global:PowerGainGUI_ActiveOperation
    if(-not $operation -or $operation.CancelRequested){return}
    $operation.CancelRequested=$true; $operation.CancelFile=$operation.CurrentFile
    $operation.ActionButton.Text=T 'Cancelling'; $operation.ActionButton.Enabled=$false
    $status.Text=T 'Cancelling'
    $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $(T 'Cancelling') $($operation.Label)`r`n")
    try {
        if(-not $operation.Process.HasExited){$operation.Process.Kill()}
    } catch {
        if($operation.Process.HasExited){return}
        $operation.CancelRequested=$false; $operation.CancelFile=$null
        $operation.ActionButton.Text=T 'Cancel'; $operation.ActionButton.Enabled=$true
        $status.Text="$(T 'Error'): $($_.Exception.Message)"
        $log.AppendText("$(T 'Error'): $($_.Exception.Message)`r`n")
    }
}
function Set-UiBusy([bool]$Busy) {
    foreach($button in $script:buttons) { $button.Enabled=-not $Busy }
    $grid.Enabled=-not $Busy; $target.Enabled=-not $Busy; $noClip.Enabled=-not $Busy; $albumByFolder.Enabled=-not $Busy; $language.Enabled=-not $Busy
    $form.UseWaitCursor=$Busy
    if($Busy -and $global:PowerGainGUI_ActiveOperation) {
        $global:PowerGainGUI_ActiveOperation.ActionButton.Text=T 'Cancel'
        $global:PowerGainGUI_ActiveOperation.ActionButton.Enabled=$true
    } elseif(-not $Busy) {
        foreach($key in $script:actionButtons.Keys) { $script:actionButtons[$key].Text=T $key }
    }
}
function Complete-Mp3GainSequence([hashtable]$Operation) {
    $progressBar.Value=$progressBar.Maximum
    if($Operation.HadErrors) { $status.Text=(T 'FailedCode') -f $Operation.FirstErrorCode }
    else { $status.Text=T 'Complete' }
    $script:processTimer.Stop(); $global:PowerGainGUI_ActiveOperation=$null
    Set-UiBusy $false
}
function Start-Mp3GainBatch([hashtable]$Operation) {
    while(($Operation.BatchIndex + 1) -lt $Operation.Groups.Count) {
        $Operation.BatchIndex++
        $Operation.CurrentGroup=$Operation.Groups[$Operation.BatchIndex]
        $Operation.BatchFiles=[string[]]$Operation.CurrentGroup.Files
        $Operation.CurrentFile=$null; $Operation.CurrentPercent=0
        $process=$null
        try {
            $psi=New-Object Diagnostics.ProcessStartInfo; $psi.FileName=$Operation.Executable
            $commandArgs=@($Operation.ArgsForGain)+@($Operation.BatchFiles)
            $psi.Arguments=(($commandArgs | ForEach-Object { Quote-Argument ([string]$_) }) -join ' ')
            $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
            $process=New-Object Diagnostics.Process; $process.StartInfo=$psi
            if(-not $process.Start()){throw 'MP3Gain did not start.'}
            $Operation.Process=$process
            $Operation.Stdout=New-ProcessReadState $process.StandardOutput
            $Operation.Stderr=New-ProcessReadState $process.StandardError
            foreach($file in $Operation.BatchFiles) {
                if(-not $Operation.CompletedFiles.Contains($file)) { Set-GridValue $file 'Status' (T 'Pending') }
            }
            $firstFile=$null
            foreach($file in $Operation.BatchFiles) {
                if(-not $Operation.CompletedFiles.Contains($file)) { $firstFile=$file; break }
            }
            if($firstFile) { Start-OperationFile $Operation $firstFile }
            else { $status.Text="$(T 'Executing') $($Operation.Label)" }
            $script:processTimer.Start()
            return
        } catch {
            $Operation.HadErrors=$true
            if($null -eq $Operation.FirstErrorCode) { $Operation.FirstErrorCode=1 }
            $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $(T 'Error'): $($_.Exception.Message)`r`n")
            foreach($file in $Operation.BatchFiles) {
                if(-not $Operation.CompletedFiles.Contains($file)) {
                    Set-GridValue $file 'Status' ((T 'ErrorCode') -f 1)
                    [void]$Operation.CompletedFiles.Add($file)
                }
            }
            if($process) {
                try { if(-not $process.HasExited){$process.Kill()} } catch {}
                try { $process.Dispose() } catch {}
            }
            $Operation.Process=$null
        }
    }
    Complete-Mp3GainSequence $Operation
}
function Finish-Mp3GainOperation([int]$ExitCode) {
    $operation=$global:PowerGainGUI_ActiveOperation
    if(-not $operation){return}
    if($operation.CancelRequested){Repair-Mp3GainTemporaryFile $operation}
    $stdout=$operation.Stdout.Text.ToString(); $stderr=$operation.Stderr.Text.ToString()
    Parse-Mp3GainOutput $stdout $operation.BatchFiles $operation.OperationName
    if($operation.CancelRequested) {
        foreach($file in $operation.Files) {
            if($operation.CompletedFiles.Contains($file)){continue}
            if([string]::Equals($file,$operation.CancelFile,[StringComparison]::OrdinalIgnoreCase)) { Set-GridValue $file 'Status' (T 'CancelledFile') }
            else { Set-GridValue $file 'Status' (T 'Pending') }
        }
        $progressBar.Value=[math]::Min(($operation.CompletedFiles.Count*100)+$operation.CurrentPercent,$progressBar.Maximum - 1)
        $status.Text=T 'Cancelled'
    } elseif($ExitCode -eq 0) {
        foreach($file in $operation.BatchFiles) { Complete-OperationFile $operation $file }
    } else {
        $operation.HadErrors=$true
        if($null -eq $operation.FirstErrorCode) { $operation.FirstErrorCode=$ExitCode }
        foreach($file in $operation.BatchFiles) {
            if(-not $operation.CompletedFiles.Contains($file)) {
                Set-GridValue $file 'Status' ((T 'ErrorCode') -f $ExitCode)
                [void]$operation.CompletedFiles.Add($file)
            }
        }
    }
    $text=$stdout
    $stderrLines=@($stderr -split "`r`n|`r|`n" | Where-Object {
        $trimmed=$_.Trim()
        $trimmed -and $trimmed -notmatch '^(?:\[\d+\s*/\s*\d+\]\s*)?\d{1,3}%\s+of\s+[\d,]+\s+bytes\s+(?:analyzed|written)$'
    })
    $stderrForLog=$stderrLines -join "`r`n"
    if($stderrForLog){$text += "`r`n[$(T 'Messages')]`r`n$stderrForLog"}
    if(-not $text){$text=T 'NoOutput'}
    foreach($file in ($operation.BatchFiles | Sort-Object { $_.Length } -Descending)) {
        $shortName=[IO.Path]::GetFileName($file)
        if($file -and $shortName){$text=$text.Replace([string]$file,[string]$shortName)}
    }
    $displayText=$text -replace "`r`n|`r|`n",[Environment]::NewLine
    $displayText=$displayText -replace "`t",' | '
    $batchLabel=$operation.Label
    if($operation.Groups.Count -gt 1) {
        $groupName=[IO.Path]::GetFileName($operation.CurrentGroup.Name)
        if(-not $groupName) { $groupName=$operation.CurrentGroup.Name }
        $batchLabel+=" [$($operation.BatchIndex+1)/$($operation.Groups.Count) — $groupName]"
    }
    $resultLabel=if($operation.CancelRequested){T 'Cancelled'}else{"code $ExitCode"}
    $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $batchLabel — $resultLabel`r`n$displayText`r`n`r`n")
    try { $operation.Stdout.Reader.Dispose() } catch {}
    try { $operation.Stderr.Reader.Dispose() } catch {}
    try { $operation.Process.Dispose() } catch {}
    if($operation.CancelRequested) {
        $script:processTimer.Stop(); $global:PowerGainGUI_ActiveOperation=$null
        Set-UiBusy $false
        return
    }
    Start-Mp3GainBatch $operation
}
function Update-Mp3GainOperation {
    $operation=$global:PowerGainGUI_ActiveOperation
    if(-not $operation){return}
    try {
        if($operation.CancelRequested) {
            if($operation.Process.HasExited) { Finish-Mp3GainOperation $operation.Process.ExitCode }
            return
        }
        Read-Mp3GainStream $operation.Stdout $operation $false
        Read-Mp3GainStream $operation.Stderr $operation $true
        if($operation.Process.HasExited -and $operation.Stdout.Closed -and $operation.Stderr.Closed) {
            [void]$operation.Process.WaitForExit()
            Finish-Mp3GainOperation $operation.Process.ExitCode
        }
    } catch {
        if($operation.CancelRequested -and $operation.Process.HasExited) { Finish-Mp3GainOperation $operation.Process.ExitCode; return }
        $log.AppendText("$(T 'Error'): $($_.Exception.Message)`r`n")
        $status.Text=T 'LaunchFailed'
        try { if(-not $operation.Process.HasExited){$operation.Process.Kill()} } catch {}
        try { Finish-Mp3GainOperation 1 } catch { $global:PowerGainGUI_ActiveOperation=$null; $script:processTimer.Stop(); Set-UiBusy $false }
    }
}
function Invoke-Mp3Gain([string[]]$ArgsForGain,[string]$OperationName,[System.Windows.Forms.Button]$ActionButton) {
    if($OperationName -ne 'EngineHelp' -and $grid.Rows.Count -eq 0){[System.Windows.Forms.MessageBox]::Show((T 'AddFirst'),(T 'Title')) | Out-Null; return}
    $exe=Get-Mp3GainPath; if(-not $exe){$status.Text=T 'EngineMissing'; return}
    $files=@()
    if($OperationName -ne 'EngineHelp') {
        $albumOperation=$OperationName -in @('AnalyzeAlbum','ApplyAlbum')
        if($albumOperation -and $albumByFolder.Checked -and $grid.SelectedRows.Count -gt 0) {
            $selectedFolderKeys=@{}
            foreach($r in $grid.SelectedRows) {
                $selectedPath=[string]$r.Cells['File'].Value
                try { $selectedFolder=[IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($selectedPath)) }
                catch { $selectedFolder=[IO.Path]::GetDirectoryName($selectedPath) }
                if($selectedFolder) { $selectedFolderKeys[$selectedFolder.ToUpperInvariant()]=$true }
            }
            foreach($r in $grid.Rows) {
                $path=[string]$r.Cells['File'].Value
                try { $folder=[IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($path)) }
                catch { $folder=[IO.Path]::GetDirectoryName($path) }
                if($folder -and $selectedFolderKeys.ContainsKey($folder.ToUpperInvariant())) { $files += $path }
            }
        } elseif($grid.SelectedRows.Count -gt 0) {
            foreach($r in $grid.SelectedRows){$files += [string]$r.Cells['File'].Value}
        } else {
            foreach($r in $grid.Rows){$files += [string]$r.Cells['File'].Value}
        }
    }
    $operationLabel=T $OperationName
    if($OperationName -notin @('EngineHelp','AnalyzeTrack','AnalyzeAlbum','MaxAmplitude','CheckTags') -and [System.Windows.Forms.MessageBox]::Show("$(T 'Confirm')`r`n`r`n$operationLabel",(T 'ConfirmTitle'),[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question) -ne [System.Windows.Forms.DialogResult]::Yes){return}
    $groups=New-Object 'System.Collections.Generic.List[object]'
    if($OperationName -in @('AnalyzeAlbum','ApplyAlbum') -and $albumByFolder.Checked) {
        $folderMap=@{}; $folderOrder=New-Object 'System.Collections.Generic.List[string]'
        foreach($file in $files) {
            try { $folder=[IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($file)) }
            catch { $folder=[IO.Path]::GetDirectoryName($file) }
            if(-not $folder) { $folder='' }
            $folderKey=$folder.ToUpperInvariant()
            if(-not $folderMap.ContainsKey($folderKey)) {
                $folderMap[$folderKey]=New-Object 'System.Collections.Generic.List[string]'
                $folderOrder.Add($folder)
            }
            $folderMap[$folderKey].Add($file)
        }
        foreach($folder in $folderOrder) {
            $folderKey=$folder.ToUpperInvariant()
            $groups.Add(@{Name=$folder; Files=[string[]]$folderMap[$folderKey].ToArray()})
        }
    } else {
        $groups.Add(@{Name=''; Files=[string[]]$files})
    }
    $global:PowerGainGUI_ActiveOperation=@{
        Process=$null; Executable=$exe; ArgsForGain=[string[]]$ArgsForGain; Files=[string[]]$files; Groups=[object[]]$groups.ToArray(); BatchIndex=-1; BatchFiles=[string[]]@(); CurrentGroup=$null
        Label=$operationLabel; OperationName=$OperationName; ActionButton=$ActionButton; CancelRequested=$false; CancelFile=$null
        CompletedFiles=[System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase); CurrentFile=$null; CurrentPercent=0
        Stdout=$null; Stderr=$null; HadErrors=$false; FirstErrorCode=$null
    }
    $progressBar.Minimum=0; $progressBar.Maximum=[math]::Max(1,($files.Count*100)+100); $progressBar.Value=0
    foreach($file in $files){Set-GridValue $file 'Status' (T 'Pending')}
    Set-UiBusy $true
    Start-Mp3GainBatch $global:PowerGainGUI_ActiveOperation
}
$global:PowerGainGUI_ActiveOperation=$null
$script:processTimer=New-Object System.Windows.Forms.Timer; $script:processTimer.Interval=50
$script:processTimer.Add_Tick({ Update-Mp3GainOperation })
$form.Add_FormClosing({ param($sender,$e) if($global:PowerGainGUI_ActiveOperation){$e.Cancel=$true; $status.Text=T 'Waiting'} })
$startupMp3GainPath=Find-Mp3GainPath
Write-Mp3GainEngineInfo $startupMp3GainPath
[void]$form.ShowDialog()
Remove-Variable -Name PowerGainGUI_ActiveOperation -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name MP3GainGUI_State -Scope Global -ErrorAction SilentlyContinue
