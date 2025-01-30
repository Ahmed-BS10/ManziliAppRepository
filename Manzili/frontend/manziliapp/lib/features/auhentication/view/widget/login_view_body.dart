import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/features/auhentication/cubit/login_cubit.dart';
import 'package:manziliapp/features/auhentication/cubit/login_state.dart';
import 'package:manziliapp/features/auhentication/model/login_model.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_divider.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/header_image.dart';
import 'package:manziliapp/features/auhentication/view/widget/register_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/social_login_buttons.dart';
import 'package:manziliapp/features/auhentication/view/widget/welcome_text.dart';

// class LoginViewBody extends StatefulWidget {
//   const LoginViewBody({super.key});

//   @override
//   State<LoginViewBody> createState() => _LoginViewBodyState();
// }

// class _LoginViewBodyState extends State<LoginViewBody> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const HeaderImage(),
//             const SizedBox(height: 15),
//             const WelcomeText(),
//             const SizedBox(height: 20),
//             EmailTextFiled(),
//             const SizedBox(height: 10),
//             const PasswordTextField(hintText: 'كلمة السر'),
//             const SizedBox(height: 10),
//             const ForgotPasswordText(),
//             const SizedBox(height: 15),
//             CustomTextButton(
//               onPressed: () {
//                 _validateForm();
//               },
//               name: 'تسجيل الدخول',
//               radius: 23,
//               fontColor: Colors.white,
//               backColor: pColor,
//             ),
//             const SizedBox(height: 20),
//             const CustomDivider(),
//             const SizedBox(height: 15),
//             const SocialLoginButtons(),
//             const SizedBox(height: 10),
//             RegisterText(),
//           ],
//         ),
//       ),
//     );
//   }

//   void _validateForm() {
//     if (_formKey.currentState!.validate()) {
//       print('Successed');
//     } else {
//       print('Failed');
//     }
//   }
// }

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 170),
      child: InkWell(
        onTap: () {},
        child: Text(
          'نسيت كلمة السر؟',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginModel _loginModel = LoginModel(Email: '', Password: '');
  late LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(AuthService(apiService: ApiService()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginCubit,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderImage(),
              const SizedBox(height: 15),
              const WelcomeText(),
              const SizedBox(height: 20),
              EmailTextFiled(
                onChanged: (value) {
                  _loginModel.Email = value;
                },
              ),
              const SizedBox(height: 10),
              PasswordTextField(
                  onChanged: (value) {
                    _loginModel.Password = value;
                  },
                  hintText: 'كلمة السر'),
              const SizedBox(height: 10),
              const ForgotPasswordText(),
              const SizedBox(height: 15),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('فشل في تسجيل الدخول: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return CircularProgressIndicator(); // عرض مؤشر تحميل
                  }
                  return CustomTextButton(
                    onPressed: () {
                      _validateForm();
                    },
                    name: 'تسجيل الدخول',
                    radius: 23,
                    fontColor: Colors.white,
                    backColor: pColor,
                  );
                },
              ),
              const SizedBox(height: 20),
              const CustomDivider(),
              const SizedBox(height: 15),
              const SocialLoginButtons(),
              const SizedBox(height: 10),
              RegisterText(),
            ],
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _loginCubit.login(_loginModel);
    }
  }
}
