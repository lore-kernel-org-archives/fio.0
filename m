Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAF+0mvkxEvMfjE3r2ffAz6QWMrHMLfmJOhNU5_3kcYO9Qdm9dg@mail.gmail.com>
References: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>
	<5547D8F3.6090408@kernel.dk>
	<CABtFm2Xwk7krWgobsW0JfCMuGvjFaUzeORggei7+gdVqg2rjhg@mail.gmail.com>
	<CAF+0mvkxEvMfjE3r2ffAz6QWMrHMLfmJOhNU5_3kcYO9Qdm9dg@mail.gmail.com>
Date: Thu, 7 May 2015 11:58:04 +0800
Message-ID: <CABtFm2VhjHURUMHfB=iPoXZfa+_m8xm9qpBCQmv=2UB+Rd-BYA@mail.gmail.com>
Subject: Re: achieving a workload to get specific unique duplicate blocks
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Eaton. One question thought. From the man page for refill_buffers:

"If this option is given, fio will refill the IO buffers on every
submit. The default is to only fill it at init time and reuse that
data. Only makes sense if zero_buffers isn't specified, naturally. If
data verification is enabled, refill_buffers is also automatically
enabled."

Every IO submitted will have a new pattern for repeated workloads?
using refill_buffers, i seem to get same pattern repeatedly. Is that
how it should be? i was under the impression that refill will use new
pattern every time.

# fio --filename=test_refill --readwrite=randwrite --size=1m
--refill_buffers --bs=256k --norandommap --name=refill
# for each in {0..3}; do dd if=test_refill bs=262144 count=1
skip=$each 2>/dev/null | md5sum; done
86c3e47e173a58ad93470fd8db856f8c  -
6fe5ce86d04522889c99809d6d97cb94  -
9113ce00f3781861afc41aaf6da32428  -
f0b575c40e9da23b524f585723cbea4e  -

# fio --filename=test_refill --readwrite=randwrite --size=1m
--refill_buffers --bs=256k --norandommap --name=refill
# for each in {0..3}; do dd if=test_refill bs=262144 count=1
skip=$each 2>/dev/null | md5sum; done
86c3e47e173a58ad93470fd8db856f8c  -
6fe5ce86d04522889c99809d6d97cb94  -
9113ce00f3781861afc41aaf6da32428  -
f0b575c40e9da23b524f585723cbea4e  -
Srinivasa R Chamarthy


On Thu, May 7, 2015 at 10:19 AM, Matthew Eaton <m.eaton82@gmail.com> wrote:
> It doesn't make sense to set refill_buffers and scramble_buffers at
> the same time, since you won't get any repeating data with
> refill_buffers set.
>
> On Mon, May 4, 2015 at 7:23 PM, Srinivasa Chamarthy
> <chamarthy.raju@gmail.com> wrote:
>> Thanks Jens. I was using refill_buffers and scramble_buffers at the
>> same time. If i specify them at the same time, there seems to be no
>> difference in the workloads. If i specify scramble_buffers then there
>> shouldn't be refill_buffers specified to get the buffers differently.
>> Thanks.
>> Srinivasa R Chamarthy
>>
>>
>> On Tue, May 5, 2015 at 4:39 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 04/25/2015 07:03 AM, Srinivasa Chamarthy wrote:
>>>>
>>>> Firstly, thanks before in hand. :)
>>>>
>>>> Using FIO, what is the way to achieve a work load with specific number
>>>> of unique blocks duplicates for specific number of times. For Example,
>>>> i want a 252k block duplicates 1000 times and i want it to be the
>>>> unique block in the complete workload.
>>>
>>>
>>> If you have very specific requirements, it might be easier to simply write
>>> an iolog generator that spits out what you want the pattern to look like.
>>> Then fio can import that, and run the workload.
>>>
>>>> Another query is that, for a blocksize of 256k does the io buffers are
>>>> created at 256k and written to the disk and are all those 256k blocks
>>>> unique buffer?. Can there be a change that in a 256k block, the
>>>> smaller size buffers be the same?
>>>
>>>
>>> That depends on the settings for compressibility, dedupability, etc. In
>>> general see scramble_buffers, refill_buffers, and so on. That is all in the
>>> man page or HOWTO.
>>>
>>> --
>>> Jens Axboe
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

