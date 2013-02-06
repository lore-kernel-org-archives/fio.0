Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:43367 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465Ab3BFVPK convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 6 Feb 2013 16:15:10 -0500
Received: from vmwexceht02-prd.hq.netapp.com (vmwexceht02-prd.hq.netapp.com [10.106.76.240])
	by smtp2.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id r16LF9lj027003
	for <fio@vger.kernel.org>; Wed, 6 Feb 2013 13:15:09 -0800 (PST)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Running fio on Windows 64 bits with offset, zonesize and zoneskip
 and fio stops to respond
Date: Wed, 6 Feb 2013 21:15:08 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6F05E5@SACEXCMBX02-PRD.hq.netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

Running fio on Windows 64 bits with offset, zonesize and zoneskip and fio stops to respond

-- Random.sh - to generate config.fio file

cat > config.fio << EOF
[global]
bs=8k
ioengine=windowsaio
size=1024g
iodepth=3
numjobs=2
direct=1
runtime=30
file_service_type=random
rw=randrw
rwmixread=80
rwmixwrite=20
thread
unified_rw_reporting=1
group_reporting=1
randrepeat=0
norandommap=1
EOF
loops=1
OFFSET=0
USERS=0016
MEGABYTES=8192
while [[ $loops -le 8 ]] ; do 
JOBNUMBER=$loops
loops=$(expr $loops + 1)
OFFSET=`echo $(( $RANDOM % 134217728000 * 1024))`
cat >> config.fio << EOF

[PhysicalDrive$JOBNUMBER]
filename=\\\\.\PhysicalDrive$JOBNUMBER
size=125g
offset=$OFFSET
zonesize=`echo $((RANDOM%1000001+200000000))`
zoneskip=`echo $((RANDOM%2000001+500000000))`
EOF
done

-- config.fio
[global]
bs=8k
ioengine=windowsaio
size=1024g
iodepth=3
numjobs=2
direct=1
runtime=30
file_service_type=random
rw=randrw
rwmixread=80
rwmixwrite=20
thread
unified_rw_reporting=1
group_reporting=1
randrepeat=0
norandommap=1

[PhysicalDrive1]
filename=\\.\PhysicalDrive1
size=125g
offset=14062592
zonesize=200003129
zoneskip=500017345

[PhysicalDrive2]
filename=\\.\PhysicalDrive2
size=125g
offset=11035648
zonesize=200020109
zoneskip=500027097

[PhysicalDrive3]
filename=\\.\PhysicalDrive3
size=125g
offset=29750272
zonesize=200001897
zoneskip=500026993

[PhysicalDrive4]
filename=\\.\PhysicalDrive4
size=125g
offset=20156416
zonesize=200015008
zoneskip=500013464

[PhysicalDrive5]
filename=\\.\PhysicalDrive5
size=125g
offset=27099136
zonesize=200002460
zoneskip=500027452

[PhysicalDrive6]
filename=\\.\PhysicalDrive6
size=125g
offset=32296960
zonesize=200001144
zoneskip=500002836

[PhysicalDrive7]
filename=\\.\PhysicalDrive7
size=125g
offset=7057408
zonesize=200013388
zoneskip=500027799

[PhysicalDrive8]
filename=\\.\PhysicalDrive8
size=125g
offset=21437440
zonesize=200011927
zoneskip=500019535


When I run, I've got a pop-up message on windows - fio.exe has stopped working ...

NOTE: If I remove zoneskip and zonesize- everything works.

Could you please help me understand what am I doing wrong?

Thank you very much

neto




