Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Thu, 6 Mar 2014 16:12:00 +0000
Message-ID: <d47f31f7932e4ce3928874fe5019d6da@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
 <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
 <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
 <53189A5D.1070602@kernel.dk>
In-Reply-To: <53189A5D.1070602@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, David Nellans <david@nellans.org>
List-ID: <fio@vger.kernel.org>

OK, will grab 2.1.6 and reply with observations.

I've only recently subscribed to this mail-list and it amazes me that you c=
an give attention to such a barrage of requests.

Eric
-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, March 06, 2014 9:55 AM
To: Lamkin, Eric; David Nellans
Cc: fio@vger.kernel.org
Subject: Re: fio replay

On 03/03/2014 06:25 AM, Lamkin, Eric wrote:
> Here's my update with a blktrace captured on a single device with no drop=
ped events.
> Also switched to fio 2.1.4.
>
> Capture a single device trace with no dropped events.

[snip]

Thanks for the detailed report. But why are you replaying with fio-2.1.4? I=
f there's a bug here (and it looks like it), then please replay the blktrac=
e with fio-2.1.6 and I can take a look at it.

--
Jens Axboe



