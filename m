Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42168 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0DMIkU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 Apr 2010 04:40:20 -0400
Date: Tue, 13 Apr 2010 10:40:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: --blocksize bug?
Message-ID: <20100413084019.GY27497@kernel.dk>
References: <4BC42842.7000304@broadley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC42842.7000304@broadley.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bill Broadley <bill@broadley.org>
Cc: fio@vger.kernel.org

On Tue, Apr 13 2010, Bill Broadley wrote:
>
> I downloaded 1.38, and then the  
> http://brick.kernel.dk/snaps/fio-git-latest.tar.gz.  Both exhibited  
> identical behavior.
>
> Both built with no problems on a centos-5.4 x86-64 box.
>
> REPORTING-BUGS mentioned cat .git/HEAD, so I'll report it:
> ref: refs/heads/master
>
> Goal:
>   To benchmark randomly accessing a 1GB file with different blocksizes
>   to see how blocksize effects bandwidth.
>
> rand.fio:
> [random-read]
> rw=randread
> size=128m # just enough to get the numbers
> filesize=1G # make sure the seek distance is randomly over 1GB file
> directory=/mnt/tmp
> blocksize=1024k
>
> BTW, the fio.1 page says:
>   blocksize=int[,int], bs=int[,int]
>      Block size for I/O units.  Default: 4k.  Values  for  reads  and
>      writes  can  be  specified  seperately in the format read,write,
>      either of which may be empty to leave that value at its default.
>
> BTW, that should be separately not "seperately"

Thanks, will fix that.

> So since I wanted to vary the blocksize I figured I'd do it on the  
> command line so I said:
> ./fio --showcmd ~/rand.fio
> fio --name=random-read --rw=randread --size=128m --filesize=1G  
> --directory=/mnt/tmp --blocksize=1024k
>
> To I tried to run it:
> ./fio --name=random-read --rw=randread --size=128m --filesize=1G  
> --directory=/mnt/tmp --blocksize=1024k
> ./fio: unrecognized option `--blocksize=1024k'
>
> I tried to use the config file except for the blocksize.  I deleted the  
> blocksize= line from rand.fio and:
> ./fio --blocksize=1m  ~/rand.fio
> ./fio: unrecognized option `--blocksize=1m'
>
> Potential fixes:
> 1) fix showcmd to report a different flag for setting --blocksize
> 2) fix fio to accept --blocksize
>
> Expected behavior:
> I expected ./fio ~/rand.fio to work exactly like the arguments reported  
> by ./fio --showcmd.

And it should, apparently the alias names are not duped to the command
line options. I have fixed this up now, if you download the latest
snapshot it should work.

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

-- 
Jens Axboe

