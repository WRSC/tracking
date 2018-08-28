--Token to test the new website version
print("Script startup\r\n")
vmsleep(5000)
sio.send('at+cpin=1234\r\n')
vmsleep(15000)
sio.send('at+cgps=1\r\n')
vmsleep(10000)
sio.send('at+netopen=,,1\r\n')
vmsleep(10000)
sio.send('at+printdir=1\r\n')

-- The version I got from Sylvain had a token here. I've removed it from the
-- public version, but we can find it if needed. -TK
token = ""



tracker_id = '"6"'
mesLats=''
mesLons=''
mesdatetimes=''
messpeeds=''
mescourses=''
comp=1;
nameFileLatitude=''
nameFileLongitude=''
nameFileDatetime=''
nameFileSpeed=''
nameFileCourse=''
date=''
--os.remove("D:/latitude.txt")
--os.remove("D:/longitude.txt")
--os.remove("D:/datetime.txt")

-- Define script lua envois
-- file=io.open("envois.lua","w")
-- print (file)
-- print("\n \r")
--file:write("printdir(1) \n print(\"Demarrage envois \\r \\n\") \n cmd1=\'at+chttpact=\"haggis.ensta-bretagne.fr\",3000 \\r \' \n file2=io.open(\"donnee.txt\",\"r\") \n str10=file2:read(\"*all\") \n file2:close() \n reponce=os.remove(\"donnee.txt\") \n print(\"\\n \\r\") \n print(\"os.remove=\") \n print(reponce) \n print(\"\\n \\r\") \n print(\"\\n \\r\") \n print(\"\\n\\r\") \n print(\"str10=\") \n print(str10) \n print(\" \\n \\r\") \n print(\"\\n \\r\") \n sio.send(cmd1); \n rtc1=sio.recv(5000) \n vmsleep(5000) \n print(\"rtc1=\") \n print(rtc1, \" \\r \\n\") \n sio.send(str10); \n rtc2=sio.recv(5000) \n vmsleep(5000) \n print(\"rtc2=\") \n print(rtc2, \" \\r \\n\") \n print(\"Fin envois\\r\\n\") \n ")
-- file:close()
-- Fin Define script lua envois

