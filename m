Return-Path: <axboe@kernel.dk>
Message-ID: <5428246F.7020506@kernel.dk>
Date: Sun, 28 Sep 2014 09:08:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Question] How to perform stride access?
References: <542179FA.5040106@gmail.com> <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com> <54228237.5000805@gmail.com> <CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com> <CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com> <5427716A.1080407@kernel.dk> <20140928103616.GA9991@sucs.org> <54281A0A.8050905@kernel.dk>
In-Reply-To: <54281A0A.8050905@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------010308010701080206010404"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010308010701080206010404
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-09-28 08:24, Jens Axboe wrote:
> On 2014-09-28 04:36, Sitsofe Wheeler wrote:
>> (Resending because first mail had an HTML part)
>>
>> On 28 September 2014 03:24, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 24 September 2014 10:52, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>>
>>>>> This looks like a bug. I can reproduce it with 2.1.11-11-gb7f5 too:
>>>>>
>>>>> dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
>>>>> fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --stonewall --name=1M
>>>>> --io_limit=1M  --name=2M --io_limit=2M
>>>>> [...]
>>>>>
>>>>> Run status group 0 (all jobs):
>>>>>     WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s,
>>>>> maxb=256000KB/s,
>>>>> mint=2msec, maxt=2msec
>>>>>
>>>>> Run status group 1 (all jobs):
>>>>>     WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s,
>>>>> maxb=256000KB/s,
>>>>> mint=2msec, maxt=2msec
>>>>>
>>>>> Why isn't io 1024KB for group 0? Additionally, shouldn't the total io
>>>>> written each group be different? Jens?
>>>
>>> You are doing a sequential workload, skipping 4k every time. First write
>>> will be to offset 0, next to 8KB, etc. Write 128 would be to 1040384,
>> which
>>> is 1MB - 8KB. Hence the next feasible offset after that would be 1MB,
>> which
>>> is end of the file. So how could it do more than 512KB of IO? That's
>>> 128 *
>>> 4KB.
>>>
>>> I didn't read the whole thread in detail, just looked at your last
>>> example
>>> here. And for that one, I don't see anything wrong.
>>
>> I guess I would have thought io_limit always forced wraparound. For
>> example:
>>
>> # dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
>> # fio --bs=4k --filename=/dev/shm/1M --name=go1 --rw=write
>> [...]
>> Run status group 0 (all jobs):
>>    WRITE: io=1024KB, aggrb=341333KB/s, minb=341333KB/s, maxb=341333KB/s,
>> mint=3msec, maxt=3msec
>> # fio --bs=4k --filename=/dev/shm/1M --name=go2 --io_limit=2M --rw=write
>> Run status group 0 (all jobs):
>>    WRITE: io=2048KB, aggrb=341333KB/s, minb=341333KB/s, maxb=341333KB/s,
>> mint=6msec, maxt=6msec
>> [...]
>> # fio --bs=4k --filename=/dev/shm/1M --name=go3 --io_limit=2M
>> --rw=write:4k
>> [...]
>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>> mint=2msec, maxt=2msec
>> Run status group 0 (all jobs):
>> # fio --bs=4k --filename=/dev/shm/1M --name=go4 --io_limit=2M
>> --rw=write:4k
>> [...]
>> Run status group 0 (all jobs):
>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>> mint=2msec, maxt=2msec
>>
>> go2 is a plain sequential job that does twice as much I/O as go1. Given
>> that the size of the file being written to has not changed between the
>> runs
>> one could guess that fio simply wrapped around and started from the first
>> offset (0) to write the second MB of data. Given this isn't it a fair
>> assumption that when doing a skipping workload if io_limit is used (as in
>> go4) and an offset beyond the end of the device is produced the same
>> wraparound behaviour as go2 should occur and the total io done should
>> match
>> that specified in io_limit?
>
> I would agree on that, behavior for those cases _should_ be the same.
> Without the holed IO, it closes/reopens the file and repeats the 1M
> writes. With it, it does not. I will take a look.

Does the attached fix it up?

-- 
Jens Axboe


--------------010308010701080206010404
Content-Type: text/x-patch;
 name="seq-reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="seq-reset.patch"

diff --git a/io_u.c b/io_u.c
index 8546899c03e7..cbe14b3f5bda 100644
--- a/io_u.c
+++ b/io_u.c
@@ -283,8 +283,15 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			f->last_pos = f->real_file_size;
 
 		pos = f->last_pos - f->file_offset;
-		if (pos)
+		if (pos) {
 			pos += td->o.ddir_seq_add;
+			/*
+			 * If we reach beyond the end of the file with
+			 * holed IO, wrap around to the beginning again.
+			 */
+			if (pos >= f->real_file_size)
+				pos = f->file_offset;
+		}
 
 		*offset = pos;
 		return 0;

--------------010308010701080206010404--

