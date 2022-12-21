module.exports = {
  apps: [
    {
      name: "did-explorer",
      time: true,
      autorestart: true,
      max_restarts: 50,
      script: "node_modules/next/dist/bin/next",
      args: "start",
      exec_mode: "cluster",
      instances: 0,
      listen_timeout: 12000,
      wait_ready: true,
      watch: false,
      env: {
        PORT: 3060,
      },
    },
  ]
};
