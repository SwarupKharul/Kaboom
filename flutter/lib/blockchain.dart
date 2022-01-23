import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

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
  String nftMarketAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  String nftMarketContractName = 'NFTMarket';

  String ethereumClientUrl = 'https://rpc-mumbai.matic.today';

  // function to query
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    print("in query before contract");
    DeployedContract contract = await getNFTContract();
    print("in query after contract");
    ContractFunction function = contract.function(functionName);
    print("in query after function");
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

// function to get contract
  Future<DeployedContract> getNFTContract() async {
    print("in get contract before client");

    String abi = await rootBundle.loadString("assets/Market_abi.json");
    print("in get contract after client");
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, nftMarketContractName),
      EthereumAddress.fromHex(nftMarketAddress),
    );

    return contract;
  }

  // fetch all items by fetchMyNFTs
  Future<void> fetchMyNFTs() async {
    print("before quesry");
    List<dynamic> result = await query('fetchMarketItems', []);
    // ignore: avoid_print
    print(result);
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(ethereumClientUrl, httpClient);
    fetchMyNFTs();
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
                fetchMyNFTs();
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
