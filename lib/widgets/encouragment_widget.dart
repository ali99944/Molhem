import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EncouragementDialog extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onClose;

  EncouragementDialog({
    required this.message,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64.0,
              color: Color(0xff7ea5ad),
          ),
          SizedBox(height: 16.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onClose,
            style: ElevatedButton.styleFrom(
              primary: Color(0xff7ea5ad),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
            ),
            child: Text(
              'lets_go',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).tr(),
          ),
        ],
      ),
    );
  }
}