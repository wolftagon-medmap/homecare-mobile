import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'package:m2health/core/widgets/voice_input/voice_recording_view.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

class IssueFormPage extends StatefulWidget {
  final PersonalIssue? issue;
  final int maxImages = 3;

  const IssueFormPage({super.key, this.issue});

  @override
  State<IssueFormPage> createState() => _IssueFormPageState();
}

class _IssueFormPageState extends State<IssueFormPage> {
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<dynamic> _imageSlots;
  late final VoiceInputCubit _voiceInputCubit;

  bool get isEditMode => widget.issue != null;

  @override
  void initState() {
    super.initState();
    _voiceInputCubit = sl<VoiceInputCubit>();
    if (isEditMode) {
      _issueTitleController.text = widget.issue!.title;
      _descriptionController.text = widget.issue!.description;
      _imageSlots = List<dynamic>.from(widget.issue!.imageUrls);
      if (_imageSlots.length < widget.maxImages) {
        _imageSlots
            .addAll(List.filled(widget.maxImages - _imageSlots.length, null));
      }
    } else {
      _imageSlots = List.filled(widget.maxImages, null);
    }
  }

  void _submitData() async {
    final issueTitle = _issueTitleController.text;
    final description = _descriptionController.text;

    if (issueTitle.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(context.t.booking.issue.form.title_description_required),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final serviceType = context.read<PersonalIssuesCubit>().state.serviceType;

    if (isEditMode) {
      final Map<int, File> newImages = {};
      for (int i = 0; i < _imageSlots.length; i++) {
        if (_imageSlots[i] is File) {
          newImages[i] = _imageSlots[i] as File;
        }
      }
      final issueData = PersonalIssue(
        id: widget.issue!.id,
        type: serviceType,
        title: issueTitle,
        description: description,
        newImages: newImages,
        imageUrls: widget.issue!.imageUrls,
      );
      await context
          .read<PersonalIssuesCubit>()
          .updateIssue(widget.issue!.id!, issueData);
    } else {
      final List<File> images = _imageSlots.whereType<File>().toList();
      final newIssue = PersonalIssue(
        type: serviceType,
        title: issueTitle,
        description: description,
        images: images,
      );
      await context.read<PersonalIssuesCubit>().addIssue(newIssue);
    }
  }

  @override
  void dispose() {
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _voiceInputCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _voiceInputCubit,
      child: BlocConsumer<PersonalIssuesCubit, PersonalIssuesState>(
        listenWhen: (previous, current) =>
            previous.createStatus != current.createStatus ||
            previous.updateStatus != current.updateStatus,
        listener: (context, state) {
          if (state.createStatus == ActionStatus.success ||
              state.updateStatus == ActionStatus.success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditMode
                    ? context.t.booking.issue.messages.edit_issue_success
                    : context.t.booking.issue.messages.add_issue_success),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.createStatus == ActionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.createErrorMessage ??
                      "Unknown error occurred while creating the issue.",
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.updateStatus == ActionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.updateErrorMessage ??
                      "Unknown error occurred while updating the issue.",
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocListener<VoiceInputCubit, VoiceInputState>(
            listener: (context, voiceState) {
              voiceState.whenOrNull(
                success: (text) {
                  setState(() {
                    if (_descriptionController.text.isNotEmpty) {
                      _descriptionController.text += " $text";
                    } else {
                      _descriptionController.text = text;
                    }
                  });
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
            child: BlocBuilder<VoiceInputCubit, VoiceInputState>(
              builder: (context, voiceState) {
                final isRecording = voiceState.maybeWhen(
                  recording: (_) => true,
                  orElse: () => false,
                );
                final isPaused = voiceState.maybeWhen(
                  paused: (_) => true,
                  orElse: () => false,
                );
                final isTranscribing = voiceState.maybeWhen(
                  transcribing: () => true,
                  orElse: () => false,
                );

                final showVoiceUI = isRecording || isPaused;

                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      isEditMode
                          ? context.t.booking.issue.edit_issue_title
                          : context.t.booking.issue.add_issue_title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t.booking.issue.form.complaint_label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _issueTitleController,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: context
                                    .t.booking.issue.form.complaint_title_hint,
                                hintStyle: const TextStyle(
                                    color: Color(0xFFD0D0D0), fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                TextField(
                                  controller: _descriptionController,
                                  style: const TextStyle(fontSize: 14),
                                  textAlignVertical: TextAlignVertical.top,
                                  minLines: 5,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: context.t.booking.issue.form
                                        .complaint_description_hint,
                                    hintStyle: const TextStyle(
                                        color: Color(0xFFD0D0D0), fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 60),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.mic,
                                        color: Const.aqua),
                                    onPressed: isTranscribing
                                        ? null
                                        : () =>
                                            _voiceInputCubit.startRecording(),
                                  ),
                                ),
                              ],
                            ),
                            if (isTranscribing)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child:
                                    LinearProgressIndicator(color: Const.aqua),
                              ),
                            const SizedBox(height: 16.0),
                            Text(context.t.booking.issue.images,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...List.generate(widget.maxImages, (index) {
                              dynamic imageSource = _imageSlots[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ImagePreview(
                                  initialImageUrl: imageSource is String
                                      ? imageSource
                                      : null,
                                  imageFile:
                                      imageSource is File ? imageSource : null,
                                  onChooseImage: (file) {
                                    if (file != null) {
                                      setState(() {
                                        _imageSlots[index] = file;
                                      });
                                    }
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                      // Voice Input Overlay
                      if (showVoiceUI) ...[
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {}, // Block interactions
                            child: Container(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: VoiceRecordingView(
                              cubit: _voiceInputCubit,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.white,
                    child: SizedBox(
                      width: 352,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: (state.createStatus ==
                                    ActionStatus.loading ||
                                state.updateStatus == ActionStatus.loading ||
                                showVoiceUI ||
                                isTranscribing)
                            ? null
                            : _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Const.aqua,
                        ),
                        child: (state.createStatus == ActionStatus.loading ||
                                state.updateStatus == ActionStatus.loading)
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text(
                                isEditMode
                                    ? context.t.global.update
                                    : context.t.global.add,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
