Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:50832 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879Ab0KJTG4 (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Nov 2010 14:06:56 -0500
Date: Wed, 10 Nov 2010 19:58:26 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101110185826.GJ28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101110171856.GI28050@sebastiankayser.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Sebastian Kayser <sebastian@skayser.de> wrote:
> What I will do now is to export the whole 2TB of the disk (instead of
> just 10GB) and increase size= to see whether that makes any difference
> (hopefully). Other than that, further ideas?

Interim update. Exported the whole 2TB disk as a LUN, mkfs.ext3'd it and
set size=100g in fio's configuration. Also set runtime=1800, re-started
the test and could observe ~80 IOPS ... my dear heart was jumping with
joy :)

However, a few minutes into the test, IOPS started to increase steadily
and by now have again reached (non-bursty) regions that don't seem
plausible for a single 7.2K SATA disk.

root@ubuntu-804-x64:~# ./fio --section=iscsi patterns.fio 
iscsi: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
iscsi: Laying out IO file(s) (1 file(s) / 102400MB)
Jobs: 1 (f=1): [w] [48.4% done] [0K/986K /s] [0/240 iops] [eta 15m:28s] 

root@ubuntu-804-x64:~# cat patterns.fio 
[global]
size=100g
runtime=1800
direct=1
sync=1
overwrite=1

[iscsi]
directory=/mnt
rw=randwrite

root@ubuntu-804-x64:~# df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             1.9T  101G  1.7T   6% /mnt

Well, I am so used to see less IOPS than hoped for ... but obviously not
this time and it's driving me crazy :) Any further thoughts greatly
appreciated.

Sebastian
