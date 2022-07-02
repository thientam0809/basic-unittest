# UnitTest with OHHTTPStubs

## 1. Mở đầu.

Tiếp tục chuỗi bài liên quan đến test cùng fxstudio nào!

Đối với **functional test** ngoài việc test các hàm xử lí logic, hàm để setup data .v.v thì chúng ta cũng phải test các funcs liên quan đến server, response data, kiểm tra request đó thành công hay thất bại. 

### 1.1. Tại sao lúc test không nên phụ thuộc vào server?

Test phải đảm bảo nó nhanh, độc lập, có thể nhân rộng rà, tự verify được.
Và việc phụ thuộc vào network đã vi phạm những quy tắc này.

* Làm chậm việc test.

* Khó xác định.

  Có nghĩa là chúng ta sẽ bị phụ thuộc vào data trả về từ server. Bạn không thể đảm bảo data trả về sẽ đúng như những gì bạn kì vọng.

  Test cũng có thể bị "**time out**" bởi vì network ở một lúc nào đó nó sẽ bị tắt nghẽn hoặc server sẽ trả về một data không đúng do phía backend chạy migration trên một staging server khác mà không thông báo cho bạn.

* Khó để test trường hợp error.

  Khi thực sự truy cập vào "**real server**", thì thật sự khó để nó có thể rơi trường hợp failure nếu rơi vào team backend xịn xò. Dẫn đến reponse data luôn success và không thể nào test được case failure.

  Vậy nên:

  Quá phụ thuộc và truy cập trực tiếp đến network sẽ làm việc test thực sự rất khó. 

  > **Đó là lí do chúng ta phải tách biệt, độc lập (decouple) từ network trong  unittest.**

Đó là lí do mình sẽ giới thiệu UnitTest with OHHTTPStubs.

## 2. Chuẩn bị.

Cài đặt và import thư viện như với Nimble và Quick.

```swift
pod 'OHHTTPStubs/Swift'
```
```swift
import OHHTTPStubs
```

Mọi thứ vẫn làm như bài trước và mình chỉ bắt đầu hướng dẫn lúc bắt đầu test với những func liên quan đến server nhé!  

##  3. OHHTTPStubs. 

###  3.1. Khái niệm.

* OHHTTPStubs: là một thư viện được thiết kế để "**stub**" cái request của bạn một cách dễ dàng.


Vậy **stub** là gì?

>Stub là một chương trình hoặc thành phần giả lập để kết nối với các công đoạn khác thành một khối hoàn chỉnh.

Ví dụ: Chúng ta có 4 công đoạn, mà công đoạn đầu tiên phía BE làm chưa xong, thì phía Mobile phải làm sao?

> Dev mobile đành ngồi chơi vậy!!!

Cách giải quyết là ta tạo tạm thời "**một thành phần giả lập cho cái công đoạn chưa hoàn thành đó**" để những công đoạn tiếp theo diễn ra trôi chảy.

