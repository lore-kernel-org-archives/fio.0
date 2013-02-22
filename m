Return-Path: <cpz@coraid.com>
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Output logs and keep command line display
Date: Fri, 22 Feb 2013 19:11:47 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB014104@DAGN05A-E6.exg6.exghost.com>
References: <CANUChTxynLg7p5kK1vex9965qvYxyFagzk8QAtbh-2-=_Mdxhg@mail.gmail.com>
 <20130131140223.GI8800@kernel.dk> <20130131140854.GJ8800@kernel.dk>
 <CANUChTwu9UJt1rYSb4JZ-URXVpDmEnTmteApGRcasJM06nR0ow@mail.gmail.com>
 <20130131142425.GK8800@kernel.dk>
 <CANUChTxnudOx6B3HjWfbD36Cq31eGTA3W2+qbGDYLjr+sJP4cw@mail.gmail.com>
 <20130222120759.GU25617@kernel.dk>
In-Reply-To: <20130222120759.GU25617@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

While we're on the subject-

For some long-running tests*, I hacked the ETA display to appear every 60 s=
econds and with a trailing newline. This isn't much of a code change, but s=
ince I haven't figured out how the option processing works, I haven't creat=
ed a patch.

* Needed to watch the write speed over the entire range of a 3tb drive. On =
some drives, it drops quite a bit from low LBAs to high ones.

z!


