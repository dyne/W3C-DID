module.exports = {
  apps: [
    {
      name: "did-explorer-api",
      time: true,
      autorestart: true,
      max_restarts: 50,
      script: "yarn",
      args: "start",
      exec_mode: "fork",
      //instances: 0,
      listen_timeout: 12000,
      wait_ready: true,
      watch: false,
    },
  ]
};
