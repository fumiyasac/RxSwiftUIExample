# RxSwiftUIExample
[ING] - RxSwiftとUI実装の組み合わせサンプル

今回はRxSwiftの実装を改めて思い出すと同時に、実際のUIに当てはめた形でRxSwift+MVVMパターンの構成のサンプルアプリの作成に取り組んでみました。
UI実装に関しては全体のレイアウトやアニメーション表現に関わる部分で美しい表現でありながらも、今回のサンプル実装以外での応用した活用やカスタマイズがしやすそうなUIライブラリをいくつか利用しています。

### RxSwiftと併せて利用しているMVVMパターンの概要図

![mvvm.png](https://camo.qiitausercontent.com/b619a7738f54a958bd0da42dbbd24acf0142a07b/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f31373430302f36346566386130652d633263662d356438392d383036632d3463353732336434333137392e706e67)

### Storyboard構成図

![storyboard.png](https://qiita-image-store.s3.amazonaws.com/0/17400/f479962b-f2e1-fcb5-f42b-20b1e531da7e.png)

### サンプル画面のキャプチャ

__その1:__

![capture1.png](https://qiita-image-store.s3.amazonaws.com/0/17400/e4fa0446-fac1-3c5d-3739-08dd8472daf1.png)

__その2:__

![capture2.png](https://qiita-image-store.s3.amazonaws.com/0/17400/99948892-ccda-9edb-a038-bffbff246827.png)

### API通信を伴わない部分の実装における概要

__(1) カルーセル状のサムネイル画像表示する画面の処理に関する解説:__

◎ 処理概要

![carousel.png](https://qiita-image-store.s3.amazonaws.com/0/17400/46b639de-8a5a-5aee-b7db-afca95716aa2.png)

◎ 実装に関するポイント

+ __Model:__ 取得したJSONを定義した型に該当する形にする。初期化時のJSONの解析処理については`Decodable`プロトコルを適用しています。

+ __ViewModel:__ 初期化の際にJSONから作成したデータを`Observable<[FeaturedModel]>`型のデータとして保持しておき、UICollectionViewと紐づけられる形にする。また現在の表示しているインデックス値やボタンの表示・非表示に関するステータスを`BehaviorRelay<Int>`型または`BehaviorRelay<Bool>`型でイベントを流せる形にしておくと共に、これらの値を更新するためのメソッドを定義しています。

+ __ViewController:__ UIライブラリの初期設定やUI更新に関連する処理を適当な処理粒度で`private`なメソッドに切り出しておきます。`viewDidLoad`では、RxSwiftを利用してViewModel内で定義している`ViewController側で利用するためのプロパティ`とバインドさせることで、この値の変化に応じたUIの状態が更新される様にしています。

◎ ViewModelとUI部分との関連

![carousel_point.png](https://qiita-image-store.s3.amazonaws.com/0/17400/50dd2869-e928-5098-a2e4-8e12ade68d2d.png)

__(2) ドロップダウンメニューと連動した記事切り替えを伴う画面の処理に関する解説:__

◎ 処理概要

![dropdown.png](https://qiita-image-store.s3.amazonaws.com/0/17400/17af74d3-1d85-884b-c9c2-a56545f48958.png)

◎ 実装に関するポイント

+ __Model:__ 取得したJSONを定義した型に該当する形にする。初期化時のJSONの解析処理については`Decodable`プロトコルを適用しています。

+ __ViewModel:__ 初期化の際にJSONから作成したデータを別途`private`なプロパティで保持しておき、ViewController側で利用するタイトルの一覧を`Observable<[String]>`型のデータを作成してドロップダウンメニューの設定の際に利用できるようにする。またドロップダウンメニューの選択処理で該当のデータを格納する変数`selectedInformation`を`BehaviorRelay<InformationModel?>`型でイベントを流せる形にしておくと共に、これらの値を更新するためのメソッドを定義しています。

+ __ViewController:__ UIライブラリの初期設定やUI更新に関連する処理を適当な処理粒度で`private`なメソッドに切り出しておきます。`viewDidLoad`では、RxSwiftを利用してViewModel内で定義している`ViewController側で利用するためのプロパティ`とバインドさせることで、この値の変化に応じたUIの状態が更新される様にしています。

◎ ViewModelとUI部分との関連

![dropdown_point.png](https://qiita-image-store.s3.amazonaws.com/0/17400/96c76194-7fd7-5573-46c3-60451f256883.png)

### API通信を伴う部分の実装における概要

__(1) ページネーションを伴って最新のニュースデータから10件ずつ取得して表示する処理:__

◎ 処理概要

![api_request_1.png](https://qiita-image-store.s3.amazonaws.com/0/17400/50109c23-e8ea-7529-1f6d-5e05859ee295.png)

◎ 実装に関するポイント

+ __Model:__ 取得したJSONを定義した型に該当する形にする。初期化時のJSONの解析処理についてはレスポンスが複雑だったので`SwiftyJSON`を利用しています。

+ __ViewModel:__ 初期化の際には前述の`NewYorkTimesProductionAPI.swift`のインスタンスを渡す様にする。ViewController側で`getRecentNews()`メソッドを実行すると、成功時には`BehaviorRelay<[RecentNewsModel]>`型の変数`recentNewsLists`にデータを格納する形にする。また「最初の10件を取得 → 次の10件を取得 → ...」と取得して表示する動きを実現できるような形にしています。（APIでのデータ取得処理結果や状態に関するプロパティについても`BehaviorRelay<[Bool]>`型で定義しています。）

+ __ViewController:__ UIライブラリの初期設定やUI更新に関連する処理を適当な処理粒度で`private`なメソッドに切り出しておきます。`viewDidLoad`では、RxSwiftを利用してViewModel内で定義している`ViewController側で利用するためのプロパティ`とバインドさせることで、この値の変化に応じたUIの状態が更新される様にすると共に、`MainViewController.swift`に配置している`RecentNewsViewController.swift`を表示しているContainerViewの高さを`RecentNewsViewControllerDelegate`を利用して調整しています。

__(2) フリーワードに該当する記事をインクリメンタルサーチで10件取得して表示する処理:__

◎ 処理概要

![api_request_2.png](https://qiita-image-store.s3.amazonaws.com/0/17400/b61ac78a-9e52-29e0-a7e5-df1cb3c7c5ee.png)

◎ 実装に関するポイント

+ __Model:__ 取得したJSONを定義した型に該当する形にする。初期化時のJSONの解析処理についてはレスポンスが複雑だったので`SwiftyJSON`を利用しています。

+ __ViewModel:__ 初期化の際には前述の`NewYorkTimesProductionAPI.swift`のインスタンスを渡す様にする。ViewController側で`getSearchNews(keyword: String)`メソッドを実行すると、成功時には`BehaviorRelay<[SearchNewsModel]>`型の変数`searchNewsLists`に検索文字列に合致する最大10件のデータを格納する形にしています。（APIでのデータ取得処理結果や状態に関するプロパティについても`BehaviorRelay<[Bool]>`型で定義しています。）

+ __ViewController:__ UIライブラリの初期設定やUI更新に関連する処理を適当な処理粒度で`private`なメソッドに切り出しておきます。`viewDidLoad`では、RxSwiftを利用してViewModel内で定義している`ViewController側で利用するためのプロパティ`とバインドさせることで、この値の変化に応じたUIの状態が更新される様にすると共に、変数`searchBarText`の文字列長さが3未満の場合には`getSearchNews(keyword: String)`メソッド実行しない様な考慮をしています。（別途UIまわりの処理で必要な`UISearchBarDelegate`や`UIGestureRecognizerDelegate`についても記載しています。）

### フローティングメニューボタンの実装

![floating_menu.png](https://qiita-image-store.s3.amazonaws.com/0/17400/0939b16e-cbdf-93c7-2169-d0380d47fd3b.png)

### 利用しているライブラリについて

(1) Rx関連処理を行うために必要なもの

+ [RxSwift & RxCocoa](https://github.com/ReactiveX/RxSwift)

(2) APIへの非同期通信とJSONの解析を行うために必要なもの

+ [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
+ [Alamofire](https://github.com/Alamofire/Alamofire)

(3) UI表現をするために必要なもの

+ [Floaty](https://github.com/kciter/Floaty)
+ [DeckTransition](https://github.com/HarshilShah/DeckTransition)
+ [AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout)
+ [FontAwesome.swift](https://github.com/thii/FontAwesome.swift)
+ [BTNavigationDropdownMenu](https://github.com/PhamBaTho/BTNavigationDropdownMenu)
+ [Toast-Swift](https://github.com/scalessec/Toast-Swift)

### その他

このサンプル全体の詳細解説とポイントをまとめたものは下記に掲載しております。

(Qiita) https://qiita.com/fumiyasac@github/items/e426d321fbb8ab846bb6
