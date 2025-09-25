import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/restock_screen.dart';
import 'package:myapp/utils/time_ago.dart';
import 'package:provider/provider.dart';
import 'package:myapp/api/api_service.dart';
import 'package:myapp/models/dashboard_stats.dart';
import 'package:myapp/models/machine.dart';
import 'package:myapp/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  Future<DashboardStats>? _dashboardStats;
  Future<List<Machine>>? _machines;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _dashboardStats = _fetchDashboardStats();
      _machines = _fetchMachines();
    });
  }

  Future<DashboardStats> _fetchDashboardStats() async {
    final data = await _apiService.getDashboardStats();
    return DashboardStats.fromJson(data);
  }

  Future<List<Machine>> _fetchMachines() async {
    final data = await _apiService.getMachines();
    return (data as List).map((machine) => Machine.fromJson(machine)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ivend',
          style: GoogleFonts.oswald(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildStatsSection(),
              const SizedBox(height: 32),
              Text(
                'Machine Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildMachinesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<DashboardStats>(
      future: _dashboardStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading stats'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No stats available'));
        }

        final stats = snapshot.data!;

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              'Machines',
              stats.totalMachines.toString(),
              Icons.memory,
              Colors.blue.shade700,
              Colors.blue.shade200,
              () {},
            ),
            _buildStatCard(
              'Online',
              stats.onlineMachines.toString(),
              Icons.check_circle,
              Colors.green.shade700,
              Colors.green.shade200,
              () {},
            ),
            _buildStatCard(
              'Offline',
              stats.offlineMachines.toString(),
              Icons.cancel,
              Colors.red.shade700,
              Colors.red.shade200,
              () {},
            ),
            _buildStatCard(
              'To Restock',
              stats.shortageProductsCount.toString(),
              Icons.warning,
              Colors.orange.shade700,
              Colors.orange.shade200,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestockScreen(shortageProducts: stats.shortageProducts),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMachinesSection() {
    return FutureBuilder<List<Machine>>(
      future: _machines,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading machines'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No machines found'));
        }

        final machines = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            final machine = machines[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ExpansionTile(
                leading: Icon(
                  machine.isOnline ? Icons.power_settings_new : Icons.power_off,
                  color: machine.isOnline
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                ),
                title: Text(
                  machine.name,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Last updated: ${timeAgo(machine.lastUpdate)}',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${machine.temperature}°C',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      machine.isOnline ? 'Online' : 'Offline',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: machine.isOnline
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                            'Machine Number', machine.machineNumber, Icons.qr_code),
                        _buildDetailRow('Temperature',
                            '${machine.temperature}°C', Icons.thermostat),
                        _buildDetailRow(
                            'Status',
                            machine.isOnline ? 'Online' : 'Offline',
                            machine.isOnline
                                ? Icons.check_circle
                                : Icons.cancel),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go('/products', extra: machine);
                          },
                          icon: const Icon(Icons.inventory_2),
                          label:
                              Text('View Products', style: GoogleFonts.inter()),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color startColor,
    Color endColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.8), endColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(icon, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: GoogleFonts.oswald(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
