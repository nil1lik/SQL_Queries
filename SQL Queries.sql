--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, 
--`Phone`) almak için bir sorgu yazın.
Select p.product_id,p.product_name,s.company_name,s.phone from products p 
inner join suppliers s ON p.supplier_id = s.supplier_id
Where p.units_in_stock = 0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select e.first_name || ' ' || e.last_name as "AD SOYAD", o.ship_address, o.order_date from orders o
inner join employees e on o.employee_id=e.employee_id
where order_date between '1998-03-01' and '1998-03-29'

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(order_date) as "1997-02 Sipariş Adedi" from orders
where order_date between '1997-02-01' and '1997-02-28'

--29. London şehrinden 1998 yılında kaç siparişim var?
select * from orders
select count(order_date) from orders
where order_date between '1998-01-01' and '1998-01-31' and ship_city='London'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.company_name, c.phone, o.order_date from orders o
inner join customers c on o.customer_id = c.customer_id
where o.order_date between '1997-01-01' and '1997-12-31'
order by c.company_name ASC --group by'ı kullanamadım.

--31. Taşıma ücreti 40 üzeri olan siparişlerim
Select * from orders 
Where freight > 40 Order By freight

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
Select o.ship_city, c.contact_name, o.freight from orders o
inner join customers c ON o.customer_id = c.customer_id
Where freight > 40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
Select o.order_date, o.ship_city, Upper(e.first_name || ' ' ||  e.last_name) from orders o
inner join employees e ON o.employee_id = e.employee_id
Where date_part('YEAR',order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
Select Distinct c.contact_name, c.phone from orders o
inner join customers c ON o.customer_id = c.customer_id
Where date_part('YEAR',order_date) = 1997 AND o.ship_via > 0

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
Select o.order_date, c.contact_name, e.first_name || ' ' ||  e.last_name from orders o
inner join customers c ON o.customer_id = c.customer_id
inner join employees e On o.employee_id = e.employee_id

--36. Geciken siparişlerim?
Select * from orders
Where required_date < shipped_date 

--37. Geciken siparişlerimin tarihi, müşterisinin adı
Select o.order_date, o.required_date ||  ' < '  ||  o.shipped_date, c.contact_name
from orders o 
inner join customers c On o.customer_id = c.customer_id
Where required_date < shipped_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
Select p.product_name, c.category_name, o.ship_via from order_details od
inner join orders o On od.order_id = o.order_id
inner join products p ON od.product_id = p.product_id
inner join categories c ON p.category_id = c.category_id
Where o.order_id = 10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id ,  p.product_name, s.company_name from order_details od
inner join products p on od.product_id= p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where od.order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
Select p.product_name, o.ship_via from order_details od
inner join orders o ON od.order_id = o.order_id
inner join employees e ON o.employee_id = e.employee_id
inner join products p On od.product_id = p.product_id
Where e.employee_id = 3 AND date_part('YEAR',o.order_date) = 1997

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
Select e.employee_id, e.first_name || ' ' ||  e.last_name, od.quantity from orders o
inner join order_details od ON o.order_id = od.order_id
inner join employees e ON o.employee_id = e.employee_id
Where date_part('YEAR',order_date) = 1997 
Group BY e.employee_id, od.quantity
Order BY od.quantity desc limit 1

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
Select e.employee_id, e.first_name || ' ' ||  e.last_name, sum(od.quantity) from orders o
inner join order_details od ON o.order_id = od.order_id
inner join employees e ON o.employee_id = e.employee_id
Where date_part('YEAR',order_date) = 1997 
Group BY e.employee_id,od.quantity
Order BY od.quantity desc limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name,c.category_name,p.unit_price from products p
inner join categories c on p.category_id = c.category_id
order by p.unit_price DESC Limit 1

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name as "PERSONEL AD-SOYAD", o.order_id, o.order_date from orders o 
inner join employees e on e.employee_id = o.employee_id
order by o.order_date ASC

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
Select o.order_id, AVG(quantity * unit_price) from orders o 
inner join order_details od ON o.order_id = od.order_id
Group By o.order_id
Order By order_date Desc Limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
Select p.product_name, c.category_name, SUM(od.quantity) from order_details od
inner join orders o ON o.order_id = od.order_id
inner join products p ON od.product_id = p.product_id
inner join categories c ON c.category_id = p.category_id
Where date_part('Month',order_date) = 01
Group By p.product_name, c.category_id

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
Select * from orders o
inner join order_details od ON od.order_id = o.order_id
Where od.quantity > (Select AVG(quantity) from order_details)
Group By o.order_id,od.quantity,od.order_id,od.product_id

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.units_on_order, c.category_name, s.contact_name from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
order by units_on_order DESC LIMIT 1

--49. Kaç ülkeden müşterim var
select count(distinct country) as "Ülkelere göre müşteri adedi" from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
Select SUM(quantity * unit_price) from order_details od 
inner join orders o ON o.order_id = od.order_id
inner join employees e ON e.employee_id = o.employee_id
Where e.employee_id = 3 AND order_date >= DATE '1998-01-01' AND order_date <= current_date;

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
Select p.product_name, c.category_name, o.ship_via from order_details od
inner join orders o On od.order_id = o.order_id
inner join products p ON od.product_id = p.product_id
inner join categories c ON p.category_id = c.category_id
Where o.order_id = 10248

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
Select p.product_name, s.contact_name from order_details od
inner join orders o ON od.order_id = o.order_id
inner join products p ON od.product_id = p.product_id
inner join suppliers s ON p.supplier_id = s.supplier_id
Where o.order_id = 10248

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
Select p.product_name, o.ship_via from order_details od
inner join orders o ON od.order_id = o.order_id
inner join employees e ON o.employee_id = e.employee_id
inner join products p On od.product_id = p.product_id
Where e.employee_id = 3 AND date_part('YEAR',o.order_date) = 1997

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
Select e.employee_id, e.first_name || ' ' || e.last_name from orders o
inner join order_details od ON o.order_id = od.order_id
inner join employees e ON o.employee_id = e.employee_id
Where date_part('YEAR',order_date) = 1997 
Group BY e.employee_id, od.quantity
Order BY od.quantity desc limit 1

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select count(e.employee_id) as "MAX SATIŞ MİKTARI", e.first_name, e.last_name employee_id from orders o
inner join employees e on e.employee_id=o.employee_id
where extract(year from o.order_date) = 1997
group by e.employee_id
order by "MAX SATIŞ MİKTARI" DESC Limit 1

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name, unit_price, c.category_name from products p
inner join categories c on p.category_id=c.category_id
order by unit_price desc Limit 1

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name as "Employee Name", o.order_id, o.order_date from orders o
inner join employees e on o.employee_id=e.employee_id
order by o.order_date ASC

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
Select o.order_id as "Sipariş ID", AVG(quantity * unit_price) as "Ortalama Fiyat" from orders o 
inner join order_details od ON o.order_id = od.order_id
Group By o.order_id
Order By order_date Desc Limit 5

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,sum(od.quantity),o.order_date from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id=c.category_id
where date_part('month',o.order_date)=01
group by p.product_name,c.category_name,o.order_date

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select quantity from order_details
where quantity>(select avg(quantity) from order_details)

--61. En çok satılan(adet bazında) ürünümün adı, kategorisinin adı ve tedarikçisinin adı
select c.category_name,s.company_name,p.product_name,od.quantity from order_details od
inner join products p on p.product_id=od.product_id
inner join suppliers s on s.supplier_id=p.supplier_id
inner join categories c on c.category_id=p.category_id
order by od.quantity DESC LIMIT 1

--62. Kaç ülkeden müşterim var
select count(distinct country) from customers

--63. Hangi ülkeden kaç müşterimiz var
select count(country), country from customers
group by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.first_name || ' ' || e.last_name as "AD SOYAD", count(od.quantity) as "SATILAN ÜRÜN ADEDİ" from orders o
inner join order_details od on o.order_id=od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id=3 and o.order_date between date '1998-01-01' and current_date
group by e.first_name, e.last_name

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.unit_price*od.quantity) as "3 AYLIK CİRO" from order_details od
inner join products p on p.product_id=od.product_id
inner join orders o on o.order_id=od.order_id
where p.product_id=10 and o.order_date between date '1998-03-01' and current_date

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.first_name || ' ' || e.last_name as "AD SOYAD", count(od.quantity)  from orders o
inner join employees e on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.first_name, e.last_name, e.employee_id
order by e.employee_id

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id, c.company_name, c.contact_name from orders o
right join customers c on o.customer_id=c.customer_id
where o.customer_id isnull

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select contact_name, company_name, address, city, country from customers
where country='Brazil'
order by contact_name

