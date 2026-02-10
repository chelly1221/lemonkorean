import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/sns_user_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/social_provider.dart';
import 'widgets/user_search_card.dart';

/// User search and discovery screen with debounced search
class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  List<SnsUserModel> _searchResults = [];
  List<SnsUserModel> _suggestedUsers = [];
  bool _isSearching = false;
  bool _isLoadingSuggestions = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestedUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();

    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(_searchController.text.trim());
    });
  }

  Future<void> _loadSuggestedUsers() async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    final socialProvider =
        Provider.of<SocialProvider>(context, listen: false);
    final users = await socialProvider.getSuggestedUsers();

    if (mounted) {
      setState(() {
        _suggestedUsers = users;
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    final socialProvider =
        Provider.of<SocialProvider>(context, listen: false);
    final results = await socialProvider.searchUsersQuery(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSearchEmpty = _searchController.text.trim().isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.findFriends ?? 'Find Friends'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(l10n),

          // Content
          Expanded(
            child: isSearchEmpty
                ? _buildSuggestedSection(l10n)
                : _buildSearchResults(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: l10n?.searchUsers ?? 'Search users...',
          hintStyle: const TextStyle(
            color: AppConstants.textHint,
            fontSize: AppConstants.fontSizeMedium,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppConstants.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppConstants.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
        ),
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
        ),
      ),
    );
  }

  Widget _buildSuggestedSection(AppLocalizations? l10n) {
    if (_isLoadingSuggestions) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.primaryColor,
          ),
        ),
      );
    }

    if (_suggestedUsers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                l10n?.noSuggestions ??
                    'No suggestions available. Try searching for users!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeNormal,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: AppConstants.paddingSmall),
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: Text(
            l10n?.suggestedUsers ?? 'Suggested Users',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: AppConstants.textSecondary,
            ),
          ),
        ),

        // Suggested user cards
        ...List.generate(_suggestedUsers.length, (index) {
          return UserSearchCard(
            user: _suggestedUsers[index],
          ).animate().fadeIn(
                duration: 200.ms,
                delay: Duration(milliseconds: (index * 40).clamp(0, 300)),
              );
        }),

        const SizedBox(height: AppConstants.paddingLarge),
      ],
    );
  }

  Widget _buildSearchResults(AppLocalizations? l10n) {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.primaryColor,
          ),
          strokeWidth: 2,
        ),
      );
    }

    if (_hasSearched && _searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                l10n?.noResults ?? 'No users found',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeNormal,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppConstants.paddingSmall,
        bottom: AppConstants.paddingLarge,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return UserSearchCard(
          user: _searchResults[index],
        ).animate().fadeIn(
              duration: 200.ms,
              delay: Duration(milliseconds: (index * 40).clamp(0, 200)),
            );
      },
    );
  }
}
