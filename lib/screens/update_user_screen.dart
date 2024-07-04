import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_event.dart';
import 'package:test_maimaid_app/blocs/user/user_state.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'package:test_maimaid_app/models/user.dart';
import 'package:test_maimaid_app/repositories/user_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_maimaid_app/screens/successful_screen.dart';

class UpdateUserScreen extends StatelessWidget {
  final int userId;

  UpdateUserScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: context.read<UserRepository>())
            ..add(FetchUserDetail(userId: userId)),
      child: UserDetailView(userId: userId),
    );
  }
}

class UserDetailView extends StatelessWidget {
  final int userId;

  UserDetailView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          "Update User",
          style: GoogleFonts.sen(
              fontSize: 19, fontWeight: FontWeight.w400, color: black1),
        ),
        backgroundColor: white,
        centerTitle: false,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 4.0, bottom: 4.0),
          child: Container(
            // height: 48,
            // width: 48,
            decoration: const BoxDecoration(
                color: greyLight,
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: black,
                size: 26,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('User updated successfully')),
            // );
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SuccessfullScreen('update')),
            );
          } else if (state is UserUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update user')),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserUpdateLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primary,
              ));
            } else if (state is UserDetailLoaded) {
              return UserDetailForm(user: state.user);
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class UserDetailForm extends StatelessWidget {
  final User user;

  UserDetailForm({required this.user});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: user.firstName + ' ' + user.lastName);
    final TextEditingController jobController =
        TextEditingController(text: user.job ?? '');

    final List<String> jobs = ['Front End', 'Back End', 'Data Analyst'];

    void showJobSelection() async {
      final selectedJob = await showModalBottomSheet<String>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.0),
          ),
        ),
        backgroundColor: white,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: Column(
                    children: List.generate(jobs.length, (index) {
                      return InkWell(
                          onTap: () => (String job) {
                                Navigator.pop(context, job);
                              }(jobs[index]),
                          child: Container(
                            color: jobController.text == jobs[index]
                                ? grey3
                                : white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 12.0, 24.0, 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    jobs[index],
                                    style: GoogleFonts.sen(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: black1),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: black1,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (selectedJob != null && selectedJob.isNotEmpty) {
        jobController.text = selectedJob;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "NAME",
                    style: GoogleFonts.sen(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: grey2),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {},
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.sen(
                      // height: 3.5,
                      fontWeight: FontWeight.w400,
                      color: black,
                      fontSize: 18),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey3,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                    hintText: "Input name...",
                    hintStyle: GoogleFonts.inter(
                        // height: 3.5,
                        fontWeight: FontWeight.w400,
                        color: grey1,
                        fontSize: 18),
                    // prefixIconConstraints:
                    //     BoxConstraints.tight(const Size(46, 46)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 31.0, bottom: 8.0),
                  child: Text(
                    "JOB",
                    style: GoogleFonts.sen(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: grey2),
                  ),
                ),
                GestureDetector(
                  onTap: showJobSelection,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: jobController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a job';
                        }
                        return null;
                      },
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.sen(
                          fontWeight: FontWeight.w400,
                          color: black,
                          fontSize: 18),
                      cursorColor: primary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: grey3,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                        hintText: "Select job",
                        hintStyle: GoogleFonts.inter(
                            // height: 3.5,
                            fontWeight: FontWeight.w400,
                            color: grey1,
                            fontSize: 18),
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: black1,
                          size: 26,
                        ),
                        // prefixIconConstraints:
                        //     BoxConstraints.tight(const Size(46, 46)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<UserBloc>().add(UpdateUser(
                            id: user.id,
                            name: nameController.text,
                            job: jobController.text,
                          ));
                    }
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
                    'UPDATE',
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
    );
  }
}
