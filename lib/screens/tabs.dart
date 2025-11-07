import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/provider/filters_provider.dart' as provider;
import 'package:meal_app/screens/catagories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/provider/meals_provider.dart';
import 'package:meal_app/provider/favorites_provider.dart';

// Define initial filter settings using provider.Filter
var kIntialFilters = {
  provider.Filter.glutenFree: false,
  provider.Filter.lactoseFree: false,
  provider.Filter.vegatarian: false,
  provider.Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<provider.Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(provider.filtersProvider);

    // Filter meals based on selected filters
    final availableMeals = meals.where((meal) {
      if (activeFilters[provider.Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[provider.Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[provider.Filter.vegatarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[provider.Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CatagoriesScreen(
      availbleMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals =
          ref.watch(favoritesMealsProvider); // Corrected variable name
      activePage = MealsScreen(
        meals: favoriteMeals, // Corrected reference
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
