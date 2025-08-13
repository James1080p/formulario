import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Carrossel de Formulários")),
        body: FormCarousel(),
      ),
    );
  }
}

// classe para guardar os dados de cada formulário
class FormData {
  String nome = '';
  DateTime? dataNascimento;
  String sexo = 'Homem';
}

// widget com o carrossel de formulários
class FormCarousel extends StatefulWidget {
  const FormCarousel({super.key});

  @override
  State<FormCarousel> createState() => _FormCarouselState();
}

class _FormCarouselState extends State<FormCarousel> {
  // lista com 5 formulários (pode mudar a quantidade)
  final List<FormData> forms = List.generate(5, (_) => FormData());

  // função para abrir o seletor de data nativo
  Future<void> _selecionarData(int index) async {
    DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: forms[index].dataNascimento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    // atualiza a data escolhida
    if (escolhida != null) {
      setState(() => forms[index].dataNascimento = escolhida);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // altura do carrossel fixa
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // scroll na horizontal
        itemCount: forms.length, // quantidade de formulários
        itemBuilder: (context, index) {
          final form = forms[index]; // dados do formulário

          return Container(
            width: 280, // largura dos cards
            margin: const EdgeInsets.all(12), // espaçamento externo
            padding: const EdgeInsets.all(16), // espaçamento interno
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // bordas arredondadas
              boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // campo: nome completo
                const Text("Nome Completo"),
                TextField(
                  onChanged: (value) => form.nome = value,
                  decoration: const InputDecoration(hintText: "Digite o nome"),
                ),

                const SizedBox(height: 10),

                // campo: data de nascimento
                const Text("Data de Nascimento"),
                GestureDetector(
                  onTap: () => _selecionarData(index), // abre as opções
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: form.dataNascimento != null
                            ? "${form.dataNascimento!.day}/${form.dataNascimento!.month}/${form.dataNascimento!.year}"
                            : "Selecionar data",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Campo: Sexo
                const Text("Sexo"),
                DropdownButton<String>(
                  isExpanded: true,
                  value: form.sexo,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => form.sexo = value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: "Homem", child: Text("Homem")),
                    DropdownMenuItem(value: "Mulher", child: Text("Mulher")),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
