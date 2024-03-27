import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Card(
            child: Image.network(
              'https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=600',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // category
          const Text(
            'MALARIA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Malaria: The Past and the Present - Discovery, Development and Diagnosis of Malaria',
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, height: 1,
            ),
          ),
          
          const Text(
            'By Jasmika Talapko',
            style: TextStyle(),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            '''
          Malaria is a life-threatening mosquito-borne disease caused by the Plasmodium parasites. It is transmitted to humans through the bites of infected female Anopheles mosquitoes. There are five parasite species that cause malaria in humans, with Plasmodium falciparum being the most deadly.

          Common symptoms of malaria include fever, chills, headache, muscle aches, and fatigue. In severe cases, it can lead to jaundice, organ failure, seizures, coma, and death. Malaria is prevalent in tropical and subtropical regions, particularly in sub-Saharan Africa, Southeast Asia, and South America.

          Preventive measures include the use of insecticide-treated bed nets, indoor residual spraying, and antimalarial medications for travelers to endemic areas. Prompt diagnosis and treatment with antimalarial drugs are essential for curing malaria and preventing complications.

          Despite significant progress in malaria control efforts, it remains a major global health challenge, particularly in low-income countries. Efforts to combat malaria include vector control, research on new drugs and vaccines, and strengthening healthcare systems in endemic regions.

          Collaboration among governments, organizations, and communities is crucial for achieving the goal of malaria elimination and eventual eradication.
          ''',
          textAlign: TextAlign.justify,
            style: TextStyle(),
          ),

          const SizedBox(
            height: 10,
          ),

        ],
      ),
    );
  }
}
