import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Banneradstest extends StatefulWidget {
  const Banneradstest({super.key});

  @override
  State<Banneradstest> createState() => _BanneradstestState();
}

class _BanneradstestState extends State<Banneradstest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAD();
    datas = [];

    for (int i = 1; i <= 20; i++) {
      datas.add("List item ${i}");
    }

    dataads = List.from(datas);

    for (int i = 0; i <= 2; i++) {
      var min = 1;
      var rn = Random();

      var rannumpos = min + rn.nextInt(18);

      dataads.insert(rannumpos, bannerAd);
    }
  }

  late BannerAd bannerAd;
  bool isAdloaded = false;

  late List<String> datas;
  late List<Object> dataads;

  initBannerAD() {
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdloaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: dataads.length,
          itemBuilder: (context, index) {
            BannerAd bAd = BannerAd(
                size: AdSize.largeBanner,
                adUnitId: 'ca-app-pub-3940256099942544/9214589741',
                listener: BannerAdListener(
                  onAdLoaded: (Ad ad) {
                    print("Ad Loaded");
                  },
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    print("Ad failed to load");
                    ad.dispose();
                  },
                  onAdOpened: (Ad ad) {
                    print("Ad Loaded");
                  },
                ),
                request: AdRequest());
            if (dataads[index] is String) {
              return ListTile(
                title: Text(dataads[index].toString()),
                leading: Icon(Icons.exit_to_app),
                trailing: Icon(Icons.abc_rounded),
              );
            } else {
              return isAdloaded
                  ? SizedBox(
                      height: bAd.size.height.toDouble(),
                      width: bAd.size.width.toDouble(),
                      child: AdWidget(
                        ad: bAd..load(),
                        key: ValueKey<String>('ad_$index'),
                      ),
                    )
                  : SizedBox();
            }
          }),
      bottomNavigationBar: Container(
        child: isAdloaded
            ? SizedBox(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(
                  ad: bannerAd,
                  key: ValueKey<String>("1"),
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
