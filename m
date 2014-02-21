Return-Path: <fio-owner@vger.kernel.org>
Received: from server506g.appriver.com ([50.56.144.37]:59414 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbaBUTpd convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Feb 2014 14:45:33 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: strange discrepancy
Date: Fri, 21 Feb 2014 19:31:46 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0C0919@DAGN05A-E6.exg6.exghost.com>
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
 <CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
In-Reply-To: <CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pal, Laszlo" <vlad@vlad.hu>, "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Pal, Laszlo

> Finally I've figured out how to use FIO :) now, I can measure several
> things, so I've started to get IOPS data for our hardware. The graphs
> looks good, however I can see a very strange discrepancy at seq_write
> part

> [global]
> ioengine=libaio
Without iodepth >1, you'll effectively be doing synchronous i/o, so there's no benefit to using libaio. If you're interested in throughput (not latency), set iodepth to 512, which will likely be greater than whatever is in the drive/controller/OS.

> buffered=0
Don't need this if you specify-
> direct=1


> bs=4k
> blocksize_range=1k-64k

AFAIK, blocksize_range will supersede bs. Also depending on the drive (what type?), this can cause mis-aligned writes which massively slow the overall process. I've mostly seen this with 4kn and 512e SSDs. You can examine that by trying blockalign=4k.

> size=2048m
I usually use a runtime spec instead of size, and also set fill_device=true.

[snip]

> 
> the results as the follows
(iops or MB/s?)
> Random Read -- 86
> Random Write -- 77
> Sequential Read -- 2170
> Sequential Write -- 45

> I have two questions again.
> The parameters above are good approach to determine IOPS for this system?
See above  :)

> What can be the reason of the huge difference between Seq_read and Seq_write?

Many things. First off, is this a block level test or is there a file system involved? What drives? What controller? RAID? 

z!

