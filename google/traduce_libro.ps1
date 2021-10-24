clear-host

$Host.PrivateData.VerboseForegroundColor = 'Cyan'

# Fichero a traducir
$fichero = "H:\SCRIPTS\traducir libros\Ashes Of Victory - Weber, David.txt"

# Cargo el fichero en el array.
$array_fichero = @(get-content $fichero -Encoding UTF8)

$tama?o_array = $array_fichero.length

for ( $i = 1 ; $i -lt $array_fichero.length ; $i++ ) {
    
    $orig = $array_fichero[$i].trim()

    if ( $orig -ne "" ) {

        $v_data = [System.Web.HTTPUtility]::UrlEncode($orig) 
    
        # Mando el texto a Google para que lo traduzca
        $Uri = "https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=auto&tl=es&q=" + $v_data + "&ie=UTF-8&oe=UTF-8"
    
        # Recojo la traduccion en formato JSON
        $traducido = (Invoke-RestMethod -Uri $Uri -method POST -ContentType "application/json; charset=utf-8")
    
        # Uno todas las lineas traducidas
        $traduccion = [system.String]::Join("", $traducido.sentences.trans)

        clear-host
        write-host " " 
        write-host "Traducciendo linea "$i" de "$tama?o_array
        write-host " "
        write-host "ORIGINAL:    "$orig
        write-host " "
        write-host "TRADUCCION:  "$traduccion
        write-host "=================================================================================================================================================="
        write-host " "
        read-host "Press ENTER to continue..."

    }
    # Comentario para probar git
    
}
            
            
