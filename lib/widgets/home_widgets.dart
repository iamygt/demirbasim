import 'dart:ui';

import 'package:demirbasim/theme/all_theme.dart';
import 'package:flutter/material.dart';

Widget buildLogo(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Container(
              width: double.infinity,
              height: 370,
              decoration: BoxDecoration(
                color: const Color(0xFF262D34),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/blur.jpg',
                  ).image,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                border: Border.all(
                  color: DemirBasimTheme.of(context).primaryText,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 370,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E2429), Color(0x001E2429)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, 1),
              end: AlignmentDirectional(0, -1),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: Image.asset(
                  'assets/beyazuzun.png',
                  width: 300,
                  height: 120,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hoşgeldin!',
                            style: DemirBasimTheme.of(context).displaySmall.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'DemirBaşım ile Evini Hatırla!',
                            style: DemirBasimTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Lexend Deca',
                                  color: const Color(0xB3FFFFFF),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w200,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row odalarText() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'Odalar',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 20,
                ),
              ),
            ),
            // Other widgets...
          ],
        );
  }