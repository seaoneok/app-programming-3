import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'checkProvider.dart';
import 'navigation.dart';

class Http{
  Future<List<Vaccine>> fetchVaccine() async{
      String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json";
    final response = await http.get(url);
    if(response.statusCode == 200){
      //page = 'Vaccine';
      List<dynamic> body = jsonDecode(response.body);
      List<Vaccine> vaccines = body.map((dynamic item) => Vaccine.fromJson(item)).toList();
      return vaccines;
    } else {
      throw Exception('Failed to load Vaccine Data');
    }
  }
}


class Vaccine{
  String country;
  List<Data> data;

  Vaccine({this.country, this.data});

  factory Vaccine.fromJson(Map<String, dynamic> json){
    var list = json['data'] as List;
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return Vaccine(
        country: json['country'],
        data: dataList
    );
  }
}

class Data {
  String date;
  int total_vaccinations;
  int people_fully_vaccinated;
  int people_vaccinated;
  int daily_vaccinations;

  Data({this.date, this.total_vaccinations, this.people_fully_vaccinated, this.people_vaccinated, this.daily_vaccinations});

  factory Data.fromJson(Map<String, dynamic> json){

    return Data(
        date: json['date'],
        total_vaccinations: json['total_vaccinations'],
        people_fully_vaccinated : json['people_fully_vaccinated'],
        people_vaccinated: json['people_vaccinated'],
        daily_vaccinations: json['daily_vaccinations']
    );
  }
}

class VaccinePage extends StatelessWidget {
  final Http http = Http();
  String txt;

  @override
  Widget build(BuildContext context) {
    final check_Provider page=Provider.of<check_Provider>(context);
    final check_Provider Graphcheck=Provider.of<check_Provider>(context);
    final check_Provider Tablecheck=Provider.of<check_Provider>(context);
    return new Scaffold(
      body:
      SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: 400,
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                ),
                child: FutureBuilder(
                  future: http.fetchVaccine(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Vaccine>> snapshot) {
                    String latestDate;
                    int totalVaccine = 0;
                    int fullyVaccine = 0;
                    int dailyVaccine = 0;

                    if (snapshot.hasData) {
                      List<Vaccine> vaccines = snapshot.data;
                      for(int i=0;i<vaccines.length;i++) {
                        if (vaccines[i].country == 'South Korea') {
                          latestDate = vaccines[i].data[vaccines[i].data.length - 1]
                                  .date;
                        }
                        if (vaccines[i].data[vaccines[i].data.length - 1]
                            .total_vaccinations != null) {
                          totalVaccine  +=
                              vaccines[i].data[vaccines[i].data.length - 1]
                                  .total_vaccinations;
                        }
                        else if (vaccines[i].data[vaccines[i].data.length - 1]
                            .people_fully_vaccinated != null) {
                          totalVaccine  +=
                              vaccines[i].data[vaccines[i].data.length - 1]
                                  .people_fully_vaccinated;
                        }
                        else if (vaccines[i].data[vaccines[i].data.length - 1]
                            .people_vaccinated != null) {
                          totalVaccine  += vaccines[i].data[vaccines[i].data
                              .length - 1].people_vaccinated;
                        }
                        if (vaccines[i].data[vaccines[i].data.length - 1]
                            .people_fully_vaccinated != null) {
                          fullyVaccine +=
                              vaccines[i].data[vaccines[i].data.length - 1]
                                  .people_fully_vaccinated;
                        }
                        else if (vaccines[i].data.length - 2 >= 0 &&
                            vaccines[i].data[vaccines[i].data.length - 2]
                                .people_fully_vaccinated != null) {
                          fullyVaccine +=
                              vaccines[i].data[vaccines[i].data.length - 2]
                                  .people_fully_vaccinated;
                        }
                        else {
                          fullyVaccine += 0;
                        }
                        if (vaccines[i].data[vaccines[i].data.length - 1]
                            .daily_vaccinations != null) {
                          dailyVaccine +=
                              vaccines[i].data[vaccines[i].data.length - 1]
                                  .daily_vaccinations;
                        }
                        else if (vaccines[i].data.length - 2 >= 0 &&
                            vaccines[i].data[vaccines[i].data.length - 2]
                                .daily_vaccinations != null) {
                          dailyVaccine +=
                              vaccines[i].data[vaccines[i].data.length - 2]
                                  .daily_vaccinations;
                        }
                        else {
                          dailyVaccine += 0;
                        }
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Total Vaccine'),
                            Text(totalVaccine.toString() + " people"),
                            Text('Total fully Vacc.'),
                            Text(fullyVaccine.toString() + " people"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('Parsed latest date'),
                            Text(latestDate),
                            Text('Daily Vacc.'),
                            Text(dailyVaccine.toString() + " people"),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 250,
                width: 400,
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                ),
                child: FutureBuilder(
                    future: http.fetchVaccine(),
                    builder: (BuildContext context, AsyncSnapshot<List<Vaccine>> snapshot) {

                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextButton(onPressed: () {
                                Graphcheck.updateGraph("Graph1");
                                print(Graphcheck.Graphcheck);
                              },
                                child: Text("Graph1"),),
                              TextButton(onPressed: () {
                                Graphcheck.updateGraph("Graph2");
                              },
                                child: Text("Graph2"),),
                              TextButton(onPressed: () {
                                Graphcheck.updateGraph("Graph3");
                              },
                                child: Text("Graph3"),),
                              TextButton(onPressed: () {
                                Graphcheck.updateGraph("Graph4");
                              },
                                child: Text("Graph4"),),
                            ],
                          ),
                          Divider(
                            thickness: 2, color: Colors.grey,
                          ),
                          Container(
                            height: 180,
                            width: 300,
                            child: Consumer<check_Provider>(
                            builder:(context,Graphcheck,child)=>
                                Graph(context, snapshot,Graphcheck.Graphcheck),
                          ),)
                        ],
                      );
                    }
                ),
              ),
              Container(
                height: 250,
                width: 400,
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                ),
                child: FutureBuilder(
                    future: http.fetchVaccine(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Vaccine>> snapshot) {
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextButton(onPressed: () {
                                Tablecheck.updateTable("countryName");
                              },
                                child: Text("Country_name"),),
                              TextButton(onPressed: () {
                                Tablecheck.updateTable("totalVacc");
                              },
                                child: Text("Total_vacc"),),
                            ],
                          ),

