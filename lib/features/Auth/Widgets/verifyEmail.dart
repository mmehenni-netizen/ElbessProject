import 'dart:async';

import 'package:elbess/core/constants/colors.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/utils/app_snackbar.dart';
import 'package:elbess/features/Auth/Presentation/Pages/fill_profile_view.dart';
import 'package:elbess/features/Auth/data/auth_repo.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VerifyEmailView extends StatefulWidget {
	final String email;

	const VerifyEmailView({super.key, required this.email});

	@override
	State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
	final AuthRepo _authRepo = AuthRepo();
	final TextEditingController _codeController = TextEditingController();
	final FocusNode _focusNode = FocusNode();

	static const int _codeLength = 6;
	static const int _resendSeconds = 59;

	Timer? _timer;
	int _secondsLeft = _resendSeconds;
	bool _isLoading = false;

	@override
	void initState() {
		super.initState();
		_startTimer();

		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (mounted) {
				_requestCodeFocus();
			}
		});
	}

	void _startTimer() {
		_timer?.cancel();
		_secondsLeft = _resendSeconds;
		_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
			if (!mounted) {
				timer.cancel();
				return;
			}

			if (_secondsLeft > 0) {
				setState(() {
					_secondsLeft -= 1;
				});
			} else {
				timer.cancel();
			}
		});
	}

	void _requestCodeFocus() {
		if (!mounted) {
			return;
		}

		FocusScope.of(context).requestFocus(_focusNode);
	}

	Future<void> _verifyCode() async {
		final code = _codeController.text.trim();
		if (code.length != _codeLength) {
			AppSnackBar.show(context, 'Please enter the full 6-digit code');
			return;
		}

		setState(() {
			_isLoading = true;
		});

		try {
			await _authRepo.verifyEmail(code);
			if (!mounted) {
				return;
			}
			AppSnackBar.show(context, 'Email verified successfully');
			Navigator.pushAndRemoveUntil(
				context,
				MaterialPageRoute(builder: (_) => const FillProfileView()),
				(route) => false,
			);
		} catch (e) {
			String errorMessage = 'Verification failed.';
			if (e is ApiError) {
				errorMessage = e.message;
			}
			if (!mounted) {
				return;
			}
			AppSnackBar.show(context, errorMessage);
		} finally {
			if (mounted) {
				setState(() {
					_isLoading = false;
				});
			}
		}
	}

	void _onCodeChanged(String value) {
		final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
		final trimmed = digitsOnly.length > _codeLength
				? digitsOnly.substring(0, _codeLength)
				: digitsOnly;

		if (trimmed != _codeController.text) {
			_codeController.value = TextEditingValue(
				text: trimmed,
				selection: TextSelection.collapsed(offset: trimmed.length),
			);
		}

		if (trimmed.length == _codeLength && !_isLoading) {
			_verifyCode();
		}

		setState(() {});
	}

	@override
	void dispose() {
		_timer?.cancel();
		_codeController.dispose();
		_focusNode.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final code = _codeController.text;

		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 20),
					child: Column(
						children: [
							const Gap(16),
							Row(
								children: [
									GestureDetector(
										onTap: () => Navigator.pop(context),
										child: const Icon(
											Icons.arrow_back_ios_new_rounded,
											size: 20,
											color: Color(0xFF9A9A9A),
										),
									),
									const Expanded(
										child: Center(
											child: Text(
												'Verify',
												style: TextStyle(
													fontSize: 18,
													fontFamily: 'semi',
													fontWeight: FontWeight.w600,
													color: Colors.black,
												),
											),
										),
									),
									const SizedBox(width: 20),
								],
							),
							Expanded(
								child: Center(
									child: Column(
										mainAxisSize: MainAxisSize.min,
										children: [
											const Text(
												'OTP code verification',
												style: TextStyle(
													color: Colors.black,
													fontSize: 24,
													fontFamily: 'semi',
													fontWeight: FontWeight.w600,
												),
											),
											const Gap(10),
											Text(
												'We have sent an OTP code to your email',
												textAlign: TextAlign.center,
												style: TextStyle(
													color: Colors.black.withOpacity(0.7),
													fontSize: 12,
													fontFamily: 'medium',
												),
											),
											const Gap(2),
											Text(
												widget.email,
												textAlign: TextAlign.center,
												style: TextStyle(
													color: Colors.black.withOpacity(0.7),
													fontSize: 12,
													fontFamily: 'medium',
												),
											),
											const Gap(24),
											GestureDetector(
													behavior: HitTestBehavior.opaque,
													onTap: _requestCodeFocus,
												child: Row(
													mainAxisAlignment: MainAxisAlignment.center,
													children: List.generate(_codeLength, (index) {
														final digit = code.length > index ? code[index] : '';
														return Container(
															width: 42,
															height: 52,
															margin: const EdgeInsets.symmetric(horizontal: 4),
															alignment: Alignment.center,
															decoration: BoxDecoration(
																color: Colors.white,
																borderRadius: BorderRadius.circular(8),
																border: Border.all(
																	color: digit.isNotEmpty
																			? AppColors.primary
																			: const Color(0xFFE6E6E6),
																	width: 1.3,
																),
															),
															child: Text(
																digit,
																style: const TextStyle(
																	fontSize: 24,
																	fontFamily: 'semi',
																	color: Colors.black,
																),
															),
														);
													}),
												),
											),
											Opacity(
												opacity: 0,
												child: SizedBox(
																height: 1,
																width: 1,
													child: TextField(
														controller: _codeController,
														focusNode: _focusNode,
														keyboardType: TextInputType.number,
																	textInputAction: TextInputAction.done,
														onChanged: _onCodeChanged,
														maxLength: _codeLength,
														autofocus: true,
																	showCursor: false,
																	decoration: const InputDecoration(
																		border: InputBorder.none,
																		counterText: '',
																		isCollapsed: true,
																	),
													),
												),
											),
											const Gap(18),
											_isLoading
													? const CircularProgressIndicator()
													: SizedBox(
															width: 220,
															child: ElevatedButton(
																onPressed: _verifyCode,
																style: ElevatedButton.styleFrom(
																	backgroundColor: AppColors.primary,
																	foregroundColor: Colors.white,
																	shape: RoundedRectangleBorder(
																		borderRadius: BorderRadius.circular(10),
																	),
																	padding: const EdgeInsets.symmetric(vertical: 12),
																	elevation: 0,
																),
																child: const Text(
																	'Verify',
																	style: TextStyle(
																		fontFamily: 'semi',
																		fontSize: 14,
																		fontWeight: FontWeight.w600,
																	),
																),
															),
														),
											const Gap(18),
											Text(
												"Didn't receive email?",
												style: TextStyle(
													color: Colors.black.withOpacity(0.6),
													fontFamily: 'medium',
													fontSize: 12,
												),
											),
											const Gap(6),
											Text(
												_secondsLeft > 0
														? 'You can resend code in $_secondsLeft s'
														: 'Code expired. Please sign up again.',
												style: TextStyle(
													color: _secondsLeft > 0 ? Colors.black54 : Colors.redAccent,
													fontFamily: 'medium',
													fontSize: 12,
												),
											),
										],
									),
								),
							),
						],
					),
				),
			),
		);
	}
}