while true do
    rst= gps.gpsinfo();
    -- rst="3113.343286,N,12121.234064,E,250311,072809.3,44.1,0.0,0";
	if rst==",,,,,,,," then
		print("No GPS fix\r\n")
		vmsleep(1000)
	else
		print("GPS data received \r\n")
		str1='POST /coordinates HTTP/1.1\r\nContent-type: application/json\r\nAccept: application/json\r\nContent-length: '
		msg = string.concat(rst,"\r\n")
		print(msg)

		-- Data formating
		j=0
		str2={}
		for word in string.gmatch(rst, '([^,]+)') do
			str2[j]=word
			j=j+1
		end
		strx={}
		k=1
		while k<=string.len(str2[0]) do
			strx[k]=string.sub(str2[0],k,k)
			k=k+1
		end
		latitude=tonumber(string.sub(x, 1, 2)) + tonumber(string.sub(x, 3, 11))/60*1.0
		str2[0]=tostring(latitude)
		l=1
		while l<=string.len(str2[2]) do
			stry[l]=string.sub(str2[2],l,l)
			l=l+1
		end
		longitude1=string.concat(stry[1],stry[2])
		longitude1=tonumber(string.concat(longitude1,stry[3]))*1.0
		longitude2=string.concat(stry[4],stry[5])
		longitude2=string.concat(longitude2,stry[6])
		longitude2=string.concat(longitude2,stry[7])
		longitude2=string.concat(longitude2,stry[8])
		longitude2=string.concat(longitude2,stry[9])
		longitude2=string.concat(longitude2,stry[10])
		longitude2=string.concat(longitude2,stry[11])
		longitude2=string.concat(longitude2,stry[12])
		longitude2=tonumber(longitude2)*1.0
		longitude2=longitude2/60*1.0
		longitude3=longitude1+longitude2
		str2[2]=tostring(longitude3)
		if str2[1]=="S" then
			str2[0]=string.concat('-',str2[0])
		end
		if str2[3]=="W" then
			str2[2]=string.concat('-',str2[2])
		end
		v1=str2[4]
		v2=string.gsub(v1, "(%d%d)", "%1-")
		j=0
		v3={}
		for word in string.gmatch(v2, '([^-]+)') do
			v3[j]=word

			j=j+1
		end

		raiponce1=string.concat("20",v3[2])
		raiponce2=string.concat(raiponce1,v3[1])
		raiponce3=string.concat(raiponce2,v3[0])
		raiponce=string.concat(raiponce3,str2[5])

		strz = str2[7]

		strk = str2[8]

        -- End of formating

        -- Something
		if comp==1 then
			mesLats=str2[0]
			mesLons=str2[2]
			mesdatetimes=raiponce
			-- 1 knot = 1.852 km/h
			messpeeds=tonumber(strz)*1.852
			mescourses=strk
			if string.len(date)==0 then
				date=mesdatetimes
			end
		end
		if comp~=1 then
			mesLats=string.concat(mesLats,"_")
			mesLats=string.concat(mesLats,str2[0])
			mesLons=string.concat(mesLons,"_")
			mesLons=string.concat(mesLons,str2[2])
			mesdatetimes=string.concat(mesdatetimes,"_")
			mesdatetimes=string.concat(mesdatetimes,raiponce)
			messpeeds=string.concat(messpeeds,'_')
			messpeeds=string.concat(messpeeds,tonumber(str2[7])*1.852)
			mescourses=string.concat(mescourses,'_')
			mescourses=string.concat(mescourses,str2[8])
		end

		if comp==5 then -- Connexion opening
			print(" Open connexion \r \n")
			cmd1='at+chttpact="167.99.205.49",80 \r ' 
			sio.send(cmd1); 
			rtc1=sio.recv(5000) 
			print(" Connexion opened \r \n")
		end
		if comp==10	then
			comp=0

			str3='\r\n\r\n'
			str4='{"latitude":"'
			str5='","longitude":"'
			str6='","datetime":"'
			str8='","tracker_id":'
			str8=string.concat(str8,tracker_id)
			str9=',"token":"'
			str9=string.concat(str9,token)	
			str9=string.concat(str9,'"')
			str9=string.concat(str9,"}")
			str11='","speed":"'
			str12='","course":"'	
			length1 = string.len(str4)+string.len(mesLats)+string.len(str5)+string.len(mesLons)+string.len(str6)+string.len(mesdatetimes)+string.len(str8)+string.len(str9)+string.len(str11)+string.len(messpeeds)+string.len(str12)+string.len(mescourses)

			str10=string.concat(str1,tostring(length1))
			str10=string.concat(str10,str3)
			str10=string.concat(str10,str4)
			str10=string.concat(str10,mesLats)
			str10=string.concat(str10,str5)
			str10=string.concat(str10,mesLons)
			str10=string.concat(str10,str6)
			str10=string.concat(str10,mesdatetimes)
			str10=string.concat(str10,str11)
			str10=string.concat(str10,messpeeds)
			str10=string.concat(str10,str12)
			str10=string.concat(str10,mescourses)
			str10=string.concat(str10,str8)
			str10=string.concat(str10,str9)
			str10=string.concat(str10,string.char(0x1A))

            -- Writing of data in a file
			file=io.open(string.format("D:\\latitude%s.txt", date), "a")
			print("file= ")
			print(file)
			if file ~= nil then -- IF no SD card
				mesLats=string.concat(mesLats,"_")
				file:write(mesLats)
				file:close()
				
				file=io.open(string.format("D:\\longitude%s.txt", date), "a")
				mesLons=string.concat(mesLons,"_")
				file:write(mesLons)
				file:close()
				
				file=io.open(string.format("D:\\datetime%s.txt", date), "a")
				mesdatetimes=string.concat(mesdatetimes, "_")
				file:write(mesdatetimes)
				file:close()

				file=io.open(string.format("D:\\speed%s.txt", date), "a")
				messpeeds=string.concat(messpeeds, "_")
				file:write(messpeeds)
				file:close()

				file=io.open(string.format("D:\\course%s.txt", date), "a")
				mescourses=string.concat(mescourses, "_")
				file:write(mescourses)
				file:close()

			end
			-- Sending of data
			print(" Start data transfer \r\n")
			sio.send(str10);
			--print(str10)
			rtc2=sio.recv(5000) 
			print(" Data transfer is complete \r\n")
			
			
		end
		comp=comp+1
		vmsleep(1000)
	end	
end
