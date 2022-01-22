import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:kaboom/abi/Market.g.dart';

late Client httpClient;
late Web3Client ethereumClient;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // NFT
  String nftAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512';
  String nftContractName = 'NFT';

  // Market
  String marketAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  String marketContractName = 'NFTMarket';

  // ERC20
  String ethereumClientUrl = 'http://localhost:8545';

  // Private key
  String private_key =
      "0xa267530f49f8280200edf313ee7af6b827f2a8bce2897751d06a843f644967b1";

  // function to query NFT
  Future<List<dynamic>> queryNFT(
      String functionName, List<dynamic> args) async {
    print('query: $functionName, $args');
    DeployedContract contract = await getNFTContract();
    print('contract: $contract');
    ContractFunction function = contract.function(functionName);
    print('function: $function');
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  // function to send Transaction
  Future<TransactionReceipt> transaction(
      String functionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(private_key);
    DeployedContract contract = await getMarketContract();
    ContractFunction function = contract.function(functionName);
    print("line 57");
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction(
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(25000000000000000))),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  // function to quesry Market
  Future<List<dynamic>> queryMarket(
      String functionName, List<dynamic> args) async {
    print('Market query: $functionName, $args');
    DeployedContract contract = await getMarketContract();
    print('Market contract: $contract');
    ContractFunction function = contract.function(functionName);
    print('Market function: $function');
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

// function to get contract
  Future<DeployedContract> getNFTContract() async {
    print('getNFTContract');
    String abi = await rootBundle.loadString("assets/NFT_abi.json");
    print("in get contract after client");
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, nftContractName),
      EthereumAddress.fromHex(nftAddress),
    );

    return contract;
  }

// function to get Market contract
  Future<DeployedContract> getMarketContract() async {
    print('getMarketContract');
    String abi = await rootBundle.loadString("assets/Market_abi.json");
    print("in get market contract after client");
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, marketContractName),
      EthereumAddress.fromHex(marketAddress),
    );

    return contract;
  }

  // // fetch all items by createMarketItem
  // Future<void> createMarketItem() async {
  //   List<dynamic> result =
  //       await queryNFT('createToken', ["https://ipfs.infura.io/ipfs/1"]);
  //   print("before Market query");
  //   print(result);
  //   // var events = result.["events"][0];
  //   // var value = events.args[2];
  //   // List<dynamic> marketItem = await queryMarket('createMarketItem', [
  //   //   EthereumAddress.fromHex(marketAddress),
  //   //   result[0],
  //   //   BigInt.from(int.parse("10")),
  //   //   {
  //   //     "transaction": Transaction(
  //   //       value: EtherAmount.fromUnitAndValue(
  //   //           EtherUnit.wei, BigInt.from(25000000000000000)),
  //   //     )
  //   //   }
  //   // ]);

  //   var createdItem = await transaction("createMarketItem", [
  //     EthereumAddress.fromHex(marketAddress),
  //     result[0],
  //     BigInt.from(int.parse("10")),
  //   ]); // ignore: avoid_print
  //   print(createdItem);
  // }

  Future<String> createMarketItem(
      {required BigInt tokenId, required BigInt price}) async {
    final listingPrice = await Market.getListingPrice();
    final item = await Market.createMarketItem(
      marketAddress,
      tokenId,
      price,
      credentials: credentials,
      transaction: Transaction(
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, BigInt.from(25000000000000000)),
      ),
    );
    return item;
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(ethereumClientUrl, httpClient);
    createMarketItem();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          // print all items with fetchMyNFTs
          child: Container(
            child: IconButton(
              onPressed: () {
                createMarketItem();
              },
              icon: Icon(Icons.refresh),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
