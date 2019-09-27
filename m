Return-Path: <ming.lei@redhat.com>
Date: Fri, 27 Sep 2019 16:02:50 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: fio: iodepth_batch_submit is broken on libaio
Message-ID: <20190927080249.GA19514@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Looks fio's 'iodepth_batch_submit' is broken.

When running the attached fio script[1], I observed that 'nr' passed to
io_submit() is 1, except that 64 is only passed to the 1st io_submit().

Then plug merging can't work at all.

[root@ktest-08 tools]# cat bpf
#include <uapi/linux/aio_abi.h>
tracepoint:syscalls:sys_enter_io_submit { @nr = hist(args->nr); }
[root@ktest-08 tools]# bpftrace ./bpf
Attaching 1 probe...
^C

@nr:
[1]               902349 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[2, 4)                 0 |                                                    |
[4, 8)                 0 |                                                    |
[8, 16)                0 |                                                    |
[16, 32)               0 |                                                    |
[32, 64)               0 |                                                    |
[64, 128)              1 |                                                    |

[1] fio script:
fio --readwrite=write --filesize=4g --filename=/dev/sda \
	--runtime=10s --time_based \
	--ioengine=libaio --direct=1 --bs=4k --iodepth=64 \
	--iodepth_batch_submit=64 \
	--numjobs=64 \
	--name=foo


Thanks,
Ming

