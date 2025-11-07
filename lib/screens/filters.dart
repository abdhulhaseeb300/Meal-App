import 'package:flutter/material.dart';
import 'package:meal_app/screens/tabs.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/provider/filters_provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<provider.Filter, bool> currentFilters;

  @override
  ConsumerState<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  late bool _glutenFreeFilterSet;
  late bool _lactoseFreeFilterSet;
  late bool _vegetarianFilterSet;
  late bool _veganFilterSet;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final activeFilters = ref.read(provider.filtersProvider);
    _glutenFreeFilterSet = activeFilters[provider.Filter.glutenFree]!;
    _lactoseFreeFilterSet = activeFilters[provider.Filter.lactoseFree]!;
    _vegetarianFilterSet = activeFilters[provider.Filter.vegatarian]!;
    _veganFilterSet = activeFilters[provider.Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      drawer: MainDrawer(onSelectScreen: (identifier) {
        Navigator.of(context).pop();
        if (identifier == 'meals') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const TabsScreen(),
            ),
          );
        }
      }),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          ref.read(provider.filtersProvider.notifier).setFilters({
            provider.Filter.glutenFree: _glutenFreeFilterSet,
            provider.Filter.lactoseFree: _lactoseFreeFilterSet,
            provider.Filter.vegatarian: _vegetarianFilterSet,
            provider.Filter.vegan: _veganFilterSet,
          });
          return true;
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _glutenFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'Gluten-Free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                'Only include gluten-free meals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _lactoseFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _lactoseFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'Lactose-Free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                'Only include lactose-free meals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _vegetarianFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _vegetarianFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                'Only include vegetarian meals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _veganFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                'Only include vegan meals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
