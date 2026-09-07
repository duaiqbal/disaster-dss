import 'language_service.dart';

class Tr {
  static String t(String key) {
    final lang = LanguageService.instance.current;
    final dict = _translations[lang] ?? _translations[AppLanguage.english]!;
    return dict[key] ?? _translations[AppLanguage.english]![key] ?? key;
  }

  static String riskLevel(String level) {
    final lower = level.toLowerCase();
    if (lower.contains('high')) return t('risk_high');
    if (lower.contains('moderat')) return t('risk_moderate');
    if (lower.contains('low')) return t('risk_low');
    return level;
  }

  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.english: {
      // Bottom Tabs
      'tab_home': 'Home',
      'tab_forecast': 'Forecast',
      'tab_map': 'Map',
      'tab_alerts': 'Alerts',
      'tab_profile': 'Profile',

      // Greeting & Header
      'greeting': 'Good evening, Hafsa',
      'location_chitral': 'Chitral, Khyber Pakhtunkhwa',
      'app_title': 'Climate Risk Assistant',
      'app_subtitle': 'Explainable AI for climate hazard risk and preparedness',

      // Dashboard Sections
      'current_conditions': 'CURRENT CONDITIONS',
      'household_risk': 'HOUSEHOLD RISK',
      'official_warning': 'OFFICIAL WARNING',
      'community_risk': 'COMMUNITY RISK',
      'ai_recommendation': 'AI Recommendation',
      'seven_day_forecast': '7-DAY FORECAST',

      // Buttons & CTAs
      'view_risk_factors': 'View risk factors',
      'view_community_reports': 'View Community Reports',
      'ask_ai_assistant': 'Ask AI Assistant',
      'view_alert': 'View alert',
      'view_safety_guide': 'View Safety Guide',
      'emergency_contacts': 'Emergency Contacts',
      'give_feedback': 'Give Feedback',
      'run_decision_simulation': 'Run Decision Simulation',
      'submit_report': 'Submit Report',
      'save_profile': 'Save Risk Profile',
      'continue': 'Continue',
      'cancel': 'Cancel',
      'log_out': 'Log Out',
      'done': 'Done',
      'close': 'Close',
      'view_full': 'View full',
      'key_factors': 'Key Factors:',
      'view_risk_profile': 'View Risk Profile',

      // Language Selection
      'choose_language': 'Choose your language',
      'select_language_subtitle':
          'Select the language you prefer for guidance and alerts.',
      'language_can_change_later':
          'Language preferences can be changed later from Profile.',

      // Risk Levels
      'risk_high': 'High Risk',
      'risk_moderate': 'Moderate Risk',
      'risk_low': 'Low Risk',
      'at_risk': 'At Risk',

      // Weather & Forecast
      'humidity': 'Humidity',
      'wind': 'Wind',
      'rain': 'Rain',
      'uv': 'UV',
      'hourly_forecast': 'Hourly Forecast',
      'risk_relevant_weather': 'Risk-relevant weather',

      // Alerts Screen
      'alerts_title': 'Alerts',
      'alerts_subtitle': 'Official warnings and important risk updates',
      'cat_all': 'All',
      'cat_flood': 'Flood',
      'cat_landslide': 'Landslide',
      'cat_heavy_rain': 'Heavy Rain',

      // Bottom Sheet & Explanations
      'household_risk_factors': 'Household Risk Factors',
      'household_risk_factors_sub': 'Why your household has this risk level',
      'calc_risk_title': 'How your risk is calculated',
      'household_risk_desc':
          'Based on your current household profile and environmental conditions.',

      // Scenarios
      'evacuate_now': 'Evacuate now',
      'wait_and_monitor': 'Wait and monitor',
      'risk_trajectory': 'Risk Trajectory',
      'factor_breakdown': 'Factor Breakdown',

      // Profile Menu Items
      'menu_risk_profile': 'Risk Profile',
      'menu_risk_profile_sub': 'Manage household characteristics',
      'menu_emergency_contacts': 'Emergency Contacts',
      'menu_emergency_contacts_sub': 'View important emergency numbers',
      'menu_safety_hub': 'Safety Hub',
      'menu_safety_hub_sub': 'Safe bag checklist and hazard guides',
      'menu_feedback': 'Give Feedback',
      'menu_feedback_sub': 'Help improve the guidance system',
      'menu_language': 'Language',

      // Dialogs
      'logout_dialog_title': 'Log out?',
      'logout_dialog_desc': 'Are you sure you want to log out of your account?',
    },

