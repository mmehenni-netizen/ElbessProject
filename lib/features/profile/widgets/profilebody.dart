import 'package:elbess/core/constants/button.dart';
import 'package:elbess/features/profile/data/profilerepo.dart';
import 'package:elbess/features/profile/data/userprofile.dart';
import 'package:elbess/features/profile/widgets/editprofile.dart';
import 'package:elbess/features/profile/widgets/infocontainer.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Profilebody extends StatefulWidget {
  const Profilebody({super.key});

  @override
  State<Profilebody> createState() => _ProfilebodyState();
}

class _ProfilebodyState extends State<Profilebody> {
  final ProfileRepo _profileRepo = ProfileRepo();
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileRepo.getProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _profileRepo.getProfile();
    });
  }

  String _fullName(UserProfile profile) {
    final value = '${profile.firstName} ${profile.lastName}'.trim();
    if (value.isNotEmpty) {
      return value;
    }
    return profile.username.isNotEmpty ? profile.username : 'Unknown user';
  }

  String _cityFromAddress(String address) {
    final parts = address
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '-';
    }

    return parts.first;
  }

  String _safe(String value, {String fallback = '-'}) {
    return value.trim().isEmpty ? fallback : value.trim();
  }

  String _initials(UserProfile profile) {
    final first = profile.firstName.trim();
    final last = profile.lastName.trim();
    final buffer = StringBuffer();

    if (first.isNotEmpty) {
      buffer.write(first[0].toUpperCase());
    }
    if (last.isNotEmpty) {
      buffer.write(last[0].toUpperCase());
    }

    if (buffer.isNotEmpty) {
      return buffer.toString();
    }

    final username = profile.username.trim();
    if (username.isNotEmpty) {
      return username[0].toUpperCase();
    }

    return 'U';
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Root()),
              );
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 22,
                fontFamily: 'semi',
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _refreshProfile,
          icon: const Icon(Icons.refresh_rounded, size: 20),
        ),
      ],
    );
  }

  Widget _buildProfileContent(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC68B59), Color(0xFF8A5A44)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x228A5A44),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _initials(profile),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'bold',
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        const Gap(16),
        Center(
          child: Text(
            _fullName(profile),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontFamily: 'semi',
            ),
          ),
        ),
        const Gap(4),
        Center(
          child: Text(
            _safe(profile.email),
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontFamily: 'regular',
            ),
          ),
        ),
        const Gap(24),
        const Text(
          'Personal Info',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontFamily: 'semi',
          ),
        ),
        const Gap(12),
        FillInfoContainer(
          label: 'Full name',
          value: _fullName(profile),
          icon: Icons.person_outline_rounded,
        ),
        const Gap(12),
        FillInfoContainer(
          label: 'Phone number',
          value: _safe(profile.phone),
          icon: Icons.phone_outlined,
        ),
        const Gap(12),
        FillInfoContainer(
          label: 'City',
          value: _cityFromAddress(profile.address),
          icon: Icons.location_city_outlined,
        ),
        const Gap(12),
        FillInfoContainer(
          label: 'Address',
          value: _safe(profile.address),
          icon: Icons.home_outlined,
        ),
        const Gap(12),
        FillInfoContainer(
          label: 'Gender',
          value: _safe(profile.gender ?? ''),
          icon: Icons.wc_outlined,
        ),
        const Gap(28),
        CustomButton(
          text: 'Edit Profile',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditProfile()),
            );
            if (!mounted) {
              return;
            }
            _refreshProfile();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: FutureBuilder<UserProfile?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            return RefreshIndicator(
              onRefresh: () async {
                _refreshProfile();
                await _profileFuture;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _buildHeader(context),
                  const Gap(16),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (snapshot.hasError || snapshot.data == null)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE7EAF0)),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person_off_outlined,
                            size: 40,
                            color: Color(0xFF9CA3AF),
                          ),
                          const Gap(10),
                          const Text(
                            'Could not load profile data',
                            style: TextStyle(
                              fontFamily: 'semi',
                              color: Color(0xFF111827),
                            ),
                          ),
                          const Gap(6),
                          const Text(
                            'Pull down to retry or tap refresh above.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    _buildProfileContent(snapshot.data!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}