                          Divider(
                            thickness: 2, color: Colors.grey,
                          ),
                        Container(
                          height: 170,
                          width: 400,
                          child: Consumer<check_Provider>(
                            builder:(context,Tablecheck,child)=>
                                Table(context, snapshot,Tablecheck.Tablecheck),
                          ),)
                        ],
                      );
                    }
                ),
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.list),
          onPressed: () {
            page.updatePage("Vaccine");
              return Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavigationPage()),
              );
            },
      ),
    );
  }


  Widget Table(BuildContext context, AsyncSnapshot snapshot,String txt) {
    if(txt=='countryName') {
      return SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 5.0,
            headingRowHeight: 30.0,
            dataRowHeight: 35.0,
            columns: [
              DataColumn(label: Text('Country')),
              DataColumn(label: Text('total')),
              DataColumn(label: Text('fully')),
              DataColumn(label: Text('daily')),
            ],
            rows: createDataRows1(snapshot),
          ),
        ),
      );
    }
    else if(txt=='totalVacc') {
      return SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 5.0,
            headingRowHeight: 30.0,
            dataRowHeight: 35.0,
            columns: [
              DataColumn(label: Text('Country')),
              DataColumn(label: Text('total')),
              DataColumn(label: Text('fully')),
              DataColumn(label: Text('daily')),
            ],
            rows: createDataRows2(snapshot),
          ),
        ),
      );
    }
    else return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Text('Country', style: TextStyle(fontWeight:FontWeight.bold),),
            Text('total', style: TextStyle(fontWeight:FontWeight.bold)),
            Text('fully', style: TextStyle(fontWeight:FontWeight.bold)),
            Text('daily', style: TextStyle(fontWeight:FontWeight.bold)),
          ]
        ),
    );
  }


  List<DataRow> createDataRows1(AsyncSnapshot<List<Vaccine>> snapshot) {
    List<DataRow> dataRow = [];
    List<Vaccine> vaccines = snapshot.data;
    String a;
    String b;
    String c;

    for (int i = 0; i < 7; i++) {
      List<DataCell> cells = [];
      a = vaccines[i].data[vaccines[i].data.length - 1].total_vaccinations.toString();
      b = vaccines[i].data[vaccines[i].data.length - 1].people_fully_vaccinated.toString();
      c = vaccines[i].data[vaccines[i].data.length - 1].daily_vaccinations.toString();
      cells.add(DataCell(Text(vaccines[i].country)));
      cells.add(DataCell(Text(a)));
      cells.add(DataCell(Text(b)));
      cells.add(DataCell(Text(c)));
      dataRow.add(DataRow(cells: cells));
    }

    return dataRow;
  }

  List<DataRow> createDataRows2(AsyncSnapshot<List<Vaccine>> snapshot) {
    List<DataRow> dataRow = [];
    List<Vaccine> vaccines = snapshot.data;
    String a;
    String b;
    String c;

    for (int i = 0; i < vaccines.length - 1; i++) {
      for (int j = 0; j < vaccines.length - 1 - i; j++) {
        int temp1, temp2;
        if (vaccines[j].data[vaccines[j].data.length - 1].total_vaccinations != null)
          temp1 = vaccines[j].data[vaccines[j].data.length - 1].total_vaccinations;
        else temp1 = vaccines[j].data[vaccines[j].data.length - 2].total_vaccinations;
        if (vaccines[j + 1].data[vaccines[j + 1].data.length - 1].total_vaccinations != null)
          temp2 = vaccines[j + 1].data[vaccines[j + 1].data.length - 1].total_vaccinations;
        else temp2 = vaccines[j + 1].data[vaccines[j + 1].data.length - 2].total_vaccinations;
        if (temp1 < temp2) {
          Vaccine temp;
          temp = vaccines[j];
          vaccines[j] = vaccines[j + 1];
          vaccines[j + 1] = temp;
        }
      }
    }

    for (int i = 0; i < 7; i++) {
      List<DataCell> cells = [];
      a = vaccines[i].data[vaccines[i].data.length - 1].total_vaccinations.toString();
      b = vaccines[i].data[vaccines[i].data.length - 1].people_fully_vaccinated.toString();
      c = vaccines[i].data[vaccines[i].data.length - 1].daily_vaccinations.toString();
      cells.add(DataCell(Text(vaccines[i].country)));
      cells.add(DataCell(Text(a)));
      cells.add(DataCell(Text(b)));
      cells.add(DataCell(Text(c)));
      dataRow.add(DataRow(cells: cells));
    }
    return dataRow;
  }



  Widget Graph(BuildContext context, AsyncSnapshot snapshot,String button) {
    String latestDate;
    List<Vaccine> vaccines = snapshot.data;
    double totalVacc_7 = 0.0;
    double dailyVacc_7 = 0.0;

    double totalVacc_28 = 0.0;
    double dailyVacc_28 = 0.0;

    List<String> x_axis_7 = [];
    List<String> x_axis_tmp_7 = [];
    List<String> x_axis_28 = [];
    List<String> x_axis_tmp_28 = [];
    List<double> y_axis_1 = [];
    List<double> y_axis_2 = [];
    List<double> y_axis_3 = [];
    List<double> y_axis_4 = [];

    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].country == 'South Korea') {
        for (int j = 7; j > 0; j--) {
          if (vaccines[i].data.length - j >= 0) {
            latestDate = vaccines[i].data[vaccines[i].data.length - 1].date;
            x_axis_tmp_7.add(vaccines[i].data[vaccines[i].data.length - j].date);
          }
        }
        break;
      }
    }

    for (int i = 0; i < 7; i++) {
      int idx = x_axis_tmp_7[i].indexOf('-');
      String date = x_axis_tmp_7[i].substring(idx + 1);
      x_axis_7.add(date);
    }

    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].country == 'South Korea') {
        for (int j = 28; j > 0 ; j--) {
          if (vaccines[i].data.length - j >= 0) {
            latestDate = vaccines[i].data[vaccines[i].data.length - 1].date;
            x_axis_tmp_28.add(vaccines[i].data[vaccines[i].data.length - j].date);
          }
        }
        break;
      }
    }

    for (int i = 0; i < 28; i++) {
      int idx = x_axis_tmp_28[i].indexOf('-');
      String date = x_axis_tmp_28[i].substring(idx + 1);
      x_axis_28.add(date);
    }




    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].data[vaccines[i].data.length - 1].date == latestDate) {
        for (int j = 1; j < 8; j++) {
          if (vaccines[i].data.length - j >= 0) {
            if (vaccines[i].data[vaccines[i].data.length - j]
                .total_vaccinations != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j]
                  .total_vaccinations;
            else if (vaccines[i].data[vaccines[i].data.length - j]
                .people_fully_vaccinated != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j]
                  .people_fully_vaccinated;
            else if (vaccines[i].data[vaccines[i].data.length - j]
                .people_vaccinated != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j]
                  .people_vaccinated;
            else
              totalVacc_7 += 0;
            y_axis_1.add(totalVacc_7);
          }
        }
      }
    }
