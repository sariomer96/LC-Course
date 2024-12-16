LearnConnect

LearnConnect, video tabanlı eğitim içerikleriyle kullanıcıların bilgi yolculuğunu zenginleştiren, kişiselleştirilmiş öğrenme deneyimlerini avuçlarınıza getiren modern bir iOS uygulamasıdır.

Video Linki: https://drive.google.com/drive/folders/1PKdxYjQVGWPbVBcWhkUe_kaU9m_g8_wS?usp=sharing

Screenshots: https://drive.google.com/drive/folders/1nAIBzUB4j42lpZh9k4U80oW2JzWWWicz?usp=sharing


Kurulum Adımları:

 1- Gereksinimler
 
  Xcode 15.1
  
  Swift Package Manager
  


2- Proje Klonlama


    git clone https://github.com/sariomer96/LC-Course.git
  
    cd LC-Course
  
3- Proje Import

  * Learn Connect.xcodeproj dosyasına tıklayarak xcode üzerinde açın. 
  * Simülatör veya gerçek cihaz seçimi yaparak projeyi çalıştırın.
    
4- SQLite Kurulumu 

   * Xcode üzerinden File > Swift Packages > Add Dependency menüsüne gidin.
   * SQLite kütüphanesini ekleyin :  Search kısmına linki aşağıdaki linki yapıştırın.
     
         https://github.com/stephencelis/SQLite.swift.git
    
🌟 Özellikler

📱 Kullanıcı Arayüzü

* Şık ve kullanıcı odaklı arayüz tasarımı
* Aydınlık ve karanlık tema seçenekleri
* Dinamik ve akıcı geçiş animasyonları
* Kullanıcı deneyimini iyileştiren özelleştirilebilir tab bar menü
* Her cihaza uyumlu responsive tasarım


🔐 Kimlik Doğrulama

* Kullanıcı kaydı ve girişi
* SQLite ile güvenli veri saklama  (SHA 256)

🏠 Ana Sayfa

* Kategorize edilmiş içerik gösterimi
   * Yazılım
   * Eğitim
   * Bilim
   * Müzik

📚 İçerik Yönetimi

* Video oynatma
* İçerik indirme
* Favori ekleme
* Kategori bazlı filtreleme
* Offline video izleme

🔔 Bildirim Sistemi

* Push bildirimleri (2 dakikada bir)
* Bildirim yönetimi

* Özelleştirilmiş bildirim mesajları:
   * "Yüzlerce eğitim içeriği seni bekliyor."


🎯 Toast ve Pop Up Bildirimleri

Aşağıdaki durumlarda toast bildirimleri gösterilir:
* Başarılı giriş/kayıt işlemleri
* Hatalı giriş denemeleri
* Video indirme işlemleri
* Favori ekleme işlemleri
* Hata durumları

Video Player Özellikleri

  
* AVPlayer kullanılarak video stream ediliyor.
* Video hızlandırma (1.25x, 1.5x, 2x)
* İleri geri sarabilme 

🎨 Tema Desteği

* Sistem temasına otomatik uyum

💾 Veri Saklama

* SQLite  local veritabanı
* UserDefaults 
* Çevrimdışı içerik erişimi
* Localden JSON dosyası okuma

🔍 Arama Özellikleri

* Gerçek zamanlı arama
* Kategori bazlı filtreleme


🌐 Network

* Offline mod desteği
* Bağlantı durumu kontrolü


🌐 Unit Test

Bu iki  durum için test fonksiyonları yazıldı:
* Login success 
* Video indirme


Yeni versiyonda Yapılabilecekler 

  1- Yorum ve puanlama
  
  2- İndirilen videolar özel bir klasörde ve encrypt halde tutulabilir. 
  
 
