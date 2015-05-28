Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35264 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbE1FKt (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 28 May 2015 01:10:49 -0400
Received: by lbbuc2 with SMTP id uc2so20750354lbb.2
        for <fio@vger.kernel.org>; Wed, 27 May 2015 22:10:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALSnuyzG9MaUW0dh2-19WvPAFDDupu9QC-zK0Pz+8vZzs+fvJA@mail.gmail.com>
References: <CALSnuyzG9MaUW0dh2-19WvPAFDDupu9QC-zK0Pz+8vZzs+fvJA@mail.gmail.com>
Date: Thu, 28 May 2015 06:10:47 +0100
Message-ID: <CALjAwxgDpAOP+5O=oUVGnv2W0VStVy3AEiOc8LrDpfAjo_Fv3w@mail.gmail.com>
Subject: Re: fio offset cycling.
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Adrin Fernandes <adrin.fernandes@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 28 May 2015 at 01:05, Adrin Fernandes <adrin.fernandes@gmail.com> wrote:
> Hi,
> I'm using a statically compiled fio-2.2.8 binary to run some
> benchmarks with the fill_device option set to true with an offset of
> rw=write:4m on Linux and Windows.
>
> My file is a block device.
>
> Looking through the write_iolog, I see the offset keeps cycling. Once
> the offset is beyond the disk size, it resets to zero and starts all
> over again.
>
> I'm not sure if this is a bug or not?
>
> Is this expected behavior?

I'm not sure I follow (also bear in mind you haven't posted your full
job file which forces anyone trying to answer to guess at things).
Since you aren't expecting it can you describe what you would have
expected? When you say the offset cycles can you give an example of
what it is cycling to?

Here's what the HOWTO
(https://github.com/axboe/fio/blob/fio-2.2.8/HOWTO#L381 ) says about
the rw=<type>[:offset] syntax:

[...] It is possible to specify a number of IO's to do before getting
a new offset, this is done by appending a ':<nr>' to the end of the
string given. [...] If the suffix is used with a sequential IO
pattern, then the value specified will be added to the generated
offset for each IO.  For instance, using rw=write:4k will skip 4k for
every write. It turns sequential IO into sequential IO with holes.
[...]

Based on the above and taking some guesses I would expect a job like
the one you described to write bs amount then skip 4Mbytes, write
another bs amount then skip another 4MBytes etc. until the end of the
device. So first offset might be 0, then the next bs+4Mbytes then the
next (bs+4MBytes)*2 etc.

-- 
Sitsofe | http://sucs.org/~sits/
