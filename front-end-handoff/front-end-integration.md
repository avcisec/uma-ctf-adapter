# Hypiq UMA CTF Adapter Entegrasyon Kılavuzu

Bu doküman, `HypiqUmaCtfAdapter` akıllı kontratının bir ön yüz uygulamasına nasıl entegre edileceğini açıklamaktadır.

## Genel Bakış

`HypiqUmaCtfAdapter`, Polymarket'in koşullu tokenler çerçevesini (Conditional Tokens Framework - CTF) UMA'nın Optimistic Oracle'ı ile birleştiren bir adaptör kontratıdır. Bu kontrat, bir zincirde (örneğin Base) bir soru başlatılmasına, bu sorunun UMA oracle'ına gönderilmesine ve başka bir zincirde (örneğin Hyper) LayerZero aracılığıyla bir koşulun (condition) hazırlanmasına olanak tanır.

Temel iş akışı aşağıdaki gibidir:
1.  **Soru Başlatma:** Protokol yöneticisi(soru oluşturma ve çözümleme fonksiyonlarını logic based otomatik çağıran ön yüz botu.) ön yüz üzerinden bir soru metni ve diğer parametrelerle (`reward`, `proposalBond` vb.) bir işlem başlatır. Bu işlem, `HypiqUmaCtfAdapter` kontratındaki `initialize` fonksiyonunu çağırır.
2.  **LayerZero Mesajlaşması:** `initialize` fonksiyonu, koşulun hazırlanması için hedef zincire (Hyper) bir LayerZero mesajı gönderir.
3.  **Oracle Sorgusu:** Eş zamanlı olarak, `initialize` fonksiyonu UMA'nın Optimistic Oracle'ına bir fiyat isteği (price request) gönderir.
4.  **Soru Çözümlemesi:** UMA oracle'ı soruyu çözdükten sonra, `resolve` fonksiyonu çağrılarak sonuçlar alınır.
5.  **Sonuçların Raporlanması:** `resolve` fonksiyonu, LayerZero aracılığıyla hedef zincireki `CTFRelayer` kontratına ödeme sonuçlarını (`payouts`) raporlar.
6.  **Acil Durum Fonksiyonları:** Kontrat sahibi (admin), `flag`, `unflag`, `emergencyResolve` gibi fonksiyonlarla piyasaya müdahale edebilir.

## Kurulum

Ön yüz uygulamanızda `ethers.js` veya `web3.js` gibi bir Ethereum kütüphanesi kullanarak kontratla etkileşim kurabilirsiniz.

1.  **ABI'yi Yükleyin:** `HypiqUmaCtfAdapter.json` dosyasındaki ABI'yi projenize dahil edin.
2.  **Kontrat Adresini Belirleyin:** Dağıtılan `HypiqUmaCtfAdapter` kontratının adresini öğrenin. Bu adres, kontratın Base zincirine dağıtıldığı adrestir.


## Ana Fonksiyonlar ve İş Akışları

### 1. Soru Oluşturma (Piyasa Açma)

Bir kullanıcı yeni bir tahmin piyasası oluşturmak istediğinde, `initialize` fonksiyonu çağrılmalıdır.

**Fonksiyon:**
`initialize(bytes memory ancillaryData, address rewardToken, uint256 reward, uint256 proposalBond, uint256 liveness)`

**Parametreler:**
*   `ancillaryData`: Sorunun metnini içeren `bytes` dizisi. Örnek: `ethers.utils.formatBytes32String("Will Founder's Edition NFTs be listed on OpenSea by September 2024?")`
*   `rewardToken`: Ödül ve ücretler için kullanılacak ERC20 token'ının adresi.
*   `reward`: UMA oracle'ına doğru sonucu öneren kişiye verilecek ödül miktarı.
*   `proposalBond`: Öneri veya itirazda bulunmak için yatırılması gereken teminat miktarı. `0` girilirse, UMA'nın varsayılan değeri kullanılır.
*   `liveness`: UMA oracle'ının "canlılık" periyodu (saniye cinsinden). `0` girilirse, varsayılan değer (2 saat) kullanılır.

**İşlem Akışı:**
1.  Kullanıcıdan soru metnini ve diğer parametreleri alın.
2.  `getPrepareConditionFee` fonksiyonunu çağırarak LayerZero mesaj ücretini hesaplayın. Bu ücret, `initialize` fonksiyonuna `value` olarak gönderilmelidir.
3.  Kullanıcının `rewardToken` harcaması için kontrata onay (`approve`) vermesini sağlayın.
4.  `initialize` fonksiyonunu çağırın.
5.  Dönen `questionID` değerini saklayın. Bu ID, piyasanın takibi için kullanılacaktır.


```

### 2. Piyasayı Çözümleme

Bir soru UMA oracle'ı tarafından çözüldüğünde ve sonuçlandırmaya hazır olduğunda (`ready` fonksiyonu `true` döner), `resolve` fonksiyonu çağrılabilir.

**Fonksiyon:**
`resolve(bytes32 questionID)`

**İşlem Akışı:**
1.  Çözümlenecek piyasanın `questionID`'sini belirleyin.
2.  `getReportPayoutsFee` fonksiyonunu _önceden_ çağırarak LayerZero ücretini tahmin edin (Bu adıma dikkat, çünkü `payouts` önceden bilinmeyebilir. Alternatif olarak, UI'da yaklaşık bir gaz ücreti gösterilebilir veya ücret kontrat içinden dinamik olarak hesaplanabilir).
3.  `resolve` fonksiyonunu çağırın. Bu fonksiyon, oracle'dan sonucu alır ve hedef zincire raporlar.



### 3. Veri Okuma Fonksiyonları

*   `getQuestion(bytes32 questionID)`: Belirtilen `questionID`'ye ait tüm verileri (`QuestionData` struct) döndürür. Piyasanın güncel durumunu (çözüldü mü, duraklatıldı mı vb.) öğrenmek için kullanılır.
*   `isInitialized(bytes32 questionID)`: Bir piyasanın başlatılıp başlatılmadığını kontrol eder.
*   `ready(bytes32 questionID)`: Bir piyasanın çözüme hazır olup olmadığını kontrol eder.
*   `getExpectedPayouts(bytes32 questionID)`: Bir piyasanın çözümlenmesi durumunda beklenen ödeme oranlarını (`[YES, NO]`) döndürür.

## Olaylar (Events)

Ön yüz uygulaması, kontrat tarafından tetiklenen olayları dinleyerek piyasa durumundaki değişiklikleri takip edebilir:

*   `QuestionInitialized`: Yeni bir piyasa oluşturulduğunda tetiklenir. `questionID`'yi içerir.
*   `QuestionResolved`: Bir piyasa çözüldüğünde tetiklenir. `settledPrice` ve `payouts` gibi önemli bilgileri içerir.
*   `QuestionFlagged`, `QuestionPaused`, `QuestionReset`: Admin tarafından yapılan müdahaleleri belirtir.

