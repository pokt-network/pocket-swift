var returnValue = "%@";
var functionObj = %@;

var decodedValue = new aionInstance.eth.Contract([])._decodeMethodReturn(functionObj.outputs, returnValue);
if (typeof decodedValue === "object" && !Array.isArray(decodedValue)) {
decodedValue = Object.keys(decodedValue).map(key => decodedValue[key]);
}

