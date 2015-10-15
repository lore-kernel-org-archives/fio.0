Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.viktor.guru ([62.210.97.36]:14260 "EHLO mail.viktor.guru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbbJONLl (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Oct 2015 09:11:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.viktor.guru (Postfix) with ESMTP id 887E812A095B
	for <fio@vger.kernel.org>; Thu, 15 Oct 2015 15:11:39 +0200 (CEST)
Received: from mail.viktor.guru ([127.0.0.1])
	by localhost (mail.viktor.guru [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1LsXsuJo804 for <fio@vger.kernel.org>;
	Thu, 15 Oct 2015 15:11:38 +0200 (CEST)
Received: from [10.10.0.21] (unknown [91.185.100.46])
	by mail.viktor.guru (Postfix) with ESMTPSA id 6303412A0951
	for <fio@vger.kernel.org>; Thu, 15 Oct 2015 15:11:37 +0200 (CEST)
Subject: FIO blocksize option clear out
References: <561F97E4.5030807@htec.rs>
From: vmokric <vojislav.mokric@htec.rs>
Message-ID: <561FA608.3010904@htec.rs>
Date: Thu, 15 Oct 2015 15:11:36 +0200
MIME-Version: 1.0
In-Reply-To: <561F97E4.5030807@htec.rs>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello members of the fio forum.

In fio man it says that:

blocksize=int[,int], bs=int[,int]
Block size for I/O units. Default: 4k. Values for reads and
writes can be specified separately in the format/read/,/write/,
either of which may be empty to leave that value at its default.

What exactly is blocksize, i.e. block size for I/O units?

I'm rather new in this world of data storages and file systems, I/O
schedulers, block layers, etc., and I'm rather confused with the block
size terminology.

Judging by wiki page on block devices and block sizes: 
http://wiki.linuxquestions.org/wiki/Block_devices_and_block_sizes, what 
FIO impacts over its block size parameter is File system block size, 
right? I saw that people also give another name for file system block 
size: "cluster size".

So, by default block size (File system block size) is 4k. And my
disk physical sector size (disk block size) is also 4k (and there is
another thing: Kernel block size, and I really don't know how this
impacts data transfer to and from my sda disk (with or without caching)
or I have some vague idea...). Let's say that I change my fio block size 
to 1m. My disk block size is still 4k. What is really the difference 
here now, what is changed? Can someone explain or point me to some 
source? I know it's rather newbie question...

And, does IO depth depends on my SATA disk physical characteristics? Can 
I go higher that IO depth = 32 if my disk returns:

root@linaro-gnome:~# hdparm -I /dev/sda | grep Queue
          Queue depth: 32
             *    Native Command Queueing (NCQ)

Thanks,
Vojislav