> Stub kiểu như anh trai mưa vậy, cô gái mới cãi nhau người yêu cần một người lấp đầy khoảng trống thì stub sẽ xuất hiện, khi 2 người đó làm lành thì stub tiếp tục lặng yên nhìn 2 người đó yêu nhau :(.

Còn đối với stub trong unittest thì với những lí do chúng ra không thể phụ thuộc quá vào server vì những lí do đã nêu trên, thì cần một "**stub**" để thay thế cho việc request đến server đó. 

### 3.2. Usage example.

Để nhanh gọn mình sẽ code example một "stub" đơn giản rồi phân tích từng dòng một nhé.

```swift
                stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
                    let path: String! = OHPathForFile("detail.json", type(of: self))
                    return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
                }
```
Thư viện OHHTTPStubs hỗ trợ chúng ta một hàm **"stub"** để giả lập một quá trình request.

Nó có parameter:

* **condition**: so khớp điều kiện coi đúng không , nếu đúng thì thực hiện request.

  Nó cung cấp cho ta các điều kiện như **isMethodGET()**,  **isMethodPOST()**, **isMethodPUT()**, **isHost**, **isPATH**.

  Ở ví dụ đây, ta sử dụng  **isHost** để check condition.

  > URL: https://api.coronavirus.data.gov.uk/v1/data

  thì:

  > Host: api.coronavirus.data.gov.uk

Hàm **stub** này sẽ trả về một HTTPStubResponse với các params:

* **fileAtPath**: chính là file json mà ta tự tạo ra xem như nó chính là data response từ server về.

  > Qua đó chúng ta thấy được rằng nhờ OHHTTPStubs mà chúng ta có thể control được response nó trả về như thế nào, dữ liệu ra sao để ta đạt được kết quả kì vọng đúng.

  ```swift
                      let path: String! = OHPathForFile("detail.json", type(of: self))
  ```

  ![image_008](../images/008.png) 

* **statusCode**:
  Chúng ta có thể control được mã trạng thái bằng cách nhập code mà mình mong muốn.

  **200**: Ok. Request đã được tiếp nhận và xử lý thành công.

  **400**: Bad Request. Server sẽ không thể xử lý hoặc sẽ không xử lý các request lỗi về phía client (request có cú pháp sai, ..)

  **500**: Internal Server Error: Lỗi server khi mà server gặp một sự cố nào đó.

  Còn nhiều statusCode khác nữa, tuỳ yêu cầu test những gì thì mình thay đổi statusCode thôi.

  Trong ví dụ này , thì chúng ta đang test 2 trường hợp cơ bản là success có data với statusCode là 200 và failure do bad request với status code là 400.

* **Header**: Tuỳ request đó có yêu cầu hay không, cần thì thêm vào không cần thì cho nó **nil**.

Ok! Vậy là chúng ta vừa tạo một stub để chuẩn bị cho việc test server.

Tiếp tục nào:

```swift
                waitUntil(timeout: DispatchTimeInterval.seconds(20)) { done in
                    viewModel.getDataCovid { _ in
                        expect(viewModel.covids.count) == 841
                        done()
                    }
                }
```

Chúng ta tiếp tục sử dụng hàm **waitUntil** của thư viện **Nimble** ở bài trước với param là **timeout** để thực hiện việc "chờ bất đồng bộ cho đến khi quá trình **done()** hoàn tất hoặc đã vượt quá timeout mà chúng ta cho phép"

Như trong ví dụ:

Nếu ta request lên server bằng cách gọi hàm **getDataCovid** vì một lí do nào đó mà quá thời gian 20s thì nó sẽ báo lỗi "timeout" như này.

![image_009](../images/009.png)

Chúng ta phải gọi closure **done()** để báo rằng quá trình đợi đã được hoàn thành. Nếu không gọi thì nó sẽ chạy ở trong đó mãi và đến thời gian timeout thì nó sẽ báo lỗi tương tự như trên.

```swift
                        expect(viewModel.covids.count) == 841
```

 Ở đây chúng ta có dựa vào **detail.json** mà chúng ta đã tạo ra để dự đoán số item của mảng **covids** mà server trả về có đúng hay không.

Còn trường hợp kiểm tra **case failure**, bạn chỉ cần đổi status code từ 200 -> 400 để request của chúng ta thành bad request và kì vọng mảng **covids** sẽ là rỗng.

```swift
                        expect(viewModel.covids.count) == 0
```

Đây là phần code tổng quan cho các bạn dễ hình dung hơn:

```swift
override func spec() {
        var viewModel: DetailViewModel!
        context("Test func getdataCovid") {
            beforeEach {
                viewModel = DetailViewModel()
            }
            it("Test api success") {
                stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
                    let path: String! = OHPathForFile("detail.json", type(of: self))
                    return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
                }

                waitUntil(timeout: DispatchTimeInterval.seconds(20)) { done in
                    viewModel.getDataCovid { _ in
                        expect(viewModel.covids.count) == 841
                        done()
                    }
                }
            }
            
            it("Test api failure") {
                stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
                    let path: String! = OHPathForFile("detail.json", type(of: self))
                    return HTTPStubsResponse(fileAtPath: path, statusCode: 400, headers: nil)
                }

                waitUntil(timeout: DispatchTimeInterval.seconds(20)) { done in
                    viewModel.getDataCovid { _ in
                        expect(viewModel.covids.count) == 0
                        done()
                    }
                }
            }
            afterEach {
                viewModel = nil
            }
        }
    }
```

 Từ đó, chúng ta test đủ cả 2 case success và failure để đảm bảo coverage toàn bộ. Chúng ta có thể control được được sự thay đổi server bằng một số thay đổi thôi qua trình giả lập stub. Còn nếu ta request trực tiếp thì đảm bảo với bạn nó vừa lâu, vừa gây spam và rất khó để handle để nó "**được lỗi**".

### 3.3. Advanced

Phần này không liên quan đến việc test nhưng có liên quan đến **OHHTTPStubs** thì mình cũng nói thêm những kinh nghiệm mà mình biết.

Trong một dự án có nhiều lúc BE không thể chạy trước vì một số lí do nên phía FE hay Mobile không nên đợi BE deploy xong mới làm vì vô cùng mất thời gian, ảnh hưởng đến dự án chung nên chúng ta có thể tận dụng khả năng của "**stub**" để "chạy trước BE" để xem chúng ta kiểm tra:

* Parse data đúng hay chưa?
* UI khi hiển thị dữ liệu nó đúng chưa?
* kiểm thử nhiều chức năng khác liên quan đến server.

Các bước thực hiện như sau:

**Step1**: Phía BE làm chưa xong nhưng chắc chắn có document json, xml example. Chúng ta hoàn toàn có thể copy đoạn json,xml mẫu đó xem như đó là response trả về và muốn response trả về như thế nào thì vào đó mà sửa (file tương tự như **detail.json** ở ví dụ trên).

**Step2**: Ở ViewModel chúng ta viết một hàm handle **stub** như sau:

```swift
    // handle stub
    func handleStub(completion: () -> Void) {
        stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
            let path: String! = OHPathForFile("detail.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
            completion()
        }
    }
```

File json, xml example phía BE đưa cho thì bỏ vào **OHPathForFile** nhé.

Step3: Ở viewController chúng ta thực thi như sau:

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
//        getDataCovid()
        viewModel.handleStub {
            self.getDataCovid()
        }
    }
```

Chúng ta chạy hàm **getDataCovid()** sau khi hàm **handleStub()** hoàn thành xong để đảm bảo sẽ có reponse trả về như ta mong muốn.
Còn đến khi nào phía BE họ deploy lên thì không cần dùng **stub** nữa, gọi trực tiếp như cũ.

> Hãy trên trọng stub đi, lúc chúng ta khó khăn thì chỉ có stub giúp chúng ta, thế thôi!!

Ví dụ trên request này đã có sẵn, đã được deploy. Còn khi các bạn làm một api mới hoàn toàn thì nhớ check document cho kĩ để thay đổi cái host hoặc check kĩ các json, xml của bạn đã đúng cấu trúc và các key đã đúng hay chưa. Nếu nó sai thì debug sửa lại cho đúng nhé :))

## 4. Tạm kết.

Bài viết đã hướng dẫn bạn cách sử dụng thư viện OHHTTPStubs để test những funcs liên quan đến api.
Và từ đó ta có thể kết hợp với bài trước và bài này để có thể test được toàn bộ một viewModel cụ thể nào đó.
Bạn có thể checkout code example ở [đây](https://github.com/thientam0809/basic-unittest).
