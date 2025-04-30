import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const Apiis());
}

class Apiis extends StatefulWidget {
  const Apiis({Key? key}) : super(key: key);

  @override
  State<Apiis> createState() => _ApiisState();
}

class _ApiisState extends State<Apiis> {


  late Interpreter interpreter;

  // Controllers for TextFields
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController chestPainController = TextEditingController();
  final TextEditingController trestbpsController = TextEditingController();
  final TextEditingController cholController = TextEditingController();
  final TextEditingController fbsController = TextEditingController();
  final TextEditingController restecgController = TextEditingController();
  final TextEditingController thalachController = TextEditingController();
  final TextEditingController exangController = TextEditingController();
  final TextEditingController oldpeakController = TextEditingController();
  final TextEditingController slopeController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController thalController = TextEditingController();

  String predictionResult = '';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/model.tflite');
    print('Model loaded successfully');
  }

  // Preprocessing Function with feature-wise normalization
  final List<double> means = [
    54.434 ,
    0.696 ,
    0.942 ,
    131.612 ,
    246.0 ,
    0.149 ,
    0.53 ,
    149.114 ,
    0.337 ,
    1.072 ,
    1.385 ,
    0.754 ,
    2.324 ,
    0.513 ,
  ];
  final List<double> stds = [
    9.072 ,
    0.46 ,
    1.03 ,
    17.517 ,
    51.593 ,
    0.357 ,
    0.528 ,
    23.006 ,
    0.473 ,
    1.175 ,
    0.618 ,
    1.031 ,
    0.621 ,
    0.5 ,
  ];

  List<double> preprocessInput(List<double> rawData) {
    List<double> normalized = [];
    for (int i = 0; i < rawData.length; i++) {
      double normValue = (rawData[i] - means[i]) / stds[i];
      normalized.add(normValue);
    }
    return normalized;
  }

  Future<int> predict(List<double> inputData) async {
    final processedInput = preprocessInput(inputData);

    // Prepare input tensor as 2D array [1, inputLength]
    var input = List.filled(
      processedInput.length,
      0.0,
    ).reshape([1, processedInput.length]);
    for (int i = 0; i < processedInput.length; i++) {
      input[0][i] = processedInput[i];
    }

    // Prepare output tensor as 2D array [1, 1]
    var output = List.filled(1, 0.0).reshape([1, 1]);

    interpreter.run(input, output);

    double rawPrediction = output[0][0];
    print('Raw model output: \$rawPrediction'); // Debug print

    // Convert raw prediction to 0 or 1 using threshold 0.5
    int predictedClass = rawPrediction >= 0.5 ? 1 : 0;
    return predictedClass;
  }

  void onPredictPressed() async {
    try {
      // Parse inputs from controllers, use default 0.0 if empty
      List<double> inputData = [
        ageController.text.isNotEmpty ? double.parse(ageController.text) : 0.0,
        sexController.text.isNotEmpty ? double.parse(sexController.text) : 0.0,
        chestPainController.text.isNotEmpty
            ? double.parse(chestPainController.text)
            : 0.0,
        trestbpsController.text.isNotEmpty
            ? double.parse(trestbpsController.text)
            : 0.0,
        cholController.text.isNotEmpty
            ? double.parse(cholController.text)
            : 0.0,
        fbsController.text.isNotEmpty ? double.parse(fbsController.text) : 0.0,
        restecgController.text.isNotEmpty
            ? double.parse(restecgController.text)
            : 0.0,
        thalachController.text.isNotEmpty
            ? double.parse(thalachController.text)
            : 0.0,
        exangController.text.isNotEmpty
            ? double.parse(exangController.text)
            : 0.0,
        oldpeakController.text.isNotEmpty
            ? double.parse(oldpeakController.text)
            : 0.0,
        slopeController.text.isNotEmpty
            ? double.parse(slopeController.text)
            : 0.0,
        caController.text.isNotEmpty ? double.parse(caController.text) : 0.0,
        thalController.text.isNotEmpty
            ? double.parse(thalController.text)
            : 0.0,
      ];

      int prediction = await predict(inputData);

      setState(() {
        predictionResult = 'Prediction: $prediction';
      });
    } catch (e) {
      setState(() {
        predictionResult = 'Error: Please enter valid numbers in all fields.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Center(child: const Text('Heart Disease Prediction',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),))
            ,backgroundColor: Colors.blueAccent,),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Enter the following values:'),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: sexController,
                  decoration: const InputDecoration(labelText: 'Sex'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: chestPainController,
                  decoration: const InputDecoration(labelText: 'Chest Pain'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: trestbpsController,
                  decoration: const InputDecoration(labelText: 'Trestbps'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cholController,
                  decoration: const InputDecoration(labelText: 'Chol'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: fbsController,
                  decoration: const InputDecoration(labelText: 'Fbs'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: restecgController,
                  decoration: const InputDecoration(labelText: 'Restecg'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: thalachController,
                  decoration: const InputDecoration(labelText: 'Thalach'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: exangController,
                  decoration: const InputDecoration(labelText: 'Exang'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: oldpeakController,
                  decoration: const InputDecoration(labelText: 'Old Peak'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: slopeController,
                  decoration: const InputDecoration(labelText: 'Slope'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: caController,
                  decoration: const InputDecoration(labelText: 'Ca'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: thalController,
                  decoration: const InputDecoration(labelText: 'Thal'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onPredictPressed,
                  child: const Text('Predict',style: TextStyle(color:Colors.white ),),
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ) ,
                ),
                const SizedBox(height: 20),
                Text(
                  predictionResult,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension method to reshape List<double> to List<List<double>>
