import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool signed = false;
bool logged = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BudgetTrackingApp());
}

class BudgetTrackingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SignInPage(),
      },
    );
  }
}

class Expense {
  String category;
  double amount;

  Expense({required this.category, required this.amount});
}

class BudgetTrackingPage extends StatefulWidget {
  @override
  _BudgetTrackingPageState createState() => _BudgetTrackingPageState();
}

class _BudgetTrackingPageState extends State<BudgetTrackingPage> {
  List<Expense> _expenses = [];

  TextEditingController _categoryController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  void _addExpense() {
    String category = _categoryController.text;
    double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (category.isNotEmpty && amount > 0) {
      setState(() {
        _expenses.add(Expense(category: category, amount: amount));
      });

      _categoryController.clear();
      _amountController.clear();
    }
  }

  double _calculateTotalExpenses() {
    return _expenses.fold(
        0.0, (previous, current) => previous + current.amount);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Budget Tracker',
            style: TextStyle(fontFamily: 'Font1', color: Color(0xFFEDFFAB)),
          ),
          backgroundColor: Color(0xFF89608E),
        ),
        body: Container(
          color: Color(0xFFBA9593),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome Back !!',
                    style: TextStyle(
                        fontSize: 43,
                        color: Color(0xFFEDFFAB),
                        fontFamily: 'Font1'),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _categoryController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Category',
                        icon: Icon(
                          Icons.category,
                          size: 30,
                          color: Color(0xFF623B5A),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Font1',
                            color: Color(0xFFEDFFAB))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Amount',
                        icon: Icon(
                          Icons.monetization_on,
                          size: 30,
                          color: Color(0xFF623B5A),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Font1',
                            color: Color(0xFFEDFFAB))),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _addExpense,
                    icon: Icon(
                      Icons.add,
                      color: Color(0xFFBA9593),
                    ),
                    label: Text(
                      'Add Another Expense',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Font1',
                          color: Color(0xFFEDFFAB)),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF623B5A),
                      fixedSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      Expense expense = _expenses[index];
                      return ElevatedButton(
                        onPressed:
                            () {}, // You can add functionality here if needed
                        child: Text(
                          '${expense.category}: \ Rs ${expense.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Font1',
                              color: Color(0xFF623B5A)),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFC8FFBE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Adjust the radius as needed
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 100),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _expenses.clear();
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xFFEDFFAB),
                    ),
                    label: Text(
                      'Clear Expenses',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Font1',
                          color: Color(0xFFEDFFAB)),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF89608E),
                      fixedSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Expenses: \ Rs ${_calculateTotalExpenses().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Font1',
                        color: Color(0xFFEDFFAB)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void sigUpUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      signed = true;
      setState(() {
        signed = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        signed = false;
      });
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Budget Tracker',
              style: TextStyle(
                  fontSize: 20, color: Color(0xFFEDFFAB), fontFamily: 'Font1'),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF89608E),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Color(0xFFBA9593),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 50,
                        color: Color(0xFFEDFFAB),
                        fontFamily: 'Font1'),
                  ),
                  SizedBox(height: 30),
                  Icon(
                    Icons.person_add,
                    size: 100,
                    color: Color(0xFF623B5A),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: '     Email',
                        icon: Icon(
                          Icons.email,
                          color: Color(0xFF623B5A),
                          size: 30,
                        ),
                        labelStyle: TextStyle(
                            color: Color(0xFFEDFFAB),
                            fontSize: 25,
                            fontFamily: 'Font1')),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: '     Password',
                        icon: Icon(
                          Icons.lock_outline,
                          color: Color(0xFF623B5A),
                          size: 30,
                        ),
                        labelStyle: TextStyle(
                            color: Color(0xFFEDFFAB),
                            fontSize: 25,
                            fontFamily: 'Font1')),
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                      onPressed: () async {
                        sigUpUser();
                        if (signed)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BudgetTrackingPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF623B5A),
                        fixedSize: Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius as needed
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFFEDFFAB),
                            fontFamily: 'Font1'),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Your onTap logic
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text(
                      "Return to Login Page ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFFEDFFAB),
                          fontSize: 20,
                          fontFamily: 'Font1'),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  TextEditingController _emailController2 = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  void login() async {
    dynamic result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController2.text, password: _passwordController2.text);
    logged = true;

    if (result == null) {
      logged = false;
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Budget Tracker',
              style: TextStyle(
                  fontSize: 20, color: Color(0xFFEDFFAB), fontFamily: 'Font1'),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF89608E),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Color(0xFFBA9593),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 50,
                        color: Color(0xFFEDFFAB),
                        fontFamily: 'Font1'),
                  ),
                  SizedBox(height: 30),
                  Icon(
                    Icons.lock,
                    size: 100,
                    color: Color(0xFF623B5A),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController2,
                    decoration: InputDecoration(
                        labelText: '     Email',
                        icon: Icon(
                          Icons.email,
                          color: Color(0xFF623B5A),
                          size: 30,
                        ),
                        labelStyle: TextStyle(
                            color: Color(0xFFEDFFAB),
                            fontSize: 25,
                            fontFamily: 'Font1')),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController2,
                    decoration: InputDecoration(
                        labelText: '     Password',
                        icon: Icon(
                          Icons.lock_outline,
                          size: 30,
                          color: Color(0xFF623B5A),
                        ),
                        labelStyle: TextStyle(
                            color: Color(0xFFEDFFAB),
                            fontSize: 25,
                            fontFamily: 'Font1')),
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                      onPressed: () async {
                        login();
                        if (logged)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BudgetTrackingPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF623B5A),
                        fixedSize: Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius as needed
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFFEDFFAB),
                            fontFamily: 'Font1'),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Your onTap logic
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Create new account ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFFEDFFAB),
                          fontSize: 20,
                          fontFamily: 'Font1'),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
