import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SpeedDialFab extends StatefulWidget {
  /// Posición inicial. Si dy == -1, el widget la calcula al primer build.
  final Offset initialPosition;
  final ValueChanged<Offset> onPositionChanged;

  /// URL de "Agendar cita" que se carga en el WebView.
  final String agendarUrl;

  /// Número de WhatsApp (solo dígitos, sin espacios ni guiones).
  final String whatsappNumber;

  /// URL de Google Maps que se abre en la app externa.
  final String mapsUrl;

  /// Callback para que el padre cargue una URL en el WebView
  /// (así reutilizamos el Loader existente).
  final ValueChanged<String> onLoadUrl;

  const SpeedDialFab({
    super.key,
    required this.initialPosition,
    required this.onPositionChanged,
    required this.agendarUrl,
    required this.whatsappNumber,
    required this.mapsUrl,
    required this.onLoadUrl,
  });

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late Offset _position;
  bool _initialized = false;
  bool _isOpen = false;
  bool _isDragging = false;

  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  static const _bgColor = Color(0xFF1C2C4C);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      _position = widget.initialPosition.dy == -1
          ? Offset(24, size.height - 350)
          : widget.initialPosition;
      _initialized = true;
    }
  }

  // ── Lógica de arrastre ──────────────────────────────────────────────────────
  void _onPanStart(DragStartDetails _) {
    _isDragging = false;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    _isDragging = true;
    if (_isOpen) _closeMenu();
    setState(() {
      _position = Offset(
        (_position.dx + details.delta.dx).clamp(0, size.width - 56),
        (_position.dy + details.delta.dy).clamp(0, size.height - 56),
      );
    });
    widget.onPositionChanged(_position);
  }

  // ── Lógica del menú ─────────────────────────────────────────────────────────
  void _toggleMenu() {
    if (_isDragging) {
      _isDragging = false;
      return;
    }
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _animController.forward() : _animController.reverse();
  }

  void _closeMenu() {
    setState(() => _isOpen = false);
    _animController.reverse();
  }

  // ── Acciones ────────────────────────────────────────────────────────────────
  void _onAgendar() {
    _closeMenu();
    widget.onLoadUrl(widget.agendarUrl);
  }

  Future<void> _onWhatsApp() async {
    _closeMenu();
    final number = widget.whatsappNumber.replaceAll(RegExp(r'\D'), '');
    // Intentar abrir con la app nativa de WhatsApp primero
    final nativeUri = Uri.parse('whatsapp://send?phone=$number');
    final webUri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: abrir en navegador externo
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _onMaps() async {
    _closeMenu();
    // maps.app.goo.gl redirige a intent://, el WebView no lo puede manejar.
    // Abrimos directamente en la app de Google Maps (o navegador como fallback).
    final uri = Uri.parse(widget.mapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onShare() {
    _closeMenu();
    Share.share(
      '¡Hola! Te invito a agendar una cita en Interiorisma. Puedes hacerlo desde aquí: ${widget.agendarUrl}',
      subject: 'Agendar cita en Interiorisma',
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────────
  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int index = 0,
  }) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Etiqueta
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              elevation: 3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _bgColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Botón circular
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: _bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Opciones del menú ────────────────────────────────────────────
            if (_isOpen) ...[
              _buildOption(
                icon: Icons.calendar_month_rounded,
                label: 'Agendar cita',
                onTap: _onAgendar,
                index: 0,
              ),
              _buildOption(
                icon: Icons.chat_rounded,
                label: 'WhatsApp',
                onTap: _onWhatsApp,
                index: 1,
              ),
              _buildOption(
                icon: Icons.location_on_rounded,
                label: 'Cómo llegar',
                onTap: _onMaps,
                index: 2,
              ),
              _buildOption(
                icon: Icons.share_rounded,
                label: 'Compartir',
                onTap: _onShare,
                index: 3,
              ),
            ],

            // ── Botón principal ──────────────────────────────────────────────
            GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _bgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _isOpen ? 0.125 : 0, // rota 45° al abrir
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
