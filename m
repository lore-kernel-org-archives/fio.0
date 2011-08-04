Return-Path: <dongjin.lee@auckland.ac.nz>
MIME-Version: 1.0
From: DongJin Lee <dongjin.lee@auckland.ac.nz>
Date: Thu, 4 Aug 2011 01:12:57 -0600
Subject: Re: On I/O engines
Message-ID: 
 <CA+e7fc8=c5seskVFiPRW_6iQ4YQGQG4eiD0Mxgi9tHS72UYj1Q@mail.gmail.com>
References: <201108032213.36977.Martin@lichtvoll.de>
	<4E3A4008.9050105@fusionio.com>
	<CA+e7fc_Lfm=Zhp52sAWWLf7g4h6K_fW9w66inSqpx-n9ajh__g@mail.gmail.com>
	<4E3A445E.9010901@fusionio.com>
In-Reply-To: <4E3A445E.9010901@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> The devices are stopped at some point, that should ensure that the
> caches are stable.

so assuming that I have no data caches (to be written to the disk)
hanging around the system; I should be able to just unplug the
sata/power cable? :-} (i.e., equivalent to nice shut-down?)
I always thought that there was some special os command to shuts it
nicely, i.e., all confirmed within disk internal that its 32/64mb is
empty before goes off...
I know for raid-wb with bbu, no problems whatsoever..

Regards

On Thu, Aug 4, 2011 at 19:03, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-08-04 08:58, DongJin Lee wrote:
>> just adding 2c question:
>>
>>> On Thu, Aug 4, 2011 at 18:45, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> That does not mean it's stable, it could just be
>>> sitting in the drive write back cache.
>>
>> right, example with a simple hdd 2tb with some 64mb cache, so indeed,
>> there's no real way to confirm that the data has been physically
>> written to the mechanical platter;
>
> Usually any type of device that has a write back caching scheme also
> supports a command to sync/flush that cache. This is what the kernel
> does when you use one of the fsync() variants.
>
>> but as I understand when shutting down the system, all are physically
>> written to the platter; so I wonder what command the os issues to the
>> disk then? maybe just unmount do so?
>
> The devices are stopped at some point, that should ensure that the
> caches are stable.
>
>
> --
> Jens Axboe
>
>

