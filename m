Return-Path: <BCran@fusionio.com>
From: Bruce Cran <BCran@fusionio.com>
Subject: RE: ioengine=sync issue on Windows
Date: Wed, 12 Mar 2014 19:44:21 +0000
Message-ID: <2b1a7177596f4a7e944ef1f91860f6e2@BLUPR04MB467.namprd04.prod.outlook.com>
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208C60.8090708@kernel.dk>
 <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com>
 <5320B15F.1060401@kernel.dk>
 <bd155da4787d49eb88221a9cc7f4612a@BLUPR04MB467.namprd04.prod.outlook.com>
 <5320B5E6.7010902@kernel.dk>
 <749c722481744d36883cdd77210a41be@BLUPR04MB467.namprd04.prod.outlook.com>
 <5320B7BC.3090801@kernel.dk> <5320B85C.7070806@kernel.dk>
In-Reply-To: <5320B85C.7070806@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Perfect - thanks!

--=20
Bruce

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 12, 2014 1:41 PM
To: Bruce Cran; S=E9bastien Bouchex Bellomi=E9; fio@vger.kernel.org
Subject: Re: ioengine=3Dsync issue on Windows

On 03/12/2014 01:38 PM, Jens Axboe wrote:
> On 03/12/2014 01:36 PM, Bruce Cran wrote:
>> Oh, I see - that works.   Though the existing code also does with the
>> removal of
>  > 'tmp' from FIO_STATUS_FILE - Windows defines both TMP and TEMP=20
> environment variables.
>
> So the getenv() works fine on Windows? If so, I can clean it up some more.

Queued this up:

http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Ddac45f23c3c7d146f7df82047a=
e7f25abf231ed3

--
Jens Axboe


This e-mail (and any attachments) is confidential and may be privileged.  A=
ny unauthorized use, copying, disclosure or dissemination of this communica=
tion is prohibited.  If you are not the intended recipient,  please notify =
the sender immediately and delete all copies of the message and its attachm=
ents.

