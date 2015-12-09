Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbbLICzI (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Dec 2015 21:55:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1a6UuG-0004RR-Fu
	for fio@vger.kernel.org; Wed, 09 Dec 2015 03:55:05 +0100
Received: from eagleheights-118-111.resnet.wisc.edu ([146.151.118.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 03:55:04 +0100
Received: from jhe by eagleheights-118-111.resnet.wisc.edu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 03:55:04 +0100
From: Jun He <jhe@cs.wisc.edu>
Subject: =?utf-8?b?aW9fc2l6ZQ==?= usage
Date: Wed, 9 Dec 2015 02:50:40 +0000 (UTC)
Message-ID: <loom.20151209T033523-799@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,
I think there is a bug for io_size. 

For example, I want to write 16KB data to a file of size 8KB (so each block is
written twice) and I have the following job file:

[global]
ioengine=sync
rw=write
bs=4kb
size=8kb
io_size=32kb

[job1]
write_iolog=iolog.1


After running, iolog.1 will contain the following contents:

fio version 2 iolog
job1.0.0 add
job1.0.0 open
job1.0.0 write 0 4096
job1.0.0 write 4096 4096
job1.0.0 close

This shows that each block has been only written once. 

If I change the ioengine to libaio, iolog.1 will contain:

fio version 2 iolog
job1.0.0 add
job1.0.0 open
job1.0.0 write 0 4096
job1.0.0 write 4096 4096
job1.0.0 close
job1.0.0 open
job1.0.0 write 0 4096
job1.0.0 write 4096 4096
job1.0.0 close
job1.0.0 open
job1.0.0 write 0 4096
job1.0.0 write 4096 4096
job1.0.0 close
job1.0.0 open
job1.0.0 write 0 4096
job1.0.0 write 4096 4096
job1.0.0 close


Bug or wrong usage?

Thanks,
Jun



