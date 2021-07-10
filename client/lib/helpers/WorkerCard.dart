import 'package:client/models/Shift.dart';
import 'package:client/screens/shiftDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkerCard extends StatefulWidget {
  final Shift shift;

  const WorkerCard({Key? key, required this.shift}) : super(key: key);

  @override
  _WorkerCardState createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  void getDetail() => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShiftDetail()),
        )
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 170,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  //decoration: BoxDecoration(color: Colors.greenAccent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.shift.worker.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "${DateFormat('yyyy-MM-dd').format(widget.shift.date)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(119, 125, 120, 0.8),
                        ),
                      ),
                      TextButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 230, 0, 0.8),
                          minimumSize: Size(70, 40),
                        ),
                        child: Text(
                          "more",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: widget.shift.done
                      ? Icon(
                          Icons.done,
                          color: Color.fromRGBO(11, 252, 3, 0.9),
                        )
                      : Icon(
                          Icons.close,
                          color: Color.fromRGBO(252, 3, 3, 0.9),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
