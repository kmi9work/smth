#encoding: utf-8
require 'net/http'
require 'nokogiri'
require 'iconv'
class Vkuser < ActiveRecord::Base
  attr_accessible :vkid
  validates :vkid, :uniqueness => true
  has_one :dmp_admin_dmp_request_vkuser
  def dmp_admin
    dmp_admin_dmp_request_vkuser.try(:dmp_admin)
  end
  
  def set_dmp_admin_request admin, request
    dmp_admin_dmp_request_vkuser = DmpAdminDmpRequestVkuser.new
    dmp_admin_dmp_request_vkuser.dmp_request = request
    dmp_admin_dmp_request_vkuser.vkuser = self
    dmp_admin_dmp_request_vkuser.dmp_admin = admin
    dmp_admin_dmp_request_vkuser.save
  end
  
  def dmp_request
    dmp_admin_dmp_request_vkuser.try(:dmp_request)
  end
  
  def Vkuser.get_vkusers dmp_request, offset, dmp_admin #if returns nil --> vk DOM changed
    http = Net::HTTP.new('vk.com', 80)
    path = '/al_search.php'
    if dmp_request.query.present?
      query = "al=1&#{dmp_request.query}&offset=#{offset}"
    else
      query = "al=1&#{dmp_request.vk_attrs.delete_if{|k,v| v.blank? or v == 0}.map{|k, v| "c%5B#{k}%5D=#{v}"}.join('&')}&offset=#{offset}"
    end
    # puts query
    # data = 'al=1&c%5Bcountry%5D=1&c%5Bname%5D=1&c%5Bq%5D=trolo&c%5Bsection%5D=people&offset=40'
    headers = { 
      'X-Requested-With' => 'XMLHttpRequest', 
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Accept' => 'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap',
      'Accept-Encoding' => 'gzip, deflate',
      'Referer' => 'http://vk.com/al_search.php',
      'User-Agent' => 'Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }

    resp, data = http.post(path, query, headers)


    # Output on the screen -> we should get either a 302 redirect (after a successful login) or an error page
    # puts 'Code = ' + resp.code
    #     puts 'Message = ' + resp.message
    #     resp.each {|key, val| puts key + ' = ' + val}

    gz = Zlib::GzipReader.new(StringIO.new(data))    
    xml = Iconv.conv('UTF-8', 'CP1251', gz.read)
    # puts xml
    status = 2 if xml =~ /"has_more":false/
    doc = Nokogiri::HTML(xml)
    regex_id = Regexp.new(/Searcher\.bigphOver\(this, (\d+)\)/)
    matched = true
    vkusers = []
    fl = false
    last = -1
    doc.css('.img.search_bigph_wrap.fl_l').each_with_index do |div, i|
      if div['onmouseover']
        if div['onmouseover'].match(regex_id)
          fl = true
          vk_id = div['onmouseover'].match(regex_id)[1].to_i
          u = Vkuser.new(:vkid => vk_id)
          if u.valid?
            u.save
            u.set_dmp_admin_request dmp_admin, dmp_request
            vkusers << u
          end
        else
          matched = false
        end
      end
      last = i
    end
    status = 3 if vkusers.empty? #add offsets
    status = 0 unless fl
    status = 1 unless matched #vk DOM changed
    return vkusers, status
  end
  
  def Vkuser.get_countries
    ["Россия","Украина","Беларусь","Казахстан","Азербайджан","Армения","Грузия","Израиль","США","Канада","Кыргызстан","Латвия","Литва","Эстония","Молдова","Таджикистан","Туркменистан","Узбекистан","Австралия","Гана","Гваделупа","Гватемала","Гвинея","Гвинея-Бисау","Германия","Гибралтар","Гондурас","Гонконг","Гренада","Австрия","Албания","Алжир","Американское Самоа","Ангилья","Ангола","Андорра","Антигуа и Барбуда","Аргентина","Аруба","Боливия","Босния и Герцеговина","Ботсвана","Бразилия","Бруней-Даруссалам","Буркина-Фасо","Бурунди","Бутан","Вануату","Великобритания","Гренландия","Греция","Гуам","Дания","Доминика","Доминиканская Республика","Египет","Замбия","Западная Сахара","Зимбабве","Афганистан","Багамы","Бангладеш","Барбадос","Бахрейн","Белиз","Бельгия","Бенин","Бермуды","Болгария","Венгрия","Венесуэла","Виргинские острова, Британские","Виргинские острова, США","Восточный Тимор","Вьетнам","Габон","Гаити","Гайана","Гамбия","Индия","Индонезия","Иордания","Ирак","Иран","Ирландия","Исландия","Испания","Италия","Йемен","Кабо-Верде","Камбоджа","Камерун","Катар","Кения","Кипр","Кирибати","Китай","Колумбия","Коморы","Ливия","Лихтенштейн","Люксембург","Маврикий","Мавритания","Мадагаскар","Макао","Македония","Малави","Малайзия","Конго","Конго, демократическая республика","Коста-Рика","Кот д`Ивуар","Куба","Кувейт","Лаос","Лесото","Либерия","Ливан","Мали","Мальдивы","Мальта","Марокко","Мартиника","Маршалловы Острова","Мексика","Микронезия, федеративные штаты","Мозамбик","Монако","Монголия","Монтсеррат","Мьянма","Намибия","Науру","Непал","Нигер","Нигерия","Кюрасао","Нидерланды","Острова Кука","Острова Теркс и Кайкос","Пакистан","Палау","Палестинская автономия","Панама","Папуа - Новая Гвинея","Парагвай","Перу","Питкерн","Никарагуа","Ниуэ","Новая Зеландия","Новая Каледония","Норвегия","Объединенные Арабские Эмираты","Оман","Остров Мэн","Остров Норфолк","Острова Кайман","Саудовская Аравия","Свазиленд","Святая Елена","Северная Корея","Северные Марианские острова","Сейшелы","Сенегал","Сент-Винсент","Сент-Китс и Невис","Сент-Люсия","Польша","Португалия","Пуэрто-Рико","Реюньон","Руанда","Румыния","Сальвадор","Самоа","Сан-Марино","Сан-Томе и Принсипи","Сент-Пьер и Микелон","Сербия","Сингапур","Сирийская Арабская Республика","Словакия","Словения","Соломоновы Острова","Сомали","Судан","Суринам","Сьерра-Леоне","Таиланд","Тайвань","Танзания","Того","Токелау","Тонга","Тринидад и Тобаго","Тувалу","Тунис","Турция","Уганда","Уоллис и Футуна","Уругвай","Фарерские острова","Фиджи","Филиппины","Финляндия","Фолклендские острова","Франция","Черногория","Джибути","Южный Судан","Ватикан","Синт-Мартен","Бонайре, Синт-Эстатиус и Саба","Шри-Ланка","Эквадор","Экваториальная Гвинея","Эритрея","Эфиопия","Южная Корея","Южно-Африканская Республика","Ямайка","Япония","Французская Гвиана","Французская Полинезия","Хорватия","Центрально-Африканская Республика","Чад","Чехия","Чили","Швейцария","Швеция","Шпицберген и Ян Майен"]
  end

  def Vkuser.get_cities country, str
    act = "a_get_cities"
    ans = get_search_ajax act, country, nil, str
    ans.scan(/\['\d+?','(.+?)','.+?','\d+?'\]/u).flatten
  end

  def Vkuser.get_universities country, city, str
    act = "a_get_universities"
    ans = get_search_ajax act, country, city, str
    # puts ans
    if country == 0 and city == 0
      ans.scan(/\[\"\d+?\",\"(.+?)\"\]/u).flatten
    else
      ans.scan(/\[\"\d+?\",\"(.+?)\"\]/u).flatten
    end
  end

  def Vkuser.get_schools city, str
    act = "a_get_schools"
    ans = get_search_ajax act, nil, city, str
    ans.scan(/\[\d+?,\"(.+?)\"\]/u).flatten
  end
  
  def Vkuser.get_school_id city, str
    act = "a_get_schools"
    buf_str = str
    if str =~ /(\d+)/
      str = $1
    end
    ans = get_search_ajax act, nil, city, str
    ans.match(/\[(\d+?),\".*?#{str}.*?\"\]/u)[1].to_i
  end
  
  def Vkuser.get_university_id country, city, str
    act = "a_get_universities"
    ans = get_search_ajax act, country, city, str
    p ans
    ans.match(/\[\"(\d+?)\",\".*?#{str}.*?\"\]/u)[1].to_i
  end
  
  def Vkuser.get_city_id country, str
    act = "a_get_cities"
    ans = get_search_ajax act, country, nil, str
    # puts ans
    ans.match(/\['(\d+?)','#{str}','.+?','\d+?'\]/u)[1].to_i
  end
  
  def Vkuser.get_country_id str
    countries = {"Россия"=>1,"Украина"=>2,"Беларусь"=>3,"Казахстан"=>4,"Азербайджан"=>5,"Армения"=>6,"Грузия"=>7,"Израиль"=>8,"США"=>9,"Канада"=>10,"Кыргызстан"=>11,"Латвия"=>12,"Литва"=>13,"Эстония"=>14,"Молдова"=>15,"Таджикистан"=>16,"Туркменистан"=>17,"Узбекистан"=>18,"Австралия"=>19,"Гана"=>60,"Гваделупа"=>61,"Гватемала"=>62,"Гвинея"=>63,"Гвинея-Бисау"=>64,"Германия"=>65,"Гибралтар"=>66,"Гондурас"=>67,"Гонконг"=>68,"Гренада"=>69,"Австрия"=>20,"Албания"=>21,"Алжир"=>22,"Американское Самоа"=>23,"Ангилья"=>24,"Ангола"=>25,"Андорра"=>26,"Антигуа и Барбуда"=>27,"Аргентина"=>28,"Аруба"=>29,"Боливия"=>40,"Босния и Герцеговина"=>41,"Ботсвана"=>42,"Бразилия"=>43,"Бруней-Даруссалам"=>44,"Буркина-Фасо"=>45,"Бурунди"=>46,"Бутан"=>47,"Вануату"=>48,"Великобритания"=>49,"Гренландия"=>70,"Греция"=>71,"Гуам"=>72,"Дания"=>73,"Доминика"=>74,"Доминиканская Республика"=>75,"Египет"=>76,"Замбия"=>77,"Западная Сахара"=>78,"Зимбабве"=>79,"Афганистан"=>30,"Багамы"=>31,"Бангладеш"=>32,"Барбадос"=>33,"Бахрейн"=>34,"Белиз"=>35,"Бельгия"=>36,"Бенин"=>37,"Бермуды"=>38,"Болгария"=>39,"Венгрия"=>50,"Венесуэла"=>51,"Виргинские острова, Британские"=>52,"Виргинские острова, США"=>53,"Восточный Тимор"=>54,"Вьетнам"=>55,"Габон"=>56,"Гаити"=>57,"Гайана"=>58,"Гамбия"=>59,"Индия"=>80,"Индонезия"=>81,"Иордания"=>82,"Ирак"=>83,"Иран"=>84,"Ирландия"=>85,"Исландия"=>86,"Испания"=>87,"Италия"=>88,"Йемен"=>89,"Кабо-Верде"=>90,"Камбоджа"=>91,"Камерун"=>92,"Катар"=>93,"Кения"=>94,"Кипр"=>95,"Кирибати"=>96,"Китай"=>97,"Колумбия"=>98,"Коморы"=>99,"Ливия"=>110,"Лихтенштейн"=>111,"Люксембург"=>112,"Маврикий"=>113,"Мавритания"=>114,"Мадагаскар"=>115,"Макао"=>116,"Македония"=>117,"Малави"=>118,"Малайзия"=>119,"Конго"=>100,"Конго, демократическая республика"=>101,"Коста-Рика"=>102,"Кот д`Ивуар"=>103,"Куба"=>104,"Кувейт"=>105,"Лаос"=>106,"Лесото"=>107,"Либерия"=>108,"Ливан"=>109,"Мали"=>120,"Мальдивы"=>121,"Мальта"=>122,"Марокко"=>123,"Мартиника"=>124,"Маршалловы Острова"=>125,"Мексика"=>126,"Микронезия, федеративные штаты"=>127,"Мозамбик"=>128,"Монако"=>129,"Монголия"=>130,"Монтсеррат"=>131,"Мьянма"=>132,"Намибия"=>133,"Науру"=>134,"Непал"=>135,"Нигер"=>136,"Нигерия"=>137,"Кюрасао"=>138,"Нидерланды"=>139,"Острова Кука"=>150,"Острова Теркс и Кайкос"=>151,"Пакистан"=>152,"Палау"=>153,"Палестинская автономия"=>154,"Панама"=>155,"Папуа - Новая Гвинея"=>156,"Парагвай"=>157,"Перу"=>158,"Питкерн"=>159,"Никарагуа"=>140,"Ниуэ"=>141,"Новая Зеландия"=>142,"Новая Каледония"=>143,"Норвегия"=>144,"Объединенные Арабские Эмираты"=>145,"Оман"=>146,"Остров Мэн"=>147,"Остров Норфолк"=>148,"Острова Кайман"=>149,"Саудовская Аравия"=>170,"Свазиленд"=>171,"Святая Елена"=>172,"Северная Корея"=>173,"Северные Марианские острова"=>174,"Сейшелы"=>175,"Сенегал"=>176,"Сент-Винсент"=>177,"Сент-Китс и Невис"=>178,"Сент-Люсия"=>179,"Польша"=>160,"Португалия"=>161,"Пуэрто-Рико"=>162,"Реюньон"=>163,"Руанда"=>164,"Румыния"=>165,"Сальвадор"=>166,"Самоа"=>167,"Сан-Марино"=>168,"Сан-Томе и Принсипи"=>169,"Сент-Пьер и Микелон"=>180,"Сербия"=>181,"Сингапур"=>182,"Сирийская Арабская Республика"=>183,"Словакия"=>184,"Словения"=>185,"Соломоновы Острова"=>186,"Сомали"=>187,"Судан"=>188,"Суринам"=>189,"Сьерра-Леоне"=>190,"Таиланд"=>191,"Тайвань"=>192,"Танзания"=>193,"Того"=>194,"Токелау"=>195,"Тонга"=>196,"Тринидад и Тобаго"=>197,"Тувалу"=>198,"Тунис"=>199,"Турция"=>200,"Уганда"=>201,"Уоллис и Футуна"=>202,"Уругвай"=>203,"Фарерские острова"=>204,"Фиджи"=>205,"Филиппины"=>206,"Финляндия"=>207,"Фолклендские острова"=>208,"Франция"=>209,"Черногория"=>230,"Джибути"=>231,"Южный Судан"=>232,"Ватикан"=>233,"Синт-Мартен"=>234,"Бонайре, Синт-Эстатиус и Саба"=>235,"Шри-Ланка"=>220,"Эквадор"=>221,"Экваториальная Гвинея"=>222,"Эритрея"=>223,"Эфиопия"=>224,"Южная Корея"=>226,"Южно-Африканская Республика"=>227,"Ямайка"=>228,"Япония"=>229,"Французская Гвиана"=>210,"Французская Полинезия"=>211,"Хорватия"=>212,"Центрально-Африканская Республика"=>213,"Чад"=>214,"Чехия"=>215,"Чили"=>216,"Швейцария"=>217,"Швеция"=>218,219 => "Шпицберген и Ян Майен"}
    countries[str]
  end
  
  def Vkuser.clean
    size = Vkuser.where(sent: false).find(:all, :conditions => ['created_at < ?', 1.hour.ago]).each{|i| i.destroy}.size
    if size > 0
      DmpRequest.all{|d| d.offset = d.start_offset; d.save}
    end
  end
  
  protected

  def Vkuser.get_search_ajax act, country, city, str
    data = "act=#{act}"
    data += "&country=#{country}" if country
    data += "&city=#{city}" if city
    data += "&str=#{str}" if str
    # puts "request: #{data}"
    # data = Iconv.conv('CP1251', 'UTF-8', data)
    headers = { 
      'X-Requested-With' => 'XMLHttpRequest', 
      'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.3',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Accept' => 'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap',
      'Accept-Encoding' => 'gzip, deflate',
      'Referer' => 'http://vk.com/al_search.php',
      'User-Agent' => 'Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    path = '/select_ajax.php'
    http = Net::HTTP.new('vk.com', 80)
    response_info, response_data = http.post(path, data, headers)
    resp_encoding = response_info["content-type"].match(/charset=(.+)/)[1]
    gz = Zlib::GzipReader.new(StringIO.new(response_data))   
    Iconv.conv('UTF-8', resp_encoding, gz.read)
  end
end
#====================================END CODE+++++++++++++++++++++++++++++++++
  
  #-----------------------------------------------------------------------------
  # a_get_country_info
  # 0 -- country
  # 1 -- cities
  # 10 -- edu_form
  # 100 -- edu_statuses
  # 1000 -- classes
  # a_get_city_info
  # 0 -- city
  # 1 -- stations(metro)
  # 10 -- districts
  # 100 -- schools
  # 1000 -- universities
  # 
  # a_get_schools
  # str
  #   
  #    
  #    
  #    
  #    
  #    
  #    
  #    
  #    
  #    
  #    
  #    
  #    

  # def Vkuser.get_ajax
  #     fout_schools = File.open('vk_schools.txt', 'w')
  #     fout_universities = File.open('vk_universities.txt', 'w')
  #     f = File.open('vk_cities.txt','r')
  #     cities = []
  #     while f.gets
  #       if $_ =~ /cid::(\d+) name::(.+)/
  #         cities << $1.to_i
  #       end
  #     end
  # 
  #     http = Net::HTTP.new('vk.com', 80)
  #     path = '/select_ajax.php'
  #     act = 'a_get_city_info'
  #     fields_schools = 100
  #     fields_universities = 1000
  #     cities.each do |city|
  #       puts city
  #       fout_schools.puts "city_id: #{city} -----"
  #       fout_universities.puts "city_id: #{city} -----"
  #       data_schools = "act=#{act}&city=#{city}&fields=#{fields_schools}"
  #       data_universities = "act=#{act}&city=#{city}&fields=#{fields_universities}"
  #       # data = 'al=1&c%5Bcountry%5D=1&c%5Bname%5D=1&c%5Bq%5D=trolo&c%5Bsection%5D=people&offset=40'
  #       headers = { 
  #         'X-Requested-With' => 'XMLHttpRequest', 
  #         'Accept-Charset' => 'utf-8',
  #         'Content-Type' => 'application/x-www-form-urlencoded',
  #         'Accept' => 'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap',
  #         'Accept-Encoding' => 'gzip, deflate',
  #         'Referer' => 'http://vk.com/al_search.php',
  #         'User-Agent' => 'Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9',
  #         'Content-Type' => 'application/x-www-form-urlencoded'
  #       }
  # 
  #       resp_schools, data_schools = http.post(path, data_schools, headers)
  #       sleep(1)
  #       resp_universities, data_universities = http.post(path, data_universities, headers)
  #       sleep(1)
  #       # Output on the screen -> we should get either a 302 redirect (after a successful login) or an error page
  #       # puts 'Code = ' + resp.code
  #       # puts 'Message = ' + resp.message
  #       # resp.each {|key, val| puts key + ' = ' + val}
  #       # puts data
  #       gz = Zlib::GzipReader.new(StringIO.new(data_schools))    
  #       fout_schools.puts Iconv.conv('UTF-8', 'CP1251', gz.read)
  # 
  #       gz = Zlib::GzipReader.new(StringIO.new(data_universities))    
  #       fout_universities.puts Iconv.conv('UTF-8', 'CP1251', gz.read)
  #     end
  #     fout_universities.close
  #     fout_schools.close
  #   end
  # 
  # end
=begin
{
:age_from => 14,                          #Возраст С
:age_to => 16,                            #Возраст ДО 

:country => 1,                            #Страна
:city => 49,                              #Город 

:sex => 2,                                #Пол: 1 - Женский, 2 - Мужской
:status => 1,                             #Семейное положение (1 - не женат, 2 - Есть подруга, 3 - Помолвлен, 4 - Женат, 5 - Влюблён, 6 - Всё сложно, 7 - В активном поиске)

alcohol => 1,                            #Отношение к алкоголю (1-5)
:smoking => 2,                            #Отношение к курению (1-5)
:people_priority => 1,                    #Главное в людях(1 - ум и креативность, 2 - доброта и честность, 3 - красота и здоровье, 4 - власть и богатство, 5 - смелость и упорство, 6 - юмор и жизнелюбие)
:personal_priority => 1,                  #Главное в жизни(1 - семья и дети, 2 - карьера и деньги, 3 - развлечения и отдых, 4 - наука и исследования, 5 - совершенствование мира, 6 - саморазвитие, 7 - красота и искусство, 8 - слава и влияние)

:school => 49644,                         #Школа
:school_year => 2016,                     #Год окончания школы

:university => 469,                       #Универ
:uni_year => 2017,                        #Год окончания универа 

:online => 1,                             #Онлайн
:photo => 1,                              #Наличие фото




:age_from => 14,                          #Возраст С
:age_to => 16,                            #Возраст ДО 

:bday => 3,                               #День рождения
:bmonth => 3,                             #Месяц рождения
:byear => 1996,                           #Год рождения
:country => 1,                            #Страна
:city => 49,                              #Город 

:sex => 2,                                #Пол: 1 - Женский, 2 - Мужской
:status => 1,                             #Семейное положение (1 - не женат, 2 - Есть подруга, 3 - Помолвлен, 4 - Женат, 5 - Влюблён, 6 - Всё сложно, 7 - В активном поиске)

:mil_country => 1,                        #Военная служба -- Страна
:mil_unit => 84,                          #Военная служба -- Часть
:mil_year_from => 2005,                   #Военная служба -- Год начала службы

:alcohol => 1,                            #Отношение к алкоголю (1-5)
:smoking => 2,                            #Отношение к курению (1-5)
:people_priority => 1,                    #Главное в людях(1 - ум и креативность, 2 - доброта и честность, 3 - красота и здоровье, 4 - власть и богатство, 5 - смелость и упорство, 6 - юмор и жизнелюбие)
:personal_priority => 1,                  #Главное в жизни(1 - семья и дети, 2 - карьера и деньги, 3 - развлечения и отдых, 4 - наука и исследования, 5 - совершенствование мира, 6 - саморазвитие, 7 - красота и искусство, 8 - слава и влияние)


:school => 49644,                         #Школа
:school_class => 3,                       #Буква класса
:school_year => 2016,                     #Год окончания школы

:company => %D0%BC%D0%B3%D0%B8%D1%83,     #Название компании
:position => ,                            #Должность 

:university => 469,                       #Универ
:faculty => 16323,                        #Факультет
:chair => 37946                           #Кафедра
:uni_year => 2017,                        #Год окончания универа 

:name => 1,                               #Поиск только в именах
:online => 1,                             #Онлайн
:photo => 1,                              #Наличие фото
:section => people,                       #Выбирать только людей
}
=end
