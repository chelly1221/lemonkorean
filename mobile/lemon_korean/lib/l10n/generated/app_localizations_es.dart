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
    return 'Al menos $count caracteres';
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
      'Error de conexión de red. Por favor verifica tu configuración de red.';

  @override
  String get invalidCredentials => 'Correo electrónico o contraseña inválidos';

  @override
  String get emailAlreadyExists => 'El correo electrónico ya está registrado';

  @override
  String get requestTimeout =>
      'Tiempo de solicitud agotado. Por favor intenta de nuevo.';

  @override
  String get operationFailed =>
      'Operación fallida. Por favor intenta más tarde.';

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
      'Una aplicación de aprendizaje de coreano diseñada para hablantes de chino, con soporte para aprendizaje sin conexión, recordatorios inteligentes de repaso y más.';

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
    return 'En $count días';
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
  String get lessonComplete => '¡Lección completada! Progreso guardado';

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
    return 'Racha de $days días';
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
  String get grammarExplanation => 'Explicación gramatical';

  @override
  String get exampleSentences => 'Oraciones de ejemplo';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get continueBtn => 'Continuar';

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
  String get fillInBlank => 'Llena con la partícula correcta';

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
  String get fillBlank => 'Llenar el espacio';

  @override
  String get translation => 'Traducción';

  @override
  String get wordOrder => 'Orden de palabras';

  @override
  String get pronunciation => 'Pronunciación';

  @override
  String get excellent => '¡Excelente!';

  @override
  String get correctOrderIs => 'Orden correcto:';

  @override
  String correctAnswerIs(String answer) {
    return 'Respuesta correcta: $answer';
  }

  @override
  String get previousQuestion => 'Pregunta anterior';

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
      '¡Intenta revisar el contenido de la lección antes de intentar de nuevo!';

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
    return '$count lecciones completadas';
  }

  @override
  String minutesLearned(int minutes) {
    return '$minutes minutos aprendidos';
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
    return '$count palabras esperando repaso';
  }

  @override
  String get user => 'Usuario';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingLanguageTitle => 'Lemon Korean';

  @override
  String get onboardingLanguagePrompt => 'Elige tu idioma preferido';

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
  String get goalSeriousHelper => 'Comprometido con mejora rápida';

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
    return 'Hace $count días';
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
    return '¿Seguro que quieres eliminar las $count descargas?';
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
    return '$count palabras';
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
  String get searchWordsNotesChinese => 'Buscar palabras, chino o notas...';

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
    return '¿Eliminar「$word」del libro de vocabulario?';
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
    return 'Hace $count semanas';
  }

  @override
  String get reviewComplete => '¡Repaso completado!';

  @override
  String reviewCompleteCount(int count) {
    return '$count palabras repasadas';
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
    return '$count completadas';
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
    return '$count caracteres';
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
  String get lesson5Desc => 'Aprende 5 consonantes dobles - sonidos fuertes';

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
      '¡Completa tu estudio de coreano de hoy~';

  @override
  String get reviewReminderTitle => '¡Hora de repasar!';

  @override
  String reviewReminderBody(String title) {
    return 'Es hora de repasar「$title」~';
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
    return '$count caracteres necesitan repaso';
  }

  @override
  String charactersAvailable(int count) {
    return '$count caracteres disponibles';
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
  String get writingPractice => 'Práctica de escritura';

  @override
  String get writingPracticeDesc =>
      'Ve la pronunciación, escribe el carácter correcto';

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
  String get writeCharacterForPronunciation =>
      'Escribe el carácter para esta pronunciación';

  @override
  String get writeHere => 'Escribe aquí\n(En desarrollo)';

  @override
  String get dontKnow => 'No sé';

  @override
  String get checkAnswer => 'Ver respuesta';

  @override
  String get didYouWriteCorrectly => '¿Lo escribiste correctamente?';

  @override
  String get wrongAnswer => 'Incorrecto';

  @override
  String get correctAnswer => 'Correcto';

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
    return '$count trazos';
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
    return '$count palabras';
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
  String grammarPattern(String pattern) {
    return 'Gramática · $pattern';
  }

  @override
  String get conjugationRule => 'Regla de conjugación';

  @override
  String get comparisonWithChinese => 'Comparación con el chino';

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
  String get checkAnswerBtn => 'Verificar respuesta';

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
      'No olvides completar tu práctica diaria de coreano~';

  @override
  String get notificationReviewTime => '¡Hora de repasar!';

  @override
  String get notificationReviewReminder =>
      'Repasemos lo que has aprendido antes~';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '¡Es hora de repasar \"$lessonTitle\"~';
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
  String get tapToFlipBack => 'Toca para voltear';

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
}
