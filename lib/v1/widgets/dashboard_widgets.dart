
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/charts.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class LineChartSeries extends StatelessWidget {
  const LineChartSeries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Material(
        elevation: 10.0,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: 20.h, horizontal: 15.w),
          decoration: BoxDecoration(
              border: Border.all(
                  color: baseColorLight, width: 0.4),
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white),
          child: const LineChartSample1(),
        ),
      ),
    );
  }
}



class ReachHotspotMap extends StatelessWidget {
  const ReachHotspotMap({
    super.key,
    required this.contextController,
    required this.contextAttachKey,
    required this.context,
  });

  final fluent.FlyoutController contextController;
  final GlobalKey<State<StatefulWidget>> contextAttachKey;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        elevation: 10.0,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 460,
          padding: EdgeInsets.symmetric(
              vertical: 20.h, horizontal: 15.w),
          decoration: BoxDecoration(
              border: Border.all(
                  color: baseColorLight, width: 0.4),
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              headingBig(text: 'Reach Hotspots'),
              20.ph,
              Expanded(
                child: fluent.FlyoutTarget(
                  controller: contextController,
                  child: SimpleMap(
                    key: contextAttachKey,
                    instructions:
                        SMapUganda.instructions,
                    defaultColor: baseColorLight,
                    colors: SMapUgandaColors().toMap(),
                    countryBorder: const CountryBorder(
                        color: Colors.white),
                    callback: (id, name, tapdetails) {
                      print(id);
                      print(name);

                      final targetContext =
                          contextAttachKey
                              .currentContext;

                      if (targetContext == null) return;
                      final box = targetContext
                              .findRenderObject()
                          as RenderBox;
                      final position =
                          box.localToGlobal(
                        tapdetails.localPosition,
                        ancestor: Navigator.of(context)
                            .context
                            .findRenderObject(),
                      );

                      if (id.isNotEmpty) {
                        contextController.showFlyout(
                            margin: 0,
                            additionalOffset: 0,
                            dismissOnPointerMoveAway:
                                true,
                            barrierColor: Colors.black
                                .withOpacity(0.1),
                            position: position,
                            builder: (context) {
                              return fluent
                                  .FlyoutContent(
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    paragraph(
                                        text: name,
                                        color: Colors
                                            .black,
                                        fontSize: 8.sp),
                                  ],
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


