var n;
$(document).ready(function () {
    window.addEventListener('message', function (event){
        var data = event.data;
        if(data.action === "request") {
            Noty.closeAll();
            n = new Noty({
                type: 'notification',
                layout: 'topRight',
                text: data.text,
                timeout: data.time,
                theme: "mint",
                progressBar: true,
                buttons: [
                    Noty.button('Accept [Y]', 'btn btn-sm btn-success me-2', function () {
                        n.close();
                    }),
                    Noty.button('Deny [U]', 'btn btn-sm btn-danger', function () {
                        n.close();
                    })
                  ]
            }).show();
        } else if (data.close == true) {
            n.close();
        }
    })
});
