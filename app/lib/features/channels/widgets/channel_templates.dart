import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/message.dart';
import '../../../models/channel.dart';

/// Channel templates for different types with predefined messages and styling
class ChannelTemplates {
  /// App Development template messages
  static List<Message> getAppDevelopmentMessages() {
    return [
      Message(
        id: 'template_1',
        senderId: 'ai_assistant',
        senderName: 'AI Assistant',
        content: '🚀 ¡Bienvenidos al canal de Desarrollo de App!\n\nEste es tu espacio para colaborar en el desarrollo. Aquí puedes:\n• Discutir arquitectura y diseño\n• Compartir código y prototipos\n• Planificar sprints y features\n• Resolver bugs técnicos\n\n¿En qué estamos trabajando hoy?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.system,
      ),
      Message(
        id: 'template_2',
        senderId: 'user1',
        senderName: 'Carlos Morales',
        content: 'He estado trabajando en la nueva UI del dashboard. @Ana ¿podrías revisar el diseño que subí a Figma?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        type: MessageType.text,
        mentions: ['Ana'],
        reactions: [
          MessageReaction(emoji: '👍', userIds: ['user2', 'user3']),
          MessageReaction(emoji: '👀', userIds: ['user4']),
        ],
      ),
      Message(
        id: 'template_3',
        senderId: 'user2',
        senderName: 'Ana Rodriguez',
        content: 'Perfecto @Carlos! Lo revisaré ahora mismo. También necesitamos definir los componentes reutilizables para mantener consistencia.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
        mentions: ['Carlos'],
        reactions: [
          MessageReaction(emoji: '✅', userIds: ['user1']),
        ],
      ),
    ];
  }

  /// Marketing Campaign template messages
  static List<Message> getMarketingCampaignMessages() {
    return [
      Message(
        id: 'template_1',
        senderId: 'ai_assistant',
        senderName: 'AI Assistant',
        content: '📢 ¡Canal de Campaña de Marketing activo!\n\nEste espacio está dedicado a:\n• Estrategia y planificación de campañas\n• Análisis de métricas y KPIs\n• Contenido creativo y copy\n• Coordinación con equipos\n\n¡Lancemos campañas exitosas juntos! 🎯',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.system,
      ),
      Message(
        id: 'template_2',
        senderId: 'user1',
        senderName: 'María González',
        content: 'Equipo, necesitamos acelerar la campaña Q4. @Pedro ¿tienes listas las creatividades para redes sociales?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.text,
        mentions: ['Pedro'],
        reactions: [
          MessageReaction(emoji: '🚀', userIds: ['user2']),
          MessageReaction(emoji: '👍', userIds: ['user3', 'user4']),
        ],
      ),
      Message(
        id: 'template_3',
        senderId: 'user2',
        senderName: 'Pedro Sánchez',
        content: '@María ya tengo las 10 opciones de diseño. Las subiré al drive ahora. También propongo hacer A/B testing con 3 versiones.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        type: MessageType.text,
        mentions: ['María'],
        reactions: [
          MessageReaction(emoji: '🎨', userIds: ['user1']),
          MessageReaction(emoji: '💡', userIds: ['user3']),
        ],
      ),
    ];
  }

