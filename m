Return-Path: <cpz@coraid.com>
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Generating almost-sequential traffic
Date: Thu, 27 Jun 2013 17:41:19 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB039F2F@DAGN05A-E6.exg6.exghost.com>
References: <A7A1D348E34E024BBC74480FB93A2EAB039C63@DAGN05A-E6.exg6.exghost.com>
 <20130627090123.GK25599@kernel.dk>
In-Reply-To: <20130627090123.GK25599@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Thursday, June 27, 2013 2:01 AM

> See percentage_random in the man page (or --cmdhelp=3Dpercentage_random)

In the tests I'm running, the sequence has to continue essentially uninterr=
upted with the occasional drop/transposition, but it can't contain LBAs tha=
t are wildly off. So '1 2 3 (4) 5 6' or '1 2 3 (5 4) 6' are good, '1 2 3 99=
99 4 5 6' is not. They trigger different specific behaviors in some hard dr=
ives.

Is there a good place in the code to insert this sort or thing?

z!


