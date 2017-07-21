Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:37362 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdGUD1F (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2017 23:27:05 -0400
Received: by mail-ua0-f180.google.com with SMTP id f9so36848542uaf.4
        for <fio@vger.kernel.org>; Thu, 20 Jul 2017 20:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABhOJBQzg6cbvKwxabV7gp99snT2F_u-+V0bQiVVW8-EKmQHcw@mail.gmail.com>
References: <CABhOJBTsk9O4ENXxrJagA5BurXWFWQ4Xmue0Wcy4JD1xX-4KBg@mail.gmail.com>
 <CALjAwxjqFJrG4qoQhO5cV_9c2ZZq9HB=RoTKe5A1-NEMbuNfng@mail.gmail.com> <CABhOJBQzg6cbvKwxabV7gp99snT2F_u-+V0bQiVVW8-EKmQHcw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Jul 2017 04:26:34 +0100
Message-ID: <CALjAwxhQXi=iKY1=rABXyx8cQcbfwN7QcdH-EE-G9haCNWa1qg@mail.gmail.com>
Subject: Re: Random writes' bandwidth evolves differently for different disk's portion
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

>>> If we have 10 identical cars with different fuel amount, shouldn't
>>> they all start at the same speed until the fuel is done !

I can no longer resist and I shall torture your car analogy: by
varying size your car has a different amount of fuel and also the size
of a lap is being changed (which also happens to change when you have
to pit stop). Don't read too much into this analogy though ;-)

Re size:
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
says this for size:
"The total size of file I/O for each thread of this job. Fio will run
until this many bytes has been transferred, unless runtime is limited
by other options (such as runtime, for instance, or
increased/decreased by io_size
[http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-io-size
]).".

If my regular/device file is 1GByte big and I set size to 20% then fio
will only do I/O in the region of 0-200MBytes *and* will only do
200MBytes worth of I/O. In short, size sets both the end of the range
AND the amount of I/O at the same time (this re-iterated in the
explanation for io_size -
http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-io-size
). You get this behaviour regardless of whether you explicitly set
offset or not - offset just changes where the region starts. Perhaps
you have confused io_size with size?

Now imagine my SSD is 1TByte big and has somehow been completely
erased. If I do I/O using size=20% against the SSD's file device I
will only pick random blocks from the first 200GBytes of the SSD. This
essentially means I've manually over-provisioned the SSD as it knows
the region above 200GBytes is untouched and the SSD's maximum
maintainable reserve of pre-erased cells is bigger (at least in
theory). Thus it takes longer before the SSD exhausts all the
pre-erased cells and has to start erasing cells on the fly before
actually being able to write new data. Further, when writes are not
happening the SSD knows it can safely pre-erase up to 80% of itself
thus regrowing the depleted pre-erased cells pool.

A brief aside: a blkdiscard/TRIM/UNMAP is not quite as good as doing a
secure erase because the former just says "I'm not using these
regions" whereas the later won't return until every block has been
erased. Thus you may find the former doesn't generate as many
pre-erased blocks and further you don't actually know when the SSD
will actually get around to erasing the discarded blocks. However, it
tends to be far easier for a user to initiate discards than secure
erases and only doing a discard is better for preserving the life of
your SSD (because it may prevent you using up a cell's erase cycle
unnecessarily).

On 21 July 2017 at 00:59, Elhamer Oussama AbdelKHalek
<abdelkhalekdev@gmail.com> wrote:
> I really appreciate your clarification, but i don't see how i am
> operating on a smaller range by setting only the size=X%! (shouldn't i
> need to set the offset too in order to limit the range ?), My
> understanding is that the size defines the amount of data that needs
> to be written/red/trimmed in the whole disk's LBA range! so basically
> a Job on a 10% size on a full disk should give the same performance as
> on 100%!
>
> And yes you were right, a blkdiscard after each iteration did solve the issue.
> Best.
>
> On Thu, Jul 20, 2017 at 11:39 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi,
>>
>> On 20 July 2017 at 09:26, Elhamer Oussama AbdelKHalek
>> <abdelkhalekdev@gmail.com> wrote:
>>>
>>> I've tried to measure the evolution of the bandwidth in an NVMe disk
>>> when i write only a portion of the disk, so i wrote a simple script
>>> that basically do that:
>>>
>>> For write portion in {10,20...,100} %
>>> |- Write the entire disk with 1s;
>>> |- Write a portion% of the disk randomly using 128k bs; #using fio
>>> |- Log the bandwidth each 50s
>>> End for
>>> My fio file looks like this:
>>>
>>> [global]
>>> ioengine=libaio
>>> iodepth=256
>>> size=X%
>>> direct=1
>>> do_verify=0
>>> continue_on_error=all
>>> filename=/dev/nvme0n1
>>> randseed=1
>>> [write-job]
>>> rw=randwrite
>>> bs=128k
>>> Logically the bandwidth should start from the best bandwidth (for 128k
>>> block size), which is around 1.3 GiB/s for my NVMe, then gets down
>>> till the written portion is met.
>>> But this is not the case, the randwrites for 80%, 90% and 100% of the
>>> disk size start at a different bandwidth than the others!
>>>
>>> This chart shows the evolution of the bandwidth for each portion over the time:
>>> https://user-images.githubusercontent.com/2827220/28362904-97f53fdc-6c7e-11e7-80cd-df36ebbe748e.png
>>>
>>> If we have 10 identical cars with different fuel amount, shouldn't
>>> they all start at the same speed until the fuel is done !
>>> Does fio take into consideration how much he will write and limit the
>>> bandwidth?!
>>> Is this a normal fio functioning? Or am i missing something about how
>>> fio handles portion random writes?
>>
>> You may be facing problems that stem from how SSDs work.
>>
>> By operating over a small range you make it easier for the SSD to keep
>> pre-erased cells available. Essentially you are over-provisioning the
>> SSD by progressively less and less which makes it tougher and tougher
>> for it to maintain its highest speeds.
>>
>> If you progressively tested bigger and bigger ranges you may have
>> "aged" the SSD after each test by essentially pre-conditioning it. If
>> you didn't somehow make enough pre-erased cells available after each
>> run (e.g. by secure erasing between runs) you would essentially be
>> hurting every future run as you increase the chances of running only
>> at garbage collection speeds.
>>
>> See http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.1.pdf
>> for an exhaustive explanation about reliable SSD benchmarking.

-- 
Sitsofe | http://sucs.org/~sits/
