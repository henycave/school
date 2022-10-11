import 'package:flutter/material.dart';
import 'package:school/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GradeScreen extends StatefulWidget {
  static const String id = 'grade_screen';
  final String studentDocumentId;

  GradeScreen({this.studentDocumentId});

  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  final _firestore = FirebaseFirestore.instance;

  final List<Map<String, String>> listOfColumns = [
    {'subject': 'non', '40': '0', '60': '0', 'Total': '0'},
    {'subject': 'non', '40': '0', '60': '0', 'Total': '0'},
    {'subject': 'non', '40': '0', '60': '0', 'Total': '0'},
    {'subject': 'non', '40': '0', '60': '0', 'Total': '0'},
    {'subject': 'non', '40': '0', '60': '0', 'Total': '0'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.teal,
            child: SafeArea(
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'First Quarter',
                  ),
                  Tab(
                    text: 'Second Quarter',
                  ),
                  Tab(
                    text: 'Third Quarter',
                  ),
                  Tab(
                    text: 'Fourth Quarter',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 50),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('result')
                      .where('student', isEqualTo: widget.studentDocumentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                    final documents = snapshot.data.docs;
                    if (documents.isEmpty) {
                      print('no data');
                      return DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '60',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '40',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total',
                              style: kTableTextStyle,
                            ),
                          ),
                        ],
                        rows: listOfColumns
                            .map(((element) => DataRow(cells: [
                                  DataCell(
                                    Text(
                                      element['subject'],
                                      style: kTableCellTextStyle,
                                    ),
                                  ),
                                  DataCell(Text(
                                    element['60'],
                                  )),
                                  DataCell(Text(
                                    element['40'],
                                  )),
                                  DataCell(
                                    Text(
                                      element['Total'],
                                    ),
                                  ),
                                ])))
                            .toList(),
                      );
                    }

                    List<Map<String, String>> tableContent = [];
                    for (var document in documents) {
                      int total = int.parse(
                              document.data()['firstQuar']['40'].toString()) +
                          int.parse(
                              document.data()['firstQuar']['60'].toString());
                      tableContent.add({
                        'subject': document.data()['subjectName'],
                        '40': document.data()['firstQuar']['40'],
                        '60': document.data()['firstQuar']['60'],
                        'Total': '$total'
                      });
                    }
                    return DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '60',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '40',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: kTableTextStyle,
                          ),
                        ),
                      ],
                      rows: tableContent
                          .map(((element) => DataRow(cells: [
                                DataCell(
                                  Text(
                                    element['subject'],
                                    style: kTableCellTextStyle,
                                  ),
                                ),
                                DataCell(Text(
                                  element['60'],
                                )),
                                DataCell(Text(
                                  element['40'],
                                )),
                                DataCell(
                                  Text(
                                    element['Total'],
                                  ),
                                ),
                              ])))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 50),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('result')
                      .where('student', isEqualTo: widget.studentDocumentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                    final documents = snapshot.data.docs;
                    if (documents.isEmpty) {
                      return DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '60',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '40',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total',
                              style: kTableTextStyle,
                            ),
                          ),
                        ],
                        rows: listOfColumns
                            .map(((element) => DataRow(cells: [
                                  DataCell(
                                    Text(
                                      element['subject'],
                                      style: kTableCellTextStyle,
                                    ),
                                  ),
                                  DataCell(Text(
                                    element['60'],
                                  )),
                                  DataCell(Text(
                                    element['40'],
                                  )),
                                  DataCell(
                                    Text(
                                      element['Total'],
                                    ),
                                  ),
                                ])))
                            .toList(),
                      );
                    }

                    List<Map<String, String>> tableContent = [];
                    for (var document in documents) {
                      if (document.data()['secondQuar'] == null) {
                        tableContent.add({
                          'subject': 'non',
                          '40': '0',
                          '60': '0',
                          'Total': '0',
                        });
                      } else {
                        double total = double.parse(document
                                .data()['secondQuar']['40']
                                .toString()) +
                            double.parse(
                                document.data()['secondQuar']['60'].toString());
                        tableContent.add({
                          'subject': document.data()['subjectName'],
                          '40': document.data()['secondQuar']['40'],
                          '60': document.data()['secondQuar']['60'],
                          'Total': '$total'
                        });
                      }
                    }
                    return DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '60',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '40',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: kTableTextStyle,
                          ),
                        ),
                      ],
                      rows: tableContent
                          .map(((element) => DataRow(cells: [
                                DataCell(
                                  Text(
                                    element['subject'],
                                    style: kTableCellTextStyle,
                                  ),
                                ),
                                DataCell(Text(
                                  element['60'],
                                )),
                                DataCell(Text(
                                  element['40'],
                                )),
                                DataCell(
                                  Text(
                                    element['Total'],
                                  ),
                                ),
                              ])))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 50),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('result')
                      .where('student', isEqualTo: widget.studentDocumentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                    final documents = snapshot.data.docs;
                    if (documents.isEmpty) {
                      return DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '60',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '40',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total',
                              style: kTableTextStyle,
                            ),
                          ),
                        ],
                        rows: listOfColumns
                            .map(((element) => DataRow(cells: [
                                  DataCell(
                                    Text(
                                      element['subject'],
                                      style: kTableCellTextStyle,
                                    ),
                                  ),
                                  DataCell(Text(
                                    element['60'],
                                  )),
                                  DataCell(Text(
                                    element['40'],
                                  )),
                                  DataCell(
                                    Text(
                                      element['Total'],
                                    ),
                                  ),
                                ])))
                            .toList(),
                      );
                    }

                    List<Map<String, String>> tableContent = [];
                    for (var document in documents) {
                      if (document.data()['thirdQuar'] == null) {
                        tableContent.add({
                          'subject': 'non',
                          '40': '0',
                          '60': '0',
                          'Total': '0',
                        });
                      } else {
                        double total = double.parse(
                                document.data()['thirdQuar']['40'].toString()) +
                            double.parse(
                                document.data()['thirdQuar']['60'].toString());
                        tableContent.add({
                          'subject': document.data()['subjectName'],
                          '40': document.data()['thirdQuar']['40'],
                          '60': document.data()['thirdQuar']['60'],
                          'Total': '$total'
                        });
                      }
                    }
                    return DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '60',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '40',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: kTableTextStyle,
                          ),
                        ),
                      ],
                      rows: tableContent
                          .map(((element) => DataRow(cells: [
                                DataCell(
                                  Text(
                                    element['subject'],
                                    style: kTableCellTextStyle,
                                  ),
                                ),
                                DataCell(Text(
                                  element['60'],
                                )),
                                DataCell(Text(
                                  element['40'],
                                )),
                                DataCell(
                                  Text(
                                    element['Total'],
                                  ),
                                ),
                              ])))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 50),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('result')
                      .where('student', isEqualTo: widget.studentDocumentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                    final documents = snapshot.data.docs;
                    if (documents.isEmpty) {
                      return DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '60',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '40',
                              style: kTableTextStyle,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total',
                              style: kTableTextStyle,
                            ),
                          ),
                        ],
                        rows: listOfColumns
                            .map(((element) => DataRow(cells: [
                                  DataCell(
                                    Text(
                                      element['subject'],
                                      style: kTableCellTextStyle,
                                    ),
                                  ),
                                  DataCell(Text(
                                    element['60'],
                                  )),
                                  DataCell(Text(
                                    element['40'],
                                  )),
                                  DataCell(
                                    Text(
                                      element['Total'],
                                    ),
                                  ),
                                ])))
                            .toList(),
                      );
                    }

                    List<Map<String, String>> tableContent = [];
                    for (var document in documents) {
                      if (document.data()['fourthQuar'] == null) {
                        tableContent.add({
                          'subject': 'non',
                          '40': '0',
                          '60': '0',
                          'Total': '0',
                        });
                      } else {
                        double total = double.parse(document
                                .data()['fourthQuar']['40']
                                .toString()) +
                            double.parse(
                                document.data()['fourthQuar']['60'].toString());
                        tableContent.add({
                          'subject': document.data()['subjectName'],
                          '40': document.data()['fourthQuar']['40'],
                          '60': document.data()['fourthQuar']['60'],
                          'Total': '$total'
                        });
                      }
                    }
                    return DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '60',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '40',
                            style: kTableTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: kTableTextStyle,
                          ),
                        ),
                      ],
                      rows: tableContent
                          .map(((element) => DataRow(cells: [
                                DataCell(
                                  Text(
                                    element['subject'],
                                    style: kTableCellTextStyle,
                                  ),
                                ),
                                DataCell(Text(
                                  element['60'],
                                )),
                                DataCell(Text(
                                  element['40'],
                                )),
                                DataCell(
                                  Text(
                                    element['Total'],
                                  ),
                                ),
                              ])))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
