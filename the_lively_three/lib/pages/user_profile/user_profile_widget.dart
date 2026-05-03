import 'package:flutter/material.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
import 'package:the_lively_three/utils/loader_util.dart';

class UserInfoPage extends StatefulWidget {
  static String routeName = 'userProfile';
  static String routePath = '/userProfile';
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();

  // Example controllers
  final TextEditingController _firstNameController =
      TextEditingController(text: "John");
  final TextEditingController _lastNameController =
      TextEditingController(text: "Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@email.com");

  String _selectedTimezone = "UTC+0";
  String _subscriptionPlan = "Free";

  final List<String> _timezones = [
    "UTC-8",
    "UTC-5",
    "UTC+0",
    "UTC+5:30",
    "UTC+8",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: theme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: theme.titleLarge.override(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.secondaryBackground,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  labelStyle: theme.labelMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: theme.bodyMedium,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter first name" : null,
              ),
              const SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  labelStyle: theme.labelMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: theme.bodyMedium,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter last name" : null,
              ),
              const SizedBox(height: 16),

              // Email (read-only)
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: theme.labelMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: theme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Timezone dropdown
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Timezone",
                  labelStyle: theme.labelMedium,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTimezone,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() => _selectedTimezone = value!);
                    },
                    items: _timezones.map((tz) {
                      return DropdownMenuItem(
                        value: tz,
                        child: Text(tz, style: theme.bodyMedium),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subscription plan
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFA8E6CF),
                      Color(0xffD3F4E9),
                      Color(0xFFA8E6CF)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  border: Border.all(color: theme.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subscription: $_subscriptionPlan",
                        style: theme.bodyMedium),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpgradeSubscriptionPage(
                              onSuccess: 'Setting',
                              onFailure: 'Home',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Upgrade",
                        style: theme.labelLarge.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Update button
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primaryText,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18), // left/right padding
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                      50), // button height = 50
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(99), // optional rounded corners
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                  onTap: () async {
                    LoaderUtils.showLoader(context);
                    await authManager.signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w600),
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
