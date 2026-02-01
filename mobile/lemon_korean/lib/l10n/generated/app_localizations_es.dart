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
  String get lessonComplete => '¡Lección completada!';

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
  String get grammarExplanation => 'Explicación de gramática';

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
  String get fillBlank => 'Llenar espacios';

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
  String get correctAnswerIs => 'Respuesta correcta:';

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
}
