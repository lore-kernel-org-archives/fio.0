Return-Path: <axboe@kernel.dk>
Message-ID: <54B9495E.1020804@kernel.dk>
Date: Fri, 16 Jan 2015 10:24:46 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Should io_limits/queue depth flushed persist while using verify_state?
References: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com> <54B84322.10704@kernel.dk>
In-Reply-To: <54B84322.10704@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------010607030206050009020507"
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010607030206050009020507
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/15/2015 03:45 PM, Jens Axboe wrote:
> On 01/15/2015 04:01 AM, Sitsofe Wheeler wrote:
>> While using fio-2.2.4 the following snippet produces a verification
>> error for me on the second fio invocation:
>>
>> fio --bs=4k --ioengine=libaio --direct=1 --verify=meta --iodepth=128
>> --io_limit=300k --verify_state_save=1 --rw=randwrite --name=write3
>> --filename=/dev/dm-7 && fio --bs=4k --ioengine=libaio --direct=1
>> --verify=meta --iodepth=128 --verify_state_load=1 --rw=randread
>> --name=write3 --filename=/dev/dm-7
>>
>> However if I put the iodepth of the second fio command down to 64 or
>> set io_limit the error goes away. I have also sometimes seen an error
>> that looks similar if the first fio is killed via ctrl-C. Is this to
>> be expected?
>
> Doesn't reproduce here, but both cases would seem to imply that there's
> something not quite right with the completed ios in the verify state
> output. I'll take a look.

I wonder if this will do the trick, can you check? If not, I'll need the 
full output of the two runs, and the state files saved from the first run.


-- 
Jens Axboe


--------------010607030206050009020507
Content-Type: text/x-patch;
 name="depth-ver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="depth-ver.patch"

diff --git a/verify.c b/verify.c
index 205f01a2fc30..260fa2ae2fad 100644
--- a/verify.c
+++ b/verify.c
@@ -1540,10 +1540,12 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 		return 0;
 
 	/*
-	 * If we're not into the window of issues - depth yet, continue
+	 * If we're not into the window of issues - depth yet, continue. If
+	 * issue is shorter than depth, do check.
 	 */
-	if (td->io_blocks[DDIR_READ] < s->depth ||
-	    s->numberio - td->io_blocks[DDIR_READ] > s->depth)
+	if ((td->io_blocks[DDIR_READ] < s->depth ||
+	    s->numberio - td->io_blocks[DDIR_READ] > s->depth) &&
+	    s->numberio > s->depth)
 		return 0;
 
 	/*

--------------010607030206050009020507--

