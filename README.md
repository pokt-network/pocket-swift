<div align="center">
  <a href="https://www.pokt.network">
    <img src="https://pokt.network/wp-content/uploads/2018/12/Logo-488x228-px.png" alt="drawing" width="340"/>
  </a>
</div>
<h1 align="left">PocketSwift</h1>
<h6 align="left">Official Swift client to use with the Pocket Network</h6>
<div align="lef">
  <a  href="https://swift.org/">
    <img src="https://img.shields.io/badge/swift-reference-yellow.svg"/>
  </a>
</div>

<h1 align="left">Overview</h1>
  <div align="left">
    <a  href="https://github.com/pokt-network/pocket-swift/releases">
      <img src="https://img.shields.io/github/release-pre/pokt-network/pocket-swift.svg"/>
    </a>
    <a href="https://circleci.com/gh/pokt-network/pocket-swift/tree/master">
      <img src="https://circleci.com/gh/pokt-network/pocket-swift/tree/master.svg?style=svg"/>
    </a>
    <a  href="https://github.com/pokt-network/pocket-swift/pulse">
      <img src="https://img.shields.io/github/contributors/pokt-network/pocket-swift.svg"/>
    </a>
    <a href="https://opensource.org/licenses/MIT">
      <img src="https://img.shields.io/badge/License-MIT-blue.svg"/>
    </a>
    <br >
    <a href="https://github.com/pokt-network/pocket-swift/pulse">
      <img src="https://img.shields.io/github/last-commit/pokt-network/pocket-swift.svg"/>
    </a>
    <a href="https://github.com/pokt-network/pocket-swift/pulls">
      <img src="https://img.shields.io/github/issues-pr/pokt-network/pocket-swift.svg"/>
    </a>
    <a href="https://github.com/pokt-network/pocket-swift/issues">
      <img src="https://img.shields.io/github/issues-closed/pokt-network/pocket-swift.svg"/>
    </a>
</div>

PocketSwift wraps all of the tools a developer will need to begin interacting with a network. PocketSwift contains 4 packages:

- `PocketEth`: A library that allows your DApp to communicate to the Ethereum network.
- `PocketAion`: A library that allows your DApp to communicate to the AION network.
- `PocketCore`: An implementation of the Pocket protocol that you can use to create your own plugin to interact with a blockchain of your choosing.
- `PocketSwift`: Contains the 3 beforementioned packages.

Before you can start using the library, you have to acquire a Developer ID by registering for MVP. [To learn how to register please click here.](https://pocket-network.readme.io/docs/how-to-participate#section-for-developers)

<h1 align="left">Requirements</h1>

You should have at least have a basic knowledge of blockchain technology and know your way around Swift. You will also need to install the [Cocoapods tool](https://guides.cocoapods.org/using/getting-started.html).

<h1 align="left">Installation</h1>

The PocketSwift packages are managed using [Cocoapods](https://cocoapods.org/), see below how to install each individual package.

We will be using Cocoapods, to download the pod files into your project. Inside your pod file, enter: 
For the full package that includes the ETH and Aion plugin, as well as the Core package:

Full package: 
`pod 'PocketSwift'`

For individual installation:

`pod PocketSwift/Eth`

`pod PocketSwift/Aion`

`Pod PocketSwift/Core`

<h1 align="left">Usage</h1>

If you would like you know how integrate PocketSwift into your DApp, visit our [developer portal](https://pocket-network.readme.io/) that has a lot of useful tutorials and material about Pocket Network and Pocket MVP. 

<h1 align="left">Contact Us</h1>

We have created a Discord server where you can meet with the Pocket team, as well as fellow App Developers, and Service Nodes. [Click here to join!](https://discord.gg/sarhfXP)
