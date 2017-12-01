Return-Path: <axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Subject: memcpy test
Message-ID: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
Date: Fri, 1 Dec 2017 11:20:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>, Robert Elliott <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

Hi,

Reviving this topic, since I think it's interesting in the presence
of persistent memory engines that rely heavily on optimized memcpy
to be fast.

Similar to how we have --crctest, I added --memcpytest. Very basic,
just wanted to get the ball rolling. Basically it just copies between
two 32MB chunks, using whatever implementation you would like, and in
increments of some defined size. This is what it spits out on my
laptop:

memcpy
	8 bytes:	 3360.94 MiB/sec
	16 bytes:	 4363.47 MiB/sec
	96 bytes:	 6804.46 MiB/sec
	128 bytes:	 6391.39 MiB/sec
	256 bytes:	 6571.09 MiB/sec
	512 bytes:	 6962.77 MiB/sec
	2048 bytes:	 6212.73 MiB/sec
	8192 bytes:	 6465.14 MiB/sec
	131072 bytes:	 6412.24 MiB/sec
	262144 bytes:	 6607.03 MiB/sec
	524288 bytes:	 6372.90 MiB/sec
memmove
	8 bytes:	 2503.90 MiB/sec
	16 bytes:	 4311.81 MiB/sec
	96 bytes:	 6734.74 MiB/sec
	128 bytes:	 6080.16 MiB/sec
	256 bytes:	 6162.92 MiB/sec
	512 bytes:	 7309.80 MiB/sec
	2048 bytes:	 6931.94 MiB/sec
	8192 bytes:	 6878.97 MiB/sec
	131072 bytes:	 6787.05 MiB/sec
	262144 bytes:	 6877.77 MiB/sec
	524288 bytes:	 6695.26 MiB/sec
simple
	8 bytes:	 1813.59 MiB/sec
	16 bytes:	 2191.63 MiB/sec
	96 bytes:	 7360.76 MiB/sec
	128 bytes:	 7192.63 MiB/sec
	256 bytes:	 7340.00 MiB/sec
	512 bytes:	 7158.04 MiB/sec
	2048 bytes:	 7495.96 MiB/sec
	8192 bytes:	 7315.30 MiB/sec
	131072 bytes:	 7565.82 MiB/sec
	262144 bytes:	 7410.95 MiB/sec
	524288 bytes:	 7537.09 MiB/sec

which is kind of depressing, since the fastest for larger sizes is the
very dumb and basic implementation that you'll find in any text book
under the section of "my first memcpy".

Anyway, for evaluating implementations, we need a way to test them,
and now we have. I'll be happy to take input/patches on the test
itself.

-- 
Jens Axboe


