import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseMessaging fMmessaging = FirebaseMessaging.instance;
User? currentUser = auth.currentUser;
String serverKey =
    "AAAA0UVgQns:APA91bG7UrmlSg9YA9wR4nFoX1VoH-JRMwBVXvcIGHbMq0Fkg475LR9axyYNo_ocvrdI-pQ-THHzWU5ZbBLaatfuPXQAxhr4xOQYJXJh7KVK4aNofn9tGafZ_Q5wIe4QzWLr6RZtSfjb";
//collections
const vendorCollection = "vendors";
const userCollection = "users";
const productsCollection = "products";
const cartCollection = "cart";
const chatCollection = "chats";
const messagesCollection = "messages";
const ordersCollection = "orders";
String? userToken = "";
String? username = "";
