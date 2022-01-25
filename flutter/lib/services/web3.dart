import 'dart:convert';

import 'package:kaboom/abi/NFT.g.dart';
import 'package:kaboom/abi/Market.g.dart';
import 'package:http/http.dart';
import 'package:kaboom/core/models/post.dart';
import 'package:web3dart/web3dart.dart';
import 'package:kaboom/ipfs/ipfs.wrapper.dart';
import 'package:web_socket_channel/io.dart';

var ipfs = IPFS();

class Web3Service {
  late Client httpClient;
  late Web3Client ethClient;
  String rpcUrl = 'http://10.0.2.2:8545';
  String wsUrl = 'ws://localhost:8545';
  String nftStorageUrl = 'ipfs.dweb.link/';

  final marketContractAddress =
      EthereumAddress.fromHex('0x5FbDB2315678afecb367f032d93F642f64180aa3');
  final nftContractAddress =
      EthereumAddress.fromHex('0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');

  late Market market;
  late NFT nft;
  late Credentials credentials = EthPrivateKey.fromHex(
      "0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba");

  Web3Service() {
    httpClient = Client();
    ethClient = Web3Client(rpcUrl, httpClient);
    market = Market(
      address: marketContractAddress,
      client: ethClient,
      chainId: 1337,
    );

    nft = NFT(
      address: nftContractAddress,
      client: ethClient,
      chainId: 1337,
    );
  }

  get http => null;

  // void setCredentials(String privateKey) async {
  //   credentials = EthPrivateKey.fromHex(privateKey);
  //   final address = await credentials.extractAddress();
  //   print('address: $address');
  // }

  Future<String> createMarketItem(
      {required BigInt tokenId, required BigInt price}) async {
    final listingPrice = await market.getListingPrice();
    final item = await market.createMarketItem(
      nftContractAddress,
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

  Future<String> createToken({required String tokenURI}) async {
    final txHash = await nft.createToken(
      tokenURI,
      credentials: credentials,
    );
    return txHash;
  }

  Future<String> buyNft({required BigInt itemId, required BigInt price}) async {
    final client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    final txHash = await market.createMarketSale(nftContractAddress, itemId,
        credentials: credentials,
        transaction: Transaction(
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, price),
        ));
    return txHash;
  }

  Future<List<Post>> getUserCreatedItems() async {
    final List<dynamic> items = [];
    final List<Post> posts = [];
    final address = await credentials.extractAddress();
    print('address: $address');
    final result = await market.fetchItemsCreated(address);
    print('result: $result');
    for (var item in result) {
      items.add({
        "itemId": item[0],
        "tokenId": item[2],
      });
    }

    for (var item in items) {
      final metaUri = await getTokenUri(item['tokenId']);
      print("metaUri: $metaUri");
      final metaData = await getTokenMetadata(tokenURI: metaUri);
      print("metaData: $metaData");
      var data = jsonDecode(
        metaData.toString(),
      );
      print("Data: ${data}");
      posts.add(Post(
          name: data["creatorName"],
          title: data["title"],
          price: data["price"],
          itemId: item["itemId"],
          img: data['imgHash']));
    }
    // print(result);
    return posts;
  }

  Future<List<Post>> getUserOwnedItems() async {
    final List<dynamic> items = [];
    final List<Post> posts = [];
    final address = await credentials.extractAddress();
    final result = await market.fetchMyNFTs(address);

    for (var item in result) {
      items.add({
        "itemId": item[0],
        "tokenId": item[2],
      });
    }

    for (var item in items) {
      final metaUri = await getTokenUri(item['tokenId']);
      print("metaUri: $metaUri");
      final metaData = await getTokenMetadata(tokenURI: metaUri);
      print("metaData: $metaData");
      var data = jsonDecode(
        metaData.toString(),
      );
      print("Data: ${data}");
      posts.add(Post(
          name: data["creatorName"],
          title: data["title"],
          price: data["price"],
          itemId: item["itemId"],
          img: data['imgHash']));
    }
    // print(result);
    return posts;
  }

  Future<dynamic> getTokenMetadata({required String tokenURI}) async {
    var headers = {'Accept': 'application/json; charset=UTF-8'};
    final tokenMetadata = await httpClient
        .get(Uri.parse('https://dweb.link/ipfs/$tokenURI'), headers: headers);
    return (tokenMetadata.body);
  }

  Future<dynamic> getImageMetadata({required String tokenURI}) async {
    var headers = {'Accept': 'application/json; charset=UTF-8'};
    final tokenMetadata = await httpClient
        .get(Uri.parse('https://dweb.link/ipfs/$tokenURI'), headers: headers);
    return (tokenMetadata.body);
  }

  Future<String> getTokenUri(BigInt tokenId) async {
    final tokenURI = await nft.tokenURI(tokenId);
    return tokenURI;
  }

  Future<List<Post>> getMarketItems() async {
    final List<dynamic> items = [];
    final List<Post> posts = [];
    final result = await market.fetchMarketItems();
    print(result);

    for (var item in result) {
      items.add({
        "itemId": item[0],
        "tokenId": item[2],
      });
    }

    for (var item in items) {
      final metaUri = await getTokenUri(item['tokenId']);
      print("metaUri: $metaUri");
      final metaData = await getTokenMetadata(tokenURI: metaUri);
      print("metaData: $metaData");
      var data = jsonDecode(
        metaData.toString(),
      );
      print("Data: ${data}");
      posts.add(Post(
          name: data["creatorName"],
          title: data["title"],
          price: data["price"],
          itemId: item["itemId"],
          img: data['imgHash']));
    }
    // print(result);
    return posts;
  }
}

// "\u0008\u0002\u0012k{\"price\":\"2\",\"title\":\"fs\",\"creatorName\":\"dsfsd\",\"imgHash\":\"QmbjAwRy2gUhxPGrXXuDPKUsyBzo3sXsG8MFGkJDy8Dkho\"}\u0018k"
