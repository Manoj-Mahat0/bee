import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'dart:ui';

class GymDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> gym;

  GymDetailsScreen({required this.gym});

  @override
  _GymDetailsScreenState createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen> {
  bool isMonthlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gym['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      //extendBodyBehindAppBar: true,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        type: ExpandableFabType.fan,
        children: [
          _buildActionFab(
            icon: Icons.share,
            label: 'Share',
            onPressed: () {
              Share.share(
                'Check out this gym: ${widget.gym['name']}! Visit us for great workouts and facilities!',
              );
            },
          ),
          _buildActionFab(
            icon: Icons.phone,
            label: 'Call',
            onPressed: _launchPhone,
          ),
          _buildActionFab(
            icon: Icons.email,
            label: 'Sms',
            onPressed: _launchSMS,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(widget.gym['images']),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.tealAccent, width: 2), // Border color and width
                                borderRadius: BorderRadius.circular(8), // Rounded corners
                                color: Colors.black.withOpacity(0.2), // Slight transparency for the glass effect
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.gym['description'],
                                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                                  ),
                                  SizedBox(height: 20),
                                  _buildSectionHeader('Contact Information'),
                                  Text('Phone: ${widget.gym['contact']}', style: _detailTextStyle()),
                                  Text('Address: ${widget.gym['location']}', style: _detailTextStyle()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('Membership Plans'),
                            // Add your membership plans here
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: isMonthlySelected,
                      first: true,
                      second: false,
                      spacing: 50.0,
                      style: const ToggleStyle(
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      borderWidth: 5.0,
                      height: 50,
                      styleBuilder: (isMonthly) => ToggleStyle(
                        indicatorColor: isMonthly ? Colors.tealAccent : Colors.tealAccent,
                      ),
                      iconBuilder: (isMonthly) => isMonthly
                          ? const Icon(Icons.calendar_month)
                          : const Icon(Icons.calendar_today),
                      textBuilder: (isMonthly) => Center(
                        child: Text(
                          isMonthly ? 'Monthly' : 'Yearly',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onChanged: (isMonthly) => setState(() => isMonthlySelected = isMonthly),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: _buildMembershipPlan(
                    context,
                    isMonthlySelected ? widget.gym['monthlyPlans'] : widget.gym['yearlyPlans'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFab({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: label,
      onPressed: onPressed,
      backgroundColor: Colors.tealAccent,
      child: Icon(icon, color: Colors.black),
    );
  }

  void _launchPhone() async {
    final Uri launchUri = Uri(scheme: 'tel', path: widget.gym['contact']);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void _launchSMS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.gym['contact'],
      query: Uri.encodeFull('body=Inquiry about ${widget.gym['name']}'),
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Widget _buildImageCarousel(List<dynamic> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.easeInOut,
      ),
      items: images.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMembershipPlan(BuildContext context, List<dynamic> plans) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final double price = plan['price'] is int ? (plan['price'] as int).toDouble() : plan['price'];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            color: Colors.grey[800]?.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(plan['name'], style: TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text(plan['category'], style: TextStyle(color: Colors.grey[400])),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text('Pay ₹${price.toStringAsFixed(2)}'),
                onPressed: () => _showPaymentDialog(context, plan['name'], price),
              ),
            ),
          ),
        );
      },
    );
  }
  void _showPaymentDialog(BuildContext context, String planName, double price) {
    final upiDetails = UPIDetails(
      upiID: "hackpedia0071@ybl",
      payeeName: widget.gym['name'],
      amount: price,
      transactionNote: 'Payment for $planName membership',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Confirm Payment',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You are about to pay ₹${price.toStringAsFixed(2)} for the $planName plan.',
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 20),
              UPIPaymentQRCode(
                upiDetails: upiDetails,
                size: 200,
                upiQRErrorCorrectLevel: UPIQRErrorCorrectLevel.high,
                embeddedImageSize: const Size(60, 60),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: Colors.white,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Scan the QR code to proceed with the payment.",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  TextStyle _detailTextStyle() {
    return TextStyle(color: Colors.grey[300], fontSize: 16);
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
      ),
    );
  }
}
