import 'package:flutter/material.dart';
import 'package:long_term_bets/data/ActionButton.dart';
import 'package:long_term_bets/data/Bets.dart';
import 'package:long_term_bets/data/IconStyle.dart';
import 'package:long_term_bets/mixins/WidgetHelper.dart';
import 'package:long_term_bets/styles/AppColors.dart';
import 'package:long_term_bets/widgets/BetCard/WinnerPicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BetActionsState extends State<BetActions> with WidgetHelper{
  BetActionsState({@required this.bets, @required this.bet, @required this.mainContext});

  final Bets bets;
  final Bet bet;
  final BuildContext mainContext;

  Better _selected;

  final Color _contentColor = AppColors.buttonText;
  final bool _isFlat = false;

  @override
  void initState() {
    super.initState();
    _selected = bet.better;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _actionButtons().map((ActionButton button) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child:button.generateButton()
        );
      }).toList()
    );
  }

  void _setSelected(Better value) {
   setState(() {
    _selected = value;
   });
  }

  ActionButton _createActionButton(
    String text,
    Color background,
    IconData icon,
    Function onPressed,
    ) {
    return ActionButton(
      text: text,
      textColor: _contentColor,
      color: background,
      iconStyle: IconStyle(color: _contentColor, icon: icon),
      isFlat: _isFlat,
      onPressed: onPressed,
    );
  }

  ActionButton _editButton() {
    final Function pressFn = (){};

    return _createActionButton('Edit', AppColors.secondary, Icons.edit, pressFn);
  }

  ActionButton _deleteButon() {
    final Function pressFn = () {
      bets.delete(bet);
      Navigator.pop(mainContext);
    };

    return _createActionButton(
      'Delete',
      AppColors.danger,
      Icons.delete_forever,
      pressFn,
    );
  }

  ActionButton _setWinnerButton() {
    final Function pressFn = () {
      bets.markAsCompleted(bet, _selected);
    };
    return _createActionButton('Confirm', AppColors.success, MdiIcons.trophy, pressFn);
  }

  ActionButton _setProgressButton() {

    if (!bet.isCompleted()) {
      final WinnerPicker winnerPicker = WinnerPicker(
        accepter: bet.accepter,
        better: bet.better,
        context: mainContext,
        onChanged: _setSelected,
      );
      final Function pressFn = () {
        showAlert(
          mainContext,
          '🤓 Who Won?',
          winnerPicker,
          <ActionButton>[_setWinnerButton()]
        );
      };

      return _createActionButton('Done', AppColors.success, Icons.check_circle, pressFn);
    } else {
      final Function pressFn = () => bets.markAsRunning(bet);

      return _createActionButton(
        'Running',
        AppColors.info,
        Icons.directions_run,
        pressFn,
      );
    }
  }

  List<ActionButton> _actionButtons() {
    return <ActionButton>[
      _setProgressButton(),
      _editButton(),
      _deleteButon(),
    ];
  }
}

class BetActions extends StatefulWidget {
  const BetActions({@required this.bets, @required this.bet, @required this.mainContext});

  final Bets bets;
  final Bet bet;
  final BuildContext mainContext;

  @override
  BetActionsState createState() => BetActionsState(
    bets: bets,
    bet: bet,
    mainContext: mainContext
  );
}