({
	doInit : function(component, helper) {
        var Record = component.get('v.record');
        var FieldName = component.get('v.fieldName');
        var outputText = component.find("outputTextId");
        if (FieldName.indexOf(".") >= 0) {
            var ParentSobject = Record[FieldName.split(".")[0]];
            if(ParentSobject != undefined){
                outputText.set("v.value",ParentSobject[FieldName.split(".")[1]]);
            }
        }
        else{
            outputText.set("v.value",Record[FieldName]);
        }
    }
})