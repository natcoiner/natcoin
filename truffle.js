module.exports = {
  rpc: {
    host: "localhost",
    port: 8545
  },
  networks: {

    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    live: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas : 4712388,
      from : "0xd8974bffab9f2d585d817279ac52d1979337a634"
    },
    main : {
      network_id: '*',
      gas : 4712388
    }
  }
};
