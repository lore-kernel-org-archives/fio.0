Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55B69F09.2010802@kernel.dk>
References: <1437767373-26631-1-git-send-email-r.peniaev@gmail.com>
	<55B69F09.2010802@kernel.dk>
Date: Tue, 28 Jul 2015 06:09:26 +0100
Message-ID: <CALjAwxiFJXrEkkcaihiw4tF2WbwXR1AQ7CGGwom9AJ_noCoFUQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] verify: move meta header to generic verify_header
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Roman Pen <r.peniaev@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> If you feel like you are up for more in this area, I'd love to have a mod=
e
> that writes verify info based the location on disk/file, and hence doesn'=
t
> need a header. This could/should work with any of the hashes, and it shou=
ld
> have a way to specify the seed for the data. The generated data for the
> block would be a function of the offset, hash, seed.

Would this be akin to dt's "pattern=3Diot"? From
http://www.scsifaq.org/RMiller_Tools/ftp/dt/dt-UsersGuide.pdf :
"So, what is DJ=E2=80=99s IOT test pattern? This pattern places the logical
block address (lba) in the first word (4 bytes) of each block, with
(lba+=3D0x01010101) being placed in all remaining words in the data
block (512 bytes by default). In this way, the logical block is seeded
throughout each word in the block."

If so what would happen on things like the second pass - e.g. if fio
stops how do you know which iteration you were on or is this
irrelevant?

--=20
Sitsofe | http://sucs.org/~sits/

