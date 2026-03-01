// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Lemon Coreano';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get enterEmail => 'Ingresa tu correo electrónico';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get enterConfirmPassword => 'Ingresa tu contraseña nuevamente';

  @override
  String get enterUsername => 'Ingresa tu nombre de usuario';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get startJourney => 'Comienza tu viaje de aprendizaje del coreano';

  @override
  String get interfaceLanguage => 'Idioma de la interfaz';

  @override
  String get simplifiedChinese => 'Chino simplificado';

  @override
  String get traditionalChinese => 'Chino tradicional';

  @override
  String get passwordRequirements => 'Requisitos de contraseña';

  @override
  String minCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Al menos $count caracteres',
      one: 'Al menos $count carácter',
    );
    return '$_temp0';
  }

  @override
  String get containLettersNumbers => 'Contiene letras y números';

  @override
  String get haveAccount => '¿Ya tienes una cuenta?';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get loginNow => 'Inicia sesión ahora';

  @override
  String get registerNow => 'Regístrate ahora';

  @override
  String get registerSuccess => 'Registro exitoso';

  @override
  String get registerFailed => 'Registro fallido';

  @override
  String get loginSuccess => 'Inicio de sesión exitoso';

  @override
  String get loginFailed => 'Inicio de sesión fallido';

  @override
  String get networkError =>
      'Error de conexión. Por favor verifica tu configuración de red.';

  @override
  String get invalidCredentials => 'Correo electrónico o contraseña inválidos';

  @override
  String get emailAlreadyExists => 'El correo electrónico ya está registrado';

  @override
  String get requestTimeout =>
      'Tiempo de solicitud agotado. Por favor intenta de nuevo.';

  @override
  String get operationFailed => 'Algo salió mal. Por favor intenta más tarde.';

  @override
  String get settings => 'Configuración';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get chineseDisplay => 'Visualización del chino';

  @override
  String get chineseDisplayDesc =>
      'Elige cómo se muestran los caracteres chinos. Los cambios se aplicarán a todas las pantallas inmediatamente.';

  @override
  String get switchedToSimplified => 'Cambiado a chino simplificado';

  @override
  String get switchedToTraditional => 'Cambiado a chino tradicional';

  @override
  String get displayTip =>
      'Consejo: El contenido de las lecciones se mostrará usando la fuente china seleccionada.';

  @override
  String get notificationSettings => 'Configuración de notificaciones';

  @override
  String get enableNotifications => 'Habilitar notificaciones';

  @override
  String get enableNotificationsDesc =>
      'Activa para recibir recordatorios de aprendizaje';

  @override
  String get permissionRequired =>
      'Por favor permite los permisos de notificación en la configuración del sistema';

  @override
  String get dailyLearningReminder => 'Recordatorio diario de aprendizaje';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get dailyReminderDesc =>
      'Recibe un recordatorio a una hora fija cada día';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String reminderTimeSet(String time) {
    return 'Hora del recordatorio establecida a las $time';
  }

  @override
  String get reviewReminder => 'Recordatorio de repaso';

  @override
  String get reviewReminderDesc =>
      'Recibe recordatorios basados en la curva de memoria';

  @override
  String get notificationTip => 'Consejo:';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get offlineLearning => 'Aprendizaje sin conexión';

  @override
  String get howToDownload => '¿Cómo descargo las lecciones?';

  @override
  String get howToDownloadAnswer =>
      'En la lista de lecciones, toca el ícono de descarga a la derecha para descargar una lección. Puedes estudiar sin conexión después de descargar.';

  @override
  String get howToUseDownloaded => '¿Cómo uso las lecciones descargadas?';

  @override
  String get howToUseDownloadedAnswer =>
      'Puedes estudiar las lecciones descargadas normalmente incluso sin conexión a la red. El progreso se guarda localmente y se sincroniza automáticamente cuando te reconectes.';

  @override
  String get storageManagement => 'Gestión de almacenamiento';

  @override
  String get howToCheckStorage =>
      '¿Cómo verifico el espacio de almacenamiento?';

  @override
  String get howToCheckStorageAnswer =>
      'Ve a [Configuración → Gestión de almacenamiento] para ver el espacio utilizado y disponible.';

  @override
  String get howToDeleteDownloaded =>
      '¿Cómo elimino las lecciones descargadas?';

  @override
  String get howToDeleteDownloadedAnswer =>
      'En [Gestión de almacenamiento], toca el botón de eliminar junto a la lección para borrarla.';

  @override
  String get notificationSection => 'Configuración de notificaciones';

  @override
  String get howToEnableReminder =>
      '¿Cómo activo los recordatorios de aprendizaje?';

  @override
  String get howToEnableReminderAnswer =>
      'Ve a [Configuración → Configuración de notificaciones] y activa [Habilitar notificaciones]. Necesitas otorgar permisos de notificación en el primer uso.';

  @override
  String get whatIsReviewReminder => '¿Qué es un recordatorio de repaso?';

  @override
  String get whatIsReviewReminderAnswer =>
      'Basado en el algoritmo de repetición espaciada (SRS), la aplicación te recordará repasar las lecciones completadas en momentos óptimos. Intervalos de repaso: 1 día → 3 días → 7 días → 14 días → 30 días.';

  @override
  String get languageSection => 'Configuración de idioma';

  @override
  String get howToSwitchChinese =>
      '¿Cómo cambio entre chino simplificado y tradicional?';

  @override
  String get howToSwitchChineseAnswer =>
      'Ve a [Configuración → Configuración de idioma] y selecciona [Chino simplificado] o [Chino tradicional]. Los cambios se aplican inmediatamente.';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get howToStart => '¿Cómo empiezo a aprender?';

  @override
  String get howToStartAnswer =>
      'En la pantalla principal, selecciona una lección apropiada para tu nivel y comienza desde la Lección 1. Cada lección consta de 7 etapas.';

  @override
  String get progressNotSaved => '¿Qué pasa si mi progreso no se guarda?';

  @override
  String get progressNotSavedAnswer =>
      'El progreso se guarda automáticamente de forma local. Si estás en línea, se sincronizará automáticamente con el servidor. Por favor verifica tu conexión de red.';

  @override
  String get aboutApp => 'Acerca de la aplicación';

  @override
  String get moreInfo => 'Más información';

  @override
  String get versionInfo => 'Información de versión';

  @override
  String get developer => 'Desarrollador';

  @override
  String get appIntro => 'Introducción de la aplicación';

  @override
  String get appIntroContent =>
      'Una aplicación de aprendizaje de coreano con aprendizaje sin conexión, recordatorios inteligentes de repaso y mucho más.';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get termsComingSoon =>
      'Página de términos de servicio en desarrollo...';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyComingSoon =>
      'Página de política de privacidad en desarrollo...';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get notStarted => 'No iniciado';

  @override
  String get inProgress => 'En progreso';

  @override
  String get completed => 'Completado';

  @override
  String get notPassed => 'No aprobado';

  @override
  String get timeToReview => 'Hora de repasar';

  @override
  String get today => 'Hoy';

  @override
  String get tomorrow => 'Mañana';

  @override
  String daysLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En $count días',
      one: 'En $count día',
    );
    return '$_temp0';
  }

  @override
  String get noun => 'Sustantivo';

  @override
  String get verb => 'Verbo';

  @override
  String get adjective => 'Adjetivo';

  @override
  String get adverb => 'Adverbio';

  @override
  String get particle => 'Partícula';

  @override
  String get pronoun => 'Pronombre';

  @override
  String get highSimilarity => 'Alta similitud';

  @override
  String get mediumSimilarity => 'Similitud media';

  @override
  String get lowSimilarity => 'Baja similitud';

  @override
  String get learningComplete => 'Aprendizaje completado';

  @override
  String experiencePoints(int points) {
    return '+$points XP';
  }

  @override
  String get keepLearning => 'Mantén tu motivación de aprendizaje';

  @override
  String get streakDays => 'Racha +1 día';

  @override
  String streakDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Racha de $days días',
      one: 'Racha de $days día',
    );
    return '$_temp0';
  }

  @override
  String get lessonContent => 'Contenido de la lección';

  @override
  String get words => 'Palabras';

  @override
  String get grammarPoints => 'Puntos de gramática';

  @override
  String get dialogues => 'Diálogos';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get topicParticle => 'Partícula de tema';

  @override
  String get honorificEnding => 'Terminación honorífica';

  @override
  String get questionWord => 'Qué';

  @override
  String get hello => 'Hola';

  @override
  String get thankYou => 'Gracias';

  @override
  String get goodbye => 'Adiós';

  @override
  String get sorry => 'Lo siento';

  @override
  String get imStudent => 'Soy estudiante';

  @override
  String get bookInteresting => 'El libro es interesante';

  @override
  String get isStudent => 'es estudiante';

  @override
  String get isTeacher => 'es profesor';

  @override
  String get whatIsThis => '¿Qué es esto?';

  @override
  String get whatDoingPolite => '¿Qué estás haciendo?';

  @override
  String get listenAndChoose => 'Escucha y elige la traducción correcta';

  @override
  String get fillInBlank => 'Completa con la partícula correcta';

  @override
  String get chooseTranslation => 'Elige la traducción correcta';

  @override
  String get arrangeWords => 'Ordena las palabras correctamente';

  @override
  String get choosePronunciation => 'Elige la pronunciación correcta';

  @override
  String get consonantEnding =>
      '¿Qué partícula de tema se debe usar cuando un sustantivo termina en consonante?';

  @override
  String get correctSentence => 'Elige la oración correcta';

  @override
  String get allCorrect => 'Todas las anteriores';

  @override
  String get howAreYou => '¿Cómo estás?';

  @override
  String get whatIsYourName => '¿Cuál es tu nombre?';

  @override
  String get whoAreYou => '¿Quién eres?';

  @override
  String get whereAreYou => '¿Dónde estás?';

  @override
  String get niceToMeetYou => 'Mucho gusto';

  @override
  String get areYouStudent => 'Eres estudiante';

  @override
  String get areYouStudentQuestion => '¿Eres estudiante?';

  @override
  String get amIStudent => '¿Soy estudiante?';

  @override
  String get listening => 'Escucha';

  @override
  String get translation => 'Traducción';

  @override
  String get wordOrder => 'Orden de palabras';

  @override
  String get excellent => '¡Excelente!';

  @override
  String get correctOrderIs => 'Orden correcto:';

  @override
  String get nextQuestion => 'Siguiente pregunta';

  @override
  String get finish => 'Finalizar';

  @override
  String get quizComplete => '¡Cuestionario completado!';

  @override
  String get greatJob => '¡Buen trabajo!';

  @override
  String get keepPracticing => '¡Sigue así!';

  @override
  String score(int correct, int total) {
    return 'Puntuación: $correct / $total';
  }

  @override
  String get masteredContent => '¡Has dominado el contenido de esta lección!';

  @override
  String get reviewSuggestion =>
      'Repasa el contenido de la lección antes de volver a intentarlo.';

  @override
  String timeUsed(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get playAudio => 'Reproducir audio';

  @override
  String get replayAudio => 'Reproducir de nuevo';

  @override
  String get vowelEnding => 'Cuando termina en vocal, usa:';

  @override
  String lessonNumber(int number) {
    return 'Lección $number';
  }

  @override
  String get stageIntro => 'Introducción';

  @override
  String get stageVocabulary => 'Vocabulario';

  @override
  String get stageGrammar => 'Gramática';

  @override
  String get stagePractice => 'Práctica';

  @override
  String get stageDialogue => 'Diálogo';

  @override
  String get stageQuiz => 'Cuestionario';

  @override
  String get stageSummary => 'Resumen';

  @override
  String get downloadLesson => 'Descargar lección';

  @override
  String get downloading => 'Descargando...';

  @override
  String get downloaded => 'Descargado';

  @override
  String get downloadFailed => 'Descarga fallida';

  @override
  String get home => 'Inicio';

  @override
  String get lessons => 'Lecciones';

  @override
  String get review => 'Repaso';

  @override
  String get profile => 'Perfil';

  @override
  String get continueLearning => 'Continuar aprendiendo';

  @override
  String get dailyGoal => 'Meta diaria';

  @override
  String lessonsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lecciones completadas',
      one: '$count lección completada',
    );
    return '$_temp0';
  }

  @override
  String minutesLearned(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos de estudio',
      one: '$minutes minuto de estudio',
    );
    return '$_temp0';
  }

  @override
  String get welcome => 'Bienvenido de nuevo';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get confirmLogout => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Cerrar';

  @override
  String get retry => 'Reintentar';

  @override
  String get loading => 'Cargando...';

  @override
  String get noData => 'Sin datos disponibles';

  @override
  String get error => 'Ocurrió un error';

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get reload => 'Recargar';

  @override
  String get noCharactersAvailable => 'No hay caracteres disponibles';

  @override
  String get success => 'Éxito';

  @override
  String get filter => 'Filtrar';

  @override
  String get reviewSchedule => 'Calendario de repaso';

  @override
  String get todayReview => 'Repaso de hoy';

  @override
  String get startReview => 'Comenzar repaso';

  @override
  String get learningStats => 'Estadísticas de aprendizaje';

  @override
  String get completedLessonsCount => 'Lecciones completadas';

  @override
  String get studyDays => 'Días de estudio';

  @override
  String get masteredWordsCount => 'Palabras dominadas';

  @override
  String get myVocabularyBook => 'Mi libro de vocabulario';

  @override
  String get vocabularyBrowser => 'Explorador de vocabulario';

  @override
  String get about => 'Acerca de';

  @override
  String get premiumMember => 'Miembro premium';

  @override
  String get freeUser => 'Usuario gratuito';

  @override
  String wordsWaitingReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras esperando repaso',
      one: '$count palabra esperando repaso',
    );
    return '$_temp0';
  }

  @override
  String get user => 'Usuario';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingLanguageTitle => '¡Mucho gusto! Soy Moni';

  @override
  String get onboardingLanguagePrompt =>
      '¿Qué idioma empezamos a aprender juntos?';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingWelcome =>
      '¡Hola! Soy Limón de Lemon Korean 🍋\n¿Quieres aprender coreano juntos?';

  @override
  String get onboardingLevelQuestion => '¿Cuál es tu nivel actual de coreano?';

  @override
  String get onboardingStart => 'Comenzar';

  @override
  String get onboardingStartWithoutLevel => 'Saltar y Comenzar';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelBeginnerDesc => '¡No te preocupes! Empecemos desde Hangul';

  @override
  String get levelElementary => 'Elemental';

  @override
  String get levelElementaryDesc => '¡Practiquemos conversaciones básicas!';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelIntermediateDesc => '¡Hablemos más naturalmente!';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get levelAdvancedDesc => '¡Dominemos expresiones detalladas!';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a Lemon Coreano!';

  @override
  String get onboardingWelcomeSubtitle =>
      'Tu camino hacia la fluidez comienza aquí';

  @override
  String get onboardingFeature1Title =>
      'Aprende sin conexión en cualquier momento';

  @override
  String get onboardingFeature1Desc =>
      'Descarga lecciones y estudia sin internet';

  @override
  String get onboardingFeature2Title => 'Sistema de repaso inteligente';

  @override
  String get onboardingFeature2Desc =>
      'Repetición espaciada con IA para mejor retención';

  @override
  String get onboardingFeature3Title => 'Camino de aprendizaje de 7 etapas';

  @override
  String get onboardingFeature3Desc =>
      'Currículum estructurado de principiante a avanzado';

  @override
  String get onboardingLevelTitle => '¿Cuál es tu nivel de coreano?';

  @override
  String get onboardingLevelSubtitle => 'Personalizaremos tu experiencia';

  @override
  String get onboardingGoalTitle => 'Establece tu meta semanal';

  @override
  String get onboardingGoalSubtitle => '¿Cuánto tiempo puedes dedicar?';

  @override
  String get goalCasual => 'Casual';

  @override
  String get goalCasualDesc => '1-2 lecciones por semana';

  @override
  String get goalCasualTime => '~10-20 min/semana';

  @override
  String get goalCasualHelper => 'Perfecto para horarios ocupados';

  @override
  String get goalRegular => 'Regular';

  @override
  String get goalRegularDesc => '3-4 lecciones por semana';

  @override
  String get goalRegularTime => '~30-40 min/semana';

  @override
  String get goalRegularHelper => 'Progreso constante sin presión';

  @override
  String get goalSerious => 'Serio';

  @override
  String get goalSeriousDesc => '5-6 lecciones por semana';

  @override
  String get goalSeriousTime => '~50-60 min/semana';

  @override
  String get goalSeriousHelper => 'Para quienes buscan mejorar rápido';

  @override
  String get goalIntensive => 'Intensivo';

  @override
  String get goalIntensiveDesc => 'Práctica diaria';

  @override
  String get goalIntensiveTime => '60+ min/semana';

  @override
  String get goalIntensiveHelper => 'Velocidad máxima de aprendizaje';

  @override
  String get onboardingCompleteTitle => '¡Todo listo!';

  @override
  String get onboardingCompleteSubtitle => 'Comencemos tu viaje de aprendizaje';

  @override
  String get onboardingSummaryLanguage => 'Idioma de interfaz';

  @override
  String get onboardingSummaryLevel => 'Nivel de coreano';

  @override
  String get onboardingSummaryGoal => 'Meta semanal';

  @override
  String get onboardingStartLearning => 'Comenzar a aprender';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingAccountTitle => '¿Listo para empezar?';

  @override
  String get onboardingAccountSubtitle =>
      'Inicia sesión o crea una cuenta para guardar tu progreso';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get appLanguageDesc =>
      'Selecciona el idioma para la interfaz de la aplicación.';

  @override
  String languageSelected(String language) {
    return '$language seleccionado';
  }

  @override
  String get sort => 'Ordenar';

  @override
  String get notificationTipContent =>
      '• Los recordatorios de repaso se programan automáticamente después de completar una lección\n• Algunos dispositivos pueden necesitar desactivar el ahorro de batería en la configuración del sistema para recibir notificaciones correctamente';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace $count día',
    );
    return '$_temp0';
  }

  @override
  String dateFormat(int month, int day) {
    return '$day/$month';
  }

  @override
  String get downloadManager => 'Gestor de descargas';

  @override
  String get storageInfo => 'Información de almacenamiento';

  @override
  String get clearAllDownloads => 'Borrar todo';

  @override
  String get downloadedTab => 'Descargado';

  @override
  String get availableTab => 'Disponible';

  @override
  String get downloadedLessons => 'Lecciones descargadas';

  @override
  String get mediaFiles => 'Archivos multimedia';

  @override
  String get usedStorage => 'En uso';

  @override
  String get cacheStorage => 'Caché';

  @override
  String get totalStorage => 'Total';

  @override
  String get allDownloadsCleared => 'Todas las descargas eliminadas';

  @override
  String get availableStorage => 'Disponible';

  @override
  String get noDownloadedLessons => 'No hay lecciones descargadas';

  @override
  String get goToAvailableTab =>
      'Ve a la pestaña \"Disponible\" para descargar lecciones';

  @override
  String get allLessonsDownloaded => 'Todas las lecciones descargadas';

  @override
  String get deleteDownload => 'Eliminar descarga';

  @override
  String confirmDeleteDownload(String title) {
    return '¿Seguro que quieres eliminar \"$title\"?';
  }

  @override
  String confirmClearAllDownloads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Seguro que quieres eliminar las $count descargas?',
      one: '¿Seguro que quieres eliminar la $count descarga?',
    );
    return '$_temp0';
  }

  @override
  String downloadingCount(int count) {
    return 'Descargando ($count)';
  }

  @override
  String get preparing => 'Preparando...';

  @override
  String lessonId(int id) {
    return 'Lección $id';
  }

  @override
  String get searchWords => 'Buscar palabras...';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '$count palabra',
    );
    return '$_temp0';
  }

  @override
  String get sortByLesson => 'Por lección';

  @override
  String get sortByKorean => 'Por coreano';

  @override
  String get sortByChinese => 'Por chino';

  @override
  String get noWordsFound => 'No se encontraron palabras';

  @override
  String get noMasteredWords => 'Aún no hay palabras dominadas';

  @override
  String get hanja => 'Hanja';

  @override
  String get exampleSentence => 'Ejemplo';

  @override
  String get mastered => 'Dominado';

  @override
  String get completedLessons => 'Lecciones completadas';

  @override
  String get noCompletedLessons => 'No hay lecciones completadas';

  @override
  String get startFirstLesson => '¡Comienza tu primera lección!';

  @override
  String get masteredWords => 'Palabras dominadas';

  @override
  String get download => 'Descargar';

  @override
  String get hangulLearning => 'Alfabeto Coreano';

  @override
  String get hangulLearningSubtitle => 'Aprende 40 letras del alfabeto coreano';

  @override
  String get editNotes => 'Editar notas';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => '¿Por qué guardas esta palabra?';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortNewest => 'Más reciente';

  @override
  String get sortOldest => 'Más antiguo';

  @override
  String get sortKorean => 'Por coreano';

  @override
  String get sortChinese => 'Por chino';

  @override
  String get sortMastery => 'Por dominio';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterNew => 'Nuevas (nivel 0)';

  @override
  String get filterBeginner => 'Principiante (nivel 1)';

  @override
  String get filterIntermediate => 'Intermedio (nivel 2-3)';

  @override
  String get filterAdvanced => 'Avanzado (nivel 4-5)';

  @override
  String get searchWordsNotesChinese =>
      'Buscar palabras, significado o notas...';

  @override
  String startReviewCount(int count) {
    return 'Comenzar repaso ($count)';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get confirmRemove => 'Confirmar eliminación';

  @override
  String confirmRemoveWord(String word) {
    return '¿Eliminar \"$word\" del libro de vocabulario?';
  }

  @override
  String get noBookmarkedWords => 'No hay palabras guardadas';

  @override
  String get bookmarkHint =>
      'Toca el ícono de marcador en las tarjetas de palabras durante el estudio';

  @override
  String get noMatchingWords => 'No hay palabras coincidentes';

  @override
  String weeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count semanas',
      one: 'Hace $count semana',
    );
    return '$_temp0';
  }

  @override
  String get reviewComplete => '¡Repaso completado!';

  @override
  String reviewCompleteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras repasadas',
      one: '$count palabra repasada',
    );
    return '$_temp0';
  }

  @override
  String get correct => 'Correcto';

  @override
  String get wrong => 'Incorrecto';

  @override
  String get accuracy => 'Precisión';

  @override
  String get vocabularyBookReview => 'Repaso del vocabulario';

  @override
  String get noWordsToReview => 'No hay palabras para repasar';

  @override
  String get bookmarkWordsToReview => 'Guarda palabras para comenzar a repasar';

  @override
  String get returnToVocabularyBook => 'Volver al vocabulario';

  @override
  String get exit => 'Salir';

  @override
  String get showAnswer => 'Mostrar respuesta';

  @override
  String get didYouRemember => '¿La recordaste?';

  @override
  String get forgot => 'Olvidé';

  @override
  String get hard => 'Difícil';

  @override
  String get remembered => 'Recordé';

  @override
  String get easy => 'Fácil';

  @override
  String get addedToVocabularyBook => 'Agregado al vocabulario';

  @override
  String get addFailed => 'Error al agregar';

  @override
  String get removedFromVocabularyBook => 'Eliminado del vocabulario';

  @override
  String get removeFailed => 'Error al eliminar';

  @override
  String get addToVocabularyBook => 'Agregar al vocabulario';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get add => 'Agregar';

  @override
  String get bookmarked => 'Guardado';

  @override
  String get bookmark => 'Guardar';

  @override
  String get removeFromVocabularyBook => 'Eliminar del vocabulario';

  @override
  String similarityPercent(int percent) {
    return 'Similitud: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': 'Agregado al vocabulario',
        'other': 'Marcador eliminado',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'días';

  @override
  String lessonsCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completadas',
      one: '$count completada',
    );
    return '$_temp0';
  }

  @override
  String get dailyGoalComplete => '¡Meta diaria cumplida!';

  @override
  String get hangulAlphabet => 'Hangul';

  @override
  String get alphabetTable => 'Tabla de alfabeto';

  @override
  String get learn => 'Aprender';

  @override
  String get practice => 'Practicar';

  @override
  String get learningProgress => 'Progreso de aprendizaje';

  @override
  String dueForReviewCount(int count) {
    return '$count para repasar';
  }

  @override
  String get completion => 'Completado';

  @override
  String get totalCharacters => 'Total de caracteres';

  @override
  String get learned => 'Aprendido';

  @override
  String get dueForReview => 'Para repasar';

  @override
  String overallAccuracy(String percent) {
    return 'Precisión general: $percent%';
  }

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres',
      one: '$count carácter',
    );
    return '$_temp0';
  }

  @override
  String get lesson1Title => 'Lección 1: Consonantes básicas (1)';

  @override
  String get lesson1Desc => 'Aprende las 7 consonantes más usadas';

  @override
  String get lesson2Title => 'Lección 2: Consonantes básicas (2)';

  @override
  String get lesson2Desc => 'Aprende las 7 consonantes restantes';

  @override
  String get lesson3Title => 'Lección 3: Vocales básicas (1)';

  @override
  String get lesson3Desc => 'Aprende 5 vocales básicas';

  @override
  String get lesson4Title => 'Lección 4: Vocales básicas (2)';

  @override
  String get lesson4Desc => 'Aprende las 5 vocales restantes';

  @override
  String get lesson5Title => 'Lección 5: Consonantes dobles';

  @override
  String get lesson5Desc => 'Aprende 5 consonantes dobles - sonidos tensos';

  @override
  String get lesson6Title => 'Lección 6: Vocales compuestas (1)';

  @override
  String get lesson6Desc => 'Aprende 6 vocales compuestas';

  @override
  String get lesson7Title => 'Lección 7: Vocales compuestas (2)';

  @override
  String get lesson7Desc => 'Aprende las vocales compuestas restantes';

  @override
  String get loadAlphabetFirst => 'Primero carga los datos del alfabeto';

  @override
  String get noContentForLesson => 'No hay contenido para esta lección';

  @override
  String get exampleWords => 'Palabras de ejemplo';

  @override
  String get thisLessonCharacters => 'Caracteres de esta lección';

  @override
  String congratsLessonComplete(String title) {
    return '¡Completaste $title!';
  }

  @override
  String get continuePractice => 'Continuar practicando';

  @override
  String get nextLesson => 'Siguiente lección';

  @override
  String get basicConsonants => 'Consonantes básicas';

  @override
  String get doubleConsonants => 'Consonantes dobles';

  @override
  String get basicVowels => 'Vocales básicas';

  @override
  String get compoundVowels => 'Vocales compuestas';

  @override
  String get dailyLearningReminderTitle => 'Recordatorio diario';

  @override
  String get dailyLearningReminderBody =>
      '¡Completa tu estudio de coreano de hoy!';

  @override
  String get reviewReminderTitle => '¡Hora de repasar!';

  @override
  String reviewReminderBody(String title) {
    return 'Es hora de repasar \"$title\"';
  }

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get spanish => 'Español';

  @override
  String get strokeOrder => 'Orden de trazos';

  @override
  String get reset => 'Reiniciar';

  @override
  String get pronunciationGuide => 'Guía de pronunciación';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausar';

  @override
  String loadingFailed(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String learnedCount(int count) {
    return 'Aprendidos: $count';
  }

  @override
  String get hangulPractice => 'Práctica de Hangul';

  @override
  String charactersNeedReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres necesitan repaso',
      one: '$count carácter necesita repaso',
    );
    return '$_temp0';
  }

  @override
  String charactersAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres disponibles',
      one: '$count carácter disponible',
    );
    return '$_temp0';
  }

  @override
  String get selectPracticeMode => 'Seleccionar modo de práctica';

  @override
  String get characterRecognition => 'Reconocimiento de caracteres';

  @override
  String get characterRecognitionDesc =>
      'Ve el carácter, elige la pronunciación correcta';

  @override
  String get pronunciationPractice => 'Práctica de pronunciación';

  @override
  String get pronunciationPracticeDesc =>
      'Ve la pronunciación, elige el carácter correcto';

  @override
  String get startPractice => 'Iniciar práctica';

  @override
  String get learnSomeCharactersFirst =>
      'Por favor, aprende algunos caracteres en el alfabeto primero';

  @override
  String get practiceComplete => '¡Práctica completada!';

  @override
  String get back => 'Volver';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get howToReadThis => '¿Cómo se lee este carácter?';

  @override
  String get selectCorrectCharacter => 'Selecciona el carácter correcto';

  @override
  String get correctExclamation => '¡Correcto!';

  @override
  String get incorrectExclamation => 'Incorrecto';

  @override
  String get correctAnswerLabel => 'Respuesta correcta: ';

  @override
  String get nextQuestionBtn => 'Siguiente pregunta';

  @override
  String get viewResults => 'Ver resultados';

  @override
  String get share => 'Compartir';

  @override
  String get mnemonics => 'Trucos de memoria';

  @override
  String nextReviewLabel(String date) {
    return 'Próximo repaso: $date';
  }

  @override
  String get expired => 'Vencido';

  @override
  String get practiceFunctionDeveloping => 'Función de práctica en desarrollo';

  @override
  String get romanization => 'Romanización: ';

  @override
  String get pronunciationLabel => 'Pronunciación: ';

  @override
  String get playPronunciation => 'Reproducir pronunciación';

  @override
  String strokesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trazos',
      one: '$count trazo',
    );
    return '$_temp0';
  }

  @override
  String get perfectCount => 'Perfecto';

  @override
  String get loadFailed => 'Error al cargar';

  @override
  String countUnit(int count) {
    return '$count';
  }

  @override
  String get basicConsonantsKo => '기본 자음';

  @override
  String get doubleConsonantsKo => '쌍자음';

  @override
  String get basicVowelsKo => '기본 모음';

  @override
  String get compoundVowelsKo => '복합 모음';

  @override
  String get lesson1TitleKo => 'Lección 1: Consonantes básicas (1)';

  @override
  String get lesson2TitleKo => 'Lección 2: Consonantes básicas (2)';

  @override
  String get lesson3TitleKo => 'Lección 3: Vocales básicas (1)';

  @override
  String get lesson4TitleKo => 'Lección 4: Vocales básicas (2)';

  @override
  String get lesson5TitleKo => 'Lección 5: Consonantes dobles';

  @override
  String get lesson6TitleKo => 'Lección 6: Vocales compuestas (1)';

  @override
  String get lesson7TitleKo => 'Lección 7: Vocales compuestas (2)';

  @override
  String get exitLesson => 'Salir de la lección';

  @override
  String get exitLessonConfirm =>
      '¿Seguro que quieres salir? Tu progreso se guardará.';

  @override
  String get exitBtn => 'Salir';

  @override
  String get lessonComplete => '¡Lección completada! Progreso guardado';

  @override
  String loadingLesson(String title) {
    return 'Cargando $title...';
  }

  @override
  String get cannotLoadContent =>
      'No se puede cargar el contenido de la lección';

  @override
  String get noLessonContent => 'No hay contenido disponible para esta lección';

  @override
  String stageProgress(int current, int total) {
    return 'Etapa $current / $total';
  }

  @override
  String unknownStageType(String type) {
    return 'Tipo de etapa desconocido: $type';
  }

  @override
  String wordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '$count palabra',
    );
    return '$_temp0';
  }

  @override
  String get startLearning => 'Comenzar a aprender';

  @override
  String get vocabularyLearning => 'Aprendizaje de vocabulario';

  @override
  String get noImage => 'Sin imagen';

  @override
  String get previousItem => 'Anterior';

  @override
  String get nextItem => 'Siguiente';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get previousQuestion => 'Pregunta anterior';

  @override
  String get playingAudio => 'Reproduciendo...';

  @override
  String get playAll => 'Reproducir todo';

  @override
  String audioPlayFailed(String error) {
    return 'Error de reproducción de audio: $error';
  }

  @override
  String get stopBtn => 'Detener';

  @override
  String get playAudioBtn => 'Reproducir audio';

  @override
  String get playingAudioShort => 'Reproduciendo audio...';

  @override
  String get pronunciation => 'Pronunciación';

  @override
  String grammarPattern(String pattern) {
    return 'Gramática · $pattern';
  }

  @override
  String get grammarExplanation => 'Explicación gramatical';

  @override
  String get conjugationRule => 'Regla de conjugación';

  @override
  String get comparisonWithChinese => 'Comparación con el chino';

  @override
  String get exampleSentences => 'Oraciones de ejemplo';

  @override
  String get dialogueTitle => 'Práctica de diálogo';

  @override
  String get dialogueExplanation => 'Análisis del diálogo';

  @override
  String speaker(String name) {
    return 'Hablante $name';
  }

  @override
  String get practiceTitle => 'Práctica';

  @override
  String get practiceInstructions => 'Completa los siguientes ejercicios';

  @override
  String get fillBlank => 'Llenar el espacio';

  @override
  String get checkAnswerBtn => 'Verificar respuesta';

  @override
  String correctAnswerIs(String answer) {
    return 'Respuesta correcta: $answer';
  }

  @override
  String get quizTitle => 'Examen';

  @override
  String get quizResult => 'Resultado del examen';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return 'Precisión: $percent%';
  }

  @override
  String get summaryTitle => 'Resumen de la lección';

  @override
  String get vocabLearned => 'Vocabulario aprendido';

  @override
  String get grammarLearned => 'Gramática aprendida';

  @override
  String get finishLesson => 'Terminar lección';

  @override
  String get reviewVocab => 'Revisar vocabulario';

  @override
  String similarity(int percent) {
    return 'Similitud: $percent%';
  }

  @override
  String get partOfSpeechNoun => 'Sustantivo';

  @override
  String get partOfSpeechVerb => 'Verbo';

  @override
  String get partOfSpeechAdjective => 'Adjetivo';

  @override
  String get partOfSpeechAdverb => 'Adverbio';

  @override
  String get partOfSpeechPronoun => 'Pronombre';

  @override
  String get partOfSpeechParticle => 'Partícula';

  @override
  String get partOfSpeechConjunction => 'Conjunción';

  @override
  String get partOfSpeechInterjection => 'Interjección';

  @override
  String get noVocabulary => 'Sin datos de vocabulario';

  @override
  String get noGrammar => 'Sin datos de gramática';

  @override
  String get noPractice => 'Sin ejercicios de práctica';

  @override
  String get noDialogue => 'Sin contenido de diálogo';

  @override
  String get noQuiz => 'Sin preguntas de examen';

  @override
  String get tapToFlip => 'Toca para voltear';

  @override
  String get listeningQuestion => 'Escucha';

  @override
  String get submit => 'Enviar';

  @override
  String timeStudied(String time) {
    return 'Tiempo estudiado $time';
  }

  @override
  String get statusNotStarted => 'No iniciado';

  @override
  String get statusInProgress => 'En progreso';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusFailed => 'No aprobado';

  @override
  String get masteryNew => 'Nuevo';

  @override
  String get masteryLearning => 'Aprendiendo';

  @override
  String get masteryFamiliar => 'Familiar';

  @override
  String get masteryMastered => 'Dominado';

  @override
  String get masteryExpert => 'Experto';

  @override
  String get masteryPerfect => 'Perfecto';

  @override
  String get masteryUnknown => 'Desconocido';

  @override
  String get dueForReviewNow => 'Revisar ahora';

  @override
  String get similarityHigh => 'Alta similitud';

  @override
  String get similarityMedium => 'Similitud media';

  @override
  String get similarityLow => 'Baja similitud';

  @override
  String get typeBasicConsonant => 'Consonante básica';

  @override
  String get typeDoubleConsonant => 'Consonante doble';

  @override
  String get typeBasicVowel => 'Vocal básica';

  @override
  String get typeCompoundVowel => 'Vocal compuesta';

  @override
  String get typeFinalConsonant => 'Consonante final';

  @override
  String get dailyReminderChannel => 'Recordatorio diario de estudio';

  @override
  String get dailyReminderChannelDesc =>
      'Te recuerda estudiar coreano a una hora fija cada día';

  @override
  String get reviewReminderChannel => 'Recordatorio de repaso';

  @override
  String get reviewReminderChannelDesc =>
      'Recordatorios de repaso basados en repetición espaciada';

  @override
  String get notificationStudyTime => '¡Hora de estudiar!';

  @override
  String get notificationStudyReminder =>
      'No olvides completar tu práctica diaria de coreano';

  @override
  String get notificationReviewTime => '¡Hora de repasar!';

  @override
  String get notificationReviewReminder =>
      'Repasemos lo que has aprendido antes';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '¡Es hora de repasar \"$lessonTitle\"!';
  }

  @override
  String get keepGoing => '¡Sigue adelante!';

  @override
  String scoreDisplay(int correct, int total) {
    return 'Puntuación: $correct / $total';
  }

  @override
  String loadDataError(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String downloadError(String error) {
    return 'Error de descarga: $error';
  }

  @override
  String deleteError(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String clearAllError(String error) {
    return 'Error al borrar todo: $error';
  }

  @override
  String cleanupError(String error) {
    return 'Error de limpieza: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return 'Descarga fallida: $title';
  }

  @override
  String get comprehensive => 'Integral';

  @override
  String answeredCount(int answered, int total) {
    return 'Respondidas $answered/$total';
  }

  @override
  String get hanjaWord => 'Palabra Hanja';

  @override
  String get tapToFlipBack => 'Toca para volver';

  @override
  String get similarityWithChinese => 'Similitud con chino';

  @override
  String get hanjaWordSimilarPronunciation =>
      'Palabra Hanja, pronunciación similar';

  @override
  String get sameEtymologyEasyToRemember =>
      'Misma etimología, fácil de recordar';

  @override
  String get someConnection => 'Alguna conexión';

  @override
  String get nativeWordNeedsMemorization =>
      'Palabra nativa, requiere memorización';

  @override
  String get rules => 'Reglas';

  @override
  String get koreanLanguage => '🇰🇷 Coreano';

  @override
  String get chineseLanguage => '🇨🇳 Chino';

  @override
  String exampleNumber(int number) {
    return 'Ej. $number';
  }

  @override
  String get fillInBlankPrompt => 'Rellenar espacio:';

  @override
  String get correctFeedback => '¡Excelente! ¡Correcto!';

  @override
  String get incorrectFeedback => 'No del todo, intenta de nuevo';

  @override
  String get allStagesPassed => 'Las 7 etapas completadas';

  @override
  String get continueToLearnMore => 'Continúa aprendiendo más';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String timeFormatMS(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String timeFormatS(int seconds) {
    return '${seconds}s';
  }

  @override
  String get repeatEnabled => 'Repetición activada';

  @override
  String get repeatDisabled => 'Repetición desactivada';

  @override
  String get stop => 'Detener';

  @override
  String get playbackSpeed => 'Velocidad de reproducción';

  @override
  String get slowSpeed => 'Lenta';

  @override
  String get normalSpeed => 'Normal';

  @override
  String get mouthShape => 'Forma de la boca';

  @override
  String get tonguePosition => 'Posición de la lengua';

  @override
  String get airFlow => 'Flujo de aire';

  @override
  String get nativeComparison => 'Comparación con idioma nativo';

  @override
  String get similarSounds => 'Sonidos similares';

  @override
  String get soundDiscrimination => 'Discriminación de sonidos';

  @override
  String get listenAndSelect => 'Escucha y selecciona el carácter correcto';

  @override
  String get similarSoundGroups => 'Grupos de sonidos similares';

  @override
  String get plainSound => 'Sonido simple';

  @override
  String get aspiratedSound => 'Sonido aspirado';

  @override
  String get tenseSound => 'Sonido tenso';

  @override
  String get writingPractice => 'Práctica de escritura';

  @override
  String get watchAnimation => 'Ver animación';

  @override
  String get traceWithGuide => 'Trazar con guía';

  @override
  String get freehandWriting => 'Escritura libre';

  @override
  String get clearCanvas => 'Borrar';

  @override
  String get showGuide => 'Mostrar guía';

  @override
  String get hideGuide => 'Ocultar guía';

  @override
  String get writingAccuracy => 'Precisión';

  @override
  String get tryAgainWriting => 'Intentar de nuevo';

  @override
  String get nextStep => 'Siguiente paso';

  @override
  String strokeOrderStep(int current, int total) {
    return 'Paso $current/$total';
  }

  @override
  String get syllableCombination => 'Combinación de sílabas';

  @override
  String get selectConsonant => 'Seleccionar consonante';

  @override
  String get selectVowel => 'Seleccionar vocal';

  @override
  String get selectFinalConsonant => 'Seleccionar consonante final (opcional)';

  @override
  String get noFinalConsonant => 'Sin consonante final';

  @override
  String get combinedSyllable => 'Sílaba combinada';

  @override
  String get playSyllable => 'Reproducir sílaba';

  @override
  String get decomposeSyllable => 'Descomponer sílaba';

  @override
  String get batchimPractice => 'Práctica de Batchim';

  @override
  String get batchimExplanation => 'Explicación de Batchim';

  @override
  String get recordPronunciation => 'Grabar pronunciación';

  @override
  String get startRecording => 'Iniciar grabación';

  @override
  String get stopRecording => 'Detener grabación';

  @override
  String get playRecording => 'Reproducir grabación';

  @override
  String get compareWithNative => 'Comparar con nativo';

  @override
  String get shadowingMode => 'Modo de seguimiento';

  @override
  String get listenThenRepeat => 'Escuchar y repetir';

  @override
  String get selfEvaluation => 'Autoevaluación';

  @override
  String get accurate => 'Preciso';

  @override
  String get almostCorrect => 'Casi correcto';

  @override
  String get needsPractice => 'Necesita práctica';

  @override
  String get recordingNotSupported =>
      'La grabación no es compatible con esta plataforma';

  @override
  String get showMeaning => 'Mostrar significado';

  @override
  String get hideMeaning => 'Ocultar significado';

  @override
  String get exampleWord => 'Palabra de ejemplo';

  @override
  String get meaningToggle => 'Configuración de visualización de significado';

  @override
  String get microphonePermissionRequired =>
      'Se requiere permiso de micrófono para grabar';

  @override
  String get activities => 'Actividades';

  @override
  String get listeningAndSpeaking => 'Escucha y habla';

  @override
  String get readingAndWriting => 'Lectura y escritura';

  @override
  String get soundDiscriminationDesc =>
      'Entrena tu oído para distinguir sonidos similares';

  @override
  String get shadowingDesc => 'Escucha y repite con hablantes nativos';

  @override
  String get syllableCombinationDesc =>
      'Aprende cómo se combinan consonantes y vocales';

  @override
  String get batchimPracticeDesc =>
      'Practica los sonidos de consonantes finales';

  @override
  String get writingPracticeDesc => 'Practica escribir caracteres coreanos';

  @override
  String get webNotSupported => 'No disponible en web';

  @override
  String get chapter => 'Capítulo';

  @override
  String get bossQuiz => 'Examen Final';

  @override
  String get bossQuizCleared => '¡Examen Final Superado!';

  @override
  String get bossQuizBonus => 'Limones de Bonificación';

  @override
  String get lemonsScoreHint95 => '95%+ para 3 limones';

  @override
  String get lemonsScoreHint80 => '80%+ para 2 limones';

  @override
  String get myLemonTree => 'Mi Árbol de Limones';

  @override
  String get harvestLemon => 'Cosechar Limón';

  @override
  String get watchAdToHarvest => '¿Ver un anuncio para cosechar este limón?';

  @override
  String get lemonHarvested => '¡Limón cosechado!';

  @override
  String get lemonsAvailable => 'limones disponibles';

  @override
  String get completeMoreLessons =>
      'Completa más lecciones para cultivar limones';

  @override
  String get totalLemons => 'Total de Limones';

  @override
  String get community => 'Comunidad';

  @override
  String get following => 'Siguiendo';

  @override
  String get discover => 'Descubrir';

  @override
  String get createPost => 'Crear publicación';

  @override
  String get writePost => 'Comparte algo...';

  @override
  String get postCategory => 'Categoría';

  @override
  String get categoryLearning => 'Aprendizaje';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryAll => 'Todo';

  @override
  String get post => 'Publicar';

  @override
  String get like => 'Me gusta';

  @override
  String get comment => 'Comentario';

  @override
  String get writeComment => 'Escribe un comentario...';

  @override
  String replyingTo(String name) {
    return 'Respondiendo a $name';
  }

  @override
  String get reply => 'Responder';

  @override
  String get deletePost => 'Eliminar publicación';

  @override
  String get deletePostConfirm =>
      '¿Seguro que quieres eliminar esta publicación?';

  @override
  String get deleteComment => 'Eliminar comentario';

  @override
  String get postDeleted => 'Publicación eliminada';

  @override
  String get commentDeleted => 'Comentario eliminado';

  @override
  String get noPostsYet => 'Aún no hay publicaciones';

  @override
  String get followToSeePosts =>
      'Sigue a otros usuarios para ver sus publicaciones aquí';

  @override
  String get discoverPosts => 'Descubre publicaciones de la comunidad';

  @override
  String get seeMore => 'Ver más';

  @override
  String get followers => 'Seguidores';

  @override
  String get followingLabel => 'Siguiendo';

  @override
  String get posts => 'Publicaciones';

  @override
  String get follow => 'Seguir';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get bio => 'Biografía';

  @override
  String get bioHint => 'Cuéntanos sobre ti...';

  @override
  String get searchUsers => 'Buscar usuarios...';

  @override
  String get suggestedUsers => 'Usuarios sugeridos';

  @override
  String get noUsersFound => 'No se encontraron usuarios';

  @override
  String get report => 'Reportar';

  @override
  String get reportContent => 'Reportar contenido';

  @override
  String get reportReason => 'Motivo del reporte';

  @override
  String get reportSubmitted => 'Reporte enviado';

  @override
  String get blockUser => 'Bloquear usuario';

  @override
  String get unblockUser => 'Desbloquear usuario';

  @override
  String get userBlocked => 'Usuario bloqueado';

  @override
  String get userUnblocked => 'Usuario desbloqueado';

  @override
  String get postCreated => '¡Publicación creada!';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count me gusta',
      one: '$count me gusta',
    );
    return '$_temp0';
  }

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comentarios',
      one: '$count comentario',
    );
    return '$_temp0';
  }

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seguidores',
      one: '$count seguidor',
    );
    return '$_temp0';
  }

  @override
  String followingCount(int count) {
    return '$count siguiendo';
  }

  @override
  String get findFriends => 'Buscar amigos';

  @override
  String get addPhotos => 'Añadir fotos';

  @override
  String maxPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Máximo $count fotos',
      one: 'Máximo $count foto',
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'Visibilidad';

  @override
  String get visibilityPublic => 'Público';

  @override
  String get visibilityFollowers => 'Solo seguidores';

  @override
  String get noFollowingPosts =>
      'Aún no hay publicaciones de las personas que sigues';

  @override
  String get all => 'Todo';

  @override
  String get learning => 'Aprendizaje';

  @override
  String get general => 'General';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get postFailed => 'Error al publicar';

  @override
  String get newPost => 'Nueva publicación';

  @override
  String get category => 'Categoría';

  @override
  String get writeYourThoughts => 'Comparte tus pensamientos...';

  @override
  String get photos => 'Fotos';

  @override
  String get addPhoto => 'Añadir foto';

  @override
  String get imageUrlHint => 'Ingresa la URL de la imagen';

  @override
  String get noSuggestions => 'No hay sugerencias. ¡Intenta buscar usuarios!';

  @override
  String get noResults => 'No se encontraron usuarios';

  @override
  String get postDetail => 'Publicación';

  @override
  String get comments => 'Comentarios';

  @override
  String get noComments => 'Aún no hay comentarios. ¡Sé el primero!';

  @override
  String get deleteCommentConfirm =>
      '¿Seguro que quieres eliminar este comentario?';

  @override
  String get failedToLoadProfile => 'Error al cargar el perfil';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get message => 'Mensaje';

  @override
  String get messages => 'Mensajes';

  @override
  String get noMessages => 'No hay mensajes aún';

  @override
  String get startConversation => '¡Inicia una conversación con alguien!';

  @override
  String get noMessagesYet => 'No hay mensajes aún. ¡Saluda!';

  @override
  String get typing => 'escribiendo...';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get createVoiceRoom => 'Crear Sala de Voz';

  @override
  String get roomTitle => 'Título de la Sala';

  @override
  String get roomTitleHint => 'ej. Práctica de Conversación en Coreano';

  @override
  String get topic => 'Tema';

  @override
  String get topicHint => '¿De qué te gustaría hablar?';

  @override
  String get languageLevel => 'Nivel de Idioma';

  @override
  String get allLevels => 'Todos los Niveles';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advanced => 'Avanzado';

  @override
  String get stageSlots => 'Plazas en Escenario';

  @override
  String get anyoneCanListen => 'Cualquiera puede unirse para escuchar';

  @override
  String get createAndJoin => 'Crear y Unirse';

  @override
  String get unmute => 'Activar Micrófono';

  @override
  String get mute => 'Silenciar';

  @override
  String get leave => 'Salir';

  @override
  String get closeRoom => 'Cerrar Sala';

  @override
  String get emojiReaction => 'Reacción';

  @override
  String get gesture => 'Gesto';

  @override
  String get raiseHand => 'Levantar Mano';

  @override
  String get cancelRequest => 'Cancelar';

  @override
  String get leaveStage => 'Dejar Escenario';

  @override
  String get pendingRequests => 'Solicitudes';

  @override
  String get typeAMessage => 'Escribe un mensaje...';

  @override
  String get stageRequests => 'Solicitudes de Escenario';

  @override
  String get noPendingRequests => 'Sin solicitudes pendientes';

  @override
  String get onStage => 'En Escenario';

  @override
  String get voiceRooms => 'Salas de Voz';

  @override
  String get noVoiceRooms => 'No hay salas de voz activas';

  @override
  String get createVoiceRoomHint => '¡Crea una para empezar a hablar!';

  @override
  String get createRoom => 'Crear Sala';

  @override
  String get voiceRoomMicPermission =>
      'Se requiere permiso de micrófono para las salas de voz';

  @override
  String get voiceRoomEnterTitle => 'Por favor, ingresa un título para la sala';

  @override
  String get voiceRoomCreateFailed => 'No se pudo crear la sala';

  @override
  String get voiceRoomNotAvailable => 'Sala no disponible';

  @override
  String get voiceRoomGoBack => 'Volver';

  @override
  String get voiceRoomConnecting => 'Conectando...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return 'Reconectando ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => 'Desconectado';

  @override
  String get voiceRoomRetry => 'Reintentar';

  @override
  String get voiceRoomHostLabel => '(Anfitrión)';

  @override
  String get voiceRoomDemoteToListener => 'Pasar a oyente';

  @override
  String get voiceRoomKickFromRoom => 'Expulsar de la sala';

  @override
  String get voiceRoomListeners => 'Oyentes';

  @override
  String get voiceRoomInviteToStage => 'Invitar al Escenario';

  @override
  String voiceRoomInviteConfirm(String name) {
    return '¿Invitar a $name a hablar en el escenario?';
  }

  @override
  String get voiceRoomInvite => 'Invitar';

  @override
  String get voiceRoomCloseConfirmTitle => '¿Cerrar Sala?';

  @override
  String get voiceRoomCloseConfirmBody =>
      'Esto terminará la llamada para todos.';

  @override
  String get voiceRoomNoMessagesYet => 'Aún no hay mensajes';

  @override
  String get voiceRoomTypeMessage => 'Escribe un mensaje...';

  @override
  String get voiceRoomStageFull => 'Escenario Lleno';

  @override
  String voiceRoomListenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyentes',
      one: '$count oyente',
    );
    return '$_temp0';
  }

  @override
  String get voiceRoomRemoveFromStage => '¿Quitar del Escenario?';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return '¿Quitar a $name del escenario? Se convertirá en oyente.';
  }

  @override
  String get voiceRoomDemote => 'Degradar';

  @override
  String get voiceRoomRemoveFromRoom => '¿Quitar de la Sala?';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return '¿Quitar a $name de la sala? Se desconectará.';
  }

  @override
  String get voiceRoomRemove => 'Quitar';

  @override
  String get voiceRoomPressBackToLeave => 'Presiona atrás de nuevo para salir';

  @override
  String get voiceRoomLeaveTitle => '¿Salir de la Sala?';

  @override
  String get voiceRoomLeaveBody =>
      'Estás actualmente en el escenario. ¿Estás seguro de que quieres salir?';

  @override
  String get voiceRoomReturningToList => 'Volviendo a la lista de salas...';

  @override
  String get voiceRoomConnected => '¡Conectado!';

  @override
  String get voiceRoomStageFailedToLoad => 'No se pudo cargar el escenario';

  @override
  String get voiceRoomPreparingStage => 'Preparando escenario...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return 'Aceptar a $name en el escenario';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return 'Rechazar a $name';
  }

  @override
  String get voiceRoomQuickCreate => 'Creación Rápida';

  @override
  String get voiceRoomRoomType => 'Tipo de Sala';

  @override
  String get voiceRoomSessionDuration => 'Duración de Sesión';

  @override
  String get voiceRoomOptionalTimer => 'Temporizador opcional para la sesión';

  @override
  String get voiceRoomDurationNone => 'Ninguno';

  @override
  String get voiceRoomDuration15 => '15 min';

  @override
  String get voiceRoomDuration30 => '30 min';

  @override
  String get voiceRoomDuration45 => '45 min';

  @override
  String get voiceRoomDuration60 => '60 min';

  @override
  String get voiceRoomTypeFreeTalk => 'Charla Libre';

  @override
  String get voiceRoomTypePronunciation => 'Pronunciación';

  @override
  String get voiceRoomTypeRolePlay => 'Juego de Roles';

  @override
  String get voiceRoomTypeQnA => 'Preguntas y Respuestas';

  @override
  String get voiceRoomTypeListening => 'Escucha';

  @override
  String get voiceRoomTypeDebate => 'Debate';

  @override
  String get voiceRoomTemplateFreeTalk => 'Charla Libre en Coreano';

  @override
  String get voiceRoomTemplatePronunciation => 'Práctica de Pronunciación';

  @override
  String get voiceRoomTemplateDailyKorean => 'Coreano Diario';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'Expresión Oral TOPIK';

  @override
  String get voiceRoomCreateTooltip => 'Crear sala de voz';

  @override
  String get voiceRoomSendReaction => 'Enviar reacción';

  @override
  String get voiceRoomLeaveRoom => 'Salir de la sala';

  @override
  String get voiceRoomUnmuteMic => 'Activar micrófono';

  @override
  String get voiceRoomMuteMic => 'Silenciar micrófono';

  @override
  String get voiceRoomCancelHandRaise => 'Cancelar mano levantada';

  @override
  String get voiceRoomRaiseHandSemantic => 'Levantar la mano';

  @override
  String get voiceRoomSendGesture => 'Enviar gesto';

  @override
  String get voiceRoomLeaveStageAction => 'Dejar el escenario';

  @override
  String get voiceRoomManageStage => 'Gestionar escenario';

  @override
  String get voiceRoomMoreOptions => 'Más opciones';

  @override
  String get voiceRoomMore => 'Más';

  @override
  String get voiceRoomStageWithSpeakers =>
      'Escenario de sala de voz con hablantes';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return 'Solicitudes de escenario, $count pendientes';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return '$speakers de $maxSpeakers hablantes, $listeners oyentes';
  }

  @override
  String get voiceRoomChatInput => 'Entrada de mensaje de chat';

  @override
  String get voiceRoomSendMessage => 'Enviar mensaje';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return 'Enviar reacción de $name';
  }

  @override
  String get voiceRoomCloseReactionTray => 'Cerrar bandeja de reacciones';

  @override
  String voiceRoomPerformGesture(Object name) {
    return 'Realizar gesto de $name';
  }

  @override
  String get voiceRoomCloseGestureTray => 'Cerrar bandeja de gestos';

  @override
  String get voiceRoomGestureWave => 'Saludar';

  @override
  String get voiceRoomGestureBow => 'Reverencia';

  @override
  String get voiceRoomGestureDance => 'Bailar';

  @override
  String get voiceRoomGestureJump => 'Saltar';

  @override
  String get voiceRoomGestureClap => 'Aplaudir';

  @override
  String get voiceRoomStageLabel => 'ESCENARIO';

  @override
  String get voiceRoomYouLabel => '(Tú)';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return 'Oyente $name, toca para gestionar';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return 'Oyente $name';
  }

  @override
  String get voiceRoomMicPermissionDenied =>
      'Se denegó el acceso al micrófono. Para usar las funciones de voz, actívalo en la configuración del dispositivo.';

  @override
  String get voiceRoomMicPermissionTitle => 'Permiso de Micrófono';

  @override
  String get voiceRoomOpenSettings => 'Abrir Configuración';

  @override
  String get voiceRoomMicNeededForStage =>
      'Se necesita permiso de micrófono para hablar en el escenario';

  @override
  String get batchimDescriptionText =>
      'Las consonantes finales coreanas (batchim) se pronuncian con 7 sonidos.\nVarios batchim que comparten la misma pronunciación se llaman \"sonidos representativos\".';

  @override
  String get syllableInputLabel => 'Ingresa sílaba';

  @override
  String get syllableInputHint => 'ej. 한';

  @override
  String totalPracticedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total: $count caracteres practicados',
      one: 'Total: $count carácter practicado',
    );
    return '$_temp0';
  }

  @override
  String get audioLoadError => 'No se pudo cargar el audio';

  @override
  String get writingPracticeCompleteMessage =>
      '¡Práctica de escritura completada!';

  @override
  String get sevenRepresentativeSounds => '7 Sonidos Representativos';

  @override
  String get myRoom => 'Mi Sala';

  @override
  String get characterEditor => 'Editor de Personaje';

  @override
  String get roomEditor => 'Editor de Sala';

  @override
  String get shop => 'Tienda';

  @override
  String get character => 'Personaje';

  @override
  String get room => 'Sala';

  @override
  String get hair => 'Cabello';

  @override
  String get eyes => 'Ojos';

  @override
  String get brows => 'Cejas';

  @override
  String get nose => 'Nariz';

  @override
  String get mouth => 'Boca';

  @override
  String get top => 'Camiseta';

  @override
  String get bottom => 'Pantalones';

  @override
  String get hatItem => 'Sombrero';

  @override
  String get accessory => 'Acc.';

  @override
  String get wallpaper => 'Fondo';

  @override
  String get floorItem => 'Suelo';

  @override
  String get petItem => 'Mascota';

  @override
  String get none => 'Ninguno';

  @override
  String get noItemsYet => 'Sin artículos';

  @override
  String get visitShopToGetItems => '¡Visita la tienda!';

  @override
  String get alreadyOwned => '¡Ya lo tienes!';

  @override
  String get buy => 'Comprar';

  @override
  String purchasedItem(String name) {
    return '¡$name comprado!';
  }

  @override
  String get notEnoughLemons => '¡Limones insuficientes!';

  @override
  String get owned => 'Adquirido';

  @override
  String get free => 'Gratis';

  @override
  String get comingSoon => '¡Próximamente!';

  @override
  String balanceLemons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saldo: $count limones',
      one: 'Saldo: $count limón',
    );
    return '$_temp0';
  }

  @override
  String get furnitureItem => 'Mueble';

  @override
  String get hangulWelcome => '¡Bienvenido al Hangul!';

  @override
  String get hangulWelcomeDesc =>
      'Aprende las 40 letras del alfabeto coreano una por una';

  @override
  String get hangulStartLearning => 'Empezar a aprender';

  @override
  String get hangulLearnNext => 'Aprender siguiente';

  @override
  String hangulLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡$count/40 letras aprendidas!',
      one: '¡$count/40 letra aprendida!',
    );
    return '$_temp0';
  }

  @override
  String hangulReviewNeeded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡$count letras para repasar hoy!',
      one: '¡$count letra para repasar hoy!',
    );
    return '$_temp0';
  }

  @override
  String get hangulReviewNow => 'Repasar ahora';

  @override
  String get hangulPracticeSuggestion =>
      '¡Casi lo logras! Refuerza tus habilidades con actividades';

  @override
  String get hangulStartActivities => 'Iniciar actividades';

  @override
  String get hangulMastered => '¡Felicidades! ¡Has dominado el Hangul!';

  @override
  String get hangulGoToLevel1 => 'Ir a la Etapa 1';

  @override
  String get completedLessonsLabel => 'Completadas';

  @override
  String get wordsLearnedLabel => 'Palabras';

  @override
  String get totalStudyTimeLabel => 'Tiempo';

  @override
  String get streakDetails => 'Detalles de racha';

  @override
  String get consecutiveDays => 'Días consecutivos';

  @override
  String get totalStudyDaysLabel => 'Días totales';

  @override
  String get studyRecord => 'Historial';

  @override
  String get noFriendsPrompt => '¡Encuentra amigos para estudiar juntos!';

  @override
  String get moreStats => 'Ver todo';

  @override
  String remainingLessons(int count) {
    return '¡$count más para la meta de hoy!';
  }

  @override
  String get streakMotivation0 => '¡Empieza a aprender hoy!';

  @override
  String get streakMotivation1 => '¡Buen comienzo! ¡Sigue así!';

  @override
  String get streakMotivation7 => '¡Más de una semana! ¡Increíble!';

  @override
  String get streakMotivation14 =>
      '¡Dos semanas! ¡Se está volviendo un hábito!';

  @override
  String get streakMotivation30 =>
      '¡Más de un mes! ¡Eres un verdadero estudiante!';

  @override
  String minutesShort(int count) {
    return '${count}min';
  }

  @override
  String hoursShort(int count) {
    return '${count}h';
  }

  @override
  String get speechPractice => 'Práctica de pronunciación';

  @override
  String get tapToRecord => 'Toca para grabar';

  @override
  String get recording => 'Grabando...';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get pronunciationScore => 'Puntuación de pronunciación';

  @override
  String get phonemeBreakdown => 'Análisis de fonemas';

  @override
  String tryAgainCount(String current, String max) {
    return 'Reintentar ($current/$max)';
  }

  @override
  String get nextCharacter => 'Siguiente carácter';

  @override
  String get excellentPronunciation => '¡Excelente!';

  @override
  String get goodPronunciation => '¡Buen trabajo!';

  @override
  String get fairPronunciation => '¡Mejorando!';

  @override
  String get needsMorePractice => '¡Sigue practicando!';

  @override
  String get downloadModels => 'Descargar';

  @override
  String get modelDownloading => 'Descargando modelo';

  @override
  String get modelReady => 'Listo';

  @override
  String get modelNotReady => 'No instalado';

  @override
  String get modelSize => 'Tamaño del modelo';

  @override
  String get speechModelTitle => 'Modelo de IA de reconocimiento de voz';

  @override
  String get skipSpeechPractice => 'Omitir';

  @override
  String get deleteModel => 'Eliminar modelo';

  @override
  String get overallScore => 'Puntuación total';

  @override
  String get appTagline =>
      '¡Fresco como un limón, sólido como tus habilidades!';

  @override
  String get passwordHint => 'Al menos 8 caracteres con letras y números';

  @override
  String get findAccount => 'Buscar cuenta';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get registerTitle => '¡Comienza tu viaje fresco al coreano!';

  @override
  String get registerSubtitle => '¡Está bien empezar despacio! Yo te guiaré';

  @override
  String get nickname => 'Apodo';

  @override
  String get nicknameHint =>
      'Hasta 15 caracteres: letras, números, guiones bajos';

  @override
  String get confirmPasswordHint => 'Ingresa tu contraseña una vez más';

  @override
  String get accountChoiceTitle =>
      '¡Bienvenido! ¿Creamos una\nrutina de estudio con Moni?';

  @override
  String get accountChoiceSubtitle =>
      '¡Empieza fresco, yo me aseguro de que aprendas bien!';

  @override
  String get startWithEmail => 'Comenzar con correo electrónico';

  @override
  String get deleteMessageTitle => '¿Eliminar mensaje?';

  @override
  String get deleteMessageContent => 'Este mensaje será eliminado para todos.';

  @override
  String get messageDeleted => 'Mensaje eliminado';

  @override
  String get beFirstToPost => '¡Sé el primero en publicar!';

  @override
  String get typeTagHint => 'Escribe una etiqueta...';

  @override
  String get userInfoLoadFailed => 'Error al cargar información del usuario';

  @override
  String get loginErrorOccurred =>
      'Ocurrió un error durante el inicio de sesión';

  @override
  String get registerErrorOccurred => 'Ocurrió un error durante el registro';

  @override
  String get logoutErrorOccurred => 'Ocurrió un error al cerrar sesión';

  @override
  String get hangulStage0Title =>
      'Etapa 0: Comprender la estructura del Hangul';

  @override
  String get hangulStage1Title => 'Etapa 1: Vocales básicas';

  @override
  String get hangulStage2Title => 'Etapa 2: Vocales Y';

  @override
  String get hangulStage3Title => 'Etapa 3: Vocales ㅐ/ㅔ';

  @override
  String get hangulStage4Title => 'Etapa 4: Consonantes básicas 1';

  @override
  String get hangulStage5Title => 'Etapa 5: Consonantes básicas 2';

  @override
  String get hangulStage6Title => 'Etapa 6: Combinación de sílabas';

  @override
  String get hangulStage7Title => 'Etapa 7: Consonantes tensas/aspiradas';

  @override
  String get hangulStage8Title => 'Etapa 8: Consonantes finales 1';

  @override
  String get hangulStage9Title => 'Etapa 9: Batchim extendido';

  @override
  String get hangulStage10Title => 'Etapa 10: Batchim doble';

  @override
  String get hangulStage11Title => 'Etapa 11: Lectura de palabras extendida';

  @override
  String get sortAlphabetical => 'Alfabético';

  @override
  String get sortByLevel => 'Por nivel';

  @override
  String get sortBySimilarity => 'Por similitud';

  @override
  String get searchWordsKoreanMeaning =>
      'Buscar palabras (coreano/significado)';

  @override
  String get groupedView => 'Agrupado';

  @override
  String get matrixView => 'Consonante×Vocal';

  @override
  String get reviewLessons => 'Repasar lecciones';

  @override
  String get stageDetailComingSoon =>
      'Los detalles estarán disponibles pronto.';

  @override
  String get bossQuizComingSoon => 'El Quiz del Jefe estará disponible pronto.';

  @override
  String get exitLessonDialogTitle => 'Salir de la lección';

  @override
  String get exitLessonDialogContent =>
      '¿Quieres salir de la lección?\nTu progreso hasta este paso se guardará.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get exitLessonButton => 'Salir';

  @override
  String get noQuestions => 'No hay preguntas disponibles';

  @override
  String get noCharactersDefined => 'No se han definido caracteres';

  @override
  String get recordingStartFailed => 'Error al iniciar la grabación';

  @override
  String get consonant => 'Consonante';

  @override
  String get vowel => 'Vocal';

  @override
  String get validationEmailRequired => 'Ingrese su correo electrónico';

  @override
  String get validationEmailTooLong =>
      'La dirección de correo electrónico es demasiado larga';

  @override
  String get validationEmailInvalid =>
      'Ingrese una dirección de correo electrónico válida';

  @override
  String get validationPasswordRequired => 'Ingrese su contraseña';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'La contraseña debe tener al menos $minLength caracteres';
  }

  @override
  String get validationPasswordNeedLetter =>
      'La contraseña debe contener letras';

  @override
  String get validationPasswordNeedNumber =>
      'La contraseña debe contener números';

  @override
  String get validationPasswordNeedSpecial =>
      'La contraseña debe contener caracteres especiales';

  @override
  String get validationPasswordTooLong => 'La contraseña es demasiado larga';

  @override
  String get validationConfirmPasswordRequired => 'Confirme su contraseña';

  @override
  String get validationPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get validationUsernameRequired => 'Ingrese un nombre de usuario';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'El nombre de usuario debe tener al menos $minLength caracteres';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return 'El nombre de usuario no puede exceder $maxLength caracteres';
  }

  @override
  String get validationUsernameInvalidChars =>
      'El nombre de usuario solo puede contener letras, números y guiones bajos';

  @override
  String validationFieldRequired(String fieldName) {
    return 'Ingrese $fieldName';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldName debe tener al menos $minLength caracteres';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldName no puede exceder $maxLength caracteres';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldName debe ser un número';
  }

  @override
  String get errorNetworkConnection =>
      'Error de conexión de red. Verifique su configuración de red';

  @override
  String get errorServer => 'Error del servidor. Inténtelo de nuevo más tarde';

  @override
  String get errorAuthFailed =>
      'Error de autenticación. Inicie sesión nuevamente';

  @override
  String get errorUnknown => 'Error desconocido. Inténtelo de nuevo más tarde';

  @override
  String get errorTimeout => 'Tiempo de conexión agotado. Verifique su red';

  @override
  String get errorRequestCancelled => 'Solicitud cancelada';

  @override
  String get errorForbidden => 'Acceso denegado';

  @override
  String get errorNotFound => 'El recurso solicitado no fue encontrado';

  @override
  String get errorRequestParam => 'Error en los parámetros de solicitud';

  @override
  String get errorParseData => 'Error al analizar los datos';

  @override
  String get errorParseFormat => 'Error de formato de datos';

  @override
  String get errorRateLimited =>
      'Demasiadas solicitudes. Inténtelo de nuevo más tarde';

  @override
  String get successLogin => 'Inicio de sesión exitoso';

  @override
  String get successRegister => 'Registro exitoso';

  @override
  String get successSync => 'Sincronización exitosa';

  @override
  String get successDownload => 'Descarga exitosa';

  @override
  String get failedToCreateComment => 'Error al crear el comentario';

  @override
  String get failedToDeleteComment => 'Error al eliminar el comentario';

  @override
  String get failedToSubmitReport => 'Error al enviar el reporte';

  @override
  String get failedToBlockUser => 'Error al bloquear al usuario';

  @override
  String get failedToUnblockUser => 'Error al desbloquear al usuario';

  @override
  String get failedToCreatePost => 'Error al crear la publicación';

  @override
  String get failedToDeletePost => 'Error al eliminar la publicación';

  @override
  String noVocabularyForLevel(int level) {
    return 'No se encontró vocabulario para el nivel $level';
  }

  @override
  String get uploadingImage => '[Subiendo imagen...]';

  @override
  String get uploadingVoice => '[Subiendo audio...]';

  @override
  String get imagePreview => '[Imagen]';

  @override
  String get voicePreview => '[Audio]';

  @override
  String get voiceServerConnectFailed =>
      'No se pudo conectar al servidor de voz. Verifique su conexión.';

  @override
  String get connectionLostRetry => 'Conexión perdida. Toque para reintentar.';

  @override
  String get noInternetConnection =>
      'Sin conexión a internet. Verifique su red.';

  @override
  String get couldNotLoadRooms =>
      'No se pudieron cargar las salas. Inténtelo de nuevo.';

  @override
  String get couldNotCreateRoom =>
      'No se pudo crear la sala. Inténtelo de nuevo.';

  @override
  String get couldNotJoinRoom =>
      'No se pudo unir a la sala. Verifique su conexión.';

  @override
  String get roomClosedByHost => 'El anfitrión cerró la sala.';

  @override
  String get removedFromRoomByHost =>
      'Fuiste eliminado de la sala por el anfitrión.';

  @override
  String get connectionTimedOut => 'La conexión expiró. Inténtelo de nuevo.';

  @override
  String get missingLiveKitCredentials =>
      'Faltan credenciales de conexión de voz.';

  @override
  String get microphoneEnableFailed =>
      'No se pudo activar el micrófono. Verifique los permisos e intente activar el audio.';

  @override
  String get voiceRoomNewMessages => 'Nuevos mensajes';

  @override
  String get voiceRoomChatRateLimited =>
      'Estás enviando mensajes demasiado rápido. Espera un momento.';

  @override
  String get voiceRoomMessageSendFailed =>
      'Error al enviar el mensaje. Inténtelo de nuevo.';

  @override
  String get voiceRoomChatError => 'Ocurrió un error en el chat.';

  @override
  String retryAttempt(int current, int max) {
    return 'Reintentar ($current/$max)';
  }

  @override
  String get nextButton => 'Siguiente';

  @override
  String get completeButton => 'Completar';

  @override
  String get startButton => 'Empezar';

  @override
  String get doneButton => 'Listo';

  @override
  String get goBackButton => 'Volver';

  @override
  String get tapToListen => 'Toca para escuchar';

  @override
  String get listenAllSoundsFirst => 'Escucha todos los sonidos primero';

  @override
  String get nextCharButton => 'Siguiente letra';

  @override
  String get listenAndChooseCorrect => 'Escucha y elige el carácter correcto';

  @override
  String get lessonCompletedMsg => '¡Has completado la lección!';

  @override
  String stageMasterLabel(int stage) {
    return 'Maestro de la Etapa $stage';
  }

  @override
  String get hangulS0L0Title => '¿Cómo nació el Hangul?';

  @override
  String get hangulS0L0Subtitle => 'Un breve vistazo a cómo se creó el Hangul';

  @override
  String get hangulS0L0Step0Title =>
      'Hace mucho tiempo, escribir era muy difícil';

  @override
  String get hangulS0L0Step0Desc =>
      'En el pasado, la escritura se basaba en caracteres chinos (Hanja),\nlo que hacía muy difícil leer y escribir para la mayoría.';

  @override
  String get hangulS0L0Step0Highlights => 'Hanja,Dificultad,Lectura,Escritura';

  @override
  String get hangulS0L0Step1Title =>
      'El Rey Sejong creó un nuevo sistema de escritura';

  @override
  String get hangulS0L0Step1Desc =>
      'Para que el pueblo pudiera aprender fácilmente,\nel Rey Sejong creó personalmente el Hunminjeongeum.\n(Creado en 1443, proclamado en 1446)';

  @override
  String get hangulS0L0Step1Highlights => 'Rey Sejong,Hunminjeongeum,1443,1446';

  @override
  String get hangulS0L0Step2Title => 'Y así nació el Hangul actual';

  @override
  String get hangulS0L0Step2Desc =>
      'El Hangul es un sistema de escritura diseñado para representar sonidos fácilmente.\nEn la siguiente lección, aprenderemos la estructura de consonantes y vocales.';

  @override
  String get hangulS0L0Step2Highlights => 'Sonido,Escritura fácil,Hangul';

  @override
  String get hangulS0L0SummaryTitle => '¡Introducción completada!';

  @override
  String get hangulS0L0SummaryMsg =>
      '¡Muy bien!\nAhora sabes por qué se creó el Hangul.\nAprendamos la estructura de consonantes y vocales.';

  @override
  String get hangulS0L1Title => 'Ensamblar el bloque 가';

  @override
  String get hangulS0L1Subtitle => 'Practica arrastrando las piezas';

  @override
  String get hangulS0L1IntroTitle => '¡El Hangul funciona como bloques!';

  @override
  String get hangulS0L1IntroDesc =>
      'El Hangul combina consonantes y vocales para formar caracteres.\nConsonante (ㄱ) + Vocal (ㅏ) = 가\n\nLos caracteres más complejos pueden tener una consonante final (batchim).\n(¡Lo aprenderemos después!)';

  @override
  String get hangulS0L1IntroHighlights => 'Consonante,Vocal,Carácter';

  @override
  String get hangulS0L1DragGaTitle => 'Ensamblar 가';

  @override
  String get hangulS0L1DragGaDesc => 'Arrastra ㄱ y ㅏ a los espacios vacíos';

  @override
  String get hangulS0L1DragNaTitle => 'Ensamblar 나';

  @override
  String get hangulS0L1DragNaDesc => 'Prueba con la nueva consonante ㄴ';

  @override
  String get hangulS0L1DragDaTitle => 'Ensamblar 다';

  @override
  String get hangulS0L1DragDaDesc => 'Prueba con la nueva consonante ㄷ';

  @override
  String get hangulS0L1SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS0L1SummaryMsg =>
      'Consonante + Vocal = ¡Bloque de carácter!\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => 'Exploración de sonidos';

  @override
  String get hangulS0L2Subtitle =>
      'Siente las consonantes y vocales a través del sonido';

  @override
  String get hangulS0L2IntroTitle => 'Siente los sonidos';

  @override
  String get hangulS0L2IntroDesc =>
      'Cada consonante y vocal del Hangul tiene su propio sonido único.\nEscucha y siente los sonidos.';

  @override
  String get hangulS0L2Sound1Title => 'Cómo suenan ㄱ, ㄴ, ㄷ';

  @override
  String get hangulS0L2Sound1Desc =>
      'Escucha cada consonante combinada con ㅏ: 가, 나, 다';

  @override
  String get hangulS0L2Sound2Title => 'Sonidos de las vocales ㅏ, ㅗ';

  @override
  String get hangulS0L2Sound2Desc => 'Escucha los sonidos de estas dos vocales';

  @override
  String get hangulS0L2Sound3Title => 'Escuchando 가, 나, 다';

  @override
  String get hangulS0L2Sound3Desc =>
      'Escucha los sonidos de caracteres formados por consonantes y vocales';

  @override
  String get hangulS0L2SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS0L2SummaryMsg =>
      'Las consonantes se combinan con ㅏ para formar sus sonidos básicos (가, 나, 다),\n¡y ahora también puedes sentir cómo suenan las vocales!';

  @override
  String get hangulS0L3Title => 'Escuchar y elegir';

  @override
  String get hangulS0L3Subtitle => 'Distingue caracteres por su sonido';

  @override
  String get hangulS0L3IntroTitle => 'Esta vez, usa tus oídos';

  @override
  String get hangulS0L3IntroDesc =>
      'Concéntrate en los sonidos, no en la pantalla,\ne identifica cuáles son iguales y cuáles son diferentes.';

  @override
  String get hangulS0L3Sound1Title => 'Repaso de sonidos 가/나/다/고/노';

  @override
  String get hangulS0L3Sound1Desc => 'Primero, escucha bien estos 5 sonidos';

  @override
  String get hangulS0L3Match1Title => 'Escucha y elige el carácter correcto';

  @override
  String get hangulS0L3Match1Desc =>
      'Elige el carácter que coincida con el sonido reproducido';

  @override
  String get hangulS0L3Match2Title => 'Distinguir sonidos ㅏ / ㅗ';

  @override
  String get hangulS0L3Match2Desc =>
      'La consonante es la misma — concéntrate en la vocal para distinguirlas';

  @override
  String get hangulS0L3SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS0L3SummaryMsg =>
      '¡Muy bien!\nAhora puedes usar los ojos (ensamblaje) y los oídos (sonido)\npara entender la estructura del Hangul.';

  @override
  String get hangulS0CompleteTitle => '¡Etapa 0 completada!';

  @override
  String get hangulS0CompleteMsg =>
      '¡Has comprendido la estructura del Hangul!';

  @override
  String get hangulS1L1Title => 'Forma y sonido de ㅏ';

  @override
  String get hangulS1L1Subtitle =>
      'Trazo corto a la derecha de una línea vertical: ㅏ';

  @override
  String get hangulS1L1Step0Title => 'Aprende la primera vocal ㅏ';

  @override
  String get hangulS1L1Step0Desc =>
      'ㅏ produce el sonido brillante \"아\".\nAprendamos la forma y el sonido juntos.';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,vocal básica';

  @override
  String get hangulS1L1Step1Title => 'Escuchar ㅏ';

  @override
  String get hangulS1L1Step1Desc => 'Escucha los sonidos que contienen ㅏ';

  @override
  String get hangulS1L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L1Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L1Step3Title => 'Elige el sonido ㅏ';

  @override
  String get hangulS1L1Step3Desc => 'Escucha y selecciona el carácter correcto';

  @override
  String get hangulS1L1Step4Title => 'Quiz de forma';

  @override
  String get hangulS1L1Step4Desc => 'Encuentra ㅏ con precisión';

  @override
  String get hangulS1L1Step4Q0 => '¿Cuál es ㅏ?';

  @override
  String get hangulS1L1Step4Q1 => '¿Cuál contiene ㅏ?';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => 'Construir caracteres con ㅏ';

  @override
  String get hangulS1L1Step5Desc =>
      'Combina consonantes con ㅏ para completar caracteres';

  @override
  String get hangulS1L1Step6Title => 'Quiz integral';

  @override
  String get hangulS1L1Step6Desc => 'Repasa lo aprendido en esta lección';

  @override
  String get hangulS1L1Step6Q0 => '¿Cuál es la vocal en \"아\"?';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => '¿Qué carácter contiene ㅏ?';

  @override
  String get hangulS1L1Step6Q3 => '¿Cuál suena más diferente de ㅏ?';

  @override
  String get hangulS1L1Step7Title => '¡Lección completada!';

  @override
  String get hangulS1L1Step7Msg =>
      '¡Muy bien!\nAprendiste la forma y el sonido de ㅏ.';

  @override
  String get hangulS1L2Title => 'Forma y sonido de ㅓ';

  @override
  String get hangulS1L2Subtitle =>
      'Trazo corto a la izquierda de una línea vertical: ㅓ';

  @override
  String get hangulS1L2Step0Title => 'La segunda vocal ㅓ';

  @override
  String get hangulS1L2Step0Desc =>
      'ㅓ produce el sonido \"어\".\nEl trazo va en dirección opuesta a ㅏ.';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,dirección opuesta a ㅏ';

  @override
  String get hangulS1L2Step1Title => 'Escuchar ㅓ';

  @override
  String get hangulS1L2Step1Desc => 'Escucha los sonidos que contienen ㅓ';

  @override
  String get hangulS1L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L2Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L2Step3Title => 'Elige el sonido ㅓ';

  @override
  String get hangulS1L2Step3Desc => 'Distingue ㅏ/ㅓ al oído';

  @override
  String get hangulS1L2Step4Title => 'Quiz de forma';

  @override
  String get hangulS1L2Step4Desc => 'Encuentra ㅓ';

  @override
  String get hangulS1L2Step4Q0 => '¿Cuál es ㅓ?';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => '¿Qué carácter contiene ㅓ?';

  @override
  String get hangulS1L2Step5Title => 'Construir caracteres con ㅓ';

  @override
  String get hangulS1L2Step5Desc => 'Combina consonantes con ㅓ';

  @override
  String get hangulS1L2Step6Title => '¡Lección completada!';

  @override
  String get hangulS1L2Step6Msg => '¡Excelente!\nAprendiste el sonido de ㅓ(어).';

  @override
  String get hangulS1L3Title => 'Forma y sonido de ㅗ';

  @override
  String get hangulS1L3Subtitle =>
      'Trazo vertical sobre la línea horizontal: ㅗ';

  @override
  String get hangulS1L3Step0Title => 'La tercera vocal ㅗ';

  @override
  String get hangulS1L3Step0Desc =>
      'ㅗ produce el sonido \"오\".\nUn trazo vertical sube sobre la línea horizontal.';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,vocal horizontal';

  @override
  String get hangulS1L3Step1Title => 'Escuchar ㅗ';

  @override
  String get hangulS1L3Step1Desc => 'Escucha los sonidos con ㅗ (오/고/노)';

  @override
  String get hangulS1L3Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L3Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L3Step3Title => 'Elige el sonido ㅗ';

  @override
  String get hangulS1L3Step3Desc => 'Distingue los sonidos 오/우';

  @override
  String get hangulS1L3Step4Title => 'Construir caracteres con ㅗ';

  @override
  String get hangulS1L3Step4Desc => 'Combina consonantes con ㅗ';

  @override
  String get hangulS1L3Step5Title => 'Quiz de forma y sonido';

  @override
  String get hangulS1L3Step5Desc => 'Selecciona ㅗ con precisión';

  @override
  String get hangulS1L3Step5Q0 => '¿Cuál es ㅗ?';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => '¿Cuál contiene ㅗ?';

  @override
  String get hangulS1L3Step6Title => '¡Lección completada!';

  @override
  String get hangulS1L3Step6Msg => '¡Muy bien!\nAprendiste el sonido de ㅗ(오).';

  @override
  String get hangulS1L4Title => 'Forma y sonido de ㅜ';

  @override
  String get hangulS1L4Subtitle => 'Trazo vertical bajo la línea horizontal: ㅜ';

  @override
  String get hangulS1L4Step0Title => 'La cuarta vocal ㅜ';

  @override
  String get hangulS1L4Step0Desc =>
      'ㅜ produce el sonido \"우\".\nLa posición del trazo vertical es opuesta a ㅗ.';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,comparar posición con ㅗ';

  @override
  String get hangulS1L4Step1Title => 'Escuchar ㅜ';

  @override
  String get hangulS1L4Step1Desc => 'Escucha 우/구/누';

  @override
  String get hangulS1L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L4Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L4Step3Title => 'Elige el sonido ㅜ';

  @override
  String get hangulS1L4Step3Desc => 'Distingue ㅗ/ㅜ';

  @override
  String get hangulS1L4Step4Title => 'Construir caracteres con ㅜ';

  @override
  String get hangulS1L4Step4Desc => 'Combina consonantes con ㅜ';

  @override
  String get hangulS1L4Step5Title => 'Quiz de forma y sonido';

  @override
  String get hangulS1L4Step5Desc => 'Selecciona ㅜ con precisión';

  @override
  String get hangulS1L4Step5Q0 => '¿Cuál es ㅜ?';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => '¿Cuál contiene ㅜ?';

  @override
  String get hangulS1L4Step6Title => '¡Lección completada!';

  @override
  String get hangulS1L4Step6Msg => '¡Muy bien!\nAprendiste el sonido de ㅜ(우).';

  @override
  String get hangulS1L5Title => 'Forma y sonido de ㅡ';

  @override
  String get hangulS1L5Subtitle => 'Vocal de una sola línea horizontal: ㅡ';

  @override
  String get hangulS1L5Step0Title => 'La quinta vocal ㅡ';

  @override
  String get hangulS1L5Step0Desc =>
      'ㅡ es un sonido que se produce estirando la boca hacia los lados.\nLa forma es una sola línea horizontal.';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,una línea horizontal';

  @override
  String get hangulS1L5Step1Title => 'Escuchar ㅡ';

  @override
  String get hangulS1L5Step1Desc => 'Escucha los sonidos 으/그/느';

  @override
  String get hangulS1L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L5Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L5Step3Title => 'Elige el sonido ㅡ';

  @override
  String get hangulS1L5Step3Desc => 'Distingue los sonidos ㅡ y ㅜ';

  @override
  String get hangulS1L5Step4Title => 'Construir caracteres con ㅡ';

  @override
  String get hangulS1L5Step4Desc => 'Combina consonantes con ㅡ';

  @override
  String get hangulS1L5Step5Title => 'Quiz de forma y sonido';

  @override
  String get hangulS1L5Step5Desc => 'Selecciona ㅡ con precisión';

  @override
  String get hangulS1L5Step5Q0 => '¿Cuál es ㅡ?';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => '¿Cuál contiene ㅡ?';

  @override
  String get hangulS1L5Step6Title => '¡Lección completada!';

  @override
  String get hangulS1L5Step6Msg => '¡Muy bien!\nAprendiste el sonido de ㅡ(으).';

  @override
  String get hangulS1L6Title => 'Forma y sonido de ㅣ';

  @override
  String get hangulS1L6Subtitle => 'Vocal de una sola línea vertical: ㅣ';

  @override
  String get hangulS1L6Step0Title => 'La sexta vocal ㅣ';

  @override
  String get hangulS1L6Step0Desc =>
      'ㅣ produce el sonido \"이\".\nLa forma es una sola línea vertical.';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,una línea vertical';

  @override
  String get hangulS1L6Step1Title => 'Escuchar ㅣ';

  @override
  String get hangulS1L6Step1Desc => 'Escucha los sonidos 이/기/니';

  @override
  String get hangulS1L6Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L6Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS1L6Step3Title => 'Elige el sonido ㅣ';

  @override
  String get hangulS1L6Step3Desc => 'Distingue los sonidos ㅣ y ㅡ';

  @override
  String get hangulS1L6Step4Title => 'Construir caracteres con ㅣ';

  @override
  String get hangulS1L6Step4Desc => 'Combina consonantes con ㅣ';

  @override
  String get hangulS1L6Step5Title => 'Quiz de forma y sonido';

  @override
  String get hangulS1L6Step5Desc => 'Selecciona ㅣ con precisión';

  @override
  String get hangulS1L6Step5Q0 => '¿Cuál es ㅣ?';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => '¿Cuál contiene ㅣ?';

  @override
  String get hangulS1L6Step6Title => '¡Lección completada!';

  @override
  String get hangulS1L6Step6Msg => '¡Muy bien!\nAprendiste el sonido de ㅣ(이).';

  @override
  String get hangulS1L7Title => 'Repaso de vocales verticales';

  @override
  String get hangulS1L7Subtitle => 'Distingue ㅏ · ㅓ · ㅣ rápidamente';

  @override
  String get hangulS1L7Step0Title => 'Repaso del grupo de vocales verticales';

  @override
  String get hangulS1L7Step0Desc =>
      'ㅏ, ㅓ y ㅣ son vocales de eje vertical.\nDistíngelas por la posición del trazo y el sonido.';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,vocales verticales';

  @override
  String get hangulS1L7Step1Title => 'Escuchar de nuevo';

  @override
  String get hangulS1L7Step1Desc => 'Comprueba los sonidos 아/어/이';

  @override
  String get hangulS1L7Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L7Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS1L7Step3Title => 'Quiz de escucha: vocales verticales';

  @override
  String get hangulS1L7Step3Desc =>
      'Relaciona el sonido con el carácter correcto';

  @override
  String get hangulS1L7Step4Title => 'Quiz de formas: vocales verticales';

  @override
  String get hangulS1L7Step4Desc => 'Distingue las formas con precisión';

  @override
  String get hangulS1L7Step4Q0 => '¿Trazo corto a la derecha?';

  @override
  String get hangulS1L7Step4Q1 => '¿Trazo corto a la izquierda?';

  @override
  String get hangulS1L7Step4Q2 => '¿Una línea vertical sola?';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => '¡Lección completada!';

  @override
  String get hangulS1L7Step5Msg =>
      '¡Muy bien!\nYa distingues las vocales verticales (ㅏ/ㅓ/ㅣ).';

  @override
  String get hangulS1L8Title => 'Repaso de vocales horizontales';

  @override
  String get hangulS1L8Subtitle => 'Distingue ㅗ · ㅜ · ㅡ rápidamente';

  @override
  String get hangulS1L8Step0Title => 'Repaso del grupo de vocales horizontales';

  @override
  String get hangulS1L8Step0Desc =>
      'ㅗ, ㅜ y ㅡ son vocales de eje horizontal.\nRecuerda la posición del trazo vertical y la forma de la boca.';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,vocales horizontales';

  @override
  String get hangulS1L8Step1Title => 'Escuchar de nuevo';

  @override
  String get hangulS1L8Step1Desc => 'Comprueba los sonidos 오/우/으';

  @override
  String get hangulS1L8Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L8Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS1L8Step3Title => 'Quiz de escucha: vocales horizontales';

  @override
  String get hangulS1L8Step3Desc =>
      'Relaciona el sonido con el carácter correcto';

  @override
  String get hangulS1L8Step4Title => 'Quiz de formas: vocales horizontales';

  @override
  String get hangulS1L8Step4Desc => 'Comprueba la forma y el sonido juntos';

  @override
  String get hangulS1L8Step4Q0 => '¿Trazo vertical sobre la línea horizontal?';

  @override
  String get hangulS1L8Step4Q1 => '¿Trazo vertical bajo la línea horizontal?';

  @override
  String get hangulS1L8Step4Q2 => '¿Una línea horizontal sola?';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => '¡Lección completada!';

  @override
  String get hangulS1L8Step5Msg =>
      '¡Muy bien!\nYa distingues las vocales horizontales (ㅗ/ㅜ/ㅡ).';

  @override
  String get hangulS1L9Title => 'Misión de vocales básicas';

  @override
  String get hangulS1L9Subtitle =>
      'Completa combinaciones de vocales en el tiempo límite';

  @override
  String get hangulS1L9Step0Title => 'Misión final de la Etapa 1';

  @override
  String get hangulS1L9Step0Desc =>
      'Completa combinaciones de sílabas en el tiempo límite.\n¡Gana recompensas de limón por precisión y velocidad!';

  @override
  String get hangulS1L9Step1Title => 'Misión cronometrada';

  @override
  String get hangulS1L9Step2Title => 'Resultados de la misión';

  @override
  String get hangulS1L9Step3Title => '¡Etapa 1 completada!';

  @override
  String get hangulS1L9Step3Msg =>
      '¡Felicidades!\nHas terminado todas las vocales básicas de la Etapa 1.';

  @override
  String get hangulS1L10Title => '¡Primeras palabras en coreano!';

  @override
  String get hangulS1L10Subtitle =>
      'Lee palabras reales con los caracteres aprendidos';

  @override
  String get hangulS1L10Step0Title => '¡Ahora puedes leer palabras!';

  @override
  String get hangulS1L10Step0Desc =>
      'Has aprendido vocales y consonantes básicas.\n¿Leemos algunas palabras reales en coreano?';

  @override
  String get hangulS1L10Step0Highlights => 'palabras reales,desafío de lectura';

  @override
  String get hangulS1L10Step1Title => 'Lee las primeras palabras';

  @override
  String get hangulS1L10Step1Descs =>
      'niño/a,leche,pepino,esto/diente,hermano menor';

  @override
  String get hangulS1L10Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS1L10Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS1L10Step3Title => 'Escucha y elige';

  @override
  String get hangulS1L10Step4Title => '¡Increíble!';

  @override
  String get hangulS1L10Step4Msg =>
      '¡Leíste palabras en coreano!\nAprende más consonantes y\npodrás leer muchas más palabras.';

  @override
  String get hangulS1CompleteTitle => '¡Etapa 1 completada!';

  @override
  String get hangulS1CompleteMsg => '¡Has dominado las 6 vocales básicas!';

  @override
  String get hangulS2L1Title => 'Forma y sonido de ㅑ';

  @override
  String get hangulS2L1Subtitle => 'ㅏ con un trazo extra: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏ se convierte en ㅑ';

  @override
  String get hangulS2L1Step0Desc =>
      'Si añades un trazo a ㅏ obtienes ㅑ.\nEl sonido pasa del \"a\" al más enérgico \"ya\".';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,vocal-Y';

  @override
  String get hangulS2L1Step1Title => 'Escucha ㅑ';

  @override
  String get hangulS2L1Step1Desc => 'Escucha los sonidos 야/갸/냐';

  @override
  String get hangulS2L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS2L1Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS2L1Step3Title => 'Escucha ㅏ vs ㅑ';

  @override
  String get hangulS2L1Step3Desc => 'Distingue sonidos similares';

  @override
  String get hangulS2L1Step4Title => 'Forma sílabas con ㅑ';

  @override
  String get hangulS2L1Step4Desc => 'Completa las combinaciones consonante + ㅑ';

  @override
  String get hangulS2L1Step5Title => 'Quiz de forma y sonido';

  @override
  String get hangulS2L1Step5Desc => 'Elige ㅑ correctamente';

  @override
  String get hangulS2L1Step5Q0 => '¿Cuál es ㅑ?';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => '¿Cuál contiene ㅑ?';

  @override
  String get hangulS2L1Step6Title => '¡Lección completada!';

  @override
  String get hangulS2L1Step6Msg => '¡Genial!\nHas aprendido el sonido ㅑ (야).';

  @override
  String get hangulS2L2Title => 'Forma y sonido de ㅕ';

  @override
  String get hangulS2L2Subtitle => 'ㅓ con un trazo extra: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓ se convierte en ㅕ';

  @override
  String get hangulS2L2Step0Desc =>
      'Si añades un trazo a ㅓ obtienes ㅕ.\nEl sonido pasa de \"eo\" a \"yeo\".';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,vocal-Y';

  @override
  String get hangulS2L2Step1Title => 'Escucha ㅕ';

  @override
  String get hangulS2L2Step1Desc => 'Escucha los sonidos 여/겨/녀';

  @override
  String get hangulS2L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS2L2Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS2L2Step3Title => 'Escucha ㅓ vs ㅕ';

  @override
  String get hangulS2L2Step3Desc => 'Distingue 어 y 여';

  @override
  String get hangulS2L2Step4Title => 'Forma sílabas con ㅕ';

  @override
  String get hangulS2L2Step4Desc => 'Completa las combinaciones consonante + ㅕ';

  @override
  String get hangulS2L2Step5Title => '¡Lección completada!';

  @override
  String get hangulS2L2Step5Msg => '¡Genial!\nHas aprendido el sonido ㅕ (여).';

  @override
  String get hangulS2L3Title => 'Forma y sonido de ㅛ';

  @override
  String get hangulS2L3Subtitle => 'ㅗ con un trazo extra: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗ se convierte en ㅛ';

  @override
  String get hangulS2L3Step0Desc =>
      'Si añades un trazo a ㅗ obtienes ㅛ.\nEl sonido pasa de \"o\" a \"yo\".';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,vocal-Y';

  @override
  String get hangulS2L3Step1Title => 'Escucha ㅛ';

  @override
  String get hangulS2L3Step1Desc => 'Escucha los sonidos 요/교/뇨';

  @override
  String get hangulS2L3Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS2L3Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS2L3Step3Title => 'Escucha ㅗ vs ㅛ';

  @override
  String get hangulS2L3Step3Desc => 'Distingue 오 y 요';

  @override
  String get hangulS2L3Step4Title => 'Forma sílabas con ㅛ';

  @override
  String get hangulS2L3Step4Desc => 'Completa las combinaciones consonante + ㅛ';

  @override
  String get hangulS2L3Step5Title => '¡Lección completada!';

  @override
  String get hangulS2L3Step5Msg => '¡Genial!\nHas aprendido el sonido ㅛ (요).';

  @override
  String get hangulS2L4Title => 'Forma y sonido de ㅠ';

  @override
  String get hangulS2L4Subtitle => 'ㅜ con un trazo extra: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜ se convierte en ㅠ';

  @override
  String get hangulS2L4Step0Desc =>
      'Si añades un trazo a ㅜ obtienes ㅠ.\nEl sonido pasa de \"u\" a \"yu\".';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,vocal-Y';

  @override
  String get hangulS2L4Step1Title => 'Escucha ㅠ';

  @override
  String get hangulS2L4Step1Desc => 'Escucha los sonidos 유/규/뉴';

  @override
  String get hangulS2L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS2L4Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS2L4Step3Title => 'Escucha ㅜ vs ㅠ';

  @override
  String get hangulS2L4Step3Desc => 'Distingue 우 y 유';

  @override
  String get hangulS2L4Step4Title => 'Forma sílabas con ㅠ';

  @override
  String get hangulS2L4Step4Desc => 'Completa las combinaciones consonante + ㅠ';

  @override
  String get hangulS2L4Step5Title => '¡Lección completada!';

  @override
  String get hangulS2L4Step5Msg => '¡Genial!\nHas aprendido el sonido ㅠ (유).';

  @override
  String get hangulS2L5Title => 'Grupo de vocales-Y';

  @override
  String get hangulS2L5Subtitle => 'Entrenamiento intensivo: ㅑ · ㅕ · ㅛ · ㅠ';

  @override
  String get hangulS2L5Step0Title => 'Todas las vocales-Y de un vistazo';

  @override
  String get hangulS2L5Step0Desc =>
      'ㅑ/ㅕ/ㅛ/ㅠ son vocales base con un trazo adicional.\nDistingue formas y sonidos rápidamente.';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => 'Escucha las cuatro';

  @override
  String get hangulS2L5Step1Desc => 'Repasa los sonidos 야/여/요/유';

  @override
  String get hangulS2L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS2L5Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS2L5Step3Title => 'Quiz de distinción de sonido';

  @override
  String get hangulS2L5Step3Desc => 'Distingue los sonidos de las vocales-Y';

  @override
  String get hangulS2L5Step4Title => 'Quiz de distinción de forma';

  @override
  String get hangulS2L5Step4Desc => 'Distingue las formas con precisión';

  @override
  String get hangulS2L5Step4Q0 => '¿Cuál es ㅑ?';

  @override
  String get hangulS2L5Step4Q1 => '¿Cuál es ㅕ?';

  @override
  String get hangulS2L5Step4Q2 => '¿Cuál es ㅛ?';

  @override
  String get hangulS2L5Step4Q3 => '¿Cuál es ㅠ?';

  @override
  String get hangulS2L5Step5Title => '¡Lección completada!';

  @override
  String get hangulS2L5Step5Msg =>
      '¡Genial!\nCada vez distingues mejor las 4 vocales-Y.';

  @override
  String get hangulS2L6Title => 'Contraste básico vs vocal-Y';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => 'Organiza los pares confusos';

  @override
  String get hangulS2L6Step0Desc =>
      'Compara vocales básicas y vocales-Y una al lado de la otra.';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => 'Distinción de sonido en pares';

  @override
  String get hangulS2L6Step1Desc =>
      'Elige la respuesta correcta entre sonidos similares';

  @override
  String get hangulS2L6Step2Title => 'Distinción de forma en pares';

  @override
  String get hangulS2L6Step2Desc => 'Comprueba si el trazo extra está presente';

  @override
  String get hangulS2L6Step2Q0 => '¿Qué vocal tiene el trazo extra?';

  @override
  String get hangulS2L6Step2Q1 => '¿Qué vocal tiene el trazo extra?';

  @override
  String get hangulS2L6Step2Q2 => '¿Qué vocal tiene el trazo extra?';

  @override
  String get hangulS2L6Step2Q3 => '¿Qué vocal tiene el trazo extra?';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => '¡Lección completada!';

  @override
  String get hangulS2L6Step3Msg =>
      '¡Genial!\nEl contraste básico / vocal-Y ya es sólido.';

  @override
  String get hangulS2L7Title => 'Misión vocales-Y';

  @override
  String get hangulS2L7Subtitle =>
      'Completa combinaciones de vocales-Y antes de que acabe el tiempo';

  @override
  String get hangulS2L7Step0Title => 'Misión final de la Etapa 2';

  @override
  String get hangulS2L7Step0Desc =>
      'Combina las vocales-Y rápida y precisamente.\nTu recompensa de limón depende del número y la velocidad.';

  @override
  String get hangulS2L7Step1Title => 'Misión contrarreloj';

  @override
  String get hangulS2L7Step2Title => 'Resultados de la misión';

  @override
  String get hangulS2L7Step3Title => '¡Etapa 2 completada!';

  @override
  String get hangulS2L7Step3Msg =>
      '¡Felicidades!\nHas terminado todas las vocales-Y de la Etapa 2.';

  @override
  String get hangulS2CompleteTitle => '¡Etapa 2 completada!';

  @override
  String get hangulS2CompleteMsg => '¡Has dominado las vocales-Y!';

  @override
  String get hangulS3L1Title => 'Forma y sonido de ㅐ';

  @override
  String get hangulS3L1Subtitle => 'Siente la combinación ㅏ + ㅣ';

  @override
  String get hangulS3L1Step0Title => 'Así se ve ㅐ';

  @override
  String get hangulS3L1Step0Desc =>
      'ㅐ es una vocal derivada de la familia ㅏ.\nAprende su sonido representativo como \"애\".';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,reconocimiento de forma';

  @override
  String get hangulS3L1Step1Title => 'Escucha los sonidos de ㅐ';

  @override
  String get hangulS3L1Step1Desc => 'Escucha los sonidos 애/개/내';

  @override
  String get hangulS3L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS3L1Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS3L1Step3Title => 'Escucha: ㅏ vs ㅐ';

  @override
  String get hangulS3L1Step3Desc => 'Distingue 아/애';

  @override
  String get hangulS3L1Step4Title => '¡Lección completada!';

  @override
  String get hangulS3L1Step4Msg =>
      '¡Muy bien!\nAprendiste la forma y el sonido de ㅐ(애).';

  @override
  String get hangulS3L2Title => 'Forma y sonido de ㅔ';

  @override
  String get hangulS3L2Subtitle => 'Siente la combinación ㅓ + ㅣ';

  @override
  String get hangulS3L2Step0Title => 'Así se ve ㅔ';

  @override
  String get hangulS3L2Step0Desc =>
      'ㅔ es una vocal derivada de la familia ㅓ.\nAprende su sonido representativo como \"에\".';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,reconocimiento de forma';

  @override
  String get hangulS3L2Step1Title => 'Escucha los sonidos de ㅔ';

  @override
  String get hangulS3L2Step1Desc => 'Escucha los sonidos 에/게/네';

  @override
  String get hangulS3L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS3L2Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS3L2Step3Title => 'Escucha: ㅓ vs ㅔ';

  @override
  String get hangulS3L2Step3Desc => 'Distingue 어/에';

  @override
  String get hangulS3L2Step4Title => '¡Lección completada!';

  @override
  String get hangulS3L2Step4Msg =>
      '¡Muy bien!\nAprendiste la forma y el sonido de ㅔ(에).';

  @override
  String get hangulS3L3Title => 'Distinguir ㅐ vs ㅔ';

  @override
  String get hangulS3L3Subtitle =>
      'Entrenamiento de distinción centrado en la forma';

  @override
  String get hangulS3L3Step0Title => 'La clave es distinguir las formas';

  @override
  String get hangulS3L3Step0Desc =>
      'En el nivel principiante, ㅐ/ㅔ pueden sonar muy similares.\nAsí que primero enfoquémonos en distinguir las formas con precisión.';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,distinción de forma';

  @override
  String get hangulS3L3Step1Title => 'Quiz de distinción de forma';

  @override
  String get hangulS3L3Step1Desc => 'Elige ㅐ y ㅔ con precisión';

  @override
  String get hangulS3L3Step1Q0 => '¿Cuál es ㅐ?';

  @override
  String get hangulS3L3Step1Q1 => '¿Cuál es ㅔ?';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => '¡Lección completada!';

  @override
  String get hangulS3L3Step2Msg =>
      '¡Muy bien!\nAhora puedes distinguir ㅐ/ㅔ con más precisión.';

  @override
  String get hangulS3L4Title => 'Forma y sonido de ㅒ';

  @override
  String get hangulS3L4Subtitle => 'Vocal de la familia Y-ㅐ';

  @override
  String get hangulS3L4Step0Title => 'Aprendamos ㅒ';

  @override
  String get hangulS3L4Step0Desc =>
      'ㅒ es una Y-vocal de la familia ㅐ.\nSu sonido representativo es \"얘\".';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => 'Escucha los sonidos de ㅒ';

  @override
  String get hangulS3L4Step1Desc => 'Escucha los sonidos 얘/걔/냬';

  @override
  String get hangulS3L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS3L4Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS3L4Step3Title => '¡Lección completada!';

  @override
  String get hangulS3L4Step3Msg => '¡Muy bien!\nAprendiste la forma de ㅒ(얘).';

  @override
  String get hangulS3L5Title => 'Forma y sonido de ㅖ';

  @override
  String get hangulS3L5Subtitle => 'Vocal de la familia Y-ㅔ';

  @override
  String get hangulS3L5Step0Title => 'Aprendamos ㅖ';

  @override
  String get hangulS3L5Step0Desc =>
      'ㅖ es una Y-vocal de la familia ㅔ.\nSu sonido representativo es \"예\".';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => 'Escucha los sonidos de ㅖ';

  @override
  String get hangulS3L5Step1Desc => 'Escucha los sonidos 예/계/녜';

  @override
  String get hangulS3L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS3L5Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS3L5Step3Title => '¡Lección completada!';

  @override
  String get hangulS3L5Step3Msg => '¡Muy bien!\nAprendiste la forma de ㅖ(예).';

  @override
  String get hangulS3L6Title => 'Revisión completa de la familia ㅐ/ㅔ';

  @override
  String get hangulS3L6Subtitle => 'Verificación integrada: ㅐ ㅔ ㅒ ㅖ';

  @override
  String get hangulS3L6Step0Title => 'Distingue los cuatro a la vez';

  @override
  String get hangulS3L6Step0Desc => 'Verifica ㅐ/ㅔ/ㅒ/ㅖ por forma y sonido.';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => 'Distinción de sonidos';

  @override
  String get hangulS3L6Step1Desc =>
      'Elige la respuesta correcta entre sonidos similares';

  @override
  String get hangulS3L6Step2Title => 'Distinción de formas';

  @override
  String get hangulS3L6Step2Desc => 'Mira la forma y elige rápidamente';

  @override
  String get hangulS3L6Step2Q0 => '¿Cuál pertenece a la familia Y-ㅐ?';

  @override
  String get hangulS3L6Step2Q1 => '¿Cuál pertenece a la familia Y-ㅔ?';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => '¡Lección completada!';

  @override
  String get hangulS3L6Step3Msg =>
      '¡Muy bien!\nHas dominado la distinción de las vocales clave de la Etapa 3.';

  @override
  String get hangulS3L7Title => 'Misión de la Etapa 3';

  @override
  String get hangulS3L7Subtitle => 'Misión de distinción rápida: familia ㅐ/ㅔ';

  @override
  String get hangulS3L7Step0Title => 'Misión final de la Etapa 3';

  @override
  String get hangulS3L7Step0Desc =>
      'Combina las combinaciones de la familia ㅐ/ㅔ de forma rápida y precisa.';

  @override
  String get hangulS3L7Step1Title => 'Misión cronometrada';

  @override
  String get hangulS3L7Step2Title => 'Resultados de la misión';

  @override
  String get hangulS3L7Step3Title => '¡Etapa 3 completada!';

  @override
  String get hangulS3L7Step3Msg =>
      '¡Felicidades!\nCompletaste todas las vocales de la familia ㅐ/ㅔ en la Etapa 3.';

  @override
  String get hangulS3L7Step4Title => '¡Etapa 3 completada!';

  @override
  String get hangulS3L7Step4Msg => '¡Aprendiste todas las vocales!';

  @override
  String get hangulS3CompleteTitle => '¡Etapa 3 completada!';

  @override
  String get hangulS3CompleteMsg => '¡Aprendiste todas las vocales!';

  @override
  String get hangulS4L1Title => 'Forma y sonido de ㄱ';

  @override
  String get hangulS4L1Subtitle => 'Primera consonante básica: ㄱ';

  @override
  String get hangulS4L1Step0Title => 'Aprendamos ㄱ';

  @override
  String get hangulS4L1Step0Desc =>
      'ㄱ es la primera consonante básica.\nCombinada con ㅏ, produce el sonido \"가\".';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,consonante básica';

  @override
  String get hangulS4L1Step1Title => 'Escuchar los sonidos de ㄱ';

  @override
  String get hangulS4L1Step1Desc => 'Escucha los sonidos 가/고/구';

  @override
  String get hangulS4L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L1Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L1Step3Title => 'Elige el sonido ㄱ';

  @override
  String get hangulS4L1Step3Desc => 'Escucha y selecciona el carácter correcto';

  @override
  String get hangulS4L1Step4Title => 'Formar caracteres con ㄱ';

  @override
  String get hangulS4L1Step4Desc => 'Combina ㄱ con vocales';

  @override
  String get hangulS4L1SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L1SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㄱ.';

  @override
  String get hangulS4L2Title => 'Forma y sonido de ㄴ';

  @override
  String get hangulS4L2Subtitle => 'Segunda consonante básica: ㄴ';

  @override
  String get hangulS4L2Step0Title => 'Aprendamos ㄴ';

  @override
  String get hangulS4L2Step0Desc => 'ㄴ crea la familia de sonidos \"나\".';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => 'Escuchar los sonidos de ㄴ';

  @override
  String get hangulS4L2Step1Desc => 'Escucha los sonidos 나/노/누';

  @override
  String get hangulS4L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L2Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L2Step3Title => 'Elige el sonido ㄴ';

  @override
  String get hangulS4L2Step3Desc => 'Distingue 나/다';

  @override
  String get hangulS4L2Step4Title => 'Formar caracteres con ㄴ';

  @override
  String get hangulS4L2Step4Desc => 'Combina ㄴ con vocales';

  @override
  String get hangulS4L2SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L2SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㄴ.';

  @override
  String get hangulS4L3Title => 'Forma y sonido de ㄷ';

  @override
  String get hangulS4L3Subtitle => 'Tercera consonante básica: ㄷ';

  @override
  String get hangulS4L3Step0Title => 'Aprendamos ㄷ';

  @override
  String get hangulS4L3Step0Desc => 'ㄷ crea la familia de sonidos \"다\".';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => 'Escuchar los sonidos de ㄷ';

  @override
  String get hangulS4L3Step1Desc => 'Escucha los sonidos 다/도/두';

  @override
  String get hangulS4L3Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L3Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L3Step3Title => 'Elige el sonido ㄷ';

  @override
  String get hangulS4L3Step3Desc => 'Distingue 다/나';

  @override
  String get hangulS4L3Step4Title => 'Formar caracteres con ㄷ';

  @override
  String get hangulS4L3Step4Desc => 'Combina ㄷ con vocales';

  @override
  String get hangulS4L3SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L3SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㄷ.';

  @override
  String get hangulS4L4Title => 'Forma y sonido de ㄹ';

  @override
  String get hangulS4L4Subtitle => 'Cuarta consonante básica: ㄹ';

  @override
  String get hangulS4L4Step0Title => 'Aprendamos ㄹ';

  @override
  String get hangulS4L4Step0Desc => 'ㄹ crea la familia de sonidos \"라\".';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => 'Escuchar los sonidos de ㄹ';

  @override
  String get hangulS4L4Step1Desc => 'Escucha los sonidos 라/로/루';

  @override
  String get hangulS4L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L4Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L4Step3Title => 'Elige el sonido ㄹ';

  @override
  String get hangulS4L4Step3Desc => 'Distingue 라/나';

  @override
  String get hangulS4L4Step4Title => 'Formar caracteres con ㄹ';

  @override
  String get hangulS4L4Step4Desc => 'Combina ㄹ con vocales';

  @override
  String get hangulS4L4SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L4SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㄹ.';

  @override
  String get hangulS4L5Title => 'Forma y sonido de ㅁ';

  @override
  String get hangulS4L5Subtitle => 'Quinta consonante básica: ㅁ';

  @override
  String get hangulS4L5Step0Title => 'Aprendamos ㅁ';

  @override
  String get hangulS4L5Step0Desc => 'ㅁ crea la familia de sonidos \"마\".';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => 'Escuchar los sonidos de ㅁ';

  @override
  String get hangulS4L5Step1Desc => 'Escucha los sonidos 마/모/무';

  @override
  String get hangulS4L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L5Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L5Step3Title => 'Elige el sonido ㅁ';

  @override
  String get hangulS4L5Step3Desc => 'Distingue 마/바';

  @override
  String get hangulS4L5Step4Title => 'Formar caracteres con ㅁ';

  @override
  String get hangulS4L5Step4Desc => 'Combina ㅁ con vocales';

  @override
  String get hangulS4L5SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L5SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㅁ.';

  @override
  String get hangulS4L6Title => 'Forma y sonido de ㅂ';

  @override
  String get hangulS4L6Subtitle => 'Sexta consonante básica: ㅂ';

  @override
  String get hangulS4L6Step0Title => 'Aprendamos ㅂ';

  @override
  String get hangulS4L6Step0Desc => 'ㅂ crea la familia de sonidos \"바\".';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => 'Escuchar los sonidos de ㅂ';

  @override
  String get hangulS4L6Step1Desc => 'Escucha los sonidos 바/보/부';

  @override
  String get hangulS4L6Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L6Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L6Step3Title => 'Elige el sonido ㅂ';

  @override
  String get hangulS4L6Step3Desc => 'Distingue 바/마';

  @override
  String get hangulS4L6Step4Title => 'Formar caracteres con ㅂ';

  @override
  String get hangulS4L6Step4Desc => 'Combina ㅂ con vocales';

  @override
  String get hangulS4L6SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS4L6SummaryMsg =>
      '¡Genial!\nHas aprendido la forma y el sonido de ㅂ.';

  @override
  String get hangulS4L7Title => 'Forma y sonido de ㅅ';

  @override
  String get hangulS4L7Subtitle => 'Séptima consonante básica: ㅅ';

  @override
  String get hangulS4L7Step0Title => 'Aprendamos ㅅ';

  @override
  String get hangulS4L7Step0Desc => 'ㅅ crea la familia de sonidos \"사\".';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => 'Escuchar los sonidos de ㅅ';

  @override
  String get hangulS4L7Step1Desc => 'Escucha los sonidos 사/소/수';

  @override
  String get hangulS4L7Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L7Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L7Step3Title => 'Elige el sonido ㅅ';

  @override
  String get hangulS4L7Step3Desc => 'Distingue 사/자';

  @override
  String get hangulS4L7Step4Title => 'Formar caracteres con ㅅ';

  @override
  String get hangulS4L7Step4Desc => 'Combina ㅅ con vocales';

  @override
  String get hangulS4L7SummaryTitle => '¡Etapa 4 completada!';

  @override
  String get hangulS4L7SummaryMsg =>
      '¡Felicidades!\nHas completado la Etapa 4: Consonantes básicas 1 (ㄱ~ㅅ).';

  @override
  String get hangulS4L8Title => '¡Desafío de lectura de palabras!';

  @override
  String get hangulS4L8Subtitle => 'Lee palabras usando consonantes y vocales';

  @override
  String get hangulS4L8Step0Title => '¡Ahora puedes leer aún más palabras!';

  @override
  String get hangulS4L8Step0Desc =>
      'Has aprendido las 7 consonantes básicas y las vocales.\n¿Leemos algunas palabras reales formadas con estos caracteres?';

  @override
  String get hangulS4L8Step0Highlights =>
      '7 consonantes,vocales,palabras reales';

  @override
  String get hangulS4L8Step1Title => 'Lee las palabras';

  @override
  String get hangulS4L8Step1Descs => 'árbol,mar,mariposa,sombrero,mueble,tofu';

  @override
  String get hangulS4L8Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS4L8Step2Desc =>
      'Intenta pronunciar los caracteres en voz alta';

  @override
  String get hangulS4L8Step3Title => 'Escucha y elige';

  @override
  String get hangulS4L8Step4Title => '¿Qué significa?';

  @override
  String get hangulS4L8Step4Q0 => '¿Qué significa \"나비\"?';

  @override
  String get hangulS4L8Step4Q1 => '¿Qué significa \"바다\"?';

  @override
  String get hangulS4L8SummaryTitle => '¡Excelente!';

  @override
  String get hangulS4L8SummaryMsg =>
      '¡Leíste 6 palabras coreanas!\nAprende más consonantes y podrás leer aún más.';

  @override
  String get hangulS4LMTitle =>
      'Misión: ¡Combinaciones de consonantes básicas!';

  @override
  String get hangulS4LMSubtitle =>
      'Construye sílabas dentro del límite de tiempo';

  @override
  String get hangulS4LMStep0Title => '¡Inicio de misión!';

  @override
  String get hangulS4LMStep0Desc =>
      'Combina las consonantes básicas ㄱ~ㅅ con vocales.\n¡Alcanza tu objetivo dentro del límite de tiempo!';

  @override
  String get hangulS4LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS4LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS4LMSummaryTitle => '¡Misión completada!';

  @override
  String get hangulS4LMSummaryMsg =>
      '¡Puedes combinar libremente las 7 consonantes básicas!';

  @override
  String get hangulS4CompleteTitle => '¡Etapa 4 completada!';

  @override
  String get hangulS4CompleteMsg => '¡Has dominado las 7 consonantes básicas!';

  @override
  String get hangulS5L1Title => 'Entendiendo ㅇ';

  @override
  String get hangulS5L1Subtitle => 'Lectura de ㅇ en posición inicial';

  @override
  String get hangulS5L1Step0Title => 'ㅇ es una consonante especial';

  @override
  String get hangulS5L1Step0Desc =>
      'ㅇ en posición inicial casi no tiene sonido,\ny suena como 아/오/우 al combinarse con vocales.';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,posición inicial';

  @override
  String get hangulS5L1Step1Title => 'Escucha combinaciones con ㅇ';

  @override
  String get hangulS5L1Step1Desc => 'Escucha los sonidos 아/오/우';

  @override
  String get hangulS5L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L1Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L1Step3Title => 'Forma sílabas con ㅇ';

  @override
  String get hangulS5L1Step3Desc => 'Combina ㅇ + vocal';

  @override
  String get hangulS5L1Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L1Step4Msg => '¡Muy bien!\nEntiendes cómo funciona ㅇ.';

  @override
  String get hangulS5L2Title => 'Forma y sonido de ㅈ';

  @override
  String get hangulS5L2Subtitle => 'Lectura básica de ㅈ';

  @override
  String get hangulS5L2Step0Title => 'Aprendamos ㅈ';

  @override
  String get hangulS5L2Step0Desc => 'ㅈ produce la familia de sonidos \"자\".';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => 'Escucha los sonidos de ㅈ';

  @override
  String get hangulS5L2Step1Desc => 'Escucha 자/조/주';

  @override
  String get hangulS5L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L2Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L2Step3Title => 'Elige el sonido ㅈ';

  @override
  String get hangulS5L2Step3Desc => 'Distingue 자 de 사';

  @override
  String get hangulS5L2Step4Title => 'Forma sílabas con ㅈ';

  @override
  String get hangulS5L2Step4Desc => 'Combina ㅈ + vocal';

  @override
  String get hangulS5L2Step5Title => '¡Lección completada!';

  @override
  String get hangulS5L2Step5Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅈ.';

  @override
  String get hangulS5L3Title => 'Forma y sonido de ㅊ';

  @override
  String get hangulS5L3Subtitle => 'Lectura básica de ㅊ';

  @override
  String get hangulS5L3Step0Title => 'Aprendamos ㅊ';

  @override
  String get hangulS5L3Step0Desc => 'ㅊ produce la familia de sonidos \"차\".';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => 'Escucha los sonidos de ㅊ';

  @override
  String get hangulS5L3Step1Desc => 'Escucha 차/초/추';

  @override
  String get hangulS5L3Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L3Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L3Step3Title => 'Elige el sonido ㅊ';

  @override
  String get hangulS5L3Step3Desc => 'Distingue 차 de 자';

  @override
  String get hangulS5L3Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L3Step4Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅊ.';

  @override
  String get hangulS5L4Title => 'Forma y sonido de ㅋ';

  @override
  String get hangulS5L4Subtitle => 'Lectura básica de ㅋ';

  @override
  String get hangulS5L4Step0Title => 'Aprendamos ㅋ';

  @override
  String get hangulS5L4Step0Desc => 'ㅋ produce la familia de sonidos \"카\".';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => 'Escucha los sonidos de ㅋ';

  @override
  String get hangulS5L4Step1Desc => 'Escucha 카/코/쿠';

  @override
  String get hangulS5L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L4Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L4Step3Title => 'Elige el sonido ㅋ';

  @override
  String get hangulS5L4Step3Desc => 'Distingue 카 de 가';

  @override
  String get hangulS5L4Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L4Step4Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅋ.';

  @override
  String get hangulS5L5Title => 'Forma y sonido de ㅌ';

  @override
  String get hangulS5L5Subtitle => 'Lectura básica de ㅌ';

  @override
  String get hangulS5L5Step0Title => 'Aprendamos ㅌ';

  @override
  String get hangulS5L5Step0Desc => 'ㅌ produce la familia de sonidos \"타\".';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => 'Escucha los sonidos de ㅌ';

  @override
  String get hangulS5L5Step1Desc => 'Escucha 타/토/투';

  @override
  String get hangulS5L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L5Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L5Step3Title => 'Elige el sonido ㅌ';

  @override
  String get hangulS5L5Step3Desc => 'Distingue 타 de 다';

  @override
  String get hangulS5L5Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L5Step4Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅌ.';

  @override
  String get hangulS5L6Title => 'Forma y sonido de ㅍ';

  @override
  String get hangulS5L6Subtitle => 'Lectura básica de ㅍ';

  @override
  String get hangulS5L6Step0Title => 'Aprendamos ㅍ';

  @override
  String get hangulS5L6Step0Desc => 'ㅍ produce la familia de sonidos \"파\".';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => 'Escucha los sonidos de ㅍ';

  @override
  String get hangulS5L6Step1Desc => 'Escucha 파/포/푸';

  @override
  String get hangulS5L6Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L6Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L6Step3Title => 'Elige el sonido ㅍ';

  @override
  String get hangulS5L6Step3Desc => 'Distingue 파 de 바';

  @override
  String get hangulS5L6Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L6Step4Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅍ.';

  @override
  String get hangulS5L7Title => 'Forma y sonido de ㅎ';

  @override
  String get hangulS5L7Subtitle => 'Lectura básica de ㅎ';

  @override
  String get hangulS5L7Step0Title => 'Aprendamos ㅎ';

  @override
  String get hangulS5L7Step0Desc => 'ㅎ produce la familia de sonidos \"하\".';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => 'Escucha los sonidos de ㅎ';

  @override
  String get hangulS5L7Step1Desc => 'Escucha 하/호/후';

  @override
  String get hangulS5L7Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS5L7Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS5L7Step3Title => 'Elige el sonido ㅎ';

  @override
  String get hangulS5L7Step3Desc => 'Distingue 하 de 아';

  @override
  String get hangulS5L7Step4Title => '¡Lección completada!';

  @override
  String get hangulS5L7Step4Msg =>
      '¡Muy bien!\nHas aprendido el sonido y la forma de ㅎ.';

  @override
  String get hangulS5L8Title => 'Lectura aleatoria: consonantes extra';

  @override
  String get hangulS5L8Subtitle => 'Repaso mezclado de ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS5L8Step0Title => 'Repaso aleatorio';

  @override
  String get hangulS5L8Step0Desc =>
      'Vamos a leer las 7 consonantes extra todas mezcladas.';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => 'Quiz de forma/sonido';

  @override
  String get hangulS5L8Step1Desc => 'Conecta sonidos con caracteres';

  @override
  String get hangulS5L8Step2Title => '¡Lección completada!';

  @override
  String get hangulS5L8Step2Msg =>
      '¡Muy bien!\nHas repasado aleatoriamente las 7 consonantes extra.';

  @override
  String get hangulS5L9Title => 'Vista previa de pares confusos';

  @override
  String get hangulS5L9Subtitle =>
      'Práctica de distinción para el siguiente nivel';

  @override
  String get hangulS5L9Step0Title => 'Primero veamos los pares difíciles';

  @override
  String get hangulS5L9Step0Desc => 'Practica distinguir ㅈ/ㅊ, ㄱ/ㅋ, ㄷ/ㅌ y ㅂ/ㅍ.';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => 'Escucha contrastiva';

  @override
  String get hangulS5L9Step1Desc =>
      'Elige el sonido correcto entre dos opciones';

  @override
  String get hangulS5L9Step2Title => '¡Lección completada!';

  @override
  String get hangulS5L9Step2Msg =>
      '¡Muy bien!\nEstás listo para el siguiente nivel.';

  @override
  String get hangulS5LMTitle => 'Misión de la Etapa 5';

  @override
  String get hangulS5LMSubtitle => 'Misión integral: consonantes básicas 2';

  @override
  String get hangulS5LMStep0Title => '¡Comienza la misión!';

  @override
  String get hangulS5LMStep0Desc =>
      'Combina las consonantes básicas 2 (ㅇ~ㅎ) con vocales.\n¡Alcanza el objetivo dentro del tiempo límite!';

  @override
  String get hangulS5LMStep1Title => '¡Forma sílabas!';

  @override
  String get hangulS5LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS5LMStep3Title => '¡Etapa 5 completada!';

  @override
  String get hangulS5LMStep3Msg =>
      '¡Felicidades!\nCompletaste la Etapa 5: consonantes básicas 2 (ㅇ~ㅎ).';

  @override
  String get hangulS5LMStep4Title => '¡Etapa 5 completada!';

  @override
  String get hangulS5LMStep4Msg =>
      '¡Has dominado todas las consonantes básicas!';

  @override
  String get hangulS5CompleteTitle => '¡Etapa 5 completada!';

  @override
  String get hangulS5CompleteMsg =>
      '¡Has dominado todas las consonantes básicas!';

  @override
  String get hangulS6L1Title => 'Lectura de patrones 가~기';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + patrones de vocales básicas';

  @override
  String get hangulS6L1Step0Title => 'Empezar a leer con patrones';

  @override
  String get hangulS6L1Step0Desc =>
      'Cambia la vocal unida a ㄱ\ny encontrarás el ritmo de lectura.';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => 'Escuchar los sonidos del patrón';

  @override
  String get hangulS6L1Step1Desc => 'Escucha 가/거/고/구/그/기 en orden';

  @override
  String get hangulS6L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS6L1Step2Desc => 'Di cada sílaba en voz alta';

  @override
  String get hangulS6L1Step3Title => 'Quiz de patrones';

  @override
  String get hangulS6L1Step3Desc => 'Encuentra el mismo patrón de consonante';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => '¡Lección completada!';

  @override
  String get hangulS6L1Step4Msg =>
      '¡Genial!\nHas empezado a leer los patrones 가~기.';

  @override
  String get hangulS6L2Title => 'Expansión de 나~니';

  @override
  String get hangulS6L2Subtitle => 'Lectura de patrones ㄴ';

  @override
  String get hangulS6L2Step0Title => 'Expandir los patrones de ㄴ';

  @override
  String get hangulS6L2Step0Desc => 'Cambia la vocal en ㄴ para leer 나~니.';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => 'Escuchar 나~니';

  @override
  String get hangulS6L2Step1Desc => 'Escucha los sonidos del patrón ㄴ';

  @override
  String get hangulS6L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS6L2Step2Desc => 'Di cada sílaba en voz alta';

  @override
  String get hangulS6L2Step3Title => 'Construir combinaciones con ㄴ';

  @override
  String get hangulS6L2Step3Desc => 'Forma sílabas con ㄴ + vocal';

  @override
  String get hangulS6L2Step4Title => '¡Lección completada!';

  @override
  String get hangulS6L2Step4Msg => '¡Genial!\nHas dominado los patrones 나~니.';

  @override
  String get hangulS6L3Title => 'Expansión de 다~디 y 라~리';

  @override
  String get hangulS6L3Subtitle => 'Lectura de patrones ㄷ/ㄹ';

  @override
  String get hangulS6L3Step0Title => 'Leer cambiando solo la consonante';

  @override
  String get hangulS6L3Step0Desc =>
      'Cambiar solo la consonante con la misma vocal\naumentará tu velocidad de lectura.';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => 'Escuchar: distinguir ㄷ/ㄹ';

  @override
  String get hangulS6L3Step1Desc => 'Escucha y elige la sílaba correcta';

  @override
  String get hangulS6L3Step2Title => 'Quiz de lectura';

  @override
  String get hangulS6L3Step2Desc => 'Comprueba los patrones';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => '¡Lección completada!';

  @override
  String get hangulS6L3Step3Msg => '¡Genial!\nHas aprendido los patrones ㄷ/ㄹ.';

  @override
  String get hangulS6L4Title => 'Lectura de sílabas al azar 1';

  @override
  String get hangulS6L4Subtitle => 'Mezclar patrones básicos';

  @override
  String get hangulS6L4Step0Title => 'Leer sin orden';

  @override
  String get hangulS6L4Step0Desc => 'Ahora vamos a leer como tarjetas al azar.';

  @override
  String get hangulS6L4Step1Title => 'Lectura aleatoria';

  @override
  String get hangulS6L4Step1Desc =>
      'Identifica las sílabas presentadas al azar';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => '¡Lección completada!';

  @override
  String get hangulS6L4Step2Msg =>
      '¡Genial!\nHas completado la lectura aleatoria 1.';

  @override
  String get hangulS6L5Title => 'Encontrar la sílaba por sonido';

  @override
  String get hangulS6L5Subtitle => 'Reforzar la conexión sonido-letra';

  @override
  String get hangulS6L5Step0Title => 'Práctica de escuchar y encontrar';

  @override
  String get hangulS6L5Step0Desc =>
      'Escucha el sonido y elige la sílaba correspondiente\npara reforzar tu conexión de lectura.';

  @override
  String get hangulS6L5Step1Title => 'Emparejamiento de sonidos';

  @override
  String get hangulS6L5Step1Desc => 'Elige la sílaba correcta';

  @override
  String get hangulS6L5Step2Title => '¡Lección completada!';

  @override
  String get hangulS6L5Step2Msg =>
      '¡Genial!\nHas completado la práctica de escuchar y encontrar.';

  @override
  String get hangulS6L6Title => 'Combinación de vocal compuesta 1';

  @override
  String get hangulS6L6Subtitle => 'Lectura de ㅘ, ㅝ';

  @override
  String get hangulS6L6Step0Title => 'Comenzar con vocales compuestas';

  @override
  String get hangulS6L6Step0Desc => 'Vamos a leer sílabas formadas con ㅘ y ㅝ.';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => 'Escuchar 와/워';

  @override
  String get hangulS6L6Step1Desc =>
      'Escucha los sonidos de las sílabas representativas';

  @override
  String get hangulS6L6Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS6L6Step2Desc => 'Di cada sílaba en voz alta';

  @override
  String get hangulS6L6Step3Title => 'Quiz de vocales compuestas';

  @override
  String get hangulS6L6Step3Desc => 'Distingue ㅘ y ㅝ';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => '¡Lección completada!';

  @override
  String get hangulS6L6Step4Msg =>
      '¡Genial!\nHas aprendido las combinaciones ㅘ/ㅝ.';

  @override
  String get hangulS6L7Title => 'Combinación de vocal compuesta 2';

  @override
  String get hangulS6L7Subtitle => 'Lectura de ㅙ, ㅞ, ㅚ, ㅟ, ㅢ';

  @override
  String get hangulS6L7Step0Title => 'Ampliación de vocales compuestas';

  @override
  String get hangulS6L7Step0Desc =>
      'Aprende brevemente las vocales compuestas y concéntrate en la lectura.';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'La pronunciación especial de ㅢ';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ es una vocal especial cuyo sonido cambia según su posición.\n\n• Posición inicial: [의] → 의사, 의자\n• Después de consonante: [이] → 희망→[히망]\n• Partícula \"의\": [에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => 'Elegir la vocal compuesta';

  @override
  String get hangulS6L7Step2Desc => 'Elige la sílaba correcta';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => '¡Lección completada!';

  @override
  String get hangulS6L7Step3Msg =>
      '¡Genial!\nHas completado la ampliación de vocales compuestas.';

  @override
  String get hangulS6L8Title => 'Lectura de sílabas al azar 2';

  @override
  String get hangulS6L8Subtitle => 'Repaso de vocales básicas y compuestas';

  @override
  String get hangulS6L8Step0Title => 'Lectura aleatoria integral';

  @override
  String get hangulS6L8Step0Desc =>
      'Lee sílabas de vocales básicas y compuestas mezcladas.';

  @override
  String get hangulS6L8Step1Title => 'Quiz integral';

  @override
  String get hangulS6L8Step1Desc => 'Identifica las combinaciones aleatorias';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => '¡Lección completada!';

  @override
  String get hangulS6L8Step2Msg =>
      '¡Genial!\nHas completado la lectura integral de la Etapa 6.';

  @override
  String get hangulS6LMTitle => 'Misión de la Etapa 6';

  @override
  String get hangulS6LMSubtitle =>
      'Verificación final: lectura de combinaciones';

  @override
  String get hangulS6LMStep0Title => '¡Comienza la misión!';

  @override
  String get hangulS6LMStep0Desc =>
      'Esta es la verificación final del entrenamiento de combinaciones.\n¡Alcanza tu objetivo dentro del tiempo límite!';

  @override
  String get hangulS6LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS6LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS6LMStep3Title => '¡Etapa 6 completada!';

  @override
  String get hangulS6LMStep3Msg =>
      '¡Felicidades!\nHas completado el entrenamiento de combinaciones de la Etapa 6.';

  @override
  String get hangulS6CompleteTitle => '¡Etapa 6 completada!';

  @override
  String get hangulS6CompleteMsg =>
      '¡Ahora puedes combinar sílabas libremente!';

  @override
  String get hangulS7L1Title => 'Distinción ㄱ / ㅋ / ㄲ';

  @override
  String get hangulS7L1Subtitle => 'Comparación de 가 · 카 · 까';

  @override
  String get hangulS7L1Step0Title => 'Escucha los tres sonidos';

  @override
  String get hangulS7L1Step0Desc =>
      'Distingue los sonidos ㄱ (simple), ㅋ (aspirado), ㄲ (tenso).';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => 'Exploración de sonidos';

  @override
  String get hangulS7L1Step1Desc => 'Escucha 가/카/까 varias veces';

  @override
  String get hangulS7L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS7L1Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS7L1Step3Title => 'Escucha y elige';

  @override
  String get hangulS7L1Step3Desc =>
      'Selecciona la respuesta correcta entre tres opciones';

  @override
  String get hangulS7L1Step4Title => 'Verificación rápida';

  @override
  String get hangulS7L1Step4Desc => 'Verifica la forma y el sonido juntos';

  @override
  String get hangulS7L1Step4Q0 => '¿Cuál es la consonante aspirada?';

  @override
  String get hangulS7L1Step4Q1 => '¿Cuál es la consonante tensa?';

  @override
  String get hangulS7L1Step5Title => '¡Lección completada!';

  @override
  String get hangulS7L1Step5Msg => '¡Muy bien!\nAprendiste a distinguir ㄱ/ㅋ/ㄲ.';

  @override
  String get hangulS7L2Title => 'Distinción ㄷ / ㅌ / ㄸ';

  @override
  String get hangulS7L2Subtitle => 'Comparación de 다 · 타 · 따';

  @override
  String get hangulS7L2Step0Title => 'Segundo grupo de contraste';

  @override
  String get hangulS7L2Step0Desc => 'Compara los sonidos ㄷ/ㅌ/ㄸ.';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => 'Exploración de sonidos';

  @override
  String get hangulS7L2Step1Desc => 'Escucha 다/타/따 varias veces';

  @override
  String get hangulS7L2Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS7L2Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS7L2Step3Title => 'Escucha y elige';

  @override
  String get hangulS7L2Step3Desc =>
      'Selecciona la respuesta correcta entre tres opciones';

  @override
  String get hangulS7L2Step4Title => '¡Lección completada!';

  @override
  String get hangulS7L2Step4Msg => '¡Muy bien!\nAprendiste a distinguir ㄷ/ㅌ/ㄸ.';

  @override
  String get hangulS7L3Title => 'Distinción ㅂ / ㅍ / ㅃ';

  @override
  String get hangulS7L3Subtitle => 'Comparación de 바 · 파 · 빠';

  @override
  String get hangulS7L3Step0Title => 'Tercer grupo de contraste';

  @override
  String get hangulS7L3Step0Desc => 'Compara los sonidos ㅂ/ㅍ/ㅃ.';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => 'Exploración de sonidos';

  @override
  String get hangulS7L3Step1Desc => 'Escucha 바/파/빠 varias veces';

  @override
  String get hangulS7L3Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS7L3Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS7L3Step3Title => 'Escucha y elige';

  @override
  String get hangulS7L3Step3Desc =>
      'Selecciona la respuesta correcta entre tres opciones';

  @override
  String get hangulS7L3Step4Title => '¡Lección completada!';

  @override
  String get hangulS7L3Step4Msg => '¡Muy bien!\nAprendiste a distinguir ㅂ/ㅍ/ㅃ.';

  @override
  String get hangulS7L4Title => 'Distinción ㅅ / ㅆ';

  @override
  String get hangulS7L4Subtitle => 'Comparación de 사 · 싸';

  @override
  String get hangulS7L4Step0Title => 'Contraste de dos sonidos';

  @override
  String get hangulS7L4Step0Desc => 'Distingue los sonidos ㅅ/ㅆ.';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => 'Exploración de sonidos';

  @override
  String get hangulS7L4Step1Desc => 'Escucha 사/싸 varias veces';

  @override
  String get hangulS7L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS7L4Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS7L4Step3Title => 'Escucha y elige';

  @override
  String get hangulS7L4Step3Desc =>
      'Selecciona la respuesta correcta entre dos opciones';

  @override
  String get hangulS7L4Step4Title => '¡Lección completada!';

  @override
  String get hangulS7L4Step4Msg => '¡Muy bien!\nAprendiste a distinguir ㅅ/ㅆ.';

  @override
  String get hangulS7L5Title => 'Distinción ㅈ / ㅊ / ㅉ';

  @override
  String get hangulS7L5Subtitle => 'Comparación de 자 · 차 · 짜';

  @override
  String get hangulS7L5Step0Title => 'Último grupo de contraste';

  @override
  String get hangulS7L5Step0Desc => 'Compara los sonidos ㅈ/ㅊ/ㅉ.';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => 'Exploración de sonidos';

  @override
  String get hangulS7L5Step1Desc => 'Escucha 자/차/짜 varias veces';

  @override
  String get hangulS7L5Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS7L5Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS7L5Step3Title => 'Escucha y elige';

  @override
  String get hangulS7L5Step3Desc =>
      'Selecciona la respuesta correcta entre tres opciones';

  @override
  String get hangulS7L5Step4Title => '¡Etapa 7 completada!';

  @override
  String get hangulS7L5Step4Msg =>
      '¡Felicidades!\nCompletaste los 5 grupos de contraste de la Etapa 7.';

  @override
  String get hangulS7LMTitle => 'Misión: ¡Desafío de distinción de sonidos!';

  @override
  String get hangulS7LMSubtitle =>
      'Distingue consonantes simples, aspiradas y tensas';

  @override
  String get hangulS7LMStep0Title => '¡Misión de distinción de sonidos!';

  @override
  String get hangulS7LMStep0Desc =>
      'Mezcla consonantes simples, aspiradas y tensas\n¡para combinar sílabas rápidamente!';

  @override
  String get hangulS7LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS7LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS7LMStep3Title => '¡Misión completada!';

  @override
  String get hangulS7LMStep3Msg =>
      '¡Puedes distinguir consonantes simples, aspiradas y tensas!';

  @override
  String get hangulS7LMStep4Title => '¡Etapa 7 completada!';

  @override
  String get hangulS7LMStep4Msg =>
      '¡Puedes distinguir consonantes tensas y aspiradas!';

  @override
  String get hangulS7CompleteTitle => '¡Etapa 7 completada!';

  @override
  String get hangulS7CompleteMsg =>
      '¡Puedes distinguir consonantes tensas y aspiradas!';

  @override
  String get hangulS8L0Title => 'Concepto de batchim';

  @override
  String get hangulS8L0Subtitle => 'El sonido debajo del bloque silábico';

  @override
  String get hangulS8L0Step0Title => 'El batchim va abajo';

  @override
  String get hangulS8L0Step0Desc =>
      'El batchim (consonante final) va en la parte inferior del bloque silábico.\nEjemplo: 가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => 'batchim,간,말,집';

  @override
  String get hangulS8L0Step1Title => '7 sonidos representativos del batchim';

  @override
  String get hangulS8L0Step1Desc =>
      'Solo existen 7 sonidos representativos para el batchim.\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\nMuchas letras batchim se pronuncian como uno de estos 7 sonidos.\nEjemplo: ㅅ, ㅈ, ㅊ, ㅎ como batchim → todos suenan [ㄷ]';

  @override
  String get hangulS8L0Step1Highlights =>
      '7 sonidos,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,representativo';

  @override
  String get hangulS8L0Step2Title => 'Encuentra el batchim';

  @override
  String get hangulS8L0Step2Desc => 'Identifica la posición del batchim';

  @override
  String get hangulS8L0Step2Q0 => '¿Cuál es el batchim en 간?';

  @override
  String get hangulS8L0Step2Q1 => '¿Cuál es el batchim en 말?';

  @override
  String get hangulS8L0SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L0SummaryMsg =>
      '¡Muy bien!\nEntiendes el concepto de batchim.';

  @override
  String get hangulS8L1Title => 'Batchim ㄴ';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => 'Escucha el batchim ㄴ';

  @override
  String get hangulS8L1Step0Desc => 'Escucha 간/난/단';

  @override
  String get hangulS8L1Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L1Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L1Step2Title => 'Escucha y elige';

  @override
  String get hangulS8L1Step2Desc => 'Selecciona la sílaba con batchim ㄴ';

  @override
  String get hangulS8L1SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L1SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㄴ.';

  @override
  String get hangulS8L2Title => 'Batchim ㄹ';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => 'Escucha el batchim ㄹ';

  @override
  String get hangulS8L2Step0Desc => 'Escucha 말/갈/물';

  @override
  String get hangulS8L2Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L2Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L2Step2Title => 'Escucha y elige';

  @override
  String get hangulS8L2Step2Desc => 'Selecciona la sílaba con batchim ㄹ';

  @override
  String get hangulS8L2SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L2SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㄹ.';

  @override
  String get hangulS8L3Title => 'Batchim ㅁ';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => 'Escucha el batchim ㅁ';

  @override
  String get hangulS8L3Step0Desc => 'Escucha 감/밤/숨';

  @override
  String get hangulS8L3Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L3Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L3Step2Title => 'Identifica el batchim';

  @override
  String get hangulS8L3Step2Desc => 'Elige la sílaba con batchim ㅁ';

  @override
  String get hangulS8L3Step2Q0 => '¿Cuál tiene batchim ㅁ?';

  @override
  String get hangulS8L3Step2Q1 => '¿Cuál tiene batchim ㅁ?';

  @override
  String get hangulS8L3SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L3SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㅁ.';

  @override
  String get hangulS8L4Title => 'Batchim ㅇ';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => '¡ㅇ es especial!';

  @override
  String get hangulS8L4Step0Desc =>
      'Como consonante inicial, ㅇ es silencioso (아, 오),\npero como batchim suena \"ng\" (방, 공).';

  @override
  String get hangulS8L4Step0Highlights => 'consonante inicial,batchim,ng,방,공';

  @override
  String get hangulS8L4Step1Title => 'Escucha el batchim ㅇ';

  @override
  String get hangulS8L4Step1Desc => 'Escucha 방/공/종';

  @override
  String get hangulS8L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L4Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L4Step3Title => 'Escucha y elige';

  @override
  String get hangulS8L4Step3Desc => 'Selecciona la sílaba con batchim ㅇ';

  @override
  String get hangulS8L4SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L4SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㅇ.';

  @override
  String get hangulS8L5Title => 'Batchim ㄱ';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => 'Escucha el batchim ㄱ';

  @override
  String get hangulS8L5Step0Desc => 'Escucha 박/각/국';

  @override
  String get hangulS8L5Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L5Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L5Step2Title => 'Identifica el batchim';

  @override
  String get hangulS8L5Step2Desc => 'Elige la sílaba con batchim ㄱ';

  @override
  String get hangulS8L5Step2Q0 => '¿Cuál tiene batchim ㄱ?';

  @override
  String get hangulS8L5Step2Q1 => '¿Cuál tiene batchim ㄱ?';

  @override
  String get hangulS8L5SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L5SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㄱ.';

  @override
  String get hangulS8L6Title => 'Batchim ㅂ';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => 'Escucha el batchim ㅂ';

  @override
  String get hangulS8L6Step0Desc => 'Escucha 밥/집/숲';

  @override
  String get hangulS8L6Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L6Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L6Step2Title => 'Escucha y elige';

  @override
  String get hangulS8L6Step2Desc => 'Selecciona la sílaba con batchim ㅂ';

  @override
  String get hangulS8L6SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L6SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㅂ.';

  @override
  String get hangulS8L7Title => 'Batchim ㅅ';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => 'Escucha el batchim ㅅ';

  @override
  String get hangulS8L7Step0Desc => 'Escucha 옷/맛/빛';

  @override
  String get hangulS8L7Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS8L7Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS8L7Step2Title => 'Identifica el batchim';

  @override
  String get hangulS8L7Step2Desc => 'Elige la sílaba con batchim ㅅ';

  @override
  String get hangulS8L7Step2Q0 => '¿Cuál tiene batchim ㅅ?';

  @override
  String get hangulS8L7Step2Q1 => '¿Cuál tiene batchim ㅅ?';

  @override
  String get hangulS8L7SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L7SummaryMsg => '¡Muy bien!\nAprendiste el batchim ㅅ.';

  @override
  String get hangulS8L8Title => 'Repaso mixto de batchim';

  @override
  String get hangulS8L8Subtitle => 'Revisión aleatoria de batchim clave';

  @override
  String get hangulS8L8Step0Title => 'Mezcla todos juntos';

  @override
  String get hangulS8L8Step0Desc => 'Repasemos ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ juntos.';

  @override
  String get hangulS8L8Step1Title => 'Quiz aleatorio';

  @override
  String get hangulS8L8Step1Desc =>
      'Pon a prueba tu conocimiento de batchim mixto';

  @override
  String get hangulS8L8Step1Q0 => '¿Cuál tiene batchim ㄴ?';

  @override
  String get hangulS8L8Step1Q1 => '¿Cuál tiene batchim ㅇ?';

  @override
  String get hangulS8L8Step1Q2 => '¿Cuál tiene batchim ㄹ?';

  @override
  String get hangulS8L8Step1Q3 => '¿Cuál tiene batchim ㅂ?';

  @override
  String get hangulS8L8SummaryTitle => '¡Lección completada!';

  @override
  String get hangulS8L8SummaryMsg =>
      '¡Muy bien!\nCompletaste el repaso mixto de batchim.';

  @override
  String get hangulS8LMTitle => '¡Misión: Desafío batchim!';

  @override
  String get hangulS8LMSubtitle => 'Combina sílabas con batchim';

  @override
  String get hangulS8LMStep0Title => '¡Misión batchim!';

  @override
  String get hangulS8LMStep0Desc =>
      'Lee sílabas con batchim básico\n¡y responde rápido!';

  @override
  String get hangulS8LMStep1Title => '¡Forma las sílabas!';

  @override
  String get hangulS8LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS8LMSummaryTitle => '¡Misión completada!';

  @override
  String get hangulS8LMSummaryMsg =>
      '¡Has dominado por completo las bases del batchim!';

  @override
  String get hangulS8CompleteTitle => '¡Etapa 8 completada!';

  @override
  String get hangulS8CompleteMsg =>
      '¡Has construido una base sólida en batchim!';

  @override
  String get hangulS9L1Title => 'Batchim ㄷ Extendido';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'Patrón del batchim ㄷ';

  @override
  String get hangulS9L1Step0Desc =>
      'Lee las sílabas que llevan ㄷ como batchim.';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => 'Escuchar: batchim ㄷ';

  @override
  String get hangulS9L1Step1Desc => 'Escucha 닫/곧/묻';

  @override
  String get hangulS9L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS9L1Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS9L1Step3Title => 'Identifica el batchim';

  @override
  String get hangulS9L1Step3Desc => 'Elige la sílaba con batchim ㄷ';

  @override
  String get hangulS9L1Step3Q0 => '¿Cuál tiene batchim ㄷ?';

  @override
  String get hangulS9L1Step3Q1 => '¿Cuál tiene batchim ㄷ?';

  @override
  String get hangulS9L1Step4Title => '¡Lección completada!';

  @override
  String get hangulS9L1Step4Msg => '¡Muy bien!\nHas aprendido el batchim ㄷ.';

  @override
  String get hangulS9L2Title => 'Batchim ㅈ Extendido';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => 'Escuchar: batchim ㅈ';

  @override
  String get hangulS9L2Step0Desc => 'Escucha 낮/잊/젖';

  @override
  String get hangulS9L2Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS9L2Step1Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS9L2Step2Title => 'Escucha y elige';

  @override
  String get hangulS9L2Step2Desc => 'Selecciona la sílaba con batchim ㅈ';

  @override
  String get hangulS9L2Step3Title => '¡Lección completada!';

  @override
  String get hangulS9L2Step3Msg => '¡Muy bien!\nHas aprendido el batchim ㅈ.';

  @override
  String get hangulS9L3Title => 'Batchim ㅊ Extendido';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => 'Escuchar: batchim ㅊ';

  @override
  String get hangulS9L3Step0Desc => 'Escucha 꽃/닻/빚';

  @override
  String get hangulS9L3Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS9L3Step1Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS9L3Step2Title => 'Identifica el batchim';

  @override
  String get hangulS9L3Step2Desc => 'Elige la sílaba con batchim ㅊ';

  @override
  String get hangulS9L3Step2Q0 => '¿Cuál tiene batchim ㅊ?';

  @override
  String get hangulS9L3Step2Q1 => '¿Cuál tiene batchim ㅊ?';

  @override
  String get hangulS9L3Step3Title => '¡Lección completada!';

  @override
  String get hangulS9L3Step3Msg => '¡Muy bien!\nHas aprendido el batchim ㅊ.';

  @override
  String get hangulS9L4Title => 'Batchim ㅋ / ㅌ / ㅍ';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => 'Tres batchim juntos';

  @override
  String get hangulS9L4Step0Desc => 'Aprende ㅋ, ㅌ y ㅍ como batchim de una vez.';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => 'Escuchar los sonidos';

  @override
  String get hangulS9L4Step1Desc => 'Escucha 부엌/밭/앞';

  @override
  String get hangulS9L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS9L4Step2Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS9L4Step3Title => 'Identifica el batchim';

  @override
  String get hangulS9L4Step3Desc => 'Distingue los tres batchim';

  @override
  String get hangulS9L4Step3Q0 => '¿Cuál tiene batchim ㅌ?';

  @override
  String get hangulS9L4Step3Q1 => '¿Cuál tiene batchim ㅍ?';

  @override
  String get hangulS9L4Step4Title => '¡Lección completada!';

  @override
  String get hangulS9L4Step4Msg =>
      '¡Muy bien!\nHas aprendido los batchim ㅋ/ㅌ/ㅍ.';

  @override
  String get hangulS9L5Title => 'Batchim ㅎ Extendido';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => 'Escuchar: batchim ㅎ';

  @override
  String get hangulS9L5Step0Desc => 'Escucha 좋/놓/않';

  @override
  String get hangulS9L5Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS9L5Step1Desc => 'Pronuncia cada carácter en voz alta';

  @override
  String get hangulS9L5Step2Title => 'Escucha y elige';

  @override
  String get hangulS9L5Step2Desc => 'Selecciona la sílaba con batchim ㅎ';

  @override
  String get hangulS9L5Step3Title => '¡Lección completada!';

  @override
  String get hangulS9L5Step3Msg => '¡Muy bien!\nHas aprendido el batchim ㅎ.';

  @override
  String get hangulS9L6Title => 'Batchim Extendido Mixto';

  @override
  String get hangulS9L6Subtitle => 'Mezclando ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS9L6Step0Title => 'Todo mezclado';

  @override
  String get hangulS9L6Step0Desc =>
      'Repasa todos los batchim extendidos al azar.';

  @override
  String get hangulS9L6Step1Title => 'Quiz aleatorio';

  @override
  String get hangulS9L6Step1Desc => 'Resuelve y distingue cada batchim';

  @override
  String get hangulS9L6Step1Q0 => '¿Cuál tiene batchim ㄷ?';

  @override
  String get hangulS9L6Step1Q1 => '¿Cuál tiene batchim ㅈ?';

  @override
  String get hangulS9L6Step1Q2 => '¿Cuál tiene batchim ㅊ?';

  @override
  String get hangulS9L6Step1Q3 => '¿Cuál tiene batchim ㅎ?';

  @override
  String get hangulS9L6Step2Title => '¡Lección completada!';

  @override
  String get hangulS9L6Step2Msg =>
      '¡Muy bien!\nRepaso aleatorio de batchim extendido completado.';

  @override
  String get hangulS9L7Title => 'Repaso de la Etapa 9';

  @override
  String get hangulS9L7Subtitle => 'Cierre de la lectura con batchim extendido';

  @override
  String get hangulS9L7Step0Title => 'Verificación final';

  @override
  String get hangulS9L7Step0Desc =>
      'Revisión final de los puntos clave de la Etapa 9';

  @override
  String get hangulS9L7Step1Title => '¡Etapa 9 completada!';

  @override
  String get hangulS9L7Step1Msg =>
      '¡Felicidades!\nHas completado el batchim extendido de la Etapa 9.';

  @override
  String get hangulS9LMTitle => 'Misión: ¡Desafío batchim extendido!';

  @override
  String get hangulS9LMSubtitle => 'Lee distintos batchim rápidamente';

  @override
  String get hangulS9LMStep0Title => '¡Misión batchim extendido!';

  @override
  String get hangulS9LMStep0Desc =>
      'Combina sílabas con batchim extendido\n¡lo más rápido posible!';

  @override
  String get hangulS9LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS9LMStep2Title => 'Resultado de la misión';

  @override
  String get hangulS9LMStep3Title => '¡Misión completada!';

  @override
  String get hangulS9LMStep3Msg => '¡Has dominado el batchim extendido!';

  @override
  String get hangulS9CompleteTitle => '¡Etapa 9 completada!';

  @override
  String get hangulS9CompleteMsg => '¡Has dominado el batchim extendido!';

  @override
  String get hangulS10L1Title => 'Batchim ㄳ';

  @override
  String get hangulS10L1Subtitle => 'Lectura centrada en 몫 · 넋';

  @override
  String get hangulS10L1Step0Title =>
      'Reglas de pronunciación del batchim doble';

  @override
  String get hangulS10L1Step0Desc =>
      'El batchim doble es una consonante final formada por dos consonantes combinadas.\n\nLa mayoría se pronuncian con la consonante izquierda:\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\nAlgunos se pronuncian con la consonante derecha:\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights =>
      'consonante izquierda,consonante derecha,batchim doble';

  @override
  String get hangulS10L1Step1Title => 'Comenzando con el batchim compuesto';

  @override
  String get hangulS10L1Step1Desc =>
      'Leamos palabras que contienen el batchim ㄳ.';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => 'Escuchar los sonidos';

  @override
  String get hangulS10L1Step2Desc => 'Escucha 몫/넋';

  @override
  String get hangulS10L1Step3Title => 'Práctica de pronunciación';

  @override
  String get hangulS10L1Step3Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS10L1Step4Title => 'Verificación de lectura';

  @override
  String get hangulS10L1Step4Desc => 'Mira la palabra y elige la correcta';

  @override
  String get hangulS10L1Step4Q0 => '¿Qué palabra tiene el batchim ㄳ?';

  @override
  String get hangulS10L1Step4Q1 => '¿Qué palabra tiene el batchim ㄳ?';

  @override
  String get hangulS10L1Step5Title => '¡Lección completada!';

  @override
  String get hangulS10L1Step5Msg => '¡Muy bien!\nHas aprendido el batchim ㄳ.';

  @override
  String get hangulS10L2Title => 'Batchim ㄵ / ㄶ';

  @override
  String get hangulS10L2Subtitle => '앉다 · 많다';

  @override
  String get hangulS10L2Step0Title => 'Escuchar los sonidos';

  @override
  String get hangulS10L2Step0Desc => 'Escucha 앉다/많다';

  @override
  String get hangulS10L2Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS10L2Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS10L2Step2Title => 'Escuchar y elegir';

  @override
  String get hangulS10L2Step2Desc => 'Selecciona la palabra correcta';

  @override
  String get hangulS10L2Step3Title => '¡Lección completada!';

  @override
  String get hangulS10L2Step3Msg =>
      '¡Muy bien!\nHas aprendido los batchim ㄵ/ㄶ.';

  @override
  String get hangulS10L3Title => 'Batchim ㄺ / ㄻ';

  @override
  String get hangulS10L3Subtitle => '읽다 · 삶';

  @override
  String get hangulS10L3Step0Title => 'Escuchar los sonidos';

  @override
  String get hangulS10L3Step0Desc => 'Escucha 읽다/삶';

  @override
  String get hangulS10L3Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS10L3Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS10L3Step2Title => 'Verificación de lectura';

  @override
  String get hangulS10L3Step2Desc => 'Elige la palabra con batchim compuesto';

  @override
  String get hangulS10L3Step2Q0 => '¿Qué palabra tiene el batchim ㄺ?';

  @override
  String get hangulS10L3Step2Q1 => '¿Qué palabra tiene el batchim ㄻ?';

  @override
  String get hangulS10L3Step3Title => '¡Lección completada!';

  @override
  String get hangulS10L3Step3Msg =>
      '¡Muy bien!\nHas aprendido los batchim ㄺ/ㄻ.';

  @override
  String get hangulS10L4Title => 'Conjunto avanzado 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ · ㄾ · ㄿ · ㅀ';

  @override
  String get hangulS10L4Step0Title => 'Presentación del conjunto avanzado';

  @override
  String get hangulS10L4Step0Desc =>
      'Aprendamos brevemente a través de ejemplos comunes.';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => 'Escuchar las palabras';

  @override
  String get hangulS10L4Step1Desc => 'Escucha 넓다/핥다/읊다/싫다';

  @override
  String get hangulS10L4Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS10L4Step2Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS10L4Step3Title => '¡Lección completada!';

  @override
  String get hangulS10L4Step3Msg =>
      '¡Muy bien!\nHas aprendido el conjunto avanzado 1.';

  @override
  String get hangulS10L5Title => 'Batchim ㅄ';

  @override
  String get hangulS10L5Subtitle => 'Lectura centrada en 없다';

  @override
  String get hangulS10L5Step0Title => 'Escuchar los sonidos';

  @override
  String get hangulS10L5Step0Desc => 'Escucha 없다/없어';

  @override
  String get hangulS10L5Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS10L5Step1Desc => 'Di cada carácter en voz alta';

  @override
  String get hangulS10L5Step2Title => 'Escuchar y elegir';

  @override
  String get hangulS10L5Step2Desc => 'Elige la palabra correcta';

  @override
  String get hangulS10L5Step3Title => '¡Lección completada!';

  @override
  String get hangulS10L5Step3Msg => '¡Muy bien!\nHas aprendido el batchim ㅄ.';

  @override
  String get hangulS10L6Title => 'Resumen de la Etapa 10';

  @override
  String get hangulS10L6Subtitle =>
      'Integración de palabras con batchim compuesto';

  @override
  String get hangulS10L6Step0Title => 'Revisión integral';

  @override
  String get hangulS10L6Step0Desc =>
      'Hagamos una revisión final de palabras con batchim compuesto';

  @override
  String get hangulS10L6Step0Q0 =>
      '¿Cuál de las siguientes tiene el batchim ㄶ?';

  @override
  String get hangulS10L6Step0Q1 =>
      '¿Cuál de las siguientes tiene el batchim ㄺ?';

  @override
  String get hangulS10L6Step0Q2 =>
      '¿Cuál de las siguientes tiene el batchim ㅄ?';

  @override
  String get hangulS10L6Step0Q3 =>
      '¿Cuál de las siguientes tiene el batchim ㄳ?';

  @override
  String get hangulS10L6Step1Title => '¡Etapa 10 completada!';

  @override
  String get hangulS10L6Step1Msg =>
      '¡Felicidades!\nHas completado el batchim compuesto de la Etapa 10.';

  @override
  String get hangulS10LMTitle => 'Misión: ¡Desafío de batchim doble!';

  @override
  String get hangulS10LMSubtitle =>
      'Lee rápidamente palabras con batchim doble';

  @override
  String get hangulS10LMStep0Title => '¡Misión de batchim doble!';

  @override
  String get hangulS10LMStep0Desc =>
      '¡Combina rápidamente sílabas\nque incluyan batchim doble!';

  @override
  String get hangulS10LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS10LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS10LMStep3Title => '¡Misión completada!';

  @override
  String get hangulS10LMStep3Msg => '¡También has dominado el batchim doble!';

  @override
  String get hangulS10LMStep4Title => '¡Etapa 10 completada!';

  @override
  String get hangulS10CompleteTitle => '¡Etapa 10 completada!';

  @override
  String get hangulS10CompleteMsg => '¡También has dominado el batchim doble!';

  @override
  String get hangulS11L1Title => 'Palabras sin Batchim';

  @override
  String get hangulS11L1Subtitle => 'Palabras fáciles de 2 a 3 sílabas';

  @override
  String get hangulS11L1Step0Title => 'Empezar a leer palabras';

  @override
  String get hangulS11L1Step0Desc =>
      'Ganemos confianza con palabras sin consonante final.';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => 'Escuchar palabras';

  @override
  String get hangulS11L1Step1Desc => 'Escucha 바나나 / 나비 / 하마 / 모자';

  @override
  String get hangulS11L1Step2Title => 'Práctica de pronunciación';

  @override
  String get hangulS11L1Step2Desc => 'Di cada palabra en voz alta';

  @override
  String get hangulS11L1Step3Title => '¡Lección completada!';

  @override
  String get hangulS11L1Step3Msg =>
      '¡Muy bien!\nEmpezaste a leer palabras sin batchim.';

  @override
  String get hangulS11L2Title => 'Palabras con Batchim básico';

  @override
  String get hangulS11L2Subtitle => 'Escuela · Amigo · Corea · Estudio';

  @override
  String get hangulS11L2Step0Title => 'Escuchar palabras';

  @override
  String get hangulS11L2Step0Desc => 'Escucha 학교 / 친구 / 한국 / 공부';

  @override
  String get hangulS11L2Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS11L2Step1Desc => 'Di cada palabra en voz alta';

  @override
  String get hangulS11L2Step2Title => 'Escuchar y elegir';

  @override
  String get hangulS11L2Step2Desc => 'Selecciona la palabra que escuchaste';

  @override
  String get hangulS11L2Step3Title => '¡Lección completada!';

  @override
  String get hangulS11L2Step3Msg =>
      '¡Muy bien!\nLeíste palabras con batchim básico.';

  @override
  String get hangulS11L3Title => 'Palabras con Batchim mixto';

  @override
  String get hangulS11L3Subtitle => '읽기 · 없다 · 많다 · 닭';

  @override
  String get hangulS11L3Step0Title => 'Subir el nivel';

  @override
  String get hangulS11L3Step0Desc =>
      'Leamos palabras que combinan batchim básico y doble.';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => 'Distinguir palabras';

  @override
  String get hangulS11L3Step1Desc => 'Diferencia palabras de aspecto similar';

  @override
  String get hangulS11L3Step1Q0 => '¿Cuál tiene batchim doble?';

  @override
  String get hangulS11L3Step1Q1 => '¿Cuál tiene batchim doble?';

  @override
  String get hangulS11L3Step2Title => '¡Lección completada!';

  @override
  String get hangulS11L3Step2Msg =>
      '¡Muy bien!\nLeíste palabras con batchim mixto.';

  @override
  String get hangulS11L4Title => 'Paquete de palabras por categoría';

  @override
  String get hangulS11L4Subtitle => 'Comida · Lugar · Persona';

  @override
  String get hangulS11L4Step0Title => 'Escuchar palabras por categoría';

  @override
  String get hangulS11L4Step0Desc =>
      'Escucha palabras de comida / lugar / persona';

  @override
  String get hangulS11L4Step1Title => 'Práctica de pronunciación';

  @override
  String get hangulS11L4Step1Desc => 'Di cada palabra en voz alta';

  @override
  String get hangulS11L4Step2Title => 'Clasificar por categoría';

  @override
  String get hangulS11L4Step2Desc => 'Mira la palabra y elige su categoría';

  @override
  String get hangulS11L4Step2Q0 => '¿Qué es \"김치\"?';

  @override
  String get hangulS11L4Step2Q1 => '¿Qué es \"시장\"?';

  @override
  String get hangulS11L4Step2Q2 => '¿Qué es \"학생\"?';

  @override
  String get hangulS11L4Step2CatFood => 'Comida';

  @override
  String get hangulS11L4Step2CatPlace => 'Lugar';

  @override
  String get hangulS11L4Step2CatPerson => 'Persona';

  @override
  String get hangulS11L4Step3Title => '¡Lección completada!';

  @override
  String get hangulS11L4Step3Msg =>
      '¡Muy bien!\nAprendiste palabras por categoría.';

  @override
  String get hangulS11L5Title => 'Escuchar y elegir palabras';

  @override
  String get hangulS11L5Subtitle => 'Reforzar la conexión auditiva-lectora';

  @override
  String get hangulS11L5Step0Title => 'Emparejamiento de sonidos';

  @override
  String get hangulS11L5Step0Desc => 'Escucha y elige la palabra correcta';

  @override
  String get hangulS11L5Step1Title => '¡Lección completada!';

  @override
  String get hangulS11L5Step1Msg =>
      '¡Muy bien!\nCompletaste el entrenamiento de escuchar y elegir palabras.';

  @override
  String get hangulS11L6Title => 'Repaso de la Etapa 11';

  @override
  String get hangulS11L6Subtitle => 'Revisión final de lectura de palabras';

  @override
  String get hangulS11L6Step0Title => 'Quiz completo';

  @override
  String get hangulS11L6Step0Desc =>
      'Revisión final de las palabras de la Etapa 11';

  @override
  String get hangulS11L6Step0Q0 => '¿Cuál no tiene batchim?';

  @override
  String get hangulS11L6Step0Q1 => '¿Cuál tiene batchim básico?';

  @override
  String get hangulS11L6Step0Q2 => '¿Cuál tiene batchim doble?';

  @override
  String get hangulS11L6Step0Q3 => '¿Cuál es un lugar?';

  @override
  String get hangulS11L6Step1Title => '¡Etapa 11 completada!';

  @override
  String get hangulS11L6Step1Msg =>
      '¡Felicidades!\nCompletaste la lectura extendida de palabras de la Etapa 11.';

  @override
  String get hangulS11L7Title => 'Leer coreano en la vida real';

  @override
  String get hangulS11L7Subtitle =>
      'Lee menús de cafés, estaciones de metro y saludos';

  @override
  String get hangulS11L7Step0Title => '¡Leyendo Hangul en Corea!';

  @override
  String get hangulS11L7Step0Desc =>
      '¡Ya aprendiste todo el Hangul!\n¿Leemos palabras que verías en Corea?';

  @override
  String get hangulS11L7Step0Highlights => 'Café,Metro,Saludos';

  @override
  String get hangulS11L7Step1Title => 'Leer menús de café';

  @override
  String get hangulS11L7Step1Descs =>
      'Americano,Café con leche,Té verde,Pastel';

  @override
  String get hangulS11L7Step2Title => 'Leer nombres de estaciones de metro';

  @override
  String get hangulS11L7Step2Descs =>
      'Estación Seúl,Gangnam,Hongdae,Myeongdong';

  @override
  String get hangulS11L7Step3Title => 'Leer saludos básicos';

  @override
  String get hangulS11L7Step3Descs => 'Hola,Gracias,Sí,No';

  @override
  String get hangulS11L7Step4Title => 'Práctica de pronunciación';

  @override
  String get hangulS11L7Step4Desc => 'Di cada palabra en voz alta';

  @override
  String get hangulS11L7Step5Title => '¿Dónde puedes verlo?';

  @override
  String get hangulS11L7Step5Q0 => '¿Dónde puedes ver \"아메리카노\"?';

  @override
  String get hangulS11L7Step5Q0Ans => 'Café';

  @override
  String get hangulS11L7Step5Q0C0 => 'Café';

  @override
  String get hangulS11L7Step5Q0C1 => 'Metro';

  @override
  String get hangulS11L7Step5Q0C2 => 'Escuela';

  @override
  String get hangulS11L7Step5Q1 => '¿Qué es \"강남\"?';

  @override
  String get hangulS11L7Step5Q1Ans => 'Nombre de estación de metro';

  @override
  String get hangulS11L7Step5Q1C0 => 'Nombre de comida';

  @override
  String get hangulS11L7Step5Q1C1 => 'Nombre de estación de metro';

  @override
  String get hangulS11L7Step5Q1C2 => 'Saludo';

  @override
  String get hangulS11L7Step5Q2 => '¿Qué significa \"감사합니다\" en español?';

  @override
  String get hangulS11L7Step5Q2Ans => 'Gracias';

  @override
  String get hangulS11L7Step5Q2C0 => 'Hola';

  @override
  String get hangulS11L7Step5Q2C1 => 'Gracias';

  @override
  String get hangulS11L7Step5Q2C2 => 'Adiós';

  @override
  String get hangulS11L7Step6Title => '¡Felicidades!';

  @override
  String get hangulS11L7Step6Msg =>
      '¡Ahora puedes leer menús de café, estaciones de metro y saludos en Corea!\n¡Casi eres un maestro del Hangul!';

  @override
  String get hangulS11LMTitle => 'Misión: ¡Lectura rápida de Hangul!';

  @override
  String get hangulS11LMSubtitle => 'Lee palabras coreanas rápidamente';

  @override
  String get hangulS11LMStep0Title => '¡Misión de lectura rápida de Hangul!';

  @override
  String get hangulS11LMStep0Desc =>
      '¡Lee y empareja palabras coreanas lo más rápido posible!\n¡Es hora de demostrar tus habilidades!';

  @override
  String get hangulS11LMStep1Title => '¡Combina las sílabas!';

  @override
  String get hangulS11LMStep2Title => 'Resultados de la misión';

  @override
  String get hangulS11LMStep3Title => '¡Maestro del Hangul!';

  @override
  String get hangulS11LMStep3Msg =>
      '¡Has dominado completamente el Hangul!\n¡Ahora puedes leer palabras y frases en coreano!';

  @override
  String get hangulS11LMStep4Title => '¡Etapa 11 completada!';

  @override
  String get hangulS11LMStep4Msg => '¡Ahora puedes leer Hangul completamente!';

  @override
  String get hangulS11CompleteTitle => '¡Etapa 11 completada!';

  @override
  String get hangulS11CompleteMsg => '¡Ahora puedes leer Hangul completamente!';

  @override
  String get stageRequestFailed =>
      'No se pudo enviar la solicitud. Inténtalo de nuevo.';

  @override
  String get stageRequestRejected =>
      'El anfitrión rechazó tu solicitud de escenario.';

  @override
  String get inviteToStageFailed =>
      'No se pudo invitar al escenario. Puede estar lleno.';

  @override
  String get demoteFailed =>
      'No se pudo quitar del escenario. Inténtalo de nuevo.';

  @override
  String get voiceRoomCloseRoomFailed =>
      'No se pudo cerrar la sala. Inténtalo de nuevo.';
}
