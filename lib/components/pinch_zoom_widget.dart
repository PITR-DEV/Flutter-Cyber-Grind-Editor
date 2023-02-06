import 'package:flutter/material.dart';

class PinchZoom extends StatefulWidget {
  final Widget child;
  final double maxScale;
  final bool zoomEnabled;
  final Function? onZoomStart, onZoomEnd;

  PinchZoom(
      {required this.child,
      this.maxScale = 3.0,
      this.zoomEnabled = true,
      this.onZoomStart,
      this.onZoomEnd});

  @override
  _PinchZoomState createState() => _PinchZoomState();
}

class _PinchZoomState extends State<PinchZoom>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: InteractiveViewer(
        child: widget.child,
        scaleEnabled: widget.zoomEnabled,
        maxScale: widget.maxScale,
        panEnabled: false,
        onInteractionStart: widget.zoomEnabled
            ? (_) {
                if (widget.onZoomStart != null) {
                  widget.onZoomStart!();
                }
              }
            : null,
        transformationController: _transformationController,
      ),
    );
  }
}
