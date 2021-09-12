({
    init : function(component, event, helper) {
        var action = component.get('c.getUIDataInfo');
        var theMap = component.get("v.theMap");
        action.setParams({ 
            "ComponentName" : component.get('v.uiComponentName') ,
            "filters" : theMap
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                console.log('data from apex '+JSON.stringify(result.getReturnValue()));
                component.set("v.columns", result.getReturnValue().columns);
                var formatVal = result.getReturnValue().Format;
               	component.set("v.formatVal",formatVal);
                var uiIcon =  result.getReturnValue().Icon;
                if(!$A.util.isEmpty(uiIcon) && !$A.util.isUndefined(uiIcon)){
                    component.set("v.uiIcon",uiIcon);
                }
                if(formatVal == 'Detailed' || formatVal == 'Tabular'){
                    component.set("v.data", result.getReturnValue().data);
                    component.set("v.dataCount", result.getReturnValue().data.length);
                }else{
                    component.set("v.errorMessage",result.getReturnValue().Message);
                }
                component.set("v.apexResultSuccess", true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        } );
        $A.enqueueAction(action);
    }
})