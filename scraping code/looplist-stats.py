from bs4 import BeautifulSoup
import requests
import pandas as pd
import csv

areaarea = []
with open('C:/Users/MIKAEL/Documents/Tugas Akhir/kode-wilayah.csv', newline='') as inputfile:
    for row in csv.reader(inputfile):
        areaarea.append(row[0])

arealist = ["026000", "020600", "021200","022000","022100","020700"]
df = pd.DataFrame(columns = ['Kecamatan','Baik','Rusak Ringan','Rusak Sedang','Rusak Berat','Rusak Total','Total'])

for i in areaarea:
    url = ('http://statistik.data.kemdikbud.go.id//index.php/statistik/table/sma/2020/' + str(i) + '/1/25')
    headers = { "user-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36'}
    res = requests.get(url, headers = headers)
    soup = BeautifulSoup(res.content, 'html.parser')

    kecamatan = []
    baik = []
    rringan = []
    rsedang = []
    rberat = []
    rtotal = []
    total = []
    
    table = soup.find('table', class_ = 'table_stat').find('tbody')
    
    for el in table.select('td:nth-of-type(2)'):
        kecamatan.append(el.get_text())
        
    for ol in table.select('td:nth-of-type(3)'):
        baik.append(ol.get_text())
        
    for il in table.select('td:nth-of-type(4)'):
        rringan.append(il.get_text())
        
    for al in table.select('td:nth-of-type(5)'):
        rsedang.append(al.get_text())
    
    for il in table.select('td:nth-of-type(6)'):
        rberat.append(il.get_text())
    
    for ul in table.select('td:nth-of-type(6)'):
        rtotal.append(ul.get_text())
    
    for zl in table.select('td:nth-of-type(8)'):
        total.append(zl.get_text())

    for k in range(len(kecamatan)):
        df = df.append({'Kecamatan': kecamatan[k], 'Baik': baik[k], 'Rusak Ringan': rringan[k], 'Rusak Sedang': rsedang[k], 'Rusak Berat': rberat[k], 'Rusak Total': rtotal[k], 'Total': total[k]}, ignore_index = True)
    

df.to_csv('kondisi_kelas_all.csv', index=False)