$(document).ready(function() {
    $("body").hide();

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (data.action === "open") {
            $("body").show();
        } 
        else if (data.action === "close") {
            $("body").hide();
        }
    });


    // Envia uma mensagem nova
    $("#send-message").click(function () {
        let message = $("#message-input").val();
        if (message.trim() !== "") {
            $.post("https://br_orgs/New:Message", JSON.stringify({ message: message }), function (response) {
                console.log("Mensagem enviada:", response);
            });
        }
    });

    // === Event Listener para tecla Escape ===
    document.addEventListener("keyup", function(event) {
        if (event.key === "Escape") {
            $.post("https://br_orgs/close", JSON.stringify({}));
        }
    });

    // Botão de fechar (caso tenha um)
    $("#close-nui").click(function() {
        $.post("https://br_orgs/close", JSON.stringify({})); 
    });



});
