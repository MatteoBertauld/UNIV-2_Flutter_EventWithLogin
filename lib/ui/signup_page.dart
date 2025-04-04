import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String username = '';
  String password = '';
  String confirmPassword = '';
  String? error;

  final _formKey = GlobalKey<FormState>();

  // Fonction pour valider que les mots de passe sont identiques
  String? _validatePasswordMatch(String? value) {
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final user = await context.read<AuthState>().signup(username, password);
    if (user == true) {
      // Vérifie que le contexte est toujours valide avant de naviguer
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } else {
      setState(() {
        error = 'Une erreur est survenue.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Identifiant'),
            onChanged: (value) => username = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: _validateRequired,
          ),
          TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Confirmer votre Mot de passe'),
              obscureText: true,
              onChanged: (value) => confirmPassword = value,
              validator: (value) {
                // Vérifie si les mots de passe sont identiques
                String? error = _validateRequired(value);
                if (error != null) {
                  return error;
                }
                return _validatePasswordMatch(value);
              }),
          const SizedBox(height: 16),
          if (error != null)
            Text(
              error!,
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ElevatedButton(
              onPressed: _submit,
              child: const Text('Création de votre compte')),
        ],
      ),
    );
  }
}
