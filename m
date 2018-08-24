Return-Path: <axboe@kernel.dk>
Subject: Re: Zoned block device support for fio
References: <a1373211271aee157884ec6dea024ecc2c17331d.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <be10a7d0-2d90-9381-4d05-6c4c4b81d461@kernel.dk>
Date: Fri, 24 Aug 2018 07:48:31 -0600
MIME-Version: 1.0
In-Reply-To: <a1373211271aee157884ec6dea024ecc2c17331d.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/23/18 5:00 PM, Bart Van Assche wrote:
> Hello,
> 
> The code on the master branch of my fio repository on github has been
> updated again. The changes compared to the previous version are:
> * A new job option has been added, namely zonemode. zonemode=zbd has to be
>   specified when filename refers to a zoned block device. zonesize has a new
>   meaning for zonemode=zbd. When both zonemode and zonesize have been
>   specified and filename refers to a regular block device the I/O pattern
>   the same as for a zoned block device (at least if all write pointers of the
>   zoned block device are reset before fio is started). This behavior change
>   was requested by Jens.
> * A subtle bug has been fixed that caused I/O against a zoned block device to
>   stop early if multiple jobs were doing random writes to the same LBA range
>   and with the random map enabled.
> * The zonemode=zbd do_verify=1 combination no longer causes fio to report
>   verify errors when run against the conventional zones of a zoned block
>   device.
> * The code for skipping offline zones should now work. Offline zones were not
>   skipped in previous versions. I have not yet tested this code - testing this
>   change requires access to a real or simulated openchannel SSD.
> * Several new unit tests have been added to t/zbc/test-zbc-support.
> 
> See also https://github.com/axboe/fio/pull/585.

I'm going to reply here, since I generally hate github review for anything
but the simplest of things.

I think this is starting to look good. For the filesetup.c changes, I think
that this:

+       if (o->zone_mode == ZONE_MODE_NONE && o->zone_size)
+               o->zone_mode = ZONE_MODE_STRIDED;

belongs in fixup_options()zbd_init() should not be something that
is unconditionally called. Only do it if ZONE_MODE_ZBD is set and make
that explicit. Also kill zbd querying in zbd_init() if we haven't asked for
it.

Can you git send-email the series to me and the list? I'll take a closer
look.

-- 
Jens Axboe


