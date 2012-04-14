Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2DNOrM (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 14 Apr 2012 10:47:12 -0400
Message-ID: <4F898DEC.2000807@kernel.dk>
Date: Sat, 14 Apr 2012 16:47:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20120406040004.1BF99484001@kernel.dk> <4F7E713E.7030300@suse.de> <4F7EF043.9000305@kernel.dk> <4F7F2A75.6030508@suse.de> <4F7F2B97.7000703@kernel.dk> <4F891D18.5020202@suse.de>
In-Reply-To: <4F891D18.5020202@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-14 08:45, Danny Kukawka wrote:
> Am 06.04.2012 19:44, schrieb Jens Axboe:
>> On 2012-04-06 11:40, Danny Kukawka wrote:
>>> Am 06.04.2012 15:31, schrieb Jens Axboe:
>>>> On 2012-04-05 22:29, Danny Kukawka wrote:
>>>>> Am 06.04.2012 06:00, schrieb Jens Axboe:
>>>>>> The following changes since commit 885ac623a4f154007efa49266bb381bcbc60f1e6:
>>>>>>
>>>>>>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>>>>>>
>>>>>> are available in the git repository at:
>>>>>>   git://git.kernel.dk/fio.git master
>>>>>>
>>>>>> Jens Axboe (1):
>>>>>>       group reporting: fix bad values of min/max
>>>>>
>>>>> Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't
>>>>> work for me.
>>>>>
>>>>> fio --name=fio1-write-4m-rbd --direct=1 --size=50g --group_reporting
>>>>> --bs=4m --rw=write --iodepth=128 --ioengine=libaio --filename=/dev/rbd0
>>>>>
>>>>> still prints:
>>>>>
>>>>> READ: io=65260MB, aggrb=111334KB/s, minb=114006KB/s, maxb=114006KB/s,
>>>>> mint=600232msec, maxt=600232msec
>>>>
>>>> Since that's still off by 1.024, are you absolutely sure you are running
>>>> the right version of fio?
>>
>>> I used git snapshot with latest commit
>>> ddb754dbb54a8174080f753c85ff56a7ffca3957, but I can recheck if needed.
>>
>> Yes, please re-check, it should not be happening and I don't see it
>> here.
>>
> 
> I checked again with 8423bd1106a0 and I still see the same problem:
> 
> fio --name=fio1-write-4m-rbd --direct=1 --size=50g --group_reporting
>     --bs=4m --rw=write --iodepth=128 --ioengine=libaio
>     --filename=$TEST_TARGET --output=$DIR/fio1-write-4m-rbd
> 
> Run status group 0 (all jobs):
>   WRITE: io=51200MB, aggrb=20080KB/s, minb=20080KB/s, maxb=20080KB/s,
> mint=2610946msec, maxt=2610946msec

I'm confused on what you think is an issue? From the above, fio
transferred 51200MB, which is 52428800KB. The runtime was 2610.946s,
which gives us a throughput of 20080.38KB/sec. Which is what fio
reports. aggrb/minb/maxb are identical, which was the original bug.

What am I missing?

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPiY3oAAoJEPfTWPspceCm7TIP/jCGLv0L6Th7T4FosTrCC0bm
U9jUDWkNo+b4n+87FLTmX6rxXenNN/NbGYJHaCE8A+FnWyDLihhEAslMD9mqn7OA
66EWir/HrbzikQ6mF9fMPDWCLLNKVV+eVORmrN3Ne6y6d3luH5RiMFKOfWmdbhv2
cHhVpDx5hfGF+tvRcPy/NIOkl7gNszOqF2ili9wP+aTokp+2jF7rVK9pw7KfA9jG
IPrt2oC6hIr6+6v8xekZRgEH61R/Gsq6T0Tf0dJtEMMNhcspEpXZbKCf1xV8+22W
HmYsjVJysIPEn0KCnPzE+DtDEF/rInbYvlTuOcJS1ugMt/AGOWtQm9OprIQTQsc+
T0lMQ4lVEzxmcvy3dMs2pnTL0pdWOAVfNXGopVpd1jV0jI1uBvsZyW2sBpiVn7nA
10GB6Y97Cm+ap9oaP+nnxRgLjmHrDpbgSFnRt6CFUnD+6xp2iV8Bo7qA06e0ABwT
IFpeHW57OhhR+zIMqNqsldvsuuPB8PKWxvi0eH7YBuDKk/XoD91Im9iYJRxjbvBQ
xN7hpjeWFQap4OLPERKDoTYBcJ4NdYaM9UdXPsmazc4T28K2tmxtzcIrkalj1Ryn
d6B0FoQRWZlPYk3c7NbDKcz49llC08zdptNffMP2g8fKzgGxzTY/oAgiET6JqK/o
dSMKbZgMjfK2iNGUjLR9
=Mpll
-----END PGP SIGNATURE-----
