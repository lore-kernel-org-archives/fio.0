Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: RE: Group reporting with latency and IOPS
Date: Tue, 29 Jan 2013 13:49:42 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
In-Reply-To: <20130129134652.GF8800@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> atency: (clat) 577usecs - 0.577ms
> >
> >Correct too.
> >
> >> Am I doing the correct analysis?
> >
> >Yep.
> >
> >> One question is: Is it possible to have global IOPS and latency?
> >
> >You mean for both read and write combined? Fio does not report that,=20
> >but for IOPS you could just add them. For latency, the larger of the two=
.
> >
> >--=3D20
> >Jens Axboe
> >
>=20
> Hi Jens
>=20
> This is neto from Brazil
>=20
> How are you?
>=20
> Thank you so much for your answer.
>=20
> How can I have a combined IOPS reported?

You can't, at least not automatically. You would have to sum them up. It wo=
uld not be hard to add at all, though, controlled by an option. I haven't h=
ad any requests for it before now, usually people ask for more fine grained=
 metrics, not the other way around :-)

--
Jens Axboe

Thank you Jens, I understand. To have an option to group everything could b=
e a good thing especially when you are doing a POC or demonstrating perform=
ance for a customer where they are interested in how many IOPS and total la=
tency :-)=20

