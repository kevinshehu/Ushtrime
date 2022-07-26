({
    updateValue : function(component, event, helper) {
        // get value
        var val = component.find("myInput").getElement().value;

        // update
        component.set("v.greeting", val)
    }
})