    AppLanguage.urdu: {
      // Bottom Tabs
      'tab_home': 'ہوم',
      'tab_forecast': 'پیشن گوئی',
      'tab_map': 'نقشہ',
      'tab_alerts': 'اطلاعات',
      'tab_profile': 'پروفائل',

      // Greeting & Header
      'greeting': 'شب بخیر، حفصہ',
      'location_chitral': 'چترال، خیبر پختونخوا',
      'app_title': 'کلائمیٹ رسک اسسٹنٹ',
      'app_subtitle': 'موسمیاتی خطرات اور تیاری کے لیے وضاحتی مصنوعی ذہانت',

      // Dashboard Sections
      'current_conditions': 'موجودہ موسمی صورتحال',
      'household_risk': 'گھر کا خطرہ',
      'official_warning': 'سرکاری تنبیہ',
      'community_risk': 'عوامی صورتحال',
      'ai_recommendation': 'مصنوعی ذہانت کی تجویز',
      'seven_day_forecast': '7 روزہ پیشن گوئی',

      // Buttons & CTAs
      'view_risk_factors': 'خطرے کے عوامل دیکھیں',
      'view_community_reports': 'عوامی رپورٹیں دیکھیں',
      'ask_ai_assistant': 'AI اسسٹنٹ سے پوچھیں',
      'view_alert': 'تنبیہ دیکھیں',
      'view_safety_guide': 'حفاظتی گائیڈ دیکھیں',
      'emergency_contacts': 'ہنگامی رابطے',
      'give_feedback': 'رائے دیں',
      'run_decision_simulation': 'فیصلہ سازی سمیلیشن شروع کریں',
      'submit_report': 'رپورٹ جمع کروائیں',
      'save_profile': 'پروفائل محفوظ کریں',
      'continue': 'آگے بڑھیں',
      'cancel': 'منسوخ کریں',
      'log_out': 'لاگ آؤٹ',
      'done': 'مکمل',
      'close': 'بند کریں',
      'view_full': 'مکمل دیکھیں',
      'key_factors': 'اہم عوامل:',
      'view_risk_profile': 'خطرے کا پروفائل دیکھیں',

      // Language Selection
      'choose_language': 'اپنی زبان منتخب کریں',
      'select_language_subtitle':
          'رہنمائی اور اطلاعات کے لیے اپنی پسندیدہ زبان منتخب کریں۔',
      'language_can_change_later':
          'زبان کی ترتیبات بعد میں پروفائل سے تبدیل کی جا سکتی ہیں۔',

      // Risk Levels
      'risk_high': 'شدید خطرہ',
      'risk_moderate': 'درمیانہ خطرہ',
      'risk_low': 'کم خطرہ',
      'at_risk': 'خطرے میں',

      // Weather & Forecast
      'humidity': 'نمی',
      'wind': 'ہوا',
      'rain': 'بارش',
      'uv': 'یو وی',
      'hourly_forecast': 'گھنٹہ وار پیشن گوئی',
      'risk_relevant_weather': 'خطرے سے متعلق موسم',

      // Alerts Screen
      'alerts_title': 'اطلاعات',
      'alerts_subtitle': 'سرکاری تنبیہات اور اہم خطرات سے متعلق اپ ڈیٹس',
      'cat_all': 'تمام',
      'cat_flood': 'سیلاب',
      'cat_landslide': 'لینڈ سلائیڈنگ',
      'cat_heavy_rain': 'شدید بارش',

      // Bottom Sheet & Explanations
      'household_risk_factors': 'گھر کے خطرے کے عوامل',
      'household_risk_factors_sub': 'آپ کے گھر کا یہ خطرے کا درجہ کیوں ہے',
      'calc_risk_title': 'آپ کے خطرے کا حساب کیسے لگایا گیا',
      'household_risk_desc':
          'آپ کے موجودہ گھریلو پروفائل اور ماحولیاتی حالات پر مبنی۔',

      // Scenarios
      'evacuate_now': 'ابھی محفوظ مقام پر منتقل ہوں',
      'wait_and_monitor': 'انتظار کریں اور نظر رکھیں',
      'risk_trajectory': 'خطرے کا رجحان',
      'factor_breakdown': 'عوامل کا جائزہ',

      // Profile Menu Items
      'menu_risk_profile': 'خطرے کا پروفائل',
      'menu_risk_profile_sub': 'گھر سے متعلق تفصیلات کا انتظام',
      'menu_emergency_contacts': 'ہنگامی رابطے',
      'menu_emergency_contacts_sub': 'اہم ہنگامی ہیلپ لائن نمبرز دیکھیں',
      'menu_safety_hub': 'سیفٹی مرکز',
      'menu_safety_hub_sub': 'حفاظتی بیگ چیک لسٹ اور رہنمائی',
      'menu_feedback': 'اپنی رائے دیں',
      'menu_feedback_sub': 'رہنمائی کے نظام کو بہتر بنانے میں مدد کریں',
      'menu_language': 'زبان',

      // Dialogs
      'logout_dialog_title': 'لاگ آؤٹ کریں؟',
      'logout_dialog_desc': 'کیا آپ واقعی اپنے اکاؤنٹ سے لاگ آؤٹ کرنا چاہتے ہیں؟',
    },

