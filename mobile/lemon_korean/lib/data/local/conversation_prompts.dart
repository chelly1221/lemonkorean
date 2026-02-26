import 'dart:math';

/// A single conversation prompt for voice rooms
class ConversationPrompt {
  final String text;
  final String textKo;
  final String level; // 'beginner', 'intermediate', 'advanced'
  final String roomType; // matches RoomTypes constants

  const ConversationPrompt({
    required this.text,
    required this.textKo,
    required this.level,
    required this.roomType,
  });
}

/// Static collection of conversation prompts for Korean learning voice rooms
class ConversationPrompts {
  static const List<ConversationPrompt> prompts = [
    // ================================================================
    // Beginner - Free Talk
    // ================================================================
    ConversationPrompt(
      text: 'What did you eat today?',
      textKo: '오늘 뭐 먹었어요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Where are you from?',
      textKo: '어디에서 왔어요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: "What's your favorite Korean food?",
      textKo: '좋아하는 한국 음식이 뭐예요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: "What's the weather like today?",
      textKo: '오늘 날씨가 어때요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Do you have any hobbies?',
      textKo: '취미가 뭐예요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What time did you wake up today?',
      textKo: '오늘 몇 시에 일어났어요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Do you like coffee or tea?',
      textKo: '커피를 좋아해요, 차를 좋아해요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What Korean words did you learn recently?',
      textKo: '최근에 어떤 한국어 단어를 배웠어요?',
      level: 'beginner',
      roomType: 'free_talk',
    ),

    // ================================================================
    // Intermediate - Free Talk
    // ================================================================
    ConversationPrompt(
      text: 'Tell us about your weekend plans',
      textKo: '주말 계획을 말해 주세요',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What K-drama are you watching these days?',
      textKo: '요즘 어떤 한국 드라마를 봐요?',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'If you could visit any city in Korea, where would you go?',
      textKo: '한국에서 어디를 여행하고 싶어요?',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What Korean song do you listen to the most?',
      textKo: '가장 많이 듣는 한국 노래가 뭐예요?',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Tell us about a funny experience while learning Korean',
      textKo: '한국어를 배우면서 웃긴 경험을 이야기해 주세요',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: "What's the hardest part about learning Korean?",
      textKo: '한국어 배울 때 가장 어려운 게 뭐예요?',
      level: 'intermediate',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Describe your typical daily routine in Korean',
      textKo: '하루 일과를 한국어로 설명해 보세요',
      level: 'intermediate',
      roomType: 'free_talk',
    ),

    // ================================================================
    // Advanced - Free Talk
    // ================================================================
    ConversationPrompt(
      text: "What do you think about Korea's education system?",
      textKo: '한국의 교육 제도에 대해 어떻게 생각하세요?',
      level: 'advanced',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'How has Korean culture influenced your country?',
      textKo: '한국 문화가 여러분의 나라에 어떤 영향을 미쳤나요?',
      level: 'advanced',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What are the differences between Korean and your native language?',
      textKo: '한국어와 모국어의 차이점은 뭐예요?',
      level: 'advanced',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'Discuss the impact of K-pop on global music trends',
      textKo: '케이팝이 세계 음악 트렌드에 미친 영향에 대해 이야기해 봅시다',
      level: 'advanced',
      roomType: 'free_talk',
    ),
    ConversationPrompt(
      text: 'What Korean proverb or expression do you find most interesting?',
      textKo: '가장 흥미로운 한국 속담이나 표현은 뭐예요?',
      level: 'advanced',
      roomType: 'free_talk',
    ),

    // ================================================================
    // Beginner - Pronunciation
    // ================================================================
    ConversationPrompt(
      text: 'Practice: plain, aspirated, and tense consonants (ㄱ/ㅋ/ㄲ)',
      textKo: '연습: 가 / 카 / 까',
      level: 'beginner',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Practice vowel sounds: ㅓ vs ㅗ',
      textKo: '연습: 어 vs 오 - 먹다, 목, 벌, 볼',
      level: 'beginner',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Read aloud: basic greetings and self-introduction',
      textKo: '소리 내어 읽기: 안녕하세요, 저는 ___이에요/예요',
      level: 'beginner',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Practice: ㄴ vs ㄹ sounds in different positions',
      textKo: '연습: 나라, 라면, 날, 달',
      level: 'beginner',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Practice: double vowels (ㅐ vs ㅔ, ㅘ vs ㅝ)',
      textKo: '연습: 개/게, 과/궈',
      level: 'beginner',
      roomType: 'pronunciation',
    ),

    // Intermediate - Pronunciation
    ConversationPrompt(
      text: 'Practice linking sounds: consonant + vowel connection',
      textKo: '연습: 연음 법칙 - 음악이 [으마기], 한국어 [한구거]',
      level: 'intermediate',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Read a short Korean tongue twister together',
      textKo: '연습: 간장 공장 공장장은 강 공장장이고...',
      level: 'intermediate',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Practice batchim (final consonant) sound changes',
      textKo: '연습: 받침 발음 - 국물 [궁물], 맛있다 [마싣따]',
      level: 'intermediate',
      roomType: 'pronunciation',
    ),

    // Advanced - Pronunciation
    ConversationPrompt(
      text: 'Practice natural intonation in complex sentences',
      textKo: '연습: 자연스러운 억양 - 긴 문장을 자연스럽게 읽어 봅시다',
      level: 'advanced',
      roomType: 'pronunciation',
    ),
    ConversationPrompt(
      text: 'Practice formal vs informal speech tone differences',
      textKo: '연습: 존댓말과 반말의 톤 차이 연습',
      level: 'advanced',
      roomType: 'pronunciation',
    ),

    // ================================================================
    // Beginner - Role Play
    // ================================================================
    ConversationPrompt(
      text: 'At a Korean restaurant - ordering food',
      textKo: '한국 식당에서 음식 주문하기',
      level: 'beginner',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'At a convenience store - buying snacks',
      textKo: '편의점에서 과자 사기',
      level: 'beginner',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'Meeting a new Korean friend - self-introduction',
      textKo: '새로운 한국 친구 만나기 - 자기소개',
      level: 'beginner',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'Asking for directions on the street',
      textKo: '길에서 길 묻기',
      level: 'beginner',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'Taking a taxi - telling the driver your destination',
      textKo: '택시 타기 - 기사님에게 목적지 말하기',
      level: 'beginner',
      roomType: 'roleplay',
    ),

    // Intermediate - Role Play
    ConversationPrompt(
      text: 'Shopping for clothes - asking about sizes and prices',
      textKo: '옷 가게에서 쇼핑하기 - 사이즈와 가격 물어보기',
      level: 'intermediate',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: "At the doctor's office - describing symptoms",
      textKo: '병원에서 - 증상 설명하기',
      level: 'intermediate',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'Calling to make a restaurant reservation',
      textKo: '식당 예약 전화하기',
      level: 'intermediate',
      roomType: 'roleplay',
    ),

    // Advanced - Role Play
    ConversationPrompt(
      text: 'Job interview in Korean',
      textKo: '한국어로 면접 보기',
      level: 'advanced',
      roomType: 'roleplay',
    ),
    ConversationPrompt(
      text: 'Negotiating rent with a Korean landlord',
      textKo: '집주인과 월세 협상하기',
      level: 'advanced',
      roomType: 'roleplay',
    ),

    // ================================================================
    // Beginner - Q&A
    // ================================================================
    ConversationPrompt(
      text: 'Ask anything about Korean grammar!',
      textKo: '한국어 문법에 대해 무엇이든 물어보세요!',
      level: 'beginner',
      roomType: 'qna',
    ),
    ConversationPrompt(
      text: 'When do you use -이에요 vs -예요?',
      textKo: '-이에요와 -예요는 언제 사용해요?',
      level: 'beginner',
      roomType: 'qna',
    ),
    ConversationPrompt(
      text: "What's the difference between -은/는 and -이/가?",
      textKo: '-은/는과 -이/가의 차이는 뭐예요?',
      level: 'beginner',
      roomType: 'qna',
    ),

    // Intermediate - Q&A
    ConversationPrompt(
      text: 'How do you use -는데 in natural conversation?',
      textKo: '대화에서 -는데를 어떻게 자연스럽게 써요?',
      level: 'intermediate',
      roomType: 'qna',
    ),
    ConversationPrompt(
      text: 'When should you use formal vs informal speech?',
      textKo: '존댓말과 반말은 언제 사용해야 해요?',
      level: 'intermediate',
      roomType: 'qna',
    ),

    // Advanced - Q&A
    ConversationPrompt(
      text: 'Explain nuances between similar grammar patterns',
      textKo: '비슷한 문법 표현의 미묘한 차이를 설명해 주세요',
      level: 'advanced',
      roomType: 'qna',
    ),
    ConversationPrompt(
      text: 'How to express complex emotions in Korean naturally?',
      textKo: '복잡한 감정을 한국어로 자연스럽게 표현하는 방법은?',
      level: 'advanced',
      roomType: 'qna',
    ),

    // ================================================================
    // Beginner - Listening
    // ================================================================
    ConversationPrompt(
      text: 'Listen and repeat: basic daily expressions',
      textKo: '듣고 따라하기: 기본 일상 표현',
      level: 'beginner',
      roomType: 'listening',
    ),
    ConversationPrompt(
      text: 'Listen to a short self-introduction and answer questions',
      textKo: '짧은 자기소개를 듣고 질문에 답하기',
      level: 'beginner',
      roomType: 'listening',
    ),

    // Intermediate - Listening
    ConversationPrompt(
      text: 'Listen to a short story and summarize it',
      textKo: '짧은 이야기를 듣고 요약하기',
      level: 'intermediate',
      roomType: 'listening',
    ),
    ConversationPrompt(
      text: 'Listen to a Korean news headline and discuss',
      textKo: '한국 뉴스 헤드라인을 듣고 토론하기',
      level: 'intermediate',
      roomType: 'listening',
    ),

    // Advanced - Listening
    ConversationPrompt(
      text: 'Listen to a Korean podcast clip and share your thoughts',
      textKo: '한국어 팟캐스트를 듣고 생각을 나눠 봅시다',
      level: 'advanced',
      roomType: 'listening',
    ),
    ConversationPrompt(
      text: 'Dictation practice with natural-speed Korean',
      textKo: '자연스러운 속도의 한국어 받아쓰기 연습',
      level: 'advanced',
      roomType: 'listening',
    ),

    // ================================================================
    // Intermediate - Debate
    // ================================================================
    ConversationPrompt(
      text: 'Is it better to study Korean alone or with others?',
      textKo: '한국어를 혼자 공부하는 게 좋을까요, 같이 공부하는 게 좋을까요?',
      level: 'intermediate',
      roomType: 'debate',
    ),
    ConversationPrompt(
      text: 'K-dramas vs K-movies: which is better for learning Korean?',
      textKo: '한국 드라마 vs 한국 영화: 한국어 공부에 뭐가 더 좋을까요?',
      level: 'intermediate',
      roomType: 'debate',
    ),

    // Advanced - Debate
    ConversationPrompt(
      text: 'Is it better to live in the city or countryside?',
      textKo: '도시와 시골 중 어디가 더 살기 좋을까요?',
      level: 'advanced',
      roomType: 'debate',
    ),
    ConversationPrompt(
      text: 'Should AI be used to teach languages?',
      textKo: 'AI를 언어 교육에 사용해야 할까요?',
      level: 'advanced',
      roomType: 'debate',
    ),
    ConversationPrompt(
      text: 'Is learning Korean getting easier or harder in the digital age?',
      textKo: '디지털 시대에 한국어 배우기가 더 쉬워졌나요, 어려워졌나요?',
      level: 'advanced',
      roomType: 'debate',
    ),
    ConversationPrompt(
      text: 'Should textbooks or immersion be prioritized for language learning?',
      textKo: '언어 학습에서 교과서 공부와 몰입 학습 중 어떤 걸 우선해야 할까요?',
      level: 'advanced',
      roomType: 'debate',
    ),
  ];

  /// Filter prompts by level and/or room type
  static List<ConversationPrompt> getPrompts({
    String? level,
    String? roomType,
  }) {
    return prompts.where((p) {
      if (level != null && level != 'all' && p.level != level) return false;
      if (roomType != null && p.roomType != roomType) return false;
      return true;
    }).toList();
  }

  /// Get a random prompt, optionally filtered by level and/or room type
  static ConversationPrompt getRandomPrompt({
    String? level,
    String? roomType,
  }) {
    final filtered = getPrompts(level: level, roomType: roomType);
    if (filtered.isEmpty) return prompts.first;
    return filtered[Random().nextInt(filtered.length)];
  }

  /// Get daily topic (deterministic based on date, so all users see the same one)
  static ConversationPrompt getDailyTopic() {
    final now = DateTime.now();
    final dayIndex = now.year * 366 + now.month * 31 + now.day;
    final freeTalkPrompts = getPrompts(roomType: 'free_talk');
    if (freeTalkPrompts.isEmpty) return prompts.first;
    return freeTalkPrompts[dayIndex % freeTalkPrompts.length];
  }
}
