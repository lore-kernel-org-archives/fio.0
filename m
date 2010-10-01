Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:56485 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0JASLC (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 1 Oct 2010 14:11:02 -0400
Message-ID: <4CA620CD.4040309@fusionio.com>
Date: Fri, 1 Oct 2010 19:56:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: possible fio bug, file not found in hash, cannot open file
References: <AANLkTinEQRcw8ZD6_fYZxodaRiOYda6uYLEf6aenKrXq@mail.gmail.com>
In-Reply-To: <AANLkTinEQRcw8ZD6_fYZxodaRiOYda6uYLEf6aenKrXq@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: DongJin Lee <dongjin.lee@auckland.ac.nz>
Cc: fio@vger.kernel.org

On 2010-09-30 04:57, DongJin Lee wrote:
> Hi all.
> 
> System: ubuntu 10.04 x32 and x64
> 
> I'm trying to use xtreemfs (distributed file system), which I got it
> successfully mounted (it uses fusermount, current version I have is
> 2.8.1),
> so I can write, read, (including gnome drap drog, etc) and do some
> file benchmarks using dbench (testing windows file server) to that
> mounted directory, without any problems.
> Also, I've used iozone benchmark without a problem, so it appears that
> the filesystem works fine.
> 
> However, when I tried to run fio (including the latest version
> 1.44-rc1), I keep getting an 'Invalid argument error', I have no idea
> because this does not happen on other file systems, (e.g., nfs, etc)
> I think the error occurs somewhere getting the file information..
> 
> randread: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> Starting 1 process
> fio: pid=12627, err=22/file:filesetup.c:493,
> func=open(/media/xtreemfs/afile), error=Invalid argument

Try making that direct=0 instead, probably the fs does not support
O_DIRECT.

-- 
Jens Axboe

