/* 
 * Delimitar textareas
 * 
 * implementacion:
 *      <textarea name="nombre_textarea" cols="50" rows="5" 
 *          onKeyUp="return textArea_maxLen(this,254)">
 */
function textArea_maxLen(texto,maxlong) {
     var tecla, in_value, out_value;

     if (texto.value.length > maxlong) {
         in_value = texto.value;
         out_value = in_value.substring(0,maxlong);
         texto.value = out_value;
         return false;
     }
     return true;
}

/**
 * Valida si la tecla que se presiono corresponde a un numero o un punto
 * 
 * Sirve para restringir que el usuario capture solo numeros decimales en un
 * campo de texto.
 * 
 * Implementación:
 *          <input type="text" name="mi_numero" 
 *              onkeypress="return validateNumber(event);"/>
 */
function validateNumber(event) {
    var key = window.event ? event.keyCode : event.which;

    //8 = Backspace (retroceder, borrar)
    //45 = punto decimal
    if (event.keyCode === 8 || event.keyCode === 46) {
     //|| event.keyCode == 37 || event.keyCode == 39) {
     
        return true;
    }
    else if ( key < 48 || key > 57 ) {
        return false;
    }
    else return true;
};

/**
 * Obtiene el valor decimal de un campo de texto, ádemas
 * obliga a que tenga un valor válido, si no lo tiene
 * asigna un CERO al control
 * 
 * Implementación (código JavaScript):
 *          var cantidad = getFloatFromInput($('#producto_cantidad'));
 */
function getFloatFromInput(control){
    var valorFloat = 0;
    
    valorFloat = parseFloat(control.val()).toFixed(2);
    
    if (isNaN(valorFloat)){
        valorFloat=0;
        control.val('0');
    }else if(valorFloat<0){
        alert('No se permiten valores negativos.');
        valorFloat = 0;
        control.val('0');
    }
    return valorFloat;
}

/**
 * Valida si la tecla que se presiono corresponde a un numero o el caracter
 * especificado en codigo ascii
 * 
 * Sirve para restringir que el usuario capture solo numeros y cierto caracter en un
 * campo de texto.
 * 
 * Implementación:
 *  Por ejemplo para aceptar numeros y el caracter backslash "/"
 *      Backslash tiene el codigo ascii 47:
 *  
 *          <input type="text" name="mi_numero" 
 *              onkeypress="return validateNumberAndChar(event,47);"/>
 */
function validateNumberAndChar(event,char_ascii_code) {
    var key = window.event ? event.keyCode : event.which;

    if (event.keyCode === char_ascii_code) {
        return true;
    }
    else if ( key < 48 || key > 57 ) {
        return false;
    }
    else return true;
};

function verificaFechaFormato(control) {
    if(control.value!==""){
        var val = control.value;	
        //dd-mm-aaaa
        var regex =/^([0-9]{2})-([0-9]{2})-([0-9]{4})$/;	
        if (!val.match(regex)){
            control.value="";
            alert('La fecha no cumple con la especificación, debe tener el formato dd-mm-aaaa , por favor verifique.');
            control.focus();
            return false;
        }else{
            return true;
        }
        
    }
}
