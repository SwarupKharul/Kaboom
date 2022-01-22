import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:kaboom/services/web3.dart';

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
  var web3 = Web3Service();

  BigInt? tokenId;

  BigInt? getTokenId() {
    return tokenId;
  }

  // fetch all items by fetchMyNFTs
  Future<String?> createMarketItem({required double price}) async {
    final nftToken = await web3.createToken(
        tokenURI:
            "https://ipfs.infura.io/ipfs/QmSwPW9hEP6RtwoMZ1bz6CqnBwR6aa244RzNL7cPoD5gYW");
    web3.nft.transferEvents().toString();
    getTokenId();
    print("tokenId: $tokenId");
    final marketItem = await web3.createMarketItem(
        tokenId: tokenId!, price: BigInt.from(price));

    print('createMarketItem $marketItem');
    return marketItem;
  }

  @override
  void initState() {
    super.initState();
    web3.nft.transferEvents().listen((event) {
      setState(() {
        tokenId = event.tokenId;
      });
    });
    createMarketItem(price: 20);
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
                createMarketItem(price: 20);
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
