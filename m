Return-Path: <brianclam@gmail.com>
References: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com> <5237593A.8050301@kernel.dk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5237593A.8050301@kernel.dk>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Message-Id: <E8B80854-5126-4A4C-92D7-26222827F9E6@gmail.com>
From: "Brian L." <brianclam@gmail.com>
Subject: Re: output mutating on me
Date: Mon, 16 Sep 2013 13:19:49 -0700
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

it's running normal directly on the machine.

 i thought maybe clat and lat might be the same as slat and that is why ther=
e is only slat being output but i  not sure.=20

Brian L.
Sent from my iPhone

On Sep 16, 2013, at 12:17 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/13/2013 07:04 PM, Brian L. wrote:
>> Just want to seek some advice as this is driving me crazy and I have a
>> deadline fast approaching so I am not sure if I can completely change
>> course at this point.
>>=20
>> So here's the situation - it looks like different run of fio is giving
>> me different output.  The outputs are mutating (reproducible) on me so
>> it broken my parser and more importantly, my data because I depend on
>> "Completion latency" ('clat') for my calculation.  Ugh.  Maybe if I
>> use '--minimal' during the run, it might be better but I am too commit
>> to change at this point.
>>=20
>> Note below: the 'clat (usec): min=3D...' line is missing from the first r=
un.
>=20
> Is this running as a client/server, or "normal" run directly on the machin=
e?
>=20
> --=20
> Jens Axboe
>=20

