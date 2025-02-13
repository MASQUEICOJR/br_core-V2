class App {
  constructor(rootElement, config) {
    if (!(rootElement instanceof HTMLElement) || typeof config !== "object") {
      throw new Error("Parâmetros inválidos para o construtor App");
    }

    this._config = config;
    this._rootElement = rootElement;
    this._spawnSelected = config.spawns[0]
    this._containerCards = rootElement.querySelector(".locales");

    this._init();
  }

  _init() {
    this._config.spawns.forEach((spawn) => this._createCard(spawn));
    window.addEventListener("message", (event) =>
      this._handleVisibilityMessage(event)
    );
    this._registerButtonEvent(".spawn", () => this._spawn(this._spawnSelected));
    this._registerButtonEvent(".last_local", () => this._lastLocation());
    this._registerButtonEvent(".special_spawn", () => this._factionLocation());

    document.querySelector('.date p').textContent = new Date().toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: '2-digit' }).split('/').join('.')
    document.querySelector('.clock p').textContent = new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })
  }

  _registerButtonEvent(selector, callback) {
    const button = this._rootElement.querySelector(selector);
    if (button) {
      button.addEventListener("click", callback);
    }
  }

  _createCard(item) {
    const cardElement = document.createElement("div");
    cardElement.classList.add("spawn");
    cardElement.innerHTML = `
      <div class="local">
      </div>
      <div class="name">
        <p>${item.name}</p>
      </div>
      <button>SELECIONAR</button> 
    `;
    cardElement.querySelector('.local').classList.add("spawn");
    cardElement.addEventListener("click", () => this._setCam(item, cardElement));
    cardElement.querySelector('.local').style.background = `url(${item.image})`
    cardElement.querySelector('button').addEventListener("click", () => this._sendPostRequest(item.name));
    this._containerCards.appendChild(cardElement);
  }

  _selectCard(item, cardElement) {
    const activeItem = this._containerCards.querySelector(".selected");
    if (activeItem) {
      activeItem.classList.remove("selected");
    }
    cardElement.classList.add("selected");

    const infoBox = this._rootElement.querySelector(".info-box");
    const textArea = this._rootElement.querySelector(".text-area");
    const mapArea = this._rootElement.querySelector(".map-area");

    if (infoBox && textArea) {
      infoBox.textContent = item.name;
      textArea.textContent = item.description;
    }

    if (mapArea && item.position) {
      mapArea.style.backgroundSize = "500% 700%";
      mapArea.style.backgroundPosition = `-${item.position.left}rem -${item.position.top}rem`;
    }
  }

  _setCam(spawn, cardElement) {
    document.querySelector('.local.selected')?.classList.remove('selected')
    cardElement.classList.add('selected')
    this._spawnSelected = spawn
    fetch(`${this._config.url}/SetCam`, {
      method: 'POST',
      body: JSON.stringify({ spawn })
    })
  }

  _spawn(spawn) {
    this._sendPostRequest(spawn)
  }

  _lastLocation() {
    this._sendPostRequest("last");
  }

  _factionLocation() {
    this._sendPostRequest("faction");
  }

  _sendPostRequest(callback) {
    fetch(`${this._config.url}/ButtonClick`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ callback }),
    }).then(() => this._setDisplay(false)).catch((err) => console.error("Erro ao enviar a solicitação POST:", err));
  }

  _handleVisibilityMessage({ data }) {
    if (data && data.action) {
      this._setDisplay(data.action === "open", data.inFaction);
    }
  }

  _setDisplay(visible, inFaction) {
    this._rootElement.style.display = visible ? "flex" : "none";
    document.querySelector(".special_spawn").style.opacity = inFaction ? 1 : .2;
    document.querySelector(".special_spawn").style.pointerEvents = inFaction ? "all" : "none";
    document.querySelector(".special_spawn svg").style.display = inFaction ? "none" : "block";
  }
}

const rootElement = document.querySelector("body");
new App(rootElement, config);

if (!window.invokeNative) {
  window.postMessage({
    action: "open",
    inFaction: false
  });
}
