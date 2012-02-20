Return-Path: <whooper@micron.com>
From: "Bill Hooper (whooper)" <whooper@micron.com>
Subject: RE: Formats for log files
Date: Mon, 20 Feb 2012 17:17:06 +0000
Message-ID: <8C39003C166535489D52AF2C9D8C58BC1A317129@NTXBOIMBX04.micron.com>
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com>
 <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com>
 <8C39003C166535489D52AF2C9D8C58BC1A316D31@NTXBOIMBX04.micron.com>,<B53FFA03-CFB4-46BB-882A-602F045FAF24@joshcarter.com>
 <8C39003C166535489D52AF2C9D8C58BC1A316DBD@NTXBOIMBX04.micron.com>
 <EF8C77A9-96EC-42F3-BC18-535FDDD9B0DF@joshcarter.com>
 <4F420D85.1090803@kernel.dk>
In-Reply-To: <4F420D85.1090803@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Josh Carter <public@joshcarter.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Jens Axboe
> Sent: Monday, February 20, 2012 1:08 AM
> To: Josh Carter
> Cc: fio@vger.kernel.org; Bill Hooper (whooper)
> Subject: Re: Formats for log files
>=20
> On 02/16/2012 08:46 PM, Josh Carter wrote:
> > Hi Bill,
> >
> > Looking at the code, I believe you're correct, the bandwidth logging
> > for mixed loads isn't right. While read and write logs are kept
> > separate, only one direction's log will get flushed on each interval.
> > Instead, fio should flush both directions.
> >
> > I'm attaching a patch. Jens: could you take a look at this? I've
> > tested both mixed and single-direction workloads, seems to work fine.
>=20
> Patch looks good, applied. Thanks!
>=20
> --
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I did test the patch from Josh and it appears to work correctly. I noticed =
that the issue also exists in the iops and latency logging. I was able to u=
se the code Josh provided to correct the iops logging. I did not spend any =
time attempting to correct the latency logging issue, although I suspect th=
e fix is similar to the others. Could someone take a deeper look into this?

Bill Hooper
Micron

