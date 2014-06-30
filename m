Return-Path: <Frank.DArcy@s3group.com>
Message-ID: <53B14574.7050900@s3group.com>
Date: Mon, 30 Jun 2014 12:09:40 +0100
From: "Frank D'Arcy" <frank.darcy@s3group.com>
MIME-Version: 1.0
Subject: Re: using fio client on 64-bit machine with fio server on 32-bit
 machine
References: <53AD168F.3070403@s3group.com> <53ADA00A.7010401@kernel.dk> <53ADDBF6.5020701@kernel.dk>
In-Reply-To: <53ADDBF6.5020701@kernel.dk>
Content-Type: text/plain;
	charset="ISO-8859-1";
	format="flowed"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Hi Jens,
thanks for getting back to me.
I've rebuilt with the latest but I still see problems with the numbers.

I do see one improvement,
the "% done" printed while the test is in progress now increases nicely 
from 0% to 100%
whereas before it would jump around to seemingly random values between 
0% to 100%

I wonder is it picking the wrong set of numbers to print in some cases.
eg. from a test with 2 jobs that runs for 23 seconds I faound the 
following in normal output ...

when run standalone on a 32-bit VM I see this for a "rw=randread" job
>   read : io=47106B, bw=2047B/s, iops=1023, runt= 23001msec
whereas when the same test is run from  64-bit client to 32-bit server I 
see this for the same job
>   trim: io=98789GB, bw=1000/s, iops=0, runt=98784247808000msec
so it says "trim" where it should say "read"

and for the 2nd job which is "rw=write"
when run standalone on a 32-bit VM I see this
>   write: io=34502B, bw=1500B/s, iops=750, runt= 23001msec
whereas when the same test is run from  64-bit client to 32-bit server I 
see this for the same job
>   read : io=148185GB, bw=1500/s, iops=750, runt=98788542775296msec
so it says "read" where it should say "write"

In the same test run, the following results are identical when run both 
ways ...
>
> Run status group 0 (all jobs):
>    READ: io=46KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s, mint=23001msec, 
> maxt=23001msec
>   WRITE: io=33KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s, mint=23001msec, 
> maxt=23001msec
so these results look correct.

All the above problems are only seen when run from 64-bit client to 
32-bit server,
no problems seen when running standalone,
and no problems seen when running 64-bit client to 64-bit server.

Thanks,
Frank


On 27/06/2014 22:02, Jens Axboe wrote:
> On 06/27/2014 10:47 AM, Jens Axboe wrote:
>> On 2014-06-27 01:00, Frank D'Arcy wrote:
>>> Hi,
>>> I've been playing around with fio (which is really great thanks)
>>> with a view to testing hard disks on set-top boxes (which I don't have
>>> yet)
>>> and as prep for this I created a test environment consisting of
>>> 2 x virtual machines running 32-bit ubuntu (using "hashicorp/precise32"
>>> from vagrant cloud)
>>> running on a 64-bit machine with ubuntu 12.04.
>>>
>>> I started fio (v2.1.10) running in server mode on both virtual machines
>>> as follows
>>> $ fio --server=,8880
>>>
>>> and launched 2 fio (v2.1.10) instances in client mode on the host 64-bit
>>> machine,
>>> $ fio --client=ip:127.0.0.1,8882 test.fio
>>> $ fio --client=ip:127.0.0.1,8881 test.fio
>>> where ports 8881 and 8882 are forwarded to port 8880 on each VM
>>>
>>> The sample test.fio (below) runs for 25 seconds
>>> but the values printed by the clients look garbled.
>>> eg. runtime is a huge number ("runt= 107374182400000msec")
>>>
>>> Same issue is seen when I switched to using latest fio from "git clone"
>>> and the same issue is seen with all output formats (json, terse, normal)
>>>
>>> I changed one of the virtual machines to 64-bit ubuntu (using
>>> "hashicorp/precise64" from vagrant cloud)
>>> and the client talking to the fio server on that VM gave the correct
>>> results (eg. "runt= 25001msec")
>>> while the client talking to the 32-bit ubuntu VM continued to show
>>> garbled values.
>>>
>>> So it looks like support is not there for client-server setups on
>>> non-matching architectures ?
>>> eg. 32-bit client to 64-bit server in this case,
>>> and perhaps endianess differences would be a problem too? ( but I
>>> haven't tried that )
>>>
>>> Apologies if I've missed this issue raised elsewhere, I did a quick
>>> search and found no mention of it.
>>> It's not critical for us, as the simple workaround is to run fio
>>> standalone on each set-top box
>>> outputting results to a file and pulling the file back to a central
>>> machine for parsing.
>>> Just wanted to raise it if its unknown to you.
>> Any mix of 32 vs 64-bit and big vs little endian should work, all the
>> data structures are sanitized across the wire. So if it doesn't work,
>> then that is surely a bug! I'll take a look at this.
> http://git.kernel.dk/?p=fio.git;a=commit;h=819db5f5009742975cfdd036440522bd45b86fe7
>
> this should make it behave better. Let me know if there are still issues
> with 32 vs 64 bit client/server.
>

-- 
Frank D'Arcy
www.s3group.com

-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.


