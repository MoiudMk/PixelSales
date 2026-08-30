# PixelSales v2 Web Ready
نسخة PixelSales Flutter مجهزة للبناء على Android وWeb عبر CodeMagic.

## Web
- دعم SQLite على المتصفح عبر sqflite_common_ffi_web.
- CodeMagic workflow باسم `web-workflow`.
- الناتج: `build/PixelSales-Web.zip`.

## Android
- workflow باسم `android-workflow`.
- الناتج APK release.

ملاحظة: مجلد `build/` لا يتم تضمينه لأنه ينتج داخل CodeMagic أثناء البناء.


## الواجهة المعتمدة
تم دمج واجهة PixelSales الحديثة داخل Flutter وربط لوحة التحكم مباشرة بقاعدة البيانات الحالية:
- إحصائيات العملاء والمنتجات والمبيعات والمصروفات.
- عرض آخر الفواتير.
- اختصارات لإضافة منتج، البيع، العملاء والتقارير.
- تنقل جانبي على الشاشات الكبيرة وتنقل سفلي على الهاتف.
- نفس المشروع يبقى قابلًا للبناء Web وAndroid عبر CodeMagic.
