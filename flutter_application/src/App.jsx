import { useState } from 'react'
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: CadastroForm(),
));

class CadastroForm extends StatefulWidget {
  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  DateTime? _dataNascimento;
  String? _sexoSelecionado;

  String? _validarIdade(DateTime? data) {
    if (data == null) return 'Data de nascimento obrigatória';

    final hoje = DateTime.now();
    final idade = hoje.year - data.year -
        ((hoje.month < data.month || (hoje.month == data.month && hoje.day < data.day)) ? 1 : 0);

    if (idade < 18) return 'É necessário ter 18 anos ou mais';
    return null;
  }

  void _selecionarDataNascimento() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataNascimento = dataSelecionada;
      });
    }
  }

  void _enviarFormulario() {
    final idadeValida = _validarIdade(_dataNascimento);

    if (_formKey.currentState!.validate() && idadeValida == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } else if (idadeValida != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(idadeValida)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome Completo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_dataNascimento == null
                    ? 'Data de Nascimento'
                    : 'Data: ${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _selecionarDataNascimento,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sexo'),
                items: ['Homem', 'Mulher']
                    .map((sexo) => DropdownMenuItem(
                          value: sexo,
                          child: Text(sexo),
                        ))
                    .toList(),
                value: _sexoSelecionado,
                onChanged: (value) {
                  setState(() {
                    _sexoSelecionado = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione o sexo' : null,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
