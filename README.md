# Yazgı

Türkçe, BitLife tarzı bir SwiftUI yaşam simülasyonu. Karakterini yaratıyor, yaş aldıkça hikaye düğümleri arasında seçim yapıyor, aktivitelerle istatistiklerini şekillendiriyor ve yaşam günlüğüyle ilerlemeni izliyorsun.

## Özellikler
- Karakter yaratma: İsim, cinsiyet, ülke seçimi; ülkeye göre aile arka planı ve başlangıç istatistikleri.
- Veri odaklı hikaye: `Resources/StoryData.json` içindeki düğümler yaş aralığı, ağırlık ve gereksinimlerle seçiliyor.
- BitLife benzeri döngü: Ana olay, opsiyonel aktiviteler, yaş alma; rastgele olaylar, ilişki ve kariyer ilerlemesi, ölüm riskleri.
- İlişkiler ve aile: Eş/partner, çocuklar, ebeveynler; ilişki kalitesi, boşanma ve çocuk ekleme akışları.
- Ekonomi: Maaş, yıllık giderler, para birikimi ve yatırım/yan iş aktiviteleri.
- Günlük ve menü: Yaşam günlüğü kaydı, panorama menüsü, hızlı kısayollar ve yapılacaklar listesi.

## Mimarisi ve Ana Dosyalar
- `Yazgi/Views/CharacterCreationView.swift`: Karakter formu, rastgele isim, ülke/cinsiyet seçimi; karakteri oluşturup oyunu başlatır.
- `Yazgi/Views/ContentView.swift`: Ana oyun ekranı (ana olay, aktiviteler, yaşam günlüğü, yaş alma butonu, menü açma).
- `Yazgi/Views/GameMenuView.swift`: Sheet menü; panorama kartı, özellik barları, kısayollar, yapılacaklar, aile görünümü, olay günlüğü.
- `Yazgi/ViewModels/GameViewModel.swift`: Tüm oyun durumu ve mantık (hikaye seçimi, aktiviteler, yaş alma, ekonomi, ilişkiler, rastgele olaylar).
- `Yazgi/Models/*.swift`: Karakter, aile, hikaye düğümleri, aktiviteler ve efektlerin veri modelleri.
- `Yazgi/Resources/StoryData.json`: Hikaye düğümleri; yaş aralığı, tekrar edilebilirlik, gereksinimler ve seçeneklerin CharacterEffect etkileri.

## Oyun Döngüsü ve Mekanik
1) Karakter yaratılır; gelir düzeyine göre başlangıç statları jitter edilir, aile geçmişi (ebeveyn meslek/gelir/velayet) üretilir.  
2) Ana olay (StoryNode) gösterilir, seçeneklerden biri seçilir → CharacterEffect stat/state değiştirir, lifeLog’a yazılır.  
3) Opsiyonel aktiviteler (Activity pool) yaş/gereksinim/weight’e göre üretilir, seçilince etkileri uygulanır.  
4) Yaş al: maaş/gider, eş ilişkisi güncelleme, çocuk yaşlandırma, kilometre taşları, rastgele olay ve ölüm kontrolü, kariyer/ilişki ilerleme; yeni yıl logu.  
5) Yeni hikaye düğümü ve aktiviteler seçilir; süreç tekrar eder.  
Not: Statlar 0-100’e clamp edilir, para negatif olmaz, lifeLog olayları tür etiketiyle tutulur (ana/aktivite/yaş/ilişki/kariyer/milestone/rastgele).

## Geliştirme ve Çalıştırma
- Gereksinimler: Xcode (iOS 18 SDK’lı sürüm), Swift 5, iOS Deployment Target 18.5.  
- Çalıştırma: `Yazgi.xcodeproj` dosyasını Xcode ile aç; `Yazgi` hedefini seçip iOS 18.5+ simülatör veya cihaza çalıştır.  
- Bağımlılıklar: Yalnızca SwiftUI ve standart iOS SDK; üçüncü parti paket yok.

## Veriyi ve Mantığı Genişletme
- Yeni hikaye düğümü: `Resources/StoryData.json` içine `StoryNode` ekle (id, title/description, minAge-maxAge, weight, repeatable, requirements, options). Seçeneklerde `CharacterEffect` ile stat/state değişimleri, `nextNodeId` ve `advanceAge` kullan.  
- Yeni aktivite: `GameViewModel.activityPool` listesine `Activity` ekle (title, summary, category, minAge/maxAge, weight, optional requirements, CharacterEffect).  
- Yeni stat davranışı: `GameViewModel.apply`, `applyYearlyDrift`, `processSalary`, `tryCareerProgression`, `tryRelationshipEvent` vb. fonksiyonları güncelleyerek ek logic ekle.

## Dosya Yapısı (kısa)
- `Yazgi/Views`: SwiftUI ekranları (CharacterCreationView, ContentView, GameMenuView, AttributeBar).  
- `Yazgi/ViewModels`: `GameViewModel` oyun akışı.  
- `Yazgi/Models`: Karakter, aile, hikaye düğümleri, aktiviteler ve efekt modelleri.  
- `Yazgi/Resources`: `StoryData.json` hikaye veri seti.  
- `Yazgi.xcodeproj`: Xcode proje ayarları (deployment 18.5, Swift 5).

## Katkı/Notlar
- Mevcut UI açık tema ağırlıklı; sistem renkleri ve gölgelerle kart düzeni.  
- Animasyon/polish istenirse SwiftUI transition/animation eklenebilir.  
- Yeni SDK sürümlerinde deployment target’ı güncellemek için proje ayarlarını düzenleyin.
