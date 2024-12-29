import 'package:flutter/material.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/presentation/page/chat/chat_detail/chat_detail.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/page/chat/chat_search/api.dart';
import 'model.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserSearch> _users = [];
  PageInfoSearch? _pageInfo;
  bool _isLoading = false;

  final String _apiPrefix = Constant.BASEURL; // Replace with your API prefix
  final int _pageSize = 10;
  int _currentPage = 0;

  void _searchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await fetchUsers(_searchController.text, _currentPage, _pageSize, _apiPrefix);
      setState(() {
        _users = result['pageContent'];
        _pageInfo = result['pageInfo'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadNextPage() {
    if (_pageInfo?.nextPage != null) {
      _currentPage = _pageInfo!.nextPage!;
      _searchUsers();
    }
  }

  void _loadPreviousPage() {
    if (_pageInfo?.previousPage != null) {
      _currentPage = _pageInfo!.previousPage!;
      _searchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
          ),

          if (_isLoading) CircularProgressIndicator(),

          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return GestureDetector(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(conversation: Conversation(id: -1, partnerId: int.parse(user.accountId), partnerName: user.firstName + user.lastName, lastMessage: null, lastMessageTime: "", unreadCount: -1))));
                    },
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text(user.email),
                  ),
                );
              },
            ),
          ),
          if (_pageInfo != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _pageInfo!.previousPage != null ? _loadPreviousPage : null,
                  child: Text('Previous'),
                ),
                Text('Page ${_pageInfo!.page + 1} of ${_pageInfo!.totalPage}'),
                TextButton(
                  onPressed: _pageInfo!.nextPage != null ? _loadNextPage : null,
                  child: Text('Next'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