  /// Team Building Event template messages
  static List<Message> getTeamBuildingMessages() {
    return [
      Message(
        id: 'template_1',
        senderId: 'ai_assistant',
        senderName: 'AI Assistant',
        content: '🎉 ¡Bienvenidos al canal de Team Building!\n\nAquí organizamos:\n• Eventos y actividades divertidas\n• Reuniones sociales del equipo\n• Celebraciones y reconocimientos\n• Dinámicas de integración\n\n¡Creemos momentos memorables juntos! 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: MessageType.system,
      ),
      Message(
        id: 'template_2',
        senderId: 'user1',
        senderName: 'Laura Jiménez',
        content: '¡Hola equipo! Estoy organizando el evento anual del viernes. @Todos ¿prefieren actividades al aire libre o algo más tranquilo indoor?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        type: MessageType.text,
        mentions: ['Todos'],
        reactions: [
          MessageReaction(emoji: '🌳', userIds: ['user2', 'user4']),
          MessageReaction(emoji: '🏠', userIds: ['user3']),
          MessageReaction(emoji: '🤔', userIds: ['user5']),
        ],
      ),
      Message(
        id: 'template_3',
        senderId: 'user2',
        senderName: 'Roberto Vega',
        content: 'Yo voto por aire libre 🌳 Podríamos hacer un picnic en el parque seguido de juegos en equipo. ¿Qué opinan?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        type: MessageType.text,
        reactions: [
          MessageReaction(emoji: '🙌', userIds: ['user1', 'user4', 'user5']),
          MessageReaction(emoji: '🍃', userIds: ['user3']),
        ],
      ),
    ];
  }

  /// Budget Review template messages
  static List<Message> getBudgetReviewMessages() {
    return [
      Message(
        id: 'template_1',
        senderId: 'ai_assistant',
        senderName: 'AI Assistant',
        content: '💰 Canal de Revisión de Presupuesto\n\nEste canal confidencial es para:\n• Análisis financiero trimestral\n• Planificación de inversiones\n• Control de gastos y recursos\n• Decisiones estratégicas de presupuesto\n\n📊 Mantengamos la salud financiera del proyecto',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: MessageType.system,
      ),
      Message(
        id: 'template_2',
        senderId: 'user1',
        senderName: 'Director Financiero',
        content: '@Equipo necesitamos revisar los números del Q3. El gasto en desarrollo ha aumentado 15% pero también nuestros ingresos. Analicemos juntos.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        mentions: ['Equipo'],
        reactions: [
          MessageReaction(emoji: '📈', userIds: ['user2']),
          MessageReaction(emoji: '🔍', userIds: ['user3']),
        ],
      ),
      Message(
        id: 'template_3',
        senderId: 'user2',
        senderName: 'CEO',
        content: 'Buen punto. Propongo que para Q4 asignemos 20% más al marketing digital ya que está dando excelente ROI. @CFO ¿es viable?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
        mentions: ['CFO'],
        reactions: [
          MessageReaction(emoji: '💡', userIds: ['user1']),
          MessageReaction(emoji: '✅', userIds: ['user3']),
        ],
      ),
    ];
  }

  /// Get template messages based on channel category
  static List<Message> getTemplateMessages(String category) {
    switch (category.toLowerCase()) {
      case 'development':
        return getAppDevelopmentMessages();
      case 'marketing':
        return getMarketingCampaignMessages();
      case 'events':
        return getTeamBuildingMessages();
      case 'finance':
        return getBudgetReviewMessages();
      default:
        return getDefaultMessages();
    }
  }

  /// Default template messages
  static List<Message> getDefaultMessages() {
    return [
      Message(
        id: 'default_1',
        senderId: 'ai_assistant',
        senderName: 'AI Assistant',
        content: '👋 ¡Bienvenidos al canal!\n\nEste es tu espacio de colaboración. Aquí puedes:\n• Comunicarte con tu equipo\n• Compartir archivos e ideas\n• Coordinarte en proyectos\n• Hacer lluvia de ideas\n\n¡Comencemos a colaborar!',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.system,
      ),
    ];
  }

  /// Get channel-specific placeholder text
  static String getPlaceholderText(String category) {
    switch (category.toLowerCase()) {
      case 'development':
        return 'Comparte tu código, ideas o bugs aquí...';
      case 'marketing':
        return 'Discute estrategias, creatividades y métricas...';
      case 'events':
        return 'Planifica actividades y eventos divertidos...';
      case 'finance':
        return 'Analiza presupuestos y decisiones financieras...';
      default:
        return 'Escribe un mensaje...';
    }
  }

