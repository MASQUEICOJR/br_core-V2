var playlist = [
  { //para adicionar mais uma duplicar bloco, colocar musica e logo na pasta assets /images e /musicas
    image: "nui://loading/web-side/assets/images/br_logo.png",
    song: "BR_CORE - 🐀",
    album: "BR_CORE",
    artist: "BR_CORE",
    mp3: "nui://loading/web-side/assets/musicas/br_core.mp3",
  },
  { //para adicionar mais uma duplicar bloco, colocar musica e logo na pasta assets /images e /musicas
    image: "nui://loading/web-side/assets/images/br_logo.png",
    song: "BR_CORE 2 - 🐀",
    album: "BR_CORE",
    artist: "BR_CORE",
    mp3: "nui://loading/web-side/assets/musicas/br_core.mp3",
  },
  // {  //para adicionar mais uma duplicar bloco, colocar musica e logo na pasta assets /images e /musicas
  //   image: "nui://loading/web-side/assets/images/br_logo.png",
  //   song: "HYLANDER 3 - 🐀",
  //   album: "BR_CORE",
  //   artist: "BR_CORE",
  //   mp3: "nui://loading/web-side/assets/musicas/br_core.mp3",
  // },
];

var rot = 0;
var duration;
var playPercent;
var bufferPercent;
var currentSong = Math.round(Math.random() * (playlist.length - 1));
var arm_rotate_timer;
var arm = document.getElementById("arm");
var next = document.getElementById("next");
var song = document.getElementById("song");
var timer = document.getElementById("timer");
var music = document.getElementById("music");
var volume = document.getElementById("volume");
var playButton = document.getElementById("play");
var timeline = document.getElementById("slider");
var playhead = document.getElementById("elapsed");
var previous = document.getElementById("previous");
var pauseButton = document.getElementById("pause");
var bufferhead = document.getElementById("buffered");
var timelineWidth = timeline.offsetWidth - playhead.offsetWidth;
var visablevolume = document.getElementsByClassName("volume")[0];

music.addEventListener("ended", _next, false);
music.addEventListener(
  "timeupdate",
  ({ target }) => {
    if (target.duration) {
      playPercent = timelineWidth * (target.currentTime / target.duration);
      playhead.style.width = playPercent + "px";
      timer.innerHTML = formatSecondsAsTime(music.currentTime.toString());
    }
  },
  false
);

window.addEventListener("DOMContentLoaded", () => load());

function load() {
  pauseButton.style.display = "none";
  song.innerHTML = playlist[currentSong]["song"];
  song.title = playlist[currentSong]["song"];
  music.volume = 0.2;

  music.src = playlist[currentSong]["mp3"];

  document.querySelector(
    ".image"
  ).style.backgroundImage = `url('${playlist[currentSong]["image"]}')`;

  music.load();
  setTimeout(() => {
    playButton.style.display = "none";
    pauseButton.style.display = "block";
    music.play();
  }, 3000);
}

function reset() {
  fireEvent(pauseButton, "click");
  playhead.style.width = "0px";
  timer.innerHTML = "0:00";
  music.innerHTML = "";
  currentSong = 0;
  song.innerHTML = playlist[currentSong]["song"];
  song.title = playlist[currentSong]["song"];
  music.src = playlist[currentSong].mp3;
  document.querySelector(
    ".image"
  ).style.backgroundImage = `url('${playlist[currentSong].image}')`;
  music.load();
}

function formatSecondsAsTime(secs) {
  var min = Math.floor(secs / 60);
  var sec = Math.floor(secs % 60);
  if (sec < 10) {
    sec = "0" + sec;
  }
  return min + ":" + sec;
}

function fireEvent(el, etype) {
  if (el.fireEvent) {
    el.fireEvent("on" + etype);
  } else {
    var evObj = document.createEvent("Events");
    evObj.initEvent(etype, true, false);
    el.dispatchEvent(evObj);
  }
}

function _next() {
  if (currentSong == playlist.length - 1) {
    reset();
  } else {
    fireEvent(next, "click");
  }
}

playButton.onclick = function () {
  music.play();
};

pauseButton.onclick = function () {
  music.pause();
};

music.addEventListener(
  "play",
  function () {
    playButton.style.display = "none";
    pauseButton.style.display = "block";
  },
  false
);

music.addEventListener(
  "pause",
  function () {
    pauseButton.style.display = "none";
    playButton.style.display = "block";
  },
  false
);

next.onclick = function () {
  playhead.style.width = "0px";
  timer.innerHTML = "0:00";
  music.innerHTML = "";

  if (currentSong + 1 == playlist.length) {
    currentSong = 0;
  } else {
    currentSong++;
  }

  music.src = playlist[currentSong]["mp3"];
  document.querySelector(
    ".image"
  ).style.backgroundImage = `url('${playlist[currentSong].image}')`;
  song.innerHTML = playlist[currentSong]["song"];
  song.title = playlist[currentSong]["song"];
  music.load();
  music.play();
};

previous.onclick = function () {
  playhead.style.width = "0px";
  timer.innerHTML = "0:00";
  music.innerHTML = "";

  if (currentSong - 1 < 0) {
    currentSong = playlist.length - 1;
  } else {
    currentSong--;
  }

  music.src = playlist[currentSong]["mp3"];
  document.querySelector(
    ".image"
  ).style.backgroundImage = `url('${playlist[currentSong].image}')`;
  song.innerHTML = playlist[currentSong]["song"];
  song.title = playlist[currentSong]["song"];
  music.load();
  music.play();
};

volume.oninput = function () {
  music.volume = volume.value;
};

music.addEventListener(
  "canplay",
  function () {
    duration = music.duration;
  },
  false
);