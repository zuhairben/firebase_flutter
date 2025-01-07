import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TeamActivityPage extends StatefulWidget {
  @override
  _TeamActivityPageState createState() => _TeamActivityPageState();
}

class _TeamActivityPageState extends State<TeamActivityPage> {
  String selectedTimePeriod = 'Last Week'; // Default filter option
  Map<String, dynamic>? teamMetrics; // To store fetched metrics (nullable)

  @override
  void initState() {
    super.initState();
    _fetchTeamMetrics(); // Fetch metrics when the page loads
  }

  Future<void> _fetchTeamMetrics() async {
    // Simulate fetching data
    await Future.delayed(Duration(seconds: 2)); // Simulate delay

    // Mock data for demonstration
    final mockData = {
      'completionRate': 75.0, // 75% tasks completed
      'overdueTasks': [2, 3, 1], // Overdue tasks per team member
      'tasksOverTime': [10, 15, 20], // Weekly task completion trend
    };

    // Update the state with the fetched data
    setState(() {
      teamMetrics = mockData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Activity'),
      ),
      body: teamMetrics == null
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Team Performance Metrics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Filters (Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Time Period:'),
                DropdownButton<String>(
                  value: selectedTimePeriod,
                  items: ['Last Week', 'Last Month', 'All Time']
                      .map(
                        (period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTimePeriod = value!;
                      _fetchTeamMetrics(); // Fetch data for the selected period
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Completion Rate Pie Chart
            Text(
              'Completion Rate',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: CompletionRatePieChart(
                  completionRate: teamMetrics!['completionRate'] ?? 0.0),
            ),

            const SizedBox(height: 16),

            // Overdue Tasks Bar Chart
            Text(
              'Overdue Tasks by Team Member',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: OverdueTasksBarChart(
                  overdueTasks:
                  teamMetrics!['overdueTasks']?.cast<int>() ?? []),
            ),

            const SizedBox(height: 16),

            // Task Trends Line Chart
            Text(
              'Task Completion Trend Over Time',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: TaskTrendsLineChart(
                  tasksOverTime:
                  teamMetrics!['tasksOverTime']?.cast<int>() ?? [0]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pie Chart Widget for Completion Rate
class CompletionRatePieChart extends StatelessWidget {
  final double completionRate;

  const CompletionRatePieChart({Key? key, required this.completionRate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: completionRate,
            color: Colors.green,
            title: '${completionRate.toStringAsFixed(1)}%',
            titleStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: 100 - completionRate,
            color: Colors.grey[300],
            title: '',
          ),
        ],
        centerSpaceRadius: 40,
      ),
    );
  }
}

/// Bar Chart Widget for Overdue Tasks
class OverdueTasksBarChart extends StatelessWidget {
  final List<int> overdueTasks;

  const OverdueTasksBarChart({Key? key, required this.overdueTasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: overdueTasks
            .asMap()
            .entries
            .map((entry) => BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: Colors.red,
              width: 16,
            ),
          ],
        ))
            .toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text('Member ${value.toInt() + 1}');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

/// Line Chart Widget for Task Trends
class TaskTrendsLineChart extends StatelessWidget {
  final List<int> tasksOverTime;

  const TaskTrendsLineChart({Key? key, required this.tasksOverTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: tasksOverTime
                .asMap()
                .entries
                .map((entry) =>
                FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                .toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
            barWidth: 4,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text('Week ${value.toInt() + 1}');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
