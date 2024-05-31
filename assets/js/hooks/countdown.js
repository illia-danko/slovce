export default {
  mounted() {
    const self = this;
    const pad = num => num.toString().padStart(2, "0");

    function showCountdown() {
      let now = new Date();
      let hours = 23 - now.getUTCHours();
      let minutes = 59 - now.getUTCMinutes();
      let seconds = 59 - now.getUTCSeconds();
      self.el.innerText = `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
    }

    showCountdown(); // show immediately.

    this.countdownInterval = setInterval(() => {
      showCountdown();
    }, 1000);
  },

  destroyed() {
    clearInterval(this.countdownInterval);
  },
};
