import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FootballMatch> _matchList = [];
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Football Live Scores',
          style: TextStyle(color: Colors.black87,)),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('football').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshots.hasError) {
            return Center(child: Text(snapshots.error.toString()));
          } else if (snapshots.hasData) {
            _matchList.clear();

            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in snapshots.data!.docs) {
              _matchList.add(
                FootballMatch(
                  id: doc.id,
                  team1: doc.get('team1_name'),
                  team1Score: doc.get('team1_score'),
                  team2: doc.get('team2_name'),
                  team2Score: doc.get('team2_score'),
                  isRunning: doc.get('is_running'),
                  winner: doc.get('winner_team'),
                ),
              );
            }

            return ListView.builder(
              itemCount: _matchList.length,
              itemBuilder: (context, index) {
                final footballMatch = _matchList[index];
                return Card(




                  child: ListTile(


                    leading: CircleAvatar(
                      backgroundColor: footballMatch.isRunning
                          ? Colors.green
                          : Colors.grey,
                      radius: 8,
                    ),
                    title: Column(
                      children: [
                        Text(
                          '${footballMatch.team1}  ${footballMatch.team1Score} - ${footballMatch.team2Score} '
                              ' ${footballMatch.team2}',
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // trailing: Text(
                    //   '${footballMatch.team1Score} - ${footballMatch.team2Score}',
                    // ),
                    subtitle: Center(
                      child: Text(
                        'Winner: ${footballMatch.isRunning ? 'Pending' : footballMatch.winner}',
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // FirebaseFirestore.instance.collection('football')
          //     .doc('usavschina')
          //     .set({
          //   'team1_name': 'USA',
          //   'team1_score': 0,
          //   'team2_name': 'China',
          //   'team2_score': 2,
          //   'winner_team': '',
          //   'is_running': true,
          // });
          FirebaseFirestore.instance.collection('football')
              .doc('usavschina')
              .delete();
       },
       ),
    );
  }
}

class FootballMatch {
  final String id;
  final String team1;
  final int team1Score;
  final String team2;
  final int team2Score;
  final bool isRunning;
  final String winner;

  FootballMatch({
    required this.id,
    required this.team1,
    required this.team1Score,
    required this.team2,
    required this.team2Score,
    required this.isRunning,
    required this.winner,
  });
}