/*
    for(int j = 0; j<7; j++){
      for(int i = 0; i<vaccines.length; i++) {
        if (vaccines[i].data.length - j - 1 >= 0) {
          if (vaccines[i].data[vaccines[i].data.length - 1].date == x_axis_tmp_7[j]) {
            if (vaccines[i].data[vaccines[i].data.length - j - 1].total_vaccinations != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j - 1].total_vaccinations;
            else if (vaccines[i].data[vaccines[i].data.length - j - 1].people_fully_vaccinated != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j - 1].people_fully_vaccinated;
            else if (vaccines[i].data[vaccines[i].data.length - j - 1].people_vaccinated != null)
              totalVacc_7 += vaccines[i].data[vaccines[i].data.length - j - 1].people_vaccinated;
            else
              continue;
          }
          else
            continue;
        }
      }
      y_axis_1.add(totalVacc_7);
    }

 */

    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].data[vaccines[i].data.length - 1].date == latestDate) {
        for (int j = 1; j < 8; j++) {
          if (vaccines[i].data.length - j >= 0) {
            if (vaccines[i].data[vaccines[i].data.length - j]
                .daily_vaccinations != null)
              dailyVacc_7 += vaccines[i].data[vaccines[i].data.length - j]
                  .daily_vaccinations;
            else dailyVacc_7 += 0;
            y_axis_2.add(dailyVacc_7);
            dailyVacc_7 = 0;
          }
          //dailyVacc_7 = 0;
        }
      }
    }
    /*
    for(int j = 0; j<7; j++){
      for(int i = 0; i<vaccines.length; i++) {
        if (vaccines[i].data.length - j - 1 >= 0) {
          if (vaccines[i].data[vaccines[i].data.length - j - 1].date == x_axis_tmp_7[j]) {
            if (vaccines[i].data[vaccines[i].data.length - j - 1].daily_vaccinations != null)
              dailyVacc_7 += vaccines[i].data[vaccines[i].data.length - j - 1].daily_vaccinations;
            else
              continue;
          }
          else
            continue;
        }
      }
      y_axis_2.add(dailyVacc_7);
    }

     */

    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].data[vaccines[i].data.length - 1].date == latestDate) {
        for (int j = 1; j < 29; j++) {
          if (vaccines[i].data.length - j >= 0) {
            if (vaccines[i].data[vaccines[i].data.length - j]
                .total_vaccinations != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j]
                  .total_vaccinations;
            else if (vaccines[i].data[vaccines[i].data.length - j]
                .people_fully_vaccinated != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j]
                  .people_fully_vaccinated;
            else if (vaccines[i].data[vaccines[i].data.length - j ]
                .people_vaccinated != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j]
                  .people_vaccinated;
            else
              totalVacc_28 += 0;
            y_axis_3.add(totalVacc_28);
          }
        }
      }
    }

    /*
    for(int j = 0; j<28; j++){
      for(int i = 0; i<vaccines.length; i++) {
        if (vaccines[i].data.length - j - 1 >= 0) {
          if (vaccines[i].data[vaccines[i].data.length - 1].date == x_axis_tmp_28[j]) {
            if (vaccines[i].data[vaccines[i].data.length - j - 1].total_vaccinations != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j - 1].total_vaccinations;
            else if (vaccines[i].data[vaccines[i].data.length - j - 1].people_fully_vaccinated != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j - 1].people_fully_vaccinated;
            else if (vaccines[i].data[vaccines[i].data.length - j - 1].people_vaccinated != null)
              totalVacc_28 += vaccines[i].data[vaccines[i].data.length - j - 1].people_vaccinated;
            else
              continue;
          }
          else
            continue;
        }
      }
      y_axis_3.add(totalVacc_28);
    }

     */

    for (int i = 0; i < vaccines.length; i++) {
      if (vaccines[i].data[vaccines[i].data.length - 1].date == latestDate) {
        for (int j = 1; j < 29; j++) {
          if (vaccines[i].data.length - j >= 0) {
            if (vaccines[i].data[vaccines[i].data.length - j].daily_vaccinations != null)
              dailyVacc_28 += vaccines[i].data[vaccines[i].data.length - j].daily_vaccinations;
            else dailyVacc_28 += 0;
            y_axis_4.add(dailyVacc_28);
            dailyVacc_28 = 0;
          }
          //dailyVacc_28 = 0;
        }
      }
    }
    /*
    for(int j = 0; j<28; j++){
      for(int i = 0; i<vaccines.length; i++) {
        if (vaccines[i].data.length - j - 1 >= 0) {
          if (vaccines[i].data[vaccines[i].data.length - j - 1].date == x_axis_tmp_28[j]) {
            if (vaccines[i].data[vaccines[i].data.length - j - 1].daily_vaccinations != null)
              dailyVacc_28 += vaccines[i].data[vaccines[i].data.length - j - 1].daily_vaccinations;
            else
              continue;
          }
          else
            continue;
        }
      }
      y_axis_4.add(dailyVacc_28);
    }

     */

    final spots_1 = [
      FlSpot(0, y_axis_1[0]),
      FlSpot(1, y_axis_1[1]),
      FlSpot(2, y_axis_1[2]),
      FlSpot(3, y_axis_1[3]),
      FlSpot(4, y_axis_1[4]),
      FlSpot(5, y_axis_1[5]),
      FlSpot(6, y_axis_1[6]),
    ];

    final spots_2 = [
      FlSpot(0, y_axis_2[0]),
      FlSpot(1, y_axis_2[1]),
      FlSpot(2, y_axis_2[2]),
      FlSpot(3, y_axis_2[3]),
      FlSpot(4, y_axis_2[4]),
      FlSpot(5, y_axis_2[5]),
      FlSpot(6, y_axis_2[6]),
    ];

    final spots_3 = [
      FlSpot(0, y_axis_3[0]),
      FlSpot(1, y_axis_3[1]),
      FlSpot(2, y_axis_3[2]),
      FlSpot(3, y_axis_3[3]),
      FlSpot(4, y_axis_3[4]),
      FlSpot(5, y_axis_3[5]),
      FlSpot(6, y_axis_3[6]),
      FlSpot(7, y_axis_3[7]),
      FlSpot(8, y_axis_3[8]),
      FlSpot(9, y_axis_3[9]),
      FlSpot(10, y_axis_3[10]),
      FlSpot(11, y_axis_3[11]),
      FlSpot(12, y_axis_3[12]),
      FlSpot(13, y_axis_3[13]),
      FlSpot(14, y_axis_3[14]),
      FlSpot(15, y_axis_3[15]),
      FlSpot(16, y_axis_3[16]),
      FlSpot(17, y_axis_3[17]),
      FlSpot(18, y_axis_3[18]),
      FlSpot(19, y_axis_3[19]),
      FlSpot(20, y_axis_3[20]),
      FlSpot(21, y_axis_3[21]),
      FlSpot(22, y_axis_3[22]),
      FlSpot(23, y_axis_3[23]),
      FlSpot(24, y_axis_3[24]),
      FlSpot(25, y_axis_3[25]),
      FlSpot(26, y_axis_3[26]),
      FlSpot(27, y_axis_3[27]),
    ];

    final spots_4 = [
      FlSpot(0, y_axis_4[0]),
      FlSpot(1, y_axis_4[1]),
      FlSpot(2, y_axis_4[2]),
      FlSpot(3, y_axis_4[3]),
      FlSpot(4, y_axis_4[4]),
      FlSpot(5, y_axis_4[5]),
      FlSpot(6, y_axis_4[6]),
      FlSpot(7, y_axis_4[7]),
      FlSpot(8, y_axis_4[8]),
      FlSpot(9, y_axis_4[9]),
      FlSpot(10, y_axis_4[10]),
      FlSpot(11, y_axis_4[11]),
      FlSpot(12, y_axis_4[12]),
      FlSpot(13, y_axis_4[13]),
      FlSpot(14, y_axis_4[14]),
      FlSpot(15, y_axis_4[15]),
      FlSpot(16, y_axis_4[16]),
      FlSpot(17, y_axis_4[17]),
      FlSpot(18, y_axis_4[18]),
      FlSpot(19, y_axis_4[19]),
      FlSpot(20, y_axis_4[20]),
      FlSpot(21, y_axis_4[21]),
      FlSpot(22, y_axis_4[22]),
      FlSpot(23, y_axis_4[23]),
      FlSpot(24, y_axis_4[24]),
      FlSpot(25, y_axis_4[25]),
      FlSpot(26, y_axis_4[26]),
      FlSpot(27, y_axis_4[27]),
    ];

    double minSpotX_1, maxSpotX_1, minSpotX_2, maxSpotX_2;
    double minSpotY_1, maxSpotY_1, minSpotY_2, maxSpotY_2;
    double minSpotX_3, maxSpotX_3, minSpotX_4, maxSpotX_4;
    double minSpotY_3, maxSpotY_3, minSpotY_4, maxSpotY_4;

    minSpotX_1 = spots_1.first.x; maxSpotX_1 = spots_1.first.x; minSpotY_1 = spots_1.first.y; maxSpotY_1 = spots_1.first.y;
    minSpotX_2 = spots_2.first.x; maxSpotX_2 = spots_2.first.x; minSpotY_2 = spots_2.first.y;maxSpotY_2 = spots_2.first.y;

    minSpotX_3 = spots_3.first.x; maxSpotX_3 = spots_3.first.x; minSpotY_3 = spots_3.first.y; maxSpotY_3 = spots_3.first.y;
    minSpotX_4 = spots_4.first.x; maxSpotX_4 = spots_4.first.x; minSpotY_4 = spots_4.first.y;maxSpotY_4 = spots_4.first.y;

    for (var spot in spots_1) {
      if (spot.x > maxSpotX_1) maxSpotX_1 = spot.x;
      if (spot.x < minSpotX_1) minSpotX_1 = spot.x;
      if (spot.y > maxSpotY_1) maxSpotY_1 = spot.y;
      if (spot.y < minSpotY_1) minSpotY_1 = spot.y;
    }

    for (var spot in spots_2) {
      if (spot.x > maxSpotX_2) maxSpotX_2 = spot.x;
      if (spot.x < minSpotX_2) minSpotX_2 = spot.x;
      if (spot.y > maxSpotY_2) maxSpotY_2 = spot.y;
      if (spot.y < minSpotY_2) minSpotY_2 = spot.y;
    }

    for (var spot in spots_3) {
      if (spot.x > maxSpotX_3) maxSpotX_3 = spot.x;
      if (spot.x < minSpotX_3) minSpotX_3 = spot.x;
      if (spot.y > maxSpotY_3) maxSpotY_3 = spot.y;
      if (spot.y < minSpotY_3) minSpotY_3 = spot.y;
    }

    for (var spot in spots_4) {
      if (spot.x > maxSpotX_4) maxSpotX_4 = spot.x;
      if (spot.x < minSpotX_4) minSpotX_4 = spot.x;
      if (spot.y > maxSpotY_4) maxSpotY_4 = spot.y;
      if (spot.y < minSpotY_4) minSpotY_4 = spot.y;
    }

    double reverseY(double y, double minX, double maxX) {
      return (maxX + minX) - y;
    }

    if (button == "Graph1") {
      print(button);
      return LineChart(
        LineChartData(
          gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                final intValue_1 = reverseY(value, minSpotY_1, maxSpotY_1)
                    .toInt();
                if (intValue_1.toInt() == (maxSpotY_1 + minSpotY_1).toInt()) {
                  return false;
                }
                return true;
              }
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots_1,
              isCurved: false,
              barWidth: 3,
              colors: [
                Colors.blueAccent,
              ],
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          maxY: maxSpotY_1 + minSpotY_1,
          minY: 0,

          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                margin: 8,
                getTextStyles: (value) =>
                const TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return x_axis_7[0];
                    case 1:
                      return x_axis_7[1];
                    case 2:
                      return x_axis_7[2];
                    case 3:
                      return x_axis_7[3];
                    case 4:
                      return x_axis_7[4];
                    case 5:
                      return x_axis_7[5];
                    case 6:
                      return x_axis_7[6];
                    default:
                      return '';
                  }
                }
            ),

            leftTitles: SideTitles(
              showTitles: true,
              margin: 16,
              getTextStyles: (value) =>
              const TextStyle(color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ),
      );
    }
    if (button == "Graph2") {
      print(button);
      return LineChart(
        LineChartData(
          gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) {
            final intValue_2 = reverseY(value, minSpotY_2, maxSpotY_2).toInt();
            if (intValue_2.toInt() == (maxSpotY_2 + minSpotY_2).toInt()) return false;
            return true;
          }
          ),
          borderData: FlBorderData(
          show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots_2,
              isCurved: false,
              barWidth: 3,
              colors: [
                Colors.blueAccent,
              ],
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          maxY: maxSpotY_2 + minSpotY_2,
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                margin: 8,
                getTextStyles: (value) => const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                    return x_axis_7[0];
                    case 1:
                    return x_axis_7[1];
                    case 2:
                    return x_axis_7[2];
                    case 3:
                    return x_axis_7[3];
                    case 4:
                    return x_axis_7[4];
                    case 5:
                    return x_axis_7[5];
                    case 6:
                    return x_axis_7[6];
                    default:
                    return '';
                  }
                }
                ),
            leftTitles: SideTitles(
              showTitles: true,
              margin: 16,
              getTextStyles: (value) => const TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ),
      );
    }
    if (button == "Graph3") {
      print(button);
      return LineChart(
        LineChartData(
          gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                final intValue_3 = reverseY(value, minSpotY_3, maxSpotY_3)
                    .toInt();
                if (intValue_3.toInt() == (maxSpotY_3 + minSpotY_3).toInt()) {
                  return false;
                }
                return true;
              }
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots_3,
              isCurved: false,
              barWidth: 3,
              colors: [
                Colors.blueAccent,
              ],
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          maxY: maxSpotY_3 + minSpotY_3,
          minY: 0,

          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                margin: 8,
                getTextStyles: (value) =>
                const TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return x_axis_28[0];
                    case 1:
                      return '';
                    case 2:
                      return '';
                    case 3:
                      return '';
                    case 4:
                      return '';
                    case 5:
                      return '';
                    case 6:
                      return '';
                    case 7:
                      return x_axis_28[7];
                    case 8:
                      return '';
                    case 9:
                      return '';
                    case 10:
                      return '';
                    case 11:
                      return '';
                    case 12:
                      return '';
                    case 13:
                      return '';
                    case 14:
                      return x_axis_28[14];
                    case 15:
                      return '';
                    case 16:
                      return '';
                    case 17:
                      return '';
                    case 18:
                      return '';
                    case 19:
                      return '';
                    case 20:
                      return '';
                    case 21:
                      return '';
                    case 22:
                      return '';
                    case 23:
                      return '';
                    case 24:
                      return '';
                    case 25:
                      return '';
                    case 26:
                      return '';
                    case 27:
                      return x_axis_28[27];
                    default:
                      return '';
                  }
                }
            ),

            leftTitles: SideTitles(
              showTitles: true,
              margin: 16,
              getTextStyles: (value) =>
              const TextStyle(color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ),
      );
    }
    if (button == "Graph4") {
      print(button);
      return LineChart(
        LineChartData(
          gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                final intValue_4 = reverseY(value, minSpotY_4, maxSpotY_4)
                    .toInt();
                if (intValue_4.toInt() == (maxSpotY_4 + minSpotY_4).toInt()) {
                  return false;
                }
                return true;
              }
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots_4,
              isCurved: true,
              barWidth: 3,
              colors: [
                Colors.blueAccent,
              ],
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          maxY: maxSpotY_4 + minSpotY_4,
          minY: 0,

          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                margin: 8,
                getTextStyles: (value) =>
                const TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return x_axis_28[0];
                    case 1:
                      return '';
                    case 2:
                      return '';
                    case 3:
                      return '';
                    case 4:
                      return '';
                    case 5:
                      return '';
                    case 6:
                      return '';
                    case 7:
                      return x_axis_28[7];
                    case 8:
                      return '';
                    case 9:
                      return '';
                    case 10:
                      return '';
                    case 11:
                      return '';
                    case 12:
                      return '';
                    case 13:
                      return '';
                    case 14:
                      return x_axis_28[14];
                    case 15:
                      return '';
                    case 16:
                      return '';
                    case 17:
                      return '';
                    case 18:
                      return '';
                    case 19:
                      return '';
                    case 20:
                      return '';
                    case 21:
                      return '';
                    case 22:
                      return '';
                    case 23:
                      return '';
                    case 24:
                      return '';
                    case 25:
                      return '';
                    case 26:
                      return '';
                    case 27:
                      return x_axis_28[27];
                    default:
                      return '';
                  }
                }
            ),

            leftTitles: SideTitles(
              showTitles: true,
              margin: 16,
              getTextStyles: (value) =>
              const TextStyle(color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ),
      );
    }
    else return Container(
      child: Text("  "),
    );

  }
}


