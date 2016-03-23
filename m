Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3on0074.outbound.protection.outlook.com ([157.55.234.74]:5168
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751611AbcCWLeX convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 23 Mar 2016 07:34:23 -0400
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
Date: Wed, 23 Mar 2016 11:34:19 +0000
Message-ID: <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
	<CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>
	<HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>,<CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
In-Reply-To: <CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


You tell:

> You should define the mix first, under rw, using total percentage for rea=
ds and writes, and then specify the random/sequential break in each directi=
on under pct_random.

I understand that but it's not correct.
-------
[global]
rw=3Drandrw
rwmixread=3D70 =EF=BF=BD =EF=BF=BD<=3D 70% randread and 30% randwrite for o=
thers
percentage_random=3D12,8 =EF=BF=BD =EF=BF=BD <=3D 12% seqread, 8%=EF=BF=BDs=
eqwrite
 -------

Could you provide an example, please?
=20
 Regards,
Thierry=20






          