    AppLanguage.romanUrdu: {
      // Bottom Tabs
      'tab_home': 'Home',
      'tab_forecast': 'Peshangoi',
      'tab_map': 'Naqsha',
      'tab_alerts': 'Ittilayein',
      'tab_profile': 'Profile',

      // Greeting & Header
      'greeting': 'Shab-ba-khair, Hafsa',
      'location_chitral': 'Chitral, Khyber Pakhtunkhwa',
      'app_title': 'Climate Risk Assistant',
      'app_subtitle': 'Mousami khatrat aur tayari ke liye wazahti AI',

      // Dashboard Sections
      'current_conditions': 'MOJOODA MOUSAM',
      'household_risk': 'GHAR KA KHATRA',
      'official_warning': 'SARKARI ITTILA',
      'community_risk': 'AWAMI SURAT-E-HAAL',
      'ai_recommendation': 'AI Mashwara',
      'seven_day_forecast': '7-ROZA PESHANGOI',

      // Buttons & CTAs
      'view_risk_factors': 'Khatray ke asbaab dekhein',
      'view_community_reports': 'Awami Reports Dekhein',
      'ask_ai_assistant': 'AI Assistant se Poochhein',
      'view_alert': 'Ittila dekhein',
      'view_safety_guide': 'Safety Guide Dekhein',
      'emergency_contacts': 'Emergency Numbers',
      'give_feedback': 'Raye Dein',
      'run_decision_simulation': 'Faisla Simulation Chalayein',
      'submit_report': 'Report Jama Karein',
      'save_profile': 'Profile Save Karein',
      'continue': 'Aagay Barhein',
      'cancel': 'Mansookh',
      'log_out': 'Log Out',
      'done': 'Mukammal',
      'close': 'Band Karein',
      'view_full': 'Mukammal dekhein',
      'key_factors': 'Aham Wajoohaat:',
      'view_risk_profile': 'Risk Profile Dekhein',

      // Language Selection
      'choose_language': 'Apni zuban muntakhib karein',
      'select_language_subtitle':
          'Rehnumai aur ittilayein ke liye apni pasandeeda zuban muntakhib karein.',
      'language_can_change_later':
          'Zuban ki tarteeb baad mein Profile se tabdeel ki ja sakti hai.',

      // Risk Levels
      'risk_high': 'Bara Khatra',
      'risk_moderate': 'Darmiyana Khatra',
      'risk_low': 'Kam Khatra',
      'at_risk': 'Khatray Mein',

      // Weather & Forecast
      'humidity': 'Nami',
      'wind': 'Hawa',
      'rain': 'Barish',
      'uv': 'UV',
      'hourly_forecast': 'Ghanta-waar Peshangoi',
      'risk_relevant_weather': 'Khatray se jurra mousam',

      // Alerts Screen
      'alerts_title': 'Ittilayein',
      'alerts_subtitle': 'Sarkari ittilayein aur ahem khatray ki updates',
      'cat_all': 'Tamam',
      'cat_flood': 'Seelab',
      'cat_landslide': 'Landslide',
      'cat_heavy_rain': 'Bhari Barish',

      // Bottom Sheet & Explanations
      'household_risk_factors': 'Ghar ke khatray ke asbaab',
      'household_risk_factors_sub': 'Aap ke ghar ka yeh khatra kyun hai',
      'calc_risk_title': 'Aap ke khatray ka hisaab kaisay lagaya gaya',
      'household_risk_desc':
          'Aap ke ghar ke profile aur mosami halaat par mabni.',

      // Scenarios
      'evacuate_now': 'Abhi mehfooz jagah jayein',
      'wait_and_monitor': 'Rukein aur nazar rakhein',
      'risk_trajectory': 'Khatray Ka Graph',
      'factor_breakdown': 'Wajohaat Ka Muqabla',

      // Profile Menu Items
      'menu_risk_profile': 'Risk Profile',
      'menu_risk_profile_sub': 'Ghar ki maloomat darj karein',
      'menu_emergency_contacts': 'Emergency Contacts',
      'menu_emergency_contacts_sub': 'Zaroori emergency helpline numbers',
      'menu_safety_hub': 'Safety Hub',
      'menu_safety_hub_sub': 'Emergency bag checklist aur safety guide',
      'menu_feedback': 'Raye Dein',
      'menu_feedback_sub': 'System ko behtar banane mein madad karein',
      'menu_language': 'Zuban',

      // Dialogs
      'logout_dialog_title': 'Log out karein?',
      'logout_dialog_desc': 'Kya aap waqai apne account se log out karna chahte hain?',
    },
  };
}
