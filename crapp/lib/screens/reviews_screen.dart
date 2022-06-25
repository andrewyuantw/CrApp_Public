import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewScreen extends StatelessWidget {
  final String name;

  const ReviewScreen(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.all(10.0)),
                    Text("Name: " + name, style: const TextStyle(fontSize: 20)),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    MyReviewForm(name: name),
                    Text("Reviews: " + name,
                        style: const TextStyle(fontSize: 20)),
                    ReviewList(name: name),
                  ])),
        ),
      ),
    );
  }
}

class MyReviewForm extends StatefulWidget {
  MyReviewForm({Key? key, required this.name}) : super(key: key);

  String name;
  @override
  MyReviewFormState createState() {
    return MyReviewFormState();
  }
}

class MyReviewFormState extends State<MyReviewForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController reviewController = TextEditingController();
  TextEditingController starController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: starController,
            decoration: const InputDecoration(
              icon: Icon(Icons.star),
              labelText: 'Star Rating (scale of 0 to 5) *',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This is a required field';
              }
              final number = num.tryParse(value);
              if (number == null) {
                return 'Please enter a number';
              }
              if (number < 0 || number > 5) {
                return 'Please enter rating between 0 and 5';
              }
              return null;
            },
          ),
          TextFormField(
            controller: reviewController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person_pin),
              labelText: 'Review',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  final db = FirebaseFirestore.instance;

                  final reviewEntry = ReviewEntry(
                    star: int.tryParse(starController.text),
                    review: reviewController.text,
                  );

                  final docRef = db
                      .collection("locations")
                      .doc(widget.name)
                      .collection("reviews")
                      .withConverter(
                        fromFirestore: ReviewEntry.fromFirestore,
                        toFirestore: (ReviewEntry reviewEntry, options) =>
                            reviewEntry.toFirestore(),
                      )
                      .doc();
                  await docRef.set(reviewEntry);
                  reviewController.text = "";
                  starController.text = "";
                }
              },
              child: const Text('Add Review'),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  ReviewList({Key? key, required this.name}) : super(key: key);

  String name;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("locations")
            .doc(name)
            .collection('reviews')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.docs
                  .map((doc) => Card(
                          child: ListTile(
                        title: Text("Rating: " +
                            ((doc.data() as Map)['star']).toString() +
                            "/5"),
                        subtitle: Text((doc.data() as Map)['review']),
                      )))
                  .toList(),
            );
          }
        });
  }
}

class ReviewEntry {
  final String? review;
  final int? star;

  ReviewEntry({
    this.review,
    this.star,
  });

  factory ReviewEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReviewEntry(
      review: data?['review'],
      star: data?['star'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (review != null) "review": review,
      if (star != null) "star": star,
    };
  }
}
