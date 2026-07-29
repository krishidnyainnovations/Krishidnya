after new registration or new login redirect user to the home screen where use can see everything he wanted.
 in our previous version of app:
at home screen we had this features 
1st section is of auto scrolling banners which were mainly: 
1. Government Schemes - After clicking on this banner user was able to see all the giovernment schemes which are benificial for farmers all the schemes were listed here. and if farmer is intrested in any of those schemes he can simply click on apply button and after clicking that apply button we ask them their name , and mobile number and after receiving those detailes on our web admin dasboard our  backloffice team will fill those forms for the farmers so we can make some revenue. 
2. second section was wearther banner card where we were fetching weather from openweathermap api  key and abd from that we were showing users locations weather data and aftwer clicking on that data user will be able to see next 15 days weather forecast. 

3. 3rd banner was of ads banner where we were serving few ads freom admob. 

below those banners section we had quick Actions section 
where we gave them few cards in 3x3 grid  like  
1. Crop Recommendation: after clicking on this user were asked to select soil type, season, area of farm and type of watering farms like sprincler, drip, flood etc.,  card user was getting top 4 crops recommendation on the basis   of their soil data and weather predictions. so here we were passing data from soil APi key, Current location and weather APi to the Gemini API key and based on that  gemini were reasining that data and it were recommending  the  top 4 crops. with detailed data like Weatehr analysis  which included temp, humidity, expexted rain.  
then below that top 4 crops we were recommending  each in expandable section  after expanding there was detailed info like why should they grow that crop, water required, days to  harwest, period of that crop, expeted profit etc etc. 

next section of quick actions was  Scan Crop: user were able to click picture of their crop and upload and on upload we were passing that image to gemini gain and it was detecting the disease of that plant. then on disease detetection we were suggesting chemical cure and organic cure both to the farmer with complete guiadance of dosages, and which exact product to use with the exact diages per ltr  for precision farming. we were triucking psylogically to farmerds to use  organic products.



 3rd was Market Place:  in this sections farmers can trade in between they anything tehy wanted to they can rent out their agriculturral machenaries  for  example farnmer A wants Tractor for cultivation and Farmer B listed his tractor for rent  so they can rent out in between.  and many pother things they have literally anything. like if  any farmers wants to sell their cow they can list there. 
 
 4th view history: all the crops history and soil history. , 
5th Mandi Prices: From api.gov.in we were fetching local mandi prices of all crops daily and farmes can easily see their crops market value everyday. 

6th Analytics : here farmes can do their farms or every crops  planing  like farmer has 2 crops like 1 is Onion 2nd is cotton so he can add all crops by clicking on Add crop and  soafter clicking o n add crop he will enter details like crop name, area, date of sowing, etc.  and add that crop 
after adding that crop he can click andopen that crops section and after opening   specific crop  farmersd can easily add  other things date wise like fertilizer given to the crop wioth  date and price of fertilizer, then spraying date with proices, cultivation dates and  prices etc etc, every thing and at then end after saving it  everytime all the expences should be auto calculated. and after harvesting that crop and selling in martket farmer can enter selling value of total field and it will calculate profit, margin , monthly income based on that  prices, so eveyrthing it will inclued :
below is the example for onion crop :
so step 1 for growing onion is to preapear field which includes twice cultivation of field , then making grids and  for plating onion. after preperation second we will require labor so labour cost will be there. if field takes 2 days to complete planting the cost will be double so 1 labour pair costs around 700-800 rs per day it depends ion region and location. after planting 3rd is like spraying of tonic or any fertilizer within 10-15 days  so this will be cost of spray an dalso it requires fertilizers like 10:26:26, urea those costes will  be there.  after month from day 30 to 35 or 40 again labour cost will be there for crop cultivation (like removing herbs from crops) etc and there are at least 3  in crop cultivations there in entire lifecycle of onion crop which is typically of 85-100 days.                                                                                                                                                                                                                                                      so this section is basically  digital notebook, logbook or a recod=rd boom for farmmers. 

and last we have  botton navigation bar whic has this sections
1. Home
2. Chat : AI chatBot for queries resolution of  farmes by typing or by voice typing. 
3. Scan Crop an quite large camera Icon to scan Crop 
4. Community: SOcialisation section for farmers where   farmers can post uopdated about their crops or anythjing sahrebale with all apps users(its basically social medai section for the farmers.)
5. Profile : farmers can manage their profile here laso a-pp settings, terms and conditions etc etc corporate and legal thing are here with delete account request button and all
                                                                                                                                                                                                                                                                                                                                         
