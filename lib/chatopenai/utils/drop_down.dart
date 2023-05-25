import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_explorer/chatopenai/models/openai_model.dart';
import 'package:wild_explorer/services/openai/openai_model_provider.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModels;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<OpenAIModelProvider>(context);
    currentModels = modelsProvider.getCurrentModel;
    return FutureBuilder<List<OpenAIModel>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
                child: DropdownButton(
                    dropdownColor: Color(0xFF343541),
                    iconEnabledColor: Colors.white,
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(
                              e.id,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    value: currentModels,
                    onChanged: (value) {
                      // setState(() {
                      //   currentModels = value.toString();
                      // });
                      modelsProvider.setCurrentModel(value.toString());
                    }),
              );
      },
    );
  }
}
