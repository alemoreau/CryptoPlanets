module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten:  {
     network_id: 3,
     host: "localhost",
     port:  8545,
     gas:      6500000,
     gasPrice: 100000000000,
     from: "0x71e7b17f694b74ad179dd6c47a16b53f943b2351"
    }
  }
};