  /// Get channel-specific theme colors
  static ChannelTheme getChannelTheme(String category) {
    switch (category.toLowerCase()) {
      case 'development':
        return ChannelTheme(
          primaryColor: const Color(0xFF0066CC),
          secondaryColor: const Color(0xFF00AAFF),
          icon: Icons.code,
          gradient: const LinearGradient(
            colors: [Color(0xFF0066CC), Color(0xFF00AAFF)],
          ),
        );
      case 'marketing':
        return ChannelTheme(
          primaryColor: const Color(0xFFFF6B35),
          secondaryColor: const Color(0xFFFF8E53),
          icon: Icons.campaign,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
          ),
        );
      case 'events':
        return ChannelTheme(
          primaryColor: const Color(0xFF10B981),
          secondaryColor: const Color(0xFF34D399),
          icon: Icons.celebration,
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
          ),
        );
      case 'finance':
        return ChannelTheme(
          primaryColor: const Color(0xFF8B5CF6),
          secondaryColor: const Color(0xFFA78BFA),
          icon: Icons.account_balance,
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
          ),
        );
      default:
        return ChannelTheme(
          primaryColor: AppColors.primary,
          secondaryColor: AppColors.secondary,
          icon: Icons.chat,
          gradient: AppColors.primaryGradient,
        );
    }
  }
}

/// Channel theme configuration
class ChannelTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final LinearGradient gradient;

  ChannelTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.gradient,
  });
}

/// Enhanced channel header with theme support
class EnhancedChannelHeader extends StatelessWidget {
  final Channel channel;
  final bool isDark;
  final VoidCallback? onBackPressed;

  const EnhancedChannelHeader({
    super.key,
    required this.channel,
    this.isDark = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChannelTemplates.getChannelTheme(channel.category);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(AppConstants.spacing16, 50, AppConstants.spacing16, AppConstants.spacing16), // Added top padding for status bar
      decoration: BoxDecoration(
        gradient: theme.gradient.scale(0.1),
        borderRadius: _shouldHaveRoundedCorners(channel.category) 
            ? BorderRadius.circular(16) 
            : null,
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          if (onBackPressed != null) ...[
            _buildActionButton(
              icon: Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              onTap: onBackPressed!,
            ),
            const SizedBox(width: AppConstants.spacing12),
          ],
          
          // Channel icon with theme
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: theme.gradient,
              borderRadius: BorderRadius.circular(AppConstants.spacing8),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              theme.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppConstants.spacing12),
          
          // Channel info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: AppConstants.spacing4),
                    Text(
                      '${channel.memberCount} miembros',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark 
                            ? AppColors.darkTextSecondary 
                            : AppColors.lightTextSecondary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    if (channel.isPrivate) ...[
                      const SizedBox(width: AppConstants.spacing8),
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: AppConstants.spacing4),
                      Text(
                        'Privado',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Action buttons
          Row(
            children: [
              _buildActionButton(
                icon: Icons.videocam_outlined,
                color: theme.primaryColor,
                onTap: () {},
              ),
              const SizedBox(width: AppConstants.spacing8),
              _buildActionButton(
                icon: Icons.phone_outlined,
                color: theme.primaryColor,
                onTap: () {},
              ),
              const SizedBox(width: AppConstants.spacing8),
              _buildActionButton(
                icon: Icons.more_vert,
                color: isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.spacing6),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing6),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    );
  }

  /// Check if the channel category should have rounded corners
  bool _shouldHaveRoundedCorners(String category) {
    final roundedCategories = [
      'development',
      'marketing', 
      'events',
      'finance'
    ];
    return roundedCategories.contains(category.toLowerCase());
  }
}

/// Extension for gradient scaling
extension GradientScale on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      colors: colors.map((color) => color.withValues(alpha: opacity)).toList(),
      begin: begin,
      end: end,
      stops: stops,
    );
  }
} 