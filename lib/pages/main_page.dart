import 'package:cinema_movies_app/model/search_country.dart';
import 'package:cinema_movies_app/pages/favorite_page.dart';
import 'package:cinema_movies_app/pages/home_page.dart';
import 'package:cinema_movies_app/service/country_service.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Box countryBox = Hive.box('country');
  int currentIndex = 0;
  List<SCountry> countryList = [];
  late SCountry selected;

  @override
  void initState() {
    super.initState();
    //countryBox.clear();
    initCountry();
  }

  //get countries list
  Future<void> initCountry() async {
    final SCountryService countryService = SCountryService();
    final countries = await countryService.getCountries();
    setState(() {
      countryList = countries;
      selected = countryBox.isEmpty
          ? countries.firstWhere((element) => element.name == 'Ukraine')
          : countries.firstWhere(
              (element) => element.name == countryBox.get('country'));
    });
  }

  //biuld dropdown items list
  List<DropdownMenuItem<SCountry>> buildDropdownItems() {
    List<DropdownMenuItem<SCountry>> dropdownItems = [];
    for (SCountry country in countryList) {
      dropdownItems.add(
        DropdownMenuItem(
          alignment: Alignment.center,
          value: country,
          child: Text(
            country.name,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      );
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(country: selected),
      FavoritePage(country: selected),
    ];

    return Scaffold(

      //appbar
      appBar: AppBar(
        title: Center(
          child: Text(
            currentIndex == 0 ? ' M O V I E S' : 'F A V O R I T E',
          ),
        ),
      ),

      //toggle pages
      body: pages[currentIndex],

      //bottom nav bar
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.purple[300],
        child: Column(
          children: [
            Expanded(
              child: DropdownButton<SCountry>(
                isExpanded: true,
                icon: const SizedBox.shrink(),
                menuMaxHeight: 300,
                dropdownColor: Colors.purple[300],
                value: selected,
                items: buildDropdownItems(),
                onChanged: (SCountry? newValue) {
                  setState(() {
                    selected = newValue!;
                    countryBox.put('country', selected.name);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GNav(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.purple,
                gap: 10,
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                iconSize: 30,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'H O M E',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'F A V O R I T E',
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
