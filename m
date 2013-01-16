Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp146.dfw.emailsrvr.com ([67.192.241.146]:50151 "EHLO
	smtp146.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3APPqm convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 16 Jan 2013 10:46:42 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Multi-thread vs. Single-thread job config
From: Josh Carter <public@joshcarter.com>
In-Reply-To: <CAB-428k3dw2TLm_5-7ELzdffCNpHb02ZSzsK73=GD-YVkOgWWA@mail.gmail.com>
Date: Wed, 16 Jan 2013 08:38:18 -0700
Content-Transfer-Encoding: 7BIT
Message-Id: <CF1923A4-1E21-476D-AF9E-AC12920DD274@joshcarter.com>
References: <CAB-428kduvROVr6oqVYsBaZAEA0WqUddLiB=yNiJNTw_TdYM0g@mail.gmail.com> <CAB-428k3dw2TLm_5-7ELzdffCNpHb02ZSzsK73=GD-YVkOgWWA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: fio@vger.kernel.org

I believe the effect you're seeing is that multiple threads will make the IO look more random at the block device. Your configuration uses sequential writes, but with numjobs=4 you'll have each job writing at a different place in the device. Thus, lots of seeks. If the jobs had rw=randwrite, you'd probably see about the same performance in both configurations.

One configuration where the 4-job config would run faster is if rw=randwrite and iodepth=1. (Or, ioengine=sync.) In that case, the 4 jobs would keep the IO queue more full than 1 job. But sequential writes with a deep IO queue (like you have) is generally the best case for a single raw block device.

Note, even solid-state/flash drives see better performance with sequential writes than with random writes.

Best regards,
Josh


On Jan 16, 2013, at 8:01 AM, Alireza Haghdoost <haghdoost@gmail.com> wrote:

> Hello
> 
> I am running fio on the top of raw block device with following two
> configurations and I saw the first config (single threaded) can put
> more load on the underlying storage system compared to second config
> (with 4 thread). However, I expected to see the opposite side (more IO
> load with multiple job compared to single job). Does it make sense to
> you ? Is there any locking or handshaking between multiple jobs in the
> second config that reduce the IO injection rate of fio ?
> 
> ; -- start job Config 1 file --
> [global]
> rw=write
> size=5G
> 
> [job1]
> ioengine=libaio
> iodepth=8192
> bs=4k
> direct=1
> numjobs=1
> directory=/dev
> filename=sdp
> ; -- end job file --
> ------------------------------------------------
> 
> ; -- start job Config 2 file --
> [global]
> rw=write
> size=5G
> 
> [job1]
> ioengine=libaio
> iodepth=8192
> bs=4k
> direct=1
> numjobs=4
> directory=/dev
> filename=sdp
> ; -- end job file --
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

