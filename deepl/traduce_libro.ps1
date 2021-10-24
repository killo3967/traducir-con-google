clear-host

$Host.PrivateData.VerboseForegroundColor = 'Cyan'

<#
# Preparo el Glosaario
$diccionario = ConvertFrom-Csv @'
Español,Ingles
Peep,Repo
steadholder,gobernador
RMN,ARM
PRH,RPH
'@
#>

$diccionario

# Fichero a traducir
$fichero = "H:\SCRIPTS\traducir libros\deepl\Ashes Of Victory - Weber, David.txt"
$fichero_salida = "H:\SCRIPTS\traducir libros\deepl\Cenizas de Victoria (deepl).txt"

#Cargo el fichero en el array.
$array_fichero = @(get-content $fichero -Encoding UTF8)

$tamaño_array=$array_fichero.Length

$uri = "https://api-free.deepl.com/v2/translate?auth_key="
$api_key = "99d72d75-177e-28fa-a8fd-77a74cbb6d0c"
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.15063; en-US) PowerShell/6.0.0" 
$Target_Lang="ES"
$Source_Lang="EN"
$ContentType = "application/x-www-form-urlencoded;charset=utf-8"  
$Method = "POST"

for ( $i=1 ; $i -lt $tamaño_array ; $i++ ) {
    
$texto_orig = $array_fichero[$i].trim()

    if ( $texto_orig -ne "" ) {

    $texto_cod = [System.Web.HTTPUtility]::UrlEncode( $texto_orig )
    $url = -join ( $uri , $api_key , "&text=" , $texto_cod , "&target_lang=" , $target_lang , "&source_lang=" , $source_lang )
    $json = ( Invoke-RestMethod -Uri $url -Method $Method -ContentType $ContentType -UserAgent $UserAgent)
    
    if ( $json -like "Quota Exceeded") { break }
    $traduccion = $json.translations.text

    <#
    clear-host
    write-host " " 
    write-host "Traducciendo linea "$i" de "$tamaño_array
    write-host " "
    write-host "ORIGINAL:    "$texto_orig
    write-host " "
    write-host "TRADUCCION:  "$traduccion
    write-host "=================================================================================================================================================="
    write-host " "
#    read-host "Press ENTER to continue..."
    #>
    
    $traduccion = $traduccion + "`r`n"    
    $traduccion 
    out-file -filepath $fichero_salida  -Encoding utf8 -append 

    }

}
            
<#
translatorName == 'google' ? `https://translate.google.com/?sl=${sourceLang}&tl=${targetLang}&text=${encodeURIComponent(t)}&op=translate` :
translatorName == 'deepl' ? `https://www.deepl.com/translator#${sourceLang}/${targetLang}/${encodeURIComponent(deeplBackslashEncode(t))}` :
#>