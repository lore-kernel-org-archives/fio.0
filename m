Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0072.outbound.protection.outlook.com ([157.56.112.72]:60048
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757022AbcASB7s convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jan 2016 20:59:48 -0500
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
Date: Tue, 19 Jan 2016 01:59:44 +0000
Message-ID: <VI1PR05MB1343ADD12D0AD91A40D460B2B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56840F80.4060903@kernel.dk>
 <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5684A8F1.6010105@kernel.dk>
 <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
 <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
 <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com>
 <VI1PR05MB13430232A50B8818A220B23DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com>
 <VI1PR05MB13431DA43361FC9F4F55FC95B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343E7E335FA4E27991FD523B1C00@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CAM8G_BJ22QGD3jgKO3i2HXjEpi4He_eUegAr+XDPPO-AYU_5xg@mail.gmail.com>
 <DA15262B-D52B-4FF3-B8A9-079073DEC874@nellans.org>
 <VI1PR05MB1343FA34ED1B8DE6E04DE3D5B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CAB-428nR4aYto5P6di8oKM2pDC3ixEy2kfRUoGTjtbs_-BbcKQ@mail.gmail.com>
In-Reply-To: <CAB-428nR4aYto5P6di8oKM2pDC3ixEy2kfRUoGTjtbs_-BbcKQ@mail.gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: David Nellans <david@nellans.org>, "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Alireza,

I use 2 hba (fscsi1 -> fabric1, fscsi2 -> fabric2). Each fabric is connect to 3 nodes.  

# lspath | grep hdisk6
Enabled hdisk6  fscsi1
Enabled hdisk6  fscsi1
Enabled hdisk6  fscsi3
Enabled hdisk6  fscsi3
Enabled hdisk6  fscsi1
Enabled hdisk6  fscsi3
#

 
With : bs=256k and 
# cat randwrite.fio
[global]
thread
numjobs=1
iodepth=1
group_reporting
bs=256k
norandommap=1
refill_buffers
direct=1
ioengine=posixaio
runtime=300
time_based
filename=/dev/hdisk6
log_avg_msec=1000
[randread_32_256]
rw=randread
numjobs=32
iodepth=256
stonewall
#
IOPS: 23 000
Bandwith: 85 Mo/s
Latency: 0.5 ms

but with this one:
# cat randwrite.fio
[global]
thread
numjobs=1
iodepth=1
group_reporting
bs=4k
norandommap=1
refill_buffers
direct=1
ioengine=posixaio
runtime=300
time_based
filename=/dev/hdisk6
log_avg_msec=1000
[randread_64_64]
rw=randread
numjobs=64
iodepth=64
stonewall
#
IOPS: 10 000
Bandwith: 40 MB/S
Latency: 1.5 ms

but write seems better than read:
# cat randwrite.fio
[global]
thread
numjobs=1
iodepth=1
group_reporting
bs=4k
norandommap=1
refill_buffers
direct=1
ioengine=posixaio
runtime=300
time_based
filename=/dev/hdisk6
log_avg_msec=1000
[randwrite_64_64]
rw=randwrite
numjobs=64
iodepth=64
stonewall
#
IOPS: 42 000
Bandwith: 163 MB/S
latency: 0.2 ms

I don't understand why for last test randwrite is better than randread.
I'm lost and don't undertand how to stress the LUN.

Regards,
Thierry
