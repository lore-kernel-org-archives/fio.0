Return-Path: <BCran@fusionio.com>
From: Bruce Cran <BCran@fusionio.com>
Subject: RE: ioengine=sync issue on Windows
Date: Wed, 12 Mar 2014 19:24:09 +0000
Message-ID: <bd155da4787d49eb88221a9cc7f4612a@BLUPR04MB467.namprd04.prod.outlook.com>
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208C60.8090708@kernel.dk>
 <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com>
 <5320B15F.1060401@kernel.dk>
In-Reply-To: <5320B15F.1060401@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

There's already code to use the environment variables TMP or TEMP, except i=
t appends "tmp" to whatever it gets.

--=20
Bruce

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 12, 2014 1:11 PM
To: Bruce Cran; S=E9bastien Bouchex Bellomi=E9; fio@vger.kernel.org
Subject: Re: ioengine=3Dsync issue on Windows

On 03/12/2014 12:02 PM, Bruce Cran wrote:
> It turns out this is unrelated, but in stat.c the following change should=
 probably be made:
>
> -#define FIO_STATUS_FILE                "/tmp/fio-dump-status"
> +#define FIO_STATUS_FILE                "fio-dump-status"
>

How about we make that use os_get_tmpdir() instead?

--=20
Jens Axboe


This e-mail (and any attachments) is confidential and may be privileged.  A=
ny unauthorized use, copying, disclosure or dissemination of this communica=
tion is prohibited.  If you are not the intended recipient,  please notify =
the sender immediately and delete all copies of the message and its attachm=
ents.

