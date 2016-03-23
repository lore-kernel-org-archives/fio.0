Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0075.outbound.protection.outlook.com ([157.56.112.75]:26896
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752820AbcCWH4h convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 23 Mar 2016 03:56:37 -0400
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
Date: Wed, 23 Mar 2016 07:41:05 +0000
Message-ID: <HE1PR05MB17874D065F974A742C73B7C9B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>,<CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>,<HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
In-Reply-To: <HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Andrey,


>Covered in the FIO HOWTO under rw and percentage_random options.
I tried this configuration but when i run, it doesn't do that=EF=BF=BDexpec=
ted.


[global]
ioengine=3Dposixaio
invalidate=3D0
norandommap
ramp_time=3D5
iodepth=3D8
runtime=3D60
time_based
direct=3D1
numjobs=3D1
group_reporting
filesize=3D100M
blocksize=3D8k
percentage_random=3D12,8 =EF=BF=BD =EF=BF=BD <=3D 12% seqread, 8%=EF=BF=BDs=
eqwrite
rw=3Drandrw
rwmixread=3D70 =EF=BF=BD =EF=BF=BD<=3D 70% randread and 30% randwrite for o=
thers


[hdisk10]
stonewall
filename=3D/dev/rhdisk10


Regards,
Thierry



       