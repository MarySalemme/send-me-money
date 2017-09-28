# Send Me Money

### Instructions
`$ git clone https://github.com/MarySalemme/send-me-money.git`  
`$ cd send-me-money`  
`$ bundle`  
`$ touch config.yml`
open `config.yml` and write:
```
coolpay_username: 'ReplaceWithYourUsername'
coolpay_apikey: 'replace-with-your-key'
```   
launch the app with `shotgun config.ru`  
run the tests with `rspec`
