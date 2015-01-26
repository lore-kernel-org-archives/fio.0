Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp114.ord1c.emailsrvr.com ([108.166.43.114]:46635 "EHLO
	smtp114.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbbAZQwL convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 26 Jan 2015 11:52:11 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: sequential writing
From: Josh Carter <public@joshcarter.com>
In-Reply-To: <CADtCuZeCCbocXKJ-_fgcxsOUw-NzhP1H+=eH6Y_LOODnWiGWaQ@mail.gmail.com>
Date: Mon, 26 Jan 2015 09:42:28 -0700
Content-Transfer-Encoding: 8BIT
Message-Id: <80CAF1A1-0654-40F2-BF72-EDD25FAC9A5E@joshcarter.com>
References: <CADtCuZeCCbocXKJ-_fgcxsOUw-NzhP1H+=eH6Y_LOODnWiGWaQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "telecolega ." <telecolega@gmail.com>, fio <fio@vger.kernel.org>

First thing: if you're writing to the device (like /dev/sdX), then you'll get sequential writes at the device. If that device is a spinning disk, then you'll get the best possible performance of laying down blocks one after another. If the device is a SSD, then they'll tend towards filling erase-block size chunks, but you won't have any idea of physical location.

If you're writing to files on a filesystem, however, the answer is less straightforward. Most filesystems will attempt to translate sequential file writes to mostly-sequential writes to the underlying disk. There will be metadata updates in there and whatnot that shake things up a bit. If the filesystem is copy-on-write, like ZFS, and it's been used a lot (has lots of holes), then there's no telling.

Finally, if the device is a RAID, SAN box, or whatever, then that can be very different than a raw disk device.

Best regards,
Josh

On Jan 26, 2015, at 5:56 AM, telecolega . <telecolega@gmail.com> wrote:

> Hi guys,
> 
> In the last days I tried to investigate how fio writes sequentially
> when using the libaio engine. As far as I understood, the key here is
> controlling the offset variable in the iocb struct (iocb->u.c.offset)
> so that the new block is written right next to the previous block.
> 
> Now a question comes to my mind. Even if fio is writing sequentially
> on a file or block, that does not guarantee that we are writing
> sequentially on the hard disk, right? I guess the linux kernel will be
> the one eventually deciding if that data is written sequentially or
> randomly across the disk. Nevertheless, I assume that when FIO writes
> sequentially to a file or block, the likelyhood that the data is
> written sequentially is increased. Is this correct?
> 
> Do you know if there is a way from the user space (e.g. fio) to
> "force" the kernel to write sequentially?
> 
> Thanks ofr your help!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

