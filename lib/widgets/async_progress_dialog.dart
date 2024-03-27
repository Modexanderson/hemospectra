import 'package:flutter/material.dart';


/// This code is an extension to the package flutter_progress_dialog (https://pub.dev/packages/future_progress_dialog)

const _defaultDecoration = BoxDecoration(
  // color: Colors.white,
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class AsyncProgressDialog extends StatefulWidget {
  final Future future;
  final BoxDecoration? decoration;
  final double opacity;
  final Widget? progress;
  // final Widget? message;
  final Function? onError;
  final Function? onComplete; // Add this callback

  const AsyncProgressDialog(
    this.future, {super.key, 
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    // this.message,
    this.onError,
    this.onComplete, // Initialize the callback
  });

  @override
  State<AsyncProgressDialog> createState() => _AsyncProgressDialogState();
}

class _AsyncProgressDialogState extends State<AsyncProgressDialog> {
  @override
  void initState() {
    widget.future.then((val) {
      if (widget.onComplete != null) {
        widget.onComplete!(); // Call the onComplete callback
      }
      Navigator.of(context).pop(val);
    }).catchError((e) {
      Navigator.of(context).pop();
      if (widget.onError != null) {
        widget.onError!.call(e);
      } else {
        throw e;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildDialog(context),
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    Container content;
    
      content = Container(
        height: 200,
        width: 100,
        alignment: Alignment.center,
        decoration: widget.decoration ?? _defaultDecoration,
        child: widget.progress ??
            const CircularProgressIndicator(),
      );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Opacity(
        opacity: widget.opacity,
        child: content,
      ),
    );
  }

}
