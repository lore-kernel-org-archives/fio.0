Return-Path: <fio-owner@vger.kernel.org>
Received: from marcos.anarc.at ([206.248.172.91]:52504 "EHLO marcos.anarc.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCPMjR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2017 08:39:17 -0400
From: Antoine =?utf-8?Q?Beaupr=C3=A9?= <anarcat@orangeseeds.org>
Subject: Re: could fio be used to wipe disks?
In-Reply-To: <CALjAwxjrNpTQTitcZCFA205m6mtE04OC_R_zmsK593hEUK3bPg@mail.gmail.com>
References: <87fuie2p40.fsf@curie.anarc.at> <CALjAwxjrNpTQTitcZCFA205m6mtE04OC_R_zmsK593hEUK3bPg@mail.gmail.com>
Date: Thu, 16 Mar 2017 08:30:18 -0400
Message-ID: <87shmd1k11.fsf@curie.anarc.at>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2017-03-16 07:42:48, Sitsofe Wheeler wrote:
> Hi,
>
> 1. It will try and use the whole area of the disk but if fio's
> blocksize turns out not to the same as the disk's block size it may
> miss the very end of the disk.

I see.

> Also if an error is encountered fio may
> stop part way through and fail to overwrite the rest of the data.

That's not much of an issue for me.

> you're not paranoid about disk wiping then it is unlikely that fio
> will be any faster than doing something like
> dd if=/dev/zero of=/dev/mydisk bs=1M oflag=direct

The idea is not to be fast, but to two the two things at once: a more
extensive stress test *and* a disk wipe, in optimal time.

> Bear in mind that if you're worried about wiping disks properly you
> will have to write particular pattern over the disk.

Yeah, I know about nwipe and everything. As I mentioned originally, I am
not sure this is in the scope of my project...

> Further it may not easier than you think to get at stale internal
> mappings the "disk" might have which is why you use SECURE ERASE on
> SSDs. fio does none of this.

... I also mentioned I was aware of SSD specifics, thanks. :)

> Since you mentioned stress you may want to look at using a deeper
> iodepth with the libaio engine (assuming you're on Linux, other
> platforms have asynchronous engines too) and only doing the sync at
> the end.

Even after reading this:

http://fio.readthedocs.io/en/latest/fio_doc.html#i-o-depth

I don't quite understand what iodepth does or how to use it. Could you
expand on this?

> 2. What you are proposing is very dangerous. Assuming the filesystem
> is unmounted you and you wanted to do writes you would need to read
> the data and then write that same data back but fio has no facility
> for such a thing at present. If the filesystem is mounted then I think
> what you're asking for is impossible without introducing the
> possibility of filesystem corruption.

Right, that's what I figured as well, thanks for the confirmation!

A.

-- 
The Net treats censorship as damage and routes around it.
                         - John Gilmore
