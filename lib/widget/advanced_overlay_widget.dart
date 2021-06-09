import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdvancedOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;

  static const allSpeeds = <double>[0.25, 0.5, 1, 1.5, 2, 3, 5, 10];//All speeds available to us

  const AdvancedOverlayWidget({
    Key key,
    @required this.controller,
    this.onClickedFullScreen,
  }) : super(key: key);

  String getPosition() {//We use this function to display time over the bar
    final duration = Duration(
        milliseconds: controller.value.position.inMilliseconds.round());//How much video has played

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');//basically we convert our minutes and seconds into a for like minutes:seconds using this mapping and json stuff
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            controller.value.isPlaying ? controller.pause() : controller.play(),
        child: Stack(
          children: <Widget>[
            buildPlay(),
            buildSpeed(),
            Positioned(
              left: 8,
              bottom: 28,
              child: Text(getPosition()),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(child: buildIndicator()),
                    const SizedBox(width: 12),
                    GestureDetector(
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 28,
                      ),
                      onTap: onClickedFullScreen,
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
          ],
        ),
      );

  Widget buildIndicator() => Container(
        margin: EdgeInsets.all(8).copyWith(right: 0),
        height: 16,
        child: VideoProgressIndicator(
          controller,
          allowScrubbing: true,
        ),
      );

  Widget buildSpeed() => Align(
        alignment: Alignment.topRight,//I want my speed button on top right
        child: PopupMenuButton<double>(//Pop menu button basically shows the list of available speeds available to us
          initialValue: controller.value.playbackSpeed,//Current speed value is loaded
          tooltip: 'Playback speed',
          onSelected: controller.setPlaybackSpeed,//We execute this function to change the speed
          itemBuilder: (context) => allSpeeds//To display speed in a list
              .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  ))
              .toList(),
          child: Container(//Initial item displayed on list
            color: Colors.white38,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text('${controller.value.playbackSpeed}x'),
          ),
        ),
      );

  Widget buildPlay() => AnimatedSwitcher(
        duration: Duration(milliseconds: 50),
        reverseDuration: Duration(milliseconds: 200),
        child: controller.value.isPlaying
            ? Container()
            : Container(
                color: Colors.black26,
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),
      );
}
