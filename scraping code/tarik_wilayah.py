# -*- coding: utf-8 -*-
"""
Created on Thu Mar 17 11:32:43 2022

@author: MIKAEL
"""

from bs4 import BeautifulSoup
import requests
import pandas as pd
import csv

areaarea = []
with open('C:/Users/MIKAEL/Documents/Tugas Akhir/kode-wilayah.csv', newline='') as inputfile:
    for row in csv.reader(inputfile):
        areaarea.append(row[0])

arealist = ["026000", "020600", "021200","022000","022100","020700","000000"]
df = pd.DataFrame(columns = ['Wilayah','Arealist'])

for i in areaarea:
    url = ('http://statistik.data.kemdikbud.go.id//index.php/statistik/table/sma/2020/' + str(i) + '/1/25')
    headers = { "user-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36'}
    res = requests.get(url, headers = headers)
    soup = BeautifulSoup(res.content, 'html.parser')
    
    area = str(i)
    wilayah = soup.select_one('table', class_ = 'table_stat')
    
    try: 
        wilayah = wilayah.find('tfoot').find(class_ = 'borderbottomtop textBold').get_text()
    except:
        wilayah = None

    
    df = df.append({'Wilayah': wilayah, 'Arealist': area}, ignore_index = True)

df7 = df[~df.Wilayah.str.contains("Prov.", na=False)]
df7 = df7.drop_duplicates()
df8 = df7.drop([0,1]).reset_index()
df8 = df8.drop(columns=['Wilayah','index'])

df8.to_csv('data_wilayah_mapping_real.csv', index=False)


    