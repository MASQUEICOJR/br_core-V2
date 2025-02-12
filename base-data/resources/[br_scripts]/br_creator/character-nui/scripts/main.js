window.addEventListener("message", ({ data }) => {
  if (data.CharacterMode == true) {
    app.OpenCharacterMode();
  }
  if (data.CharacterMode == false) {
    app.CloseCharacterMode();
  }
  if (data.whitelist === true) whitelistApp.open(data);
  if (data.whitelist === false) whitelistApp.close();
});

if (!window.invokeNative) {
  document.body.style.background = "#1c1c1c"
}