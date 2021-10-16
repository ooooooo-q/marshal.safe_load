(Work in Progress) Marshal.safe_load
===

- [module Marshal](https://docs.ruby-lang.org/ja/latest/class/Marshal.html)
- [Marshal フォーマット](https://docs.ruby-lang.org/ja/latest/doc/marshal_format.html)


```ruby
❯ irb
irb(main):001:0> require './safe_load.rb'
=> true
irb(main):002:0> Marshal.safe_load(Marshal.dump({cat: "black"}))
=> {:cat=>"black"}
irb(main):003:0>  Marshal.load(Marshal.dump(Module))
=> Module
irb(main):004:0> Marshal.safe_load(Marshal.dump(Module))
...
StandardError (unexepected type Class)
```


```
# テスト実行
ruby test.rb
```