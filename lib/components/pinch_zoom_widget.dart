import 'package:flutter/material.dart';

class PinchZoom extends StatefulWidget {
  final Widget child;
  final double maxScale;
  final bool zoomEnabled;
  final Function? onZoomStart, onZoomEnd;

  const PinchZoom(
      {Key? key, required this.child,
      this.maxScale = 3.0,
      this.zoomEnabled = true,
      this.onZoomStart,
      this.onZoomEnd}) : super(key: key);

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
        child: widget.child,
      ),
    );
  }
}
