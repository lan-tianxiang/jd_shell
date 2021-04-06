module.exports = {
  apps: [
    { 
      name: 'webshell',
      script: './index.js',
      watch: ['index.js'],
      // Delay between restart
      watch_delay: 2000,
      ignore_watch: ['node_modules', 'public'],
      watch_options: {
        followSymlinks: false,
      },
    },
  ],
};
