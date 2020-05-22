import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webnams_app_v3/src/models/user_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';

class Hosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hostState = Provider.of<UserData>(context);
    void updateHost(String id, String hostName) {
      hostState.updateHost(int.parse(id), hostName);
      Navigator.pushNamed(context, '/password');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Apsaimniekotāju izvēlne'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
            child: Text(
              'Apsaimniekotājs',
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: hexToColor('#222e42')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
            child: Text(
              'Lūdzu izvēlies apsaimniekotāju',
              style: TextStyle(fontSize: 16.0, color: hexToColor('#222e42')),
            ),
          ),
          Container(
            child: hostState.isFetching
                ? CircularProgressIndicator()
                : hostState.getResponseJson() != null
                    ? ListView.builder(
                        primary: false,
                        itemCount: hostState.getResponseJson()['hosts'].length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                              title: Text(
                                hostState.getResponseJson()['hosts'][index]
                                    ['host_name'],
                                style: TextStyle(fontSize: 16.0),
                              ),
                              trailing: Icon(Icons.arrow_right),
                              onTap: () {
                                updateHost(hostState.getResponseJson()['hosts']
                                    [index]['host_id'], hostState.getResponseJson()['hosts'][index]['host_name']);
                              },
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: index == 0
                                    ? BorderSide(color: hexToColor('#d6dde3'))
                                    : BorderSide(
                                        width: 0, color: hexToColor('#d6dde3')),
                                bottom:
                                    BorderSide(color: hexToColor('#d6dde3')),
                              ),
                            ),
                          );
                        },
                      )
                    : Text('No hosts available'),
          ),
        ],
      ),
    );
  }
}
