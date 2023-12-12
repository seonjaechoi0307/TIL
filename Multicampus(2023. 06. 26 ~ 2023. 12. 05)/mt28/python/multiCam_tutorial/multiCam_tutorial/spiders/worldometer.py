import scrapy


class WorldometerSpider(scrapy.Spider):
    name = "worldometer"
    allowed_domains = ["www.worldometers.info"]
    start_urls = ["https://www.worldometers.info/world-population/population-by-country"]

    # step 01
    def parse(self, response):
        '''
        title = response.xpath('//h1/text()').get()
        countries = response.xpath('//tbody/tr/td/a/text()').getall()

        # 'a' 요소 추출 for each country

        yield {
            'title' : title,
            'countries' : countries
        }
        pass
        '''

        # step 02
        '''
        countries = response.xpath('//tbody/tr/td/a')
        for country in countries:
            country_name = country.xpath(".//text()").get() # country = '//tbody/tr/td/a/.text()'
            # link
            link =  country.xpath(".//@href").get() # link = '//tbody/tr/td/a href

            yield {
                'country_name': country_name,
                'link' : link
            }
        '''
        #step 03
        countries = response.xpath('//tbody/tr/td/a')

        for country in countries:
            country_name = country.xpath(".//text()").get()
            link = country.xpath(".//@href").get()

            # 다른 페이지로 넘어가려면 URL
            # 절대 경로    '/world-population/saint-helena-population/'}
            # absolute_url = f'https://www.worldometers.info/{link}'

            # absolute_url = response.urljoin(link)
            # yield scrapy.Request(url=absolute_url) # request with absolute url
            # 상대경로
            yield response.follow(url=link, callback=self.parse_country, meta = {'country' : country_name})

            # 상대경로(* scrapy에서 상대경로!! )
    def parse_country(self, response):
        country = response.request.meta['country']
        if country == "South Korea":
            rows = response.xpath('(//table[contains(@class, "table")])[1]/tbody/tr')
            for row in rows:
                year = row.xpath("td[1]/text()").get()
                population = row.xpath("td/strong/text()").get()

                yield {
                    'country' : country,
                    'year' : year,
                    'population' : population
                }
