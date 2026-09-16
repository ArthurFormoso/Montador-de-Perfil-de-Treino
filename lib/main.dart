import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext meuctx) {
    return MaterialApp(
      title: 'Montador de Perfil de Treino',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const PerfilTreinoPage(),
    );
  }
}

enum Objetivo { emagrecimento, hipertrofia, condicionamento }
enum Nivel { iniciante, intermediario, avancado }

class PerfilTreinoPage extends StatefulWidget {
  const PerfilTreinoPage({super.key});

  @override
  State<PerfilTreinoPage> createState() => _PerfilTreinoPageState();
}

class _PerfilTreinoPageState extends State<PerfilTreinoPage> {
  Objetivo? _objetivoSelecionado;
  Nivel? _nivelSelecionado;

  final List<String> _opcoesRestricoes = [
    'Vegetariano',
    'Vegano',
    'Sem lactose',
    'Sem glúten',
    'Low Carb'
  ];
  final Set<String> _restricoesSelecionadas = {};

  final List<String> _alergias = ['Amendoim', 'Camarão'];
  final TextEditingController _alergiaController = TextEditingController();

  double _tempoDiario = 60;

  int? _frequenciaSemanal;

  bool _notificacoesAgua = false;
  bool _aceitouTermos = false;

  void _adicionarAlergia() {
    final texto = _alergiaController.text.trim();
    if (texto.isEmpty) return;

    final jaExiste = _alergias.any(
      (a) => a.toLowerCase() == texto.toLowerCase(),
    );

    if (!jaExiste) {
      setState(() {
        _alergias.add(texto);
        _alergiaController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta alergia já foi adicionada.')),
      );
    }
  }

  void _removerAlergia(String alergia) {
    setState(() {
      _alergias.remove(alergia);
    });
  }

  void _validarEGerarPlano() {
    List<String> erros = [];

    if (_objetivoSelecionado == null) {
      erros.add('Selecione o objetivo do treino.');
    }
    if (_nivelSelecionado == null) {
      erros.add('Selecione seu nível de experiência.');
    }
    if (_frequenciaSemanal == null) {
      erros.add('Selecione a frequência semanal.');
    }
    if (!_aceitouTermos) {
      erros.add('Você precisa aceitar os termos e condições.');
    }

    if (erros.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erros.join('\n')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    _exibirBottomSheetResumo();
  }

  void _exibirBottomSheetResumo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seu perfil de treino',
                style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Divider(height: 24),
              _itemResumo('Objetivo', _getObjetivoTexto(_objetivoSelecionado)),
              _itemResumo('Nível', _getNivelTexto(_nivelSelecionado)),
              _itemResumo(
                'Restrições alimentares',
                _restricoesSelecionadas.isEmpty
                    ? 'Nenhuma'
                    : _restricoesSelecionadas.join(', '),
              ),
              _itemResumo(
                'Alergias',
                _alergias.isEmpty ? 'Nenhuma' : _alergias.join(', '),
              ),
              _itemResumo('Tempo diário', '${_tempoDiario.round()} minutos'),
              _itemResumo(
                'Frequência',
                '$_frequenciaSemanal dias por semana',
              ),
              _itemResumo(
                'Notificações de água',
                _notificacoesAgua ? 'Ativadas' : 'Desativadas',
              ),
              _itemResumo(
                'Termos',
                _aceitouTermos ? 'Aceitos' : 'Não aceitos',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _itemResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  String _getObjetivoTexto(Objetivo? obj) {
    switch (obj) {
      case Objetivo.emagrecimento:
        return 'Emagrecimento';
      case Objetivo.hipertrofia:
        return 'Hipertrofia';
      case Objetivo.condicionamento:
        return 'Condicionamento';
      default:
        return '';
    }
  }

  String _getNivelTexto(Nivel? niv) {
    switch (niv) {
      case Nivel.iniciante:
        return 'Iniciante';
      case Nivel.intermediario:
        return 'Intermediário';
      case Nivel.avancado:
        return 'Avançado';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montador de Perfil de Treino'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('OBJETIVO DO TREINO'),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Objetivo>(
                segments: const [
                  ButtonSegment(
                    value: Objetivo.emagrecimento,
                    label: Text('Emagrec.'),
                  ),
                  ButtonSegment(
                    value: Objetivo.hipertrofia,
                    label: Text('Hipertrofia'),
                  ),
                  ButtonSegment(
                    value: Objetivo.condicionamento,
                    label: Text('Condicion.'),
                  ),
                ],
                selected: _objetivoSelecionado != null
                    ? {_objetivoSelecionado!}
                    : {},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _objetivoSelecionado = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('NÍVEL DE EXPERIÊNCIA'),
            Wrap(
              spacing: 8.0,
              children: Nivel.values.map((nivel) {
                return ChoiceChip(
                  label: Text(_getNivelTexto(nivel)),
                  selected: _nivelSelecionado == nivel,
                  onSelected: (selected) {
                    setState(() {
                      _nivelSelecionado = selected ? nivel : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('RESTRIÇÕES ALIMENTARES'),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _opcoesRestricoes.map((restricao) {
                final isSelected = _restricoesSelecionadas.contains(restricao);
                return FilterChip(
                  label: Text(restricao),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _restricoesSelecionadas.add(restricao);
                      } else {
                        _restricoesSelecionadas.remove(restricao);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('ALERGIAS'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _alergiaController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma alergia...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _adicionarAlergia(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _adicionarAlergia,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _alergias.map((alergia) {
                return InputChip(
                  label: Text(alergia),
                  onDeleted: () => _removerAlergia(alergia),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('TEMPO DIÁRIO'),
            Slider(
              value: _tempoDiario,
              min: 15,
              max: 120,
              divisions: 21,
              label: '${_tempoDiario.round()} min',
              onChanged: (double value) {
                setState(() {
                  _tempoDiario = value;
                });
              },
            ),
            Center(
              child: Text(
                '${_tempoDiario.round()} minutos',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('FREQUÊNCIA SEMANAL'),
            ...List.generate(5, (index) {
              final dias = index + 2;
              return RadioListTile<int>(
                title: Text('$dias dias por semana'),
                value: dias,
                groupValue: _frequenciaSemanal,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _frequenciaSemanal = value;
                  });
                },
              );
            }),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text('Receber notificações de água'),
              subtitle: const Text('Lembretes durante o dia'),
              value: _notificacoesAgua,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _notificacoesAgua = value;
                });
              },
            ),

            CheckboxListTile(
              title: const Text(
                'Aceito os termos e condições para geração do plano de treino.',
                style: TextStyle(fontSize: 13),
              ),
              value: _aceitouTermos,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _aceitouTermos = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _validarEGerarPlano,
                child: const Text(
                  'GERAR PLANO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}