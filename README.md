## 値オブジェクト（Value object）とは

- エンティティ（固有IDで識別できるもの・同一性）ではなく、等価性（equality）でそれぞれの値を評価するオブジェクト
  - エンティティはIDで識別され、同等の属性を持っていてもIDが違えば異なるオブジェクトといえる
  - バリューオブジェクトは、同じ値を持つオブジェクトは同一オブジェクトとして扱われる
- 日付、住所、Eメールアドレス、金額などでよく使われる


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

Userモデルに`address`という属性がある場合、その属性に直接値を保存するのではなく、バリューオブジェクトとして住所を表現する。
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
  end
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
  - たとえばCompanyモデルが今後できたとして、会社の住所を登録するときにも上記のAddressオブジェクトを使って一貫性のあるデータ構造を実現できる
- テスタブルになる
  - むだに`user_spec.rb`が肥大化しない
- 簡潔なモデルになる
  - 別モデルに切り分けるため、Userモデルが肥大化しない

