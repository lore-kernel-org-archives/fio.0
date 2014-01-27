Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140127230339.GN2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
	<20140127192215.GF2782@kernel.dk>
	<CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
	<20140127224603.GM2782@kernel.dk>
	<20140127230339.GN2782@kernel.dk>
Date: Mon, 27 Jan 2014 15:16:41 -0800
Message-ID: <CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
Subject: Re: A bug in combining fsrange and verify
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Wallence Lu <wallencelu@gmail.com>, FIO_list <fio@vger.kernel.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

On Mon, Jan 27, 2014 at 3:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Mon, Jan 27 2014, Jens Axboe wrote:
>> On Mon, Jan 27 2014, Wallence Lu wrote:
>> > Recreated with fio 2.0.11-35-g8428, the version was checked out from
>> > https://github.com/axboe/fio.
>>
>> 2.1.4 is the latest, but I don't think that would change anything for
>> you.
>>
>> > I read a little bit of the source code, it seems to me the randwrite
>> > option gets the LBA without specifying the IO size. With that said,
>> > for a bsrange option, it is likely one random IO can step onto another
>> > IO if they happen to be adjacent. For example, request A has LBA
>> > of 1024 and size 8K, request B has LBA 1016 and size 16K. Without
>> > checking the request size, request B can overwrite content of request
>> > A.
>> >
>> > Is that the right interpretation? Do I miss something? Thanks.
>>
>> Fio is supposed to handle that, the job file should work. I'll take a
>> look at it.
>
> Works for me with the 2.1.4 release. It's actually broken in current
> -git, due to the numberio patches..

You mean all of the "verify_only" support patches or specifically this patch:

commit da0a7bd224bb9331f27bb4b20394dd5c8fa3acb0
Author: Juan Casse <jcasse@chromium.org>
Date:   Tue Sep 17 14:06:12 2013 -0700

    Adds check for numberio during verify phase.

I can take a look at this tomorrow... let me see if I have the job
file in another email.

thanks,
grant

