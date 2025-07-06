
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../component/popup.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../provider/pet/pet_provider.dart';
import '../../../provider/pet/owned_provider.dart';
import '../../../provider/pet/wish_provider.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import 'home/browse/browse.dart';
import 'home/home.dart';
import 'home/pet/pet.dart';
import 'home/rank/rank.dart';
import 'home/wish/wish.dart';

class IZoo extends StatefulWidget {

  @override
  _IZooState createState() =>  _IZooState();
}

class _IZooState extends State<IZoo> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      
      // Trigger refresh for the selected tab
      _refreshCurrentTab();
    }
  }

  void _refreshCurrentTab() async {
    // Add haptic feedback for tab selection
    HapticFeedback.selectionClick();
    
    setState(() {
      _isRefreshing = true;
    });
    
    switch (_currentTabIndex) {
      case 0:
        // Refresh Home tab - trigger all pet-related providers
        print('Refreshing Home tab');
        await _refreshHomeTab();
        break;
      case 1:
        // Refresh Browse tab
        print('Refreshing Browse tab');
        await _refreshBrowseTab();
        break;
      case 2:
        // Refresh Rankings tab
        print('Refreshing Rankings tab');
        await _refreshRankTab();
        break;
    }
    
    // Add a small delay to show refresh feedback
    await Future.delayed(Duration(milliseconds: 300));
    
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshHomeTab() async {
    // Refresh all pet-related providers for Home tab
    if (mounted) {
      await Future.wait([
        Future(() => Provider.of<IPetProvider>(context, listen: false).refresh('', false)),
        Future(() => Provider.of<IOwnedProvider>(context, listen: false).refresh('', false)),
        Future(() => Provider.of<IWishProvider>(context, listen: false).refresh('', false)),
      ]);
    }
  }

  Future<void> _refreshBrowseTab() async {
    // Add specific refresh logic for Browse tab if needed
    if (mounted) {
      // You can add browse-specific provider refreshes here
      print('Browse tab refreshed');
      // Simulate refresh delay
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> _refreshRankTab() async {
    // Add specific refresh logic for Rankings tab if needed
    if (mounted) {
      // You can add ranking-specific provider refreshes here
      print('Rankings tab refreshed');
      // Simulate refresh delay
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color.xPrimaryColor,
        title: Transform(
          transform: Matrix4.translationValues(10, 0.0, 0.0),
          child: SizedBox(
            width: 310.w,
            height: 120.h,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Text('Friend Zoo',
                  style: GoogleFonts.poppins(
                    color: color.xTrailing, 
                    fontSize: FONT_APP_BAR, 
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: color.xSecondaryColor
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            Tab(child: Text("Home", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
            Tab(child: Text("Browse", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
            Tab(child: Text("Rankings", style: TextStyle(fontSize: FONT_MEDIUM, fontWeight: FontWeight.bold))),
          ],
          labelColor: color.xTextColor,
          unselectedLabelColor: color.xTextColorTertiary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: color.xTrailing),
          ),
          dividerHeight: 0,
          dividerColor: color.xPrimaryColor,
          labelStyle: TextStyle(overflow: TextOverflow.clip),
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (index) {
            print('Tab $index tapped');
            // Manual refresh trigger on tap (optional)
            if (index == _currentTabIndex && !_isRefreshing) {
              _refreshCurrentTab();
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          IPetHome(key: ValueKey('home_tab_$_currentTabIndex')),
          IBrowse(key: ValueKey('browse_tab_$_currentTabIndex')),
          IRank(key: ValueKey('rank_tab_$_currentTabIndex')),
        ],
      ),
    );
  }
}