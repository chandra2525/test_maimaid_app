import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_event.dart';
import 'package:test_maimaid_app/blocs/user/user_state.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'package:test_maimaid_app/repositories/user_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_maimaid_app/screens/successful_screen.dart';
import 'package:test_maimaid_app/screens/create_user_screen.dart';
import 'package:test_maimaid_app/screens/update_user_screen.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: UserRepository())..add(FetchUsers(page: 1)),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text(
            "User List",
            style: GoogleFonts.sen(
                fontSize: 19, fontWeight: FontWeight.w400, color: black1),
          ),
          backgroundColor: white,
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: greyLight,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: IconButton(
                  // color: primary,
                  // focusColor: primary,
                  // hoverColor: primary,
                  // splashColor: primary,
                  // disabledColor: primary,
                  // highlightColor: primary,
                  icon: const Icon(
                    Icons.add,
                    color: black,
                    size: 26,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CreateUserScreen()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: primary,
                  indicatorWeight: 4.0,
                  labelPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                  indicatorSize: TabBarIndicatorSize.label,
                  physics: const BouncingScrollPhysics(),
                  labelColor: primary,
                  unselectedLabelColor: black,
                  dividerColor: blackLight,
                  tabs: [
                    Text(
                      "Non Selected",
                      style: GoogleFonts.sen(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Selected",
                      style: GoogleFonts.sen(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Container(),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      UserList(),
                      SelectedUserList(),
                      Container(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial ||
            (state is UserLoading) ||
            (state is UserDeleteLoading)) {
          return const Center(
              child: CircularProgressIndicator(
            color: primary,
          ));
        } else if (state is UserLoaded && state.users.isEmpty) {
          return Center(
              child: Text(
            'Empty user',
            style: GoogleFonts.sen(
                fontSize: 16, fontWeight: FontWeight.w400, color: grey4),
          ));
        } else if (state is UserLoaded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Total ${state.users.length} items',
                    style: GoogleFonts.sen(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: grey1),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    physics: const BouncingScrollPhysics(),
                    enablePullDown: false,
                    enablePullUp: true,
                    // enableTwoLevel: true,
                    header: const ClassicHeader(),
                    controller: userBloc.refreshController,
                    onRefresh: () => userBloc.onScroll(),
                    onLoading: () => userBloc.onScroll(),
                    child: ListView.builder(
                      // controller: userBloc.scrollController,
                      itemCount: state.users.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.users.length) {
                          return state.page * 10 >= state.users.length
                              ? Container() // No more data to load
                              : const Center(
                                  child: CircularProgressIndicator());
                        }
                        final user = state.users[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 102,
                                    width: 102,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl: user.avatar,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: black,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, top: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstName} - ${user.lastName}',
                                          style: GoogleFonts.sen(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: black),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                          user.email,
                                          style: GoogleFonts.sen(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                  color: white1,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: black,
                                    size: 26,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Customize the border radius
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: Text(
                                            'Select',
                                            style: GoogleFonts.sen(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: black),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: Text(
                                            'Update',
                                            style: GoogleFonts.sen(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: black),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 2,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: Text(
                                            'Delete',
                                            style: GoogleFonts.sen(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: red),
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      print("value 0");
                                      userBloc.add(SelectUser(user: user));
                                    } else if (value == 1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateUserScreen(
                                                    userId: user.id)),
                                      );
                                      print("value 1");
                                    } else if (value == 2) {
                                      // userBloc.add(DeleteUser(
                                      //     userId: user.id));

                                      showDeleteNotif(context, user.id);
                                      print("value 2");
                                    }
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  void showDeleteNotif(BuildContext context, userId) {
    final userBloc = context.read<UserBloc>();
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Are you sure?',
                    style: GoogleFonts.sen(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: black1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, bottom: 30.0, top: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          userBloc.add(DeleteUser(userId: userId));
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SuccessfullScreen('delete')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // rounded corners
                          ),
                        ),
                        child: Text(
                          'DELETE NOW',
                          style: GoogleFonts.sen(
                            textStyle: const TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SelectedUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial ||
            (state is UserLoading) ||
            (state is UserDeleteLoading)) {
          return const Center(
              child: CircularProgressIndicator(
            color: primary,
          ));
        } else if (state is UserLoaded && state.selectedUsers.isEmpty) {
          return Center(
              child: Text(
            'Empty selected user',
            style: GoogleFonts.sen(
                fontSize: 16, fontWeight: FontWeight.w400, color: grey4),
          ));
        } else if (state is UserLoaded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Total ${state.selectedUsers.length} items',
                    style: GoogleFonts.sen(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: grey1),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    physics: const BouncingScrollPhysics(),
                    enablePullDown: false,
                    enablePullUp: true,
                    // enableTwoLevel: true,
                    header: const ClassicHeader(),
                    controller: userBloc.refreshControllerSelected,
                    onRefresh: () => userBloc.onScroll(),
                    onLoading: () => userBloc.onScroll(),
                    child: ListView.builder(
                      // controller: userBloc.scrollController,
                      itemCount: state.selectedUsers.length,
                      itemBuilder: (context, index) {
                        if (index == state.users.length) {
                          return state.page * 10 >= state.users.length
                              ? Container() // No more data to load
                              : const Center(
                                  child: CircularProgressIndicator());
                        }
                        final user = state.selectedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 102,
                                    width: 102,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl: user.avatar,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: black,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, top: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstName} - ${user.lastName}',
                                          style: GoogleFonts.sen(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: black),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                          user.email,
                                          style: GoogleFonts.sen(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                  color: white1,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: black,
                                    size: 26,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Customize the border radius
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: Text(
                                            'Unselect',
                                            style: GoogleFonts.sen(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: black),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: Text(
                                            'Update',
                                            style: GoogleFonts.sen(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: black),
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      print("value 0");
                                      userBloc.add(SelectUser(user: user));
                                    } else if (value == 1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateUserScreen(
                                                    userId: user.id)),
                                      );
                                      print("value 1");
                                    }
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  void showDeleteNotif(BuildContext context, userId) {
    final userBloc = context.read<UserBloc>();
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Are you sure?',
                    style: GoogleFonts.sen(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: black1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 30.0,
                      bottom: 24.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          userBloc.add(DeleteUser(userId: userId));
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SuccessfullScreen('delete')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // rounded corners
                          ),
                        ),
                        child: Text(
                          'DELETE NOW',
                          style: GoogleFonts.sen(
                            textStyle: const TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
