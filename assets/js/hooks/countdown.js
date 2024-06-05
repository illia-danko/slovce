export default {
  mounted() {
    const self = this;
    const pad = num => num.toString().padStart(2, "0");
    const tzFormatter = new Intl.DateTimeFormat("en-US", {
      timeStyle: "short",
      timeZone: "Europe/Kiev",
    });

    function showCountdown() {
      const now = new Date();
      const timeZoneParts = tzFormatter.formatToParts(now).map(v => v.value);
      const hoursTZNow = parseInt(timeZoneParts[0]);
      const dayPeriod = timeZoneParts[4];

      const hours = 23 - (dayPeriod == "PM" ? hoursTZNow + 12 : hoursTZNow);
      const minutes = 59 - now.getUTCMinutes();
      const seconds = 59 - now.getUTCSeconds();

      self.el.innerText = `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;

      if (hours == 0 && minutes == 0 && seconds == 0) {
        self.pushEvent("game:reset", {});
      }
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
