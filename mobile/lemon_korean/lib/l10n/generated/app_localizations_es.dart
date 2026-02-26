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
  String get hangulGoToLevel1 => 'Ir al Nivel 1';

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
}
