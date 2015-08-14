/*
 * all rights reserved anpho@bbdev.cn
 */
import bb.cascades 1.2

QtObject {
    function ajax(method, endpoint, paramsArray, callback, customheader, form) {
        console.log(method + "//" + endpoint + JSON.stringify(paramsArray))
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status == 200) {
                    console.log("[AJAX]Response = " + request.responseText);
                    callback({
                            "success": true,
                            "data": request.responseText
                        });
                } else {
                    console.log("[AJAX]Status: " + request.status + ", Status Text: " + request.statusText);
                    callback({
                            "success": false,
                            "data": request.statusText
                        });
                }
            }
        };
        var params = paramsArray.join("&");
        var url = endpoint;
        if (method == "GET" && params.length > 0) {
            url = url + "?" + params;
        }
        request.open(method, url, true);
        if (form) {
            request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }

        if (customheader) {
            for (var i = 0; i < customheader.length; i ++) {
                request.setRequestHeader(customheader[i].k, customheader[i].v);
            }
        }
        if (method == "GET") {
            request.send();
        } else {
            request.send(params);
        }
    }

    onCreationCompleted: {
        console.log("[QML]Common.qml loaded.")
    }

    function parse (str) {
        // validate year as 4 digits, month as 01-12, and day as 01-31 
        if ((str = str.match (/^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$/))) {
            // make a date
            str[0] = new Date (+str[1], +str[2] - 1, +str[3]);
            // check if month stayed the same (ie that day number is valid)
            if (str[0].getMonth () === +str[2] - 1)
                return str[0];
        }
        return undefined;
    }
}
