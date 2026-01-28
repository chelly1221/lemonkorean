/// Chinese Character Converter
/// Converts between Simplified and Traditional Chinese
///
/// Note: This is a simplified implementation using common character mappings.
/// For production use with extensive content, consider using the 'opencc' package.
class ChineseConverter {
  // Common Simplified to Traditional character mappings
  // Source: Most frequently used characters in Chinese language
  static final Map<String, String> _s2tMap = {
    // Common verbs
    '学': '學',
    '习': '習',
    '说': '說',
    '话': '話',
    '语': '語',
    '认': '認',
    '识': '識',
    '读': '讀',
    '写': '寫',
    '听': '聽',
    '练': '練',
    '复': '複',

    // Common nouns
    '国': '國',
    '时': '時',
    '间': '間',
    '节': '節',
    '课': '課',
    '汉': '漢',
    '词': '詞',
    '义': '義',
    '题': '題',
    '验': '驗',
    '际': '際',
    '关': '關',
    '系': '係',
    '记': '記',
    '号': '號',

    // Common adjectives
    '难': '難',
    '简': '簡',
    '单': '單',
    '对': '對',
    '错': '錯',
    '长': '長',
    '样': '樣',
    '继': '繼',
    '续': '續',
    '传': '傳',
    '统': '統',

    // Numbers and measures
    '个': '個',
    '万': '萬',
    '只': '隻',

    // UI/App related
    '设': '設',
    '置': '置',
    '当': '當',
    '前': '前',
    '确': '確',
    '录': '錄',
    '注': '註',
    '册': '冊',
    '书': '書',
    '电': '電',
    '脑': '腦',
    '邮': '郵',
    '件': '件',
    '密': '密',
    '码': '碼',
    '历': '歷',
    '史': '史',
    '进': '進',
    '度': '度',
    '绩': '績',
    '级': '級',
    '别': '別',
    '达': '達',
    '标': '標',
    '请': '請',
    '输': '輸',
    '入': '入',
    '选': '選',
    '择': '擇',
    '开': '開',
    '启': '啟',
    '动': '動',
    '态': '態',
    '应': '應',
    '须': '須',
    '务': '務',
    '显': '顯',
    '示': '示',
    '视': '視',
    '频': '頻',
    '音': '音',
    '乐': '樂',
    '图': '圖',
    '片': '片',
    '载': '載',
    '送': '送',
    '删': '刪',
    '除': '除',
    '变': '變',
    '更': '更',
    '换': '換',
    '档': '檔',
    '功': '功',
    '能': '能',
    '帮': '幫',
    '助': '助',
    '问': '問',
    '终': '終',
    '结': '結',
    '束': '束',
    '览': '覽',
    '查': '查',
    '询': '詢',
    '搜': '搜',
    '索': '索',
    '试': '試',
    '测': '測',
    '评': '評',
    '论': '論',
    '讨': '討',
    '议': '議',
    '订': '訂',
    '购': '購',
    '买': '買',
    '卖': '賣',
    '价': '價',
    '钱': '錢',
    '币': '幣',
    '费': '費',
    '业': '業',
    '专': '專',

    // Korean learning specific
    '韩': '韓',
    '汇': '彙',
    '调': '調',

    // Time related
    '钟': '鐘',
    '年': '年',
    '星': '星',
    '期': '期',
    '周': '週',
    '假': '假',
    '日': '日',

    // Actions
    '点': '點',
    '击': '擊',
    '触': '觸',
    '摸': '摸',
    '按': '按',
    '钮': '鈕',
    '滑': '滑',
    '拖': '拖',
    '拽': '拽',
    '缩': '縮',
    '放': '放',
    '转': '轉',

    // Common phrases
    '这': '這',
    '那': '那',
    '些': '些',
    '什': '什',
    '么': '麼',
    '怎': '怎',
    '为': '為',
    '吗': '嗎',
    '呢': '呢',
    '啊': '啊',
    '您': '您',
    '好': '好',
    '谢': '謝',
    '欢': '歡',
    '迎': '迎',
    '再': '再',
    '见': '見',

    // Multi-character common words (process these first)
    '柠檬': '檸檬',
    '学习': '學習',
    '练习': '練習',
    '复习': '複習',
    '韩语': '韓語',
    '语言': '語言',
    '时间': '時間',
    '设置': '設置',
    '确认': '確認',
    '认识': '認識',
    '国家': '國家',
    '简体': '簡體',
    '繁体': '繁體',
    '传统': '傳統',
    '发音': '發音',
    '词汇': '詞彙',
    '语法': '語法',
    '对话': '對話',
    '问题': '問題',
    '关系': '關係',
    '帮助': '幫助',
  };

  /// Convert Simplified Chinese to Traditional Chinese
  static String toTraditional(String simplified) {
    if (simplified.isEmpty) return simplified;

    String result = simplified;

    // First, replace multi-character words
    _s2tMap.forEach((key, value) {
      if (key.length > 1) {
        result = result.replaceAll(key, value);
      }
    });

    // Then replace single characters
    final buffer = StringBuffer();
    for (int i = 0; i < result.length; i++) {
      final char = result[i];
      buffer.write(_s2tMap[char] ?? char);
    }

    return buffer.toString();
  }

  /// Convert Traditional Chinese to Simplified Chinese
  /// (Reverse mapping - less accurate but covers common cases)
  static String toSimplified(String traditional) {
    if (traditional.isEmpty) return traditional;

    // Create reverse map
    final t2sMap = <String, String>{};
    _s2tMap.forEach((key, value) {
      t2sMap[value] = key;
    });

    String result = traditional;

    // First, replace multi-character words
    t2sMap.forEach((key, value) {
      if (key.length > 1) {
        result = result.replaceAll(key, value);
      }
    });

    // Then replace single characters
    final buffer = StringBuffer();
    for (int i = 0; i < result.length; i++) {
      final char = result[i];
      buffer.write(t2sMap[char] ?? char);
    }

    return buffer.toString();
  }

  /// Check if text contains any Traditional Chinese characters
  static bool hasTraditionalChars(String text) {
    for (final traditionalChar in _s2tMap.values) {
      if (text.contains(traditionalChar)) {
        return true;
      }
    }
    return false;
  }

  /// Check if text contains any Simplified Chinese characters
  static bool hasSimplifiedChars(String text) {
    for (final simplifiedChar in _s2tMap.keys) {
      if (text.contains(simplifiedChar)) {
        return true;
      }
    }
    return false;
  }
}
