Return-Path: <gwendal@google.com>
MIME-Version: 1.0
Sender: gwendal@google.com
From: Gwendal Grignou <gwendal@chromium.org>
Date: Sun, 8 Feb 2015 17:41:05 -0800
Message-ID: <CAMHSBOWmVjpg9j4rE5qto+J0mJnViO3kR0r6WXkPZwapkCyQag@mail.gmail.com>
Subject: fio: verify latency not reported correctly
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,

I am running a simple verify fio test, looking at latencies:

[8k_async_randwrite]

filename=/dev/loop0
size=128M
bs=8k
verify=md5
readwrite=randwrite
iodepth=1

write_lat_log=randwrite-noaio

I notice the latencies are correct at first, but goes through the roof
at during the verify phase:

0, 43, 1, 8192
0, 14, 1, 8192
0, 11, 1, 8192
...
389, 9, 1, 8192
389, 4, 1, 8192
389, 4, 1, 8192
576, 187097, 0, 8192
576, 187203, 0, 8192
576, 187261, 0, 8192
...
1118, 729300, 0, 8192
1118, 729328, 0, 8192
1118, 729356, 0, 8192

I suspect the timer is not reset at the beginning of the do_verify() phase:
When we do get_io_u in do_verify to get every IO and issue the reads,
get_io_u finds out it is a requeue, exit early and therefore does not
set io_u->start_time.

Then when we add the sample in the log file, we call add_lat_sample()
in account_io_completion, the elapsed time is since the io has first
been sent, not when it has been resent for verification.

It is correct to not reset start_time in get_io_u for a requeue due to
error for instance, but we should do it for verify.

I submit a patch next.

Gwendal.

