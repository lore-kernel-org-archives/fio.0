Return-Path: <axboe@kernel.dk>
Subject: Re: fio memory use seems .... large
References: <bd4ad58b-74ef-f07a-fe9d-69cd32b5e759@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3e3d79f3-0d24-6414-4018-9a578ca5de3b@kernel.dk>
Date: Tue, 28 Apr 2020 17:55:48 -0600
MIME-Version: 1.0
In-Reply-To: <bd4ad58b-74ef-f07a-fe9d-69cd32b5e759@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, fio <fio@vger.kernel.org>
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/28/20 5:41 PM, Eric Sandeen wrote:
> This seems ... large, no?
> 
> # /usr/bin/time -f "RSS %M kb" ./fio --name=writetest --filename=/mnt/testfile1 --rw=write --bs=4096 --size=64M --iodepth=1 --ioengine=libaio --direct=1 --verify=sha512 --do_verify=0
> 
> RSS 1138748 kb
> 
> and it got quite a bit larger with commit 
> 
> df8781b6 fio: groundwork for adding slat, lat percentiles
> 
> i.e. if I check out the commit just before that,
> 
> ab45cf07 Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio
> 
> I get:
> 
> RSS 782236 kb
> 
> which is, if I'm reading it right, ~350mb smaller.
> 
> 760mb seems pretty big for a simple fio job like this in the first
> place, that commit growing it by 350mb is unexpected and I ... haven't
> been able to figure out where that increase came from.  Am I
> mis-analyzing something here?

It probably got larger with that commit because it added to the
thread_data, and fio defaults to a large number of jobs... You can try
and add:

--max-jobs=X

to shrink the max jobs it supports, that'll reduce it drastically. I
think we default to 4k of jobs by default, or something like that, and
each job will consume ~274K.

-- 
Jens Axboe


