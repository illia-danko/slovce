window.__state = { guess: "" };
let S = window.__state;

function updateInputElement() {
  [...Array(5).keys()].map(index => {
    let char = S.guess.charAt(index);
    let id = `input-tile-${index}`;
    let el = document.getElementById(id);

    if (el) {
      el.firstElementChild.innerText = char;
      if (char === "") {
        el.classList.remove("border-gray-500");
        el.classList.add("border-gray-300");
      } else {
        el.classList.remove("border-gray-300");
        el.classList.add("border-gray-500");
      }
    } else {
      window.console.error(`Missing input element with id ${id}`);
    }
  });
}

S.onBackspace = function () {
  S.guess = S.guess.slice(0, -1);
  updateInputElement();
};

S.onChar = function (newChar) {
  if (S.guess.length < 5) {
    S.guess = S.guess + newChar;
    updateInputElement();
  }
};

export default {
  mounted() {
    let ref = this;

    S.onEnter = function () {
      ref.pushEvent("submit", { guess: S.guess });
    };

    S.onKey = function ({ key }) {
      if (key === "Enter") {
        S.onEnter();
      } else if (key === "Backspace") {
        S.onBackspace();
      } else {
        key = key.toUpperCase();
        if (key.length === 1) {
          switch (key) {
            case "Й":
            case "Ц":
            case "У":
            case "К":
            case "Е":
            case "Н":
            case "Г":
            case "Ґ":
            case "Ш":
            case "Щ":
            case "З":
            case "Х":
            case "Ї":
            case "Ф":
            case "І":
            case "В":
            case "А":
            case "П":
            case "Р":
            case "О":
            case "Л":
            case "Д":
            case "Ж":
            case "Є":
            case "Я":
            case "Ч":
            case "С":
            case "М":
            case "И":
            case "Т":
            case "Ь":
            case "Б":
            case "Ю":
            case "'":
              S.onChar(key);
          }
        }
      }
    };

    S.keyboardClicked = function (event) {
      S.onKey({ key: event.detail.key });
    };

    this.el.addEventListener("keyboard:clicked", S.keyboardClicked);

    this.handleEvent("keyboard:reset", () => {
      S.guess = "";
      updateInputElement();
    });

    window.addEventListener("keydown", S.onKey);
  },

  destroyed() {
    window.removeEventListener("keydown", S.onKey);
    this.el.removeEventListener("keyboard:clicked", S.keyboardClicked);
  },

  updated() {
    updateInputElement();
  },
};
