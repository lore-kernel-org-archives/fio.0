Return-Path: <axboe@kernel.dk>
Subject: Re: FIO compression bug
References: <CALD1HU=N7v3ZV9fFF0cEsO50GtHPrPV-XEa5mRsFyoaX8+P8zQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ced32a78-3ecc-db79-d852-c527cbe656e2@kernel.dk>
Date: Wed, 28 Nov 2018 08:27:45 -0700
MIME-Version: 1.0
In-Reply-To: <CALD1HU=N7v3ZV9fFF0cEsO50GtHPrPV-XEa5mRsFyoaX8+P8zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bari Antebi <bari@lightbitslabs.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/25/18 8:24 AM, Bari Antebi wrote:
> To Whom It May Concern,
> 
> I've noticed a bug in fio while testing it. I expected to receive
> output similar to the expected output below for: "hexdump -n 4096
> /dev/nvme0n1" (considering the configuration file I've used  that may
> be found below).
> 
> Expected output:
> 
> 0000000 fdc6 a8a8 7190 0219 1fb8 9632 d9dd 1e64
>                 /* random data */
> 00004c0 d8a3 13fe aeec 0fb6 5b14 162e 0000 0000
> 00004d0 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001000
> 
> 
> However, the output I've received  contained data after address 4cc
> (which should have been filled with zeros until 1000 as far as I
> understand, but as you can see 99a contains data.
> 
> 
> 0000000 fdc6 a8a8 7190 0219 1fb8 9632 d9dd 1e64
> /* random data */
> 00004c0 d8a3 13fe aeec 0fb6 5b14 162e 0000 0000
> 00004d0 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0000990 0000 0000 0000 0000 fdc6 a8a8 7190 0219
> 
> Config file:
> 
> [global]
> group_reporting=1
> filename=/dev/nvme0n1
> name=task_nvme0n1
> rw=write
> bs=4096
> numjobs=1
> iodepth=32
> buffer_compress_chunk=4096
> buffer_compress_percentage=70
> cpus_allowed=0-8
> cpus_allowed_policy=split
> direct=1
> ioengine=libaio
> loops=1
> refill_buffers=0
> 
> [job empty]
> size=4096
> 
> The version I ran is  fio-3.11, but it seems the bug wasn't fixed in
> the new version from a look at the code.
> 
> I solved the issue locally & would like to send a pr for the fix.
> The problem in the code maybe found in "lib/rand.c", at the function
> "__fill_random_buf_percentage".
> After fio finishes to write the random part, it should write the
> remainder of "((unsigned long long)segment * (100 - percentage)) /
> 100",
> but currently it writes "this_len" zeros which seems wrong.
> 
> My solution is to add a single line under line 168 (of the current fio
> version). If it's possible I'd like to add the PR myself, it will be
> my first contribution to any open source code :)
> 168. buf += this_len;
> 169. this_len = segment - this_len

Please do! The best bug reports are those that come with an analysis of
the issue, and even include a fix. You don't have to do a PR, you can
just send a patch here as well. It should basically be as simple as
making the edit in the file, then run git diff and send the output.

When you do send a diff or PR, ensure that your full description from
this email is included. That's very useful for the future.

-- 
Jens Axboe


