module.exports = {
  apps: [
    {
      name: "did-explorer",
      cwd: "did-explorer",
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
  ],
  deploy: {
    baloo: {
      host: "deploy_staging",
      ref: "origin/main",
      repo: "https://github.com/dyne/W3C-DID",
      path: "/root/W3C-DID",
      "pre-deploy": "git submodule update --init --recursive",
      "post-deploy": "cd did-explorer; pnpm install && pnpm build && pnpm reload; cd -",
      env: {
        NODE_ENV: "production",
      },
    },
  },
};
