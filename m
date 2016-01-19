Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0079.outbound.protection.outlook.com ([157.56.112.79]:35264
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932389AbcASAom convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jan 2016 19:44:42 -0500
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
Date: Tue, 19 Jan 2016 00:29:39 +0000
Message-ID: <VI1PR05MB13439667BBEE922D9955F58EB1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
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
 <VI1PR05MB1343E7E335FA4E27991FD523B1C00@VI1PR05MB1343.eurprd05.prod.outlook.com>,<9419CB2F-E2A7-453F-A5CE-88533306BC00@nellans.org>
In-Reply-To: <9419CB2F-E2A7-453F-A5CE-88533306BC00@nellans.org>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

David,

Sorry for typo.
I paste and not copy the configuration file.

# cat randwrite.fio
[global]
thread
numjobs=3D1
iodepth=3D1
group_reporting
bs=3D4k
norandommap=3D1
refill_buffers
direct=3D1
ioengine=3Dposixaio
runtime=3D300
time_based
filename=3D/dev/hdisk6
log_avg_msec=3D1000
[randwrite_64_64]
rw=3Drandwrite
numjobs=3D64
iodepth=3D64
stonewall
#


Cordialement,
Thierry Bertaud
Tel: 01 60 95 51 41

PS: Merci de mettre en copie pour toute demande syst=EF=BF=BDme, le groupe =
dsisystunix@conforama.fr

________________________________________
De : David Nellans <david@nellans.org>
Envoy=EF=BF=BD : mardi 19 janvier 2016 01:15
=EF=BF=BD : Thierry BERTAUD
Cc : fio@vger.kernel.org
Objet : Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s

you have two typos in your config that will likely result in less than suff=
icient iodepth to hit 500k IOPS. check if those are in your actual config o=
r not...

> On Jan 18, 2016, at 5:58 PM, Thierry BERTAUD <tbertaud@conforama.fr> wrot=
e:
>
> Hello fio team,
>
> I tryed to stress my 8 Gbps hba with fio wit a lot of case:
> I know that the hba card is capable of 500 000 IOPS or get data rate neat=
 that 8 Gbps (1600 MB/sec).
> i tried to change block size, iodepth, numjobs, iodepth but idon't have g=
ood resulut. (42000 IOPS and throughput 162 MB/s).
>
> Below fio conf:
> [global]
> thread
> numjobs=3D1
> iodepth=3D1
> group_reporting
> bs=3D4k
> norandommap=3D1
> refill_buffers
> direct=3D1
> ioengine=3Dposixaio
> runtime=3D300
> time_based
> filename=3D/dev/hdisk6
> log_avg_msec=3D1000
> [randwrite_64_64]
> rw=3Drandwrite
> numjobs=3D64
> ioepth=3D64
> stonewal
>
>
>
> Regards,
> Thierry--
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
