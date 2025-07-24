import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:niklaar/app/view/widgets/button/action_button.dart';
import 'package:niklaar/app/view/widgets/niklaar_icon.dart';
import 'package:niklaar/core/constants/navigators/routeName.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/input/search_text_input.dart';
import '../../../../core/constants/app_colors.dart';
import 'create_account_page.dart';

class SelectCountryPage extends StatefulWidget {
  const SelectCountryPage({super.key});

  @override
  State<SelectCountryPage> createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Country> _countries = [];
  List<Country> _filteredCountries = [];

  String _searchText = "";
  Country? _selectedCountry;

  @override
  initState() {
    super.initState;
    _getCountries();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  _getCountries() async {
    final countryList = await getAllCountries();
    setState(() {
      _countries = countryList;
    });

    Logger().d("Countries Length ${_countries.length}");
  }

  _search() {
    _getCountries();
    setState(() {
      if (_searchController.text.trim().isNotEmpty) {
        _filteredCountries = _countries
            .where((country) => country.name
                .toLowerCase()
                .contains(_searchController.text.trim().toLowerCase()))
            .toList();
      } else {
        _filteredCountries = _countries;
      }
    });

    Logger().d(
        "Search Text: ${_searchController.text}, Countries Length: ${_filteredCountries.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: NiklaarIcon(
          width: 39.6,
          height: 28,
          opacity: 0,
        ),
        automaticallyImplyLeading: true,
        titleSpacing: 24.w,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                overlayColor: AppColors.black25,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Sign In",
                  style: TextStyles.normalRegular14(context).copyWith(
                    color: AppColors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 15.h,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Select your Country",
              style: TextStyles.titleSemiBold20(context),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: _selectedCountry != null
                ? _buildSelectedCountryField(context)
                : SearchTextInput(
                    hintText: "Search Country",
                    controller: _searchController,
                    focusNode: _searchFocusNode, // ← pass it in
                    autofocus: true,
                    onChanged: (value) {
                      setState(() => _searchText = value);
                      _search();
                    },
                  ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 14.h,
                      ),
                    ],
                  ),
                ),
                if (_searchController.text.trim().isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: _filteredCountries.length,
                      (ctx, idx) {
                        if (idx.isOdd) {
                          return SizedBox(
                            height: 12.h,
                          );
                        }

                        Country country = _filteredCountries[idx];

                        final showLabel = idx == 0 ||
                            country.name[0] !=
                                _filteredCountries[idx - 1].name[0];

                        return _buildCountryTile(
                          context,
                          country: country,
                          showLabel: showLabel,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (_searchController.text.trim().isEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    RouteName.createAccountPage,
                    arguments: CreateAccountPageParam(
                      country: _selectedCountry!,
                    ),
                  );
                },
                waiting: _selectedCountry != null,
                text: "Continue",
              ),
            ),
            SizedBox(
              height: 45 + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedCountryField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = _selectedCountry!.name;
          _selectedCountry = null;
        });
      },
      child: Container(
        height: 41.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 1.w,
            color: AppColors.grey,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Row(
          spacing: 12.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: _selectedCountry!.flag,
                style: TextStyles.titleSemiBold20(context),
              ),
            ),
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: _selectedCountry!.name,
                  style: TextStyles.normalRegular14(context),
                ),
              ),
            ),
            Icon(
              Icons.search,
              size: 16.h,
              color: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildCountryTile(
    BuildContext context, {
    required Country country,
    required bool showLabel,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCountry = country;
          _searchController.clear();
        });
      },
      child: Ink(
        height: 40.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.w,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: country.flag,
                style: TextStyles.titleSemiBold20(context),
              ),
            ),
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: country.name,
                  style: TextStyles.normalRegular14(context),
                ),
              ),
            ),
            if (showLabel)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: country.name[0],
                  style: TextStyles.normalSemibold14(context).copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
