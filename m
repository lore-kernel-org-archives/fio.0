Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35517 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2DFRpE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Apr 2012 13:45:04 -0400
Message-ID: <4F7F2B97.7000703@kernel.dk>
Date: Fri, 06 Apr 2012 11:44:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20120406040004.1BF99484001@kernel.dk> <4F7E713E.7030300@suse.de> <4F7EF043.9000305@kernel.dk> <4F7F2A75.6030508@suse.de>
In-Reply-To: <4F7F2A75.6030508@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-06 11:40, Danny Kukawka wrote:
> Am 06.04.2012 15:31, schrieb Jens Axboe:
>> On 2012-04-05 22:29, Danny Kukawka wrote:
>>> Am 06.04.2012 06:00, schrieb Jens Axboe:
>>>> The following changes since commit 885ac623a4f154007efa49266bb381bcbc60f1e6:
>>>>
>>>>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>>>>
>>>> are available in the git repository at:
>>>>   git://git.kernel.dk/fio.git master
>>>>
>>>> Jens Axboe (1):
>>>>       group reporting: fix bad values of min/max
>>>
>>> Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't
>>> work for me.
>>>
>>> fio --name=fio1-write-4m-rbd --direct=1 --size=50g --group_reporting
>>> --bs=4m --rw=write --iodepth=128 --ioengine=libaio --filename=/dev/rbd0
>>>
>>> still prints:
>>>
>>> READ: io=65260MB, aggrb=111334KB/s, minb=114006KB/s, maxb=114006KB/s,
>>> mint=600232msec, maxt=600232msec
>>
>> Since that's still off by 1.024, are you absolutely sure you are running
>> the right version of fio?
> 
> I used git snapshot with latest commit
> ddb754dbb54a8174080f753c85ff56a7ffca3957, but I can recheck if needed.

Yes, please re-check, it should not be happening and I don't see it
here.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfyuUAAoJEPfTWPspceCmP1UQAKTo9AeqpSSz7x3VIuHFAQRJ
wv6aNitw0MMc/oWnH40UtcJgAaa19UFYBQxK6NwTCsyjbpqnG+V+lw3OQ1LKuKvj
NyBomGFSQTm6hIa6I6+WyxinR3Ahs8RiMipm4/fJjFZHsNSLd1j6Owm8quT51/YU
GmH7PytAgpJ/fU9jtH1OssZgvwAeoE9NKLL4UHxTrJaCVZLRc/BMUO+vVKsQCcWb
mEC12yK9jJ3oRYF0DYT5boFkrfBA2FSIQFAm36pvlJ7HjiFqDLBxzli//wqvqW5k
z3MlFBGjaFx7q5URRmcHZehkVn5BNnOCnaTRPav5j1B9UEnmEQ6WLK76zBSf9qsM
qnz6ReE89PZF1UdNOzzLl4KEaystJNv5402y0LIaqiNzKK6jK+aDDy09Hw/2JgJm
OnT7EbCK423eLcTA9avVJcRetQ9/0Ay06l/+vHUabmD+iXIDel4BCkN04FaWA+by
D5S9aJCi1pYk+QAygj5V2+2b2Vwv00T13785nQwRVfKBU2gQ+n43dEjLG0sjYkq1
OMnZMhUuCFGhdTHrtyM7pSJjcqEUPLf2OOY1jdHm2PGijdHGSNwCvs94aZtM9/KR
Vh03rzKtGzpPcfvnVTVxJ5F4qpUguR5Fk0tB/r4DMAyufn350vO7sag6iM4WQY8O
J8L3brrFqhkSdYvTtJpi
=FEpB
-----END PGP SIGNATURE-----
