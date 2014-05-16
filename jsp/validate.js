function validate_required(field, alerttxt) { 
    with (field) 
    {
      if (value==null||value=="") {
        alert(alerttxt);return false;
      } else {
        return true
      }
    }
} 


function validate_email(field,alerttxt) {
    with (field)
    {
      apos=value.indexOf("@");
      dotpos=value.lastIndexOf(".");
      if (apos<1||dotpos-apos<2) {
        alert(alerttxt);return false;
      } else {
        return true;
      }
    }
}

function hilite(element, c) {
   element.style.backgroundColor=c;
}