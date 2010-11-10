Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54824 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0KJTuI convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Nov 2010 14:50:08 -0500
Received: by gxk23 with SMTP id 23so667516gxk.19
        for <fio@vger.kernel.org>; Wed, 10 Nov 2010 11:50:07 -0800 (PST)
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <20101110185826.GJ28050@sebastiankayser.de>
In-Reply-To: <20101110185826.GJ28050@sebastiankayser.de>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com>
Content-Transfer-Encoding: 8BIT
From: John Cagle <jcagle@gmail.com>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Date: Wed, 10 Nov 2010 12:50:27 -0700
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

If the disk is 2TB, then your 100GB test is only using 5% of it-- thus your observed IOPS will be a lot better than expected due to short-stroking.  Right?

On Nov 10, 2010, at 11:58 AM, Sebastian Kayser <sebastian@skayser.de> wrote:

> * Sebastian Kayser <sebastian@skayser.de> wrote:
>> What I will do now is to export the whole 2TB of the disk (instead of
>> just 10GB) and increase size= to see whether that makes any difference
>> (hopefully). Other than that, further ideas?
> 
> Interim update. Exported the whole 2TB disk as a LUN, mkfs.ext3'd it and
> set size=100g in fio's configuration. Also set runtime=1800, re-started
> the test and could observe ~80 IOPS ... my dear heart was jumping with
> joy :)
> 
> However, a few minutes into the test, IOPS started to increase steadily
> and by now have again reached (non-bursty) regions that don't seem
> plausible for a single 7.2K SATA disk.
> 
> root@ubuntu-804-x64:~# ./fio --section=iscsi patterns.fio 
> iscsi: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> Starting 1 process
> iscsi: Laying out IO file(s) (1 file(s) / 102400MB)
> Jobs: 1 (f=1): [w] [48.4% done] [0K/986K /s] [0/240 iops] [eta 15m:28s] 
> 
> root@ubuntu-804-x64:~# cat patterns.fio 
> [global]
> size=100g
> runtime=1800
> direct=1
> sync=1
> overwrite=1
> 
> [iscsi]
> directory=/mnt
> rw=randwrite
> 
> root@ubuntu-804-x64:~# df -h /mnt
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb1             1.9T  101G  1.7T   6% /mnt
> 
> Well, I am so used to see less IOPS than hoped for ... but obviously not
> this time and it's driving me crazy :) Any further thoughts greatly
> appreciated.
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
