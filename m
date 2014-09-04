Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: cpus_allowed_policy for async IO verification threads
Date: Thu, 4 Sep 2014 19:40:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C4F41B@G4W3202.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

To accompany cpus_allowed_policy=3Dsplit, should fio offer
a verify_async_cpus_allowed_policy=3Dsplit to bind its
async IO verification threads to particular CPUs?

      verify_async_cpus=3Dstr
      Tell fio to set the given CPU affinity on=20
	the async IO verification threads.  See cpus_allowed for=20
	the format used.


---
Rob Elliott    HP Server Storage



