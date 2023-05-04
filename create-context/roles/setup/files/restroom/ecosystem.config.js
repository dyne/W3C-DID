module.exports = {
  apps: [
    {
      name: "sandbox-context",
      time: true,
      autorestart: true,
      max_restarts: 50,
      script: "restroom.mjs",
      exec_mode: "cluster",
      instances: 2,
      listen_timeout: 12000,
      wait_ready: true,
      watch: false,
    },
  ]
};
