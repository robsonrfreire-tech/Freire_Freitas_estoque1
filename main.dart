// lib/main.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbPath = await getDatabasesPath();
  final path = p.join(dbPath, 'estoque.db');
  final database = await openDatabase(path, version: 1, onCreate: (db, v) async {
    await db.execute('''
      CREATE TABLE produtos (
        codigo TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        quantidade INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        usuario TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE movimentacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT,
        nome TEXT,
        quantidade INTEGER,
        tipo TEXT,
        usuario TEXT,
        data_hora TEXT
      )
    ''');

    // inserir admin padrão
    await db.insert('usuarios', {
      'nome': 'Administrador',
      'usuario': 'admin',
      'senha': '1234',
    });
  });

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freire & Freitas Padaria',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: LoginPage(database: database),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ... For brevity, the full app code would be here. Replace with your full main.dart when uploading.
