## 値オブジェクト（Value object）とは

- エンティティ（固有 ID で識別できるもの・同一性）ではなく、等価性（equality）でそれぞれの値を評価するオブジェクト
  - エンティティは ID で識別され、同等の属性を持っていても ID が違えば異なるオブジェクトといえる
  - バリューオブジェクトは、同じ値を持つオブジェクトは同一オブジェクトとして扱われる
- 日付、住所、E メールアドレス、金額などでよく使われる

エンティティの場合

```ruby
class User
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end
end

user1 = User.new(1, "Alice")
user2 = User.new(1, "Bob")

# user1とuser2はIDが同じだから、同じユーザーとみなされる
```

バリューオブジェクトの場合

```ruby
class Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def ==(other)
    other.is_a?(Money) && amount == other.amount && currency == other.currency
  end
end

money1 = Money.new(100, "JPY")
money2 = Money.new(100, "JPY")

# money1とmoney2は同じ値だから、同一のオブジェクトとみなされる
```

## 用途の一例

User モデルに`address`という属性がある場合、その属性に直接値を保存するのではなく、バリューオブジェクトとして住所を表現する。
住所はいろんなフォーマットやバリデーションが予想されることが多い類の属性となるが、それをバリューオブジェクト内に閉じ込めてカプセル化し、データに一貫性をもたせることができる。また、テスタブルにすることができる。

```ruby
class User
  attr_reader :name, :address

  def initialize(name:, address:)
    @name = name
    @address = address # Addressオブジェクトをセット
  end
end


class Address
  attr_reader :postal_code, :city, :street

  def initialize(postal_code:, city:, street:)
    @postal_code = postal_code
    @city = city
    @street = street
  end

  # 等価性を定義。値が同じ場合は同一のアドレスとみなす
  def ==(other)
    other.is_a?(Address) &&
      postal_code == other.postal_code &&
      city == other.city &&
      street == other.street
  **end**
end
```

```ruby
# バリューオブジェクトを生成
address = Address.new(postal_code: "123-4567", city: "Sapporo", street: "1-2-3")

# Userモデルにバリューオブジェクトをセット
user = User.new(name: "Taro", address: address)

# 住所を表示
puts user.address.city  # "Sapporo"
```

## メリット

- データに一貫性をもたせられる
  - 上記例でいえば、住所に関するロジックを一箇所にまとめられる
- 再利用性
  - たとえば Company モデルが今後できたとして、会社の住所を登録するときにも上記の Address オブジェクトを使って一貫性のあるデータ構造を実現できる
- テスタブルになる
  - むだに`user_spec.rb`が肥大化しない
- 簡潔なモデルになる
  - 別モデルに切り分けるため、User モデルが肥大化しない

---

## `hash`メソッドを実装している理由

値オブジェクトでは、以下のように`hash`メソッドをオーバーライドされることがある。

```ruby
def hash
  [prefecture, city, street, postal_code].hash
end
```

値オブジェクトでは、同じ値を持っていれば同じオブジェクトとする特徴がある。よって、`address1.hash`と`address2.hash`は同じ値を返すことになり、同一オブジェクトと認識される。

```ruby
# 同じ属性のオブジェクトを宣言する
value-object(dev)> address1 = Address.new("Tokyo", "Shibuya", "Dogenzaka", "1500043")
=> #<Address:0x000000010bf72360 @city="Shibuya", @postal_code="1500043", @prefecture="Tokyo", @street="Dogenzaka">
value-object(dev)> address2 = Address.new("Tokyo", "Shibuya", "Dogenzaka", "1500043")
=> #<Address:0x000000010be78180 @city="Shibuya", @postal_code="1500043", @prefecture="Tokyo", @street="Dogenzaka">
value-object(dev)> address1.hash == address2.hash
=> true
```

`hash`メソッドを実装しなければ、`address1.hash`と`address2.hash`はそれぞれ異なるハッシュ値を返すため、同一性が担保できない。

```ruby
value-object(dev)> address1 = Address.new("Tokyo", "Shibuya", "Dogenzaka", "1500043")
=> #<Address:0x000000010e155e28 @city="Shibuya", @postal_code="1500043", @prefecture="Tokyo", @street="Dogenzaka">
value-object(dev)> address2 = Address.new("Tokyo", "Shibuya", "Dogenzaka", "1500043")
=> #<Address:0x000000010e4b0eb0 @city="Shibuya", @postal_code="1500043", @prefecture="Tokyo", @street="Dogenzaka">
value-object(dev)> address1.hash == address2.hash
=> false
value-object(dev)>
```