--69. Brezilya’da olmayan müşteriler
select contact_name, country from customers
where country != 'Brazil'
order by contact_name

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select contact_name, country from customers
where country='Spain' or country='France' or country='Germany'
order by country

--71. Faks numarasını bilmediğim müşteriler
select contact_name, fax from customers
where fax is null
order by contact_name

--72. Londra’da ya da Paris’de bulunan müşterilerim
select contact_name, city from customers
where city='London' or city='Paris'
order by contact_name

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select contact_name,city,contact_title from customers
where city = 'México D.F.' and contact_title = 'Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where lower(product_name) like 'c%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees
where lower(first_name) like 'a%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select contact_name,company_name from customers
where lower(company_name) like '%restaurant%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100
order by unit_price

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between '1996-07-01' and '1996-12-31'
order by order_id

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select contact_name, country from customers
where country = 'Spain' or country = 'France' or country='Germany'
order by country

--80. Faks numarasını bilmediğim müşteriler
select contact_name, fax from customers
where fax is null
order by contact_name

--81. Müşterilerimi ülkeye göre sıralıyorum:
select contact_name, country
from customers
order by country

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price
from products
order by unit_price DESC

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price DESC, units_in_stock ASC --??

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(category_id) from products
where category_id = 1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct ship_country) from orders