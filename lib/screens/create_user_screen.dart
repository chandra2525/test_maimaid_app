import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_event.dart';
import 'package:test_maimaid_app/blocs/user/user_state.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_maimaid_app/screens/successful_screen.dart';

class CreateUserScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  String? selectedJob;

  final List<String> jobs = ['Front End', 'Back End', 'Data Analyst'];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          "Create User",
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
          if (state is UserCreateSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //       content: Text('User Created: ${state.name} - ${state.job}')),
            // );
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SuccessfullScreen('create')),
            );
          } else if (state is UserCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create user: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserCreateLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primary,
              ));
            }
            return Form(
              key: _formKey,
              child: Column(
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
                    onTap: () => showJobSelection(context),
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
            );
          }),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
        child: SizedBox(
          width: double.infinity,
          height: 62,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<UserBloc>().add(CreateUser(
                      name: nameController.text,
                      job: selectedJob!,
                    ));
              }
              // if (nameController.text.isNotEmpty && selectedJob != null) {
              //   context.read<UserBloc>().add(CreateUser(
              //         name: nameController.text,
              //         job: selectedJob!,
              //       ));
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('Please fill in all fields')),
              //   );
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // rounded corners
              ),
            ),
            child: Text(
              'CREATE',
              style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showJobSelection(BuildContext context) {
    showModalBottomSheet(
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
                  children: List.generate(
                    jobs.length,
                    (int index) {
                      return InkWell(
                          onTap: () {
                            selectedJob = jobs[index];
                            jobController.text = selectedJob!;
                            Navigator.pop(context);
                          },
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
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
