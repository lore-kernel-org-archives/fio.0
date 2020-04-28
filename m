Return-Path: <sandeen@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Subject: fio memory use seems .... large
Message-ID: <bd4ad58b-74ef-f07a-fe9d-69cd32b5e759@redhat.com>
Date: Tue, 28 Apr 2020 18:41:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

This seems ... large, no?

# /usr/bin/time -f "RSS %M kb" ./fio --name=writetest --filename=/mnt/testfile1 --rw=write --bs=4096 --size=64M --iodepth=1 --ioengine=libaio --direct=1 --verify=sha512 --do_verify=0

RSS 1138748 kb

and it got quite a bit larger with commit 

df8781b6 fio: groundwork for adding slat, lat percentiles

i.e. if I check out the commit just before that,

ab45cf07 Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio

I get:

RSS 782236 kb

which is, if I'm reading it right, ~350mb smaller.

760mb seems pretty big for a simple fio job like this in the first place, that commit growing it by 350mb is unexpected and I ... haven't been able to figure out where that increase came from.  Am I mis-analyzing something here?

Thanks,
-Eric


