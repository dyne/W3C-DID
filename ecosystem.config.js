module.exports = {
  deploy: {
    baloo: {
      host: "deploy_staging",
      ref: "origin/main",
      repo: "https://github.com/dyne/W3C-DID",
      path: "/root/W3C-DID",
      "post-deploy": "cd did-explorer; pnpm install && pnpm build && pnpm reload; cd -",
      env: {
        NODE_ENV: "production",
      },
    },
  },
};
