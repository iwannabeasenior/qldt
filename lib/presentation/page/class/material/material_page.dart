import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/class/material/material_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class MaterialsPage extends StatelessWidget {
  final String classID;

  const MaterialsPage({super.key, required this.classID});

  // @override
  // Widget build(BuildContext context) {
  //   final repo = context.read<MaterialRepo>();
  //   return ChangeNotifierProvider(
  //       create: (context) => MaterialProvider(repo),
  //       child: MaterialsView(classID),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialsView(classID);
  }
}


class MaterialsView extends StatefulWidget {

  final classID;
  MaterialsView(this.classID);

  @override
  State<MaterialsView> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends State<MaterialsView> {
  @override
  void initState() {
    Logger().d("class id is: ${widget.classID}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterialProvider>().fetchMaterials(UserPreferences.getToken() ?? "", widget.classID);
    });
  }
  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: materialProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: materialProvider.materials.length, // Số lượng tài liệu
                    itemBuilder: (context, index) {
                      return DocumentCard(material: materialProvider.materials[index],);
                    },
                  )
          ),
          ElevatedButton(
            onPressed: () {
              // Handle upload document
              Navigator.pushNamed(context, '/UploadMaterial', arguments: widget.classID);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAE2C2C),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Tải tài liệu lên",
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {

  final Materials material;

  DocumentCard({required this.material});

  @override
  Widget build(BuildContext context) {
    final materialController = context.read<MaterialProvider>();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${material.materialName}.${material.materialType}" ?? "UNKNOWN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                material.description ?? '',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading:
                              Icon(Icons.folder_open, color: Colors.red),
                              title: Text("Mở"),
                              onTap: () async {
                                try {
                                  await Utils.launchUrlString(material.materialLink ?? "");
                                } catch(e) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can not open url")));
                                }
                                Navigator.pop(context);
                              },
                            ),
                            if (UserPreferences.getRole() == 'LECTURER')
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.blue),
                                title: Text("Chỉnh sửa"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/EditMaterial', arguments: { 'material': material});
                                },
                              ),
                            if (UserPreferences.getRole() == 'LECTURER')
                              ListTile(
                                leading:
                                    Icon(Icons.delete, color: Colors.black),
                                title: Text("Xóa"),
                                onTap: () {
                                  materialController.deleteMaterial(
                                      UserPreferences.getToken() ?? "",
                                      material.id);
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
