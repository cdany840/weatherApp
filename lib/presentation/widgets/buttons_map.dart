import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonsMap extends StatefulWidget {
  const ButtonsMap({
    super.key,
    required this.onPressed,
    required this.function,
  });

  final VoidCallback onPressed;
  final Function(String) function;

  @override
  State<ButtonsMap> createState() => _ButtonsMapState();
}

class _ButtonsMapState extends State<ButtonsMap> {
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'btn1',
          onPressed: () {
            setState(() {
              showButtons = !showButtons;
            });            
          },
          child: const Icon(Icons.layers),
        ),
        Visibility(
          visible: showButtons,
          child: Column(
            children: [
              const SizedBox( height: 16 ),
              FloatingActionButton(
                heroTag: 'btn1.1',
                onPressed: () {
                  // * Normal
                  widget.function('mapbox/streets-v12');
                },
                child: const Icon(FontAwesomeIcons.globe),
              ),
              const SizedBox( height: 16 ),
              FloatingActionButton(
                heroTag: 'btn1.2',
                onPressed: () {
                  // * Terreno
                  widget.function('mapbox/outdoors-v12');
                },
                child: const Icon(FontAwesomeIcons.map),
              ),
              const SizedBox( height: 16 ),
              FloatingActionButton(
                heroTag: 'btn1.3',
                onPressed: () {
                  // * Hibrido
                  widget.function('mapbox/navigation-night-v1');
                },
                child: const Icon(FontAwesomeIcons.mapLocationDot),
              ),
              const SizedBox( height: 16 ),
              FloatingActionButton(
                heroTag: 'btn1.4',
                onPressed: () {
                  // * Satelital
                  widget.function('mapbox/satellite-v9');
                },
                child: const Icon(Icons.satellite),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        FloatingActionButton(
          heroTag: 'btn2',
          onPressed: widget.onPressed,
          child: const Icon(Icons.gps_fixed),
        ),
      ],
    );   
  }
}