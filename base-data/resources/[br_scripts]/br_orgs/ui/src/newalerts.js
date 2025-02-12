// Função para exibir o modal
function showModal() {
    let modal = document.createElement("div");
    modal.className = "customModal modal";

    let modalContent = document.createElement("div");
    modalContent.className = "modal-content";
    modalContent.innerHTML = `
        <h2 class="modal-title">NOVO AVISO</h2>
        <label for="title">Título do aviso</label>
        <input type="text" class="title modal-input" placeholder="Título do aviso">
        <label for="message">Mensagem do aviso</label>
        <textarea class="message modal-input modal-textarea" placeholder="Mensagem do aviso" maxlength="110"></textarea>
        <p class="text-counter"><span class="charCount">0</span>/110</p>
        <button class="modal-button">Criar Alerta</button>
    `;

    let closeButton = document.createElement("span");
    closeButton.className = "close";
    closeButton.innerHTML = "&times;";
    closeButton.onclick = function () {
        document.body.removeChild(modal);
    };

    modalContent.appendChild(closeButton);
    modal.appendChild(modalContent);
    document.body.appendChild(modal);

    // Atualizar contador de caracteres
    let messageInput = document.querySelector(".message");
    let charCount = document.querySelector(".charCount");
    messageInput.addEventListener("input", function () {
        charCount.textContent = messageInput.value.length;
    });
}

// Adicionando evento de clique ao .new-alerts
document.addEventListener("DOMContentLoaded", function () {
    let alertsContainer = document.querySelector(".new-alerts");
    if (alertsContainer) {
        alertsContainer.addEventListener("click", showModal);
    }
});

// Estilos do modal
document.head.insertAdjacentHTML("beforeend", `
    <style>
        .modal {
            display: flex;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: black;
            border: 1px solid #660000;
            border-radius: 6px;
            padding: 20px;
            width: 350px;
            text-align: left;
            color: white;
            position: relative;
        }
        .modal-title {
            font-size: 20px;
            font-weight: bold;
            color: #660000;
        }
        .modal-subtitle {
            font-size: 14px;
            margin-bottom: 10px;
        }
        .modal-input {
            width: 94%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: none;
            border-radius: 3px;
            background: #333;
            color: white;
        }
        .modal-textarea {
            resize: none;
            height: 100px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #660000 black;
        }
        .modal-textarea::-webkit-scrollbar {
            width: 6px;
        }
        .modal-textarea::-webkit-scrollbar-track {
            background: black;
        }
        .modal-textarea::-webkit-scrollbar-thumb {
            background: #660000;
            border-radius: 3px;
        }
        .text-counter {
            font-size: 12px;
            color: white;
            text-align: right;
            margin-bottom: 10px;
        }
        .modal-button {
            width: 100%;
            padding: 10px;
            background: #660000;
            border: none;
            border-radius: 3px;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }
        .modal-button:hover {
            background: darkred;
        }
        .close {
            color: white;
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover {
            color: #660000;
        }
    </style>
`);
