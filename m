Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423096Ab2KNRnH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 12:43:07 -0500
Message-ID: <50A3D823.4050707@kernel.dk>
Date: Wed, 14 Nov 2012 10:42:59 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211132323.qADNNb1I29385361@zion.americas.sgi.com>
In-Reply-To: <201211132323.qADNNb1I29385361@zion.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Scott Emery <emery@sgi.com>
Cc: fio@vger.kernel.org

On 2012-11-13 16:23, Scott Emery wrote:
> 	I'm trying to use the client/server feature in fio 2.0.10
> vanilla and I'm finding that "All clients" prints too soon. 
> 
> ---
> semery@xxx2-zzz2 multi2]$ cat run.all.2
> 
> export FIO="../fio-2.0.10/fio"
> export SERVERS="xxx2-yyy1-ext xxx2-yyy2-ext xxx2-yyy3-ext xxx2-yyy4-ext"
> #export SERVERS="xxx2-yyy1-ext"
> export BASE=/pdmf/semery/bench
> export SCRIPT="write_tape_2"
> 
> # parameters used in test file
> 
> export ARGS=""
> 
> for i in $SERVERS
> do
> # prep for run
>         export HOST=$i
>         export DIR=${BASE}/${HOST}
>         sed "s_DIR_${DIR}"_ < $SCRIPT > $SCRIPT.$HOST
>         mkdir -p $DIR
>         ARGS+="--client=$HOST $SCRIPT.$HOST "
> done
> 
> echo $FIO $ARGS
> 
> $FIO $ARGS > $SCRIPT.out &
> [semery@xxx2-zzz2 multi2]$ rm /pdmf/semery/bench/xxx2*/*
> [semery@xxx2-zzz2 multi2]$ ./run.all.2
> ../fio-2.0.10/fio --client=xxx2-yyy1-ext write_tape_2.xxx2-yyy1-ext --client=xxx
> 2-yyy2-ext write_tape_2.xxx2-yyy2-ext --client=xxx2-yyy3-ext write_tape_2.xxx2-y
> yy3-ext --client=xxx2-yyy4-ext write_tape_2.xxx2-yyy4-ext
> [semery@xxx2-zzz2 multi2]$ egrep 'groupid|bw=' write_tape_2.out
> wt2: (groupid=1, jobs=1): err= 0: pid=1456: Tue Nov 13 15:06:11 2012
>   read : io=10240MB, bw=277592KB/s, iops=135 , runt= 37774msec
> wt2: (groupid=1, jobs=1): err= 0: pid=1457: Tue Nov 13 15:06:11 2012
>   read : io=10240MB, bw=278144KB/s, iops=135 , runt= 37699msec
> wt2: (groupid=1, jobs=1): err= 0: pid=19876: Tue Nov 13 15:06:12 2012
>   read : io=10240MB, bw=276954KB/s, iops=135 , runt= 37861msec
> All clients: (groupid=1, jobs=3): err= 0: pid=0: Tue Nov 13 15:06:12 2012
>   read : io=32212MB, bw=850803KB/s, iops=405 , runt= 37861msec
> wt2: (groupid=1, jobs=1): err= 0: pid=19877: Tue Nov 13 15:06:12 2012
>   read : io=10240MB, bw=279003KB/s, iops=136 , runt= 37583msec
> wt2: (groupid=1, jobs=1): err= 0: pid=6569: Tue Nov 13 15:06:18 2012
>   read : io=10240MB, bw=276443KB/s, iops=134 , runt= 37931msec
> wt2: (groupid=1, jobs=1): err= 0: pid=6570: Tue Nov 13 15:06:18 2012
>   read : io=10240MB, bw=276530KB/s, iops=135 , runt= 37919msec
> wt2: (groupid=1, jobs=1): err= 0: pid=19145: Tue Nov 13 15:06:18 2012
>   read : io=10240MB, bw=276501KB/s, iops=135 , runt= 37923msec
> wt2: (groupid=1, jobs=1): err= 0: pid=19146: Tue Nov 13 15:06:18 2012
>   read : io=10240MB, bw=276669KB/s, iops=135 , runt= 37900msec
> [semery@xxx2-zzz2 multi2]$ cat write_tape_2.xxx2-yyy1-ext
> 
> [global]
> bs=2m
> ioengine=libaio
> fallocate=posix
> rate=270m
> iodepth=64
> size=10g
> direct=1
> directory=/pdmf/semery/bench/xxx2-yyy1-ext
> 
> [wt2]
> rw=read
> numjobs=2
> stonewall
> 
> ---
> 
> 	For a while it was totting things up after four clients,
> which kind of made sense... now it's stuck on three.  Back when
> it made more sense I thought that maybe handle_ts only dealt with
> the information from a single thread for each client rather than
> the aggregate of multiple thread jobs.  That part seems to hold
> true even when it doesn't have the info for all the clients.
> 
> 	Is this reporting the aggregate as expected?
> 	Is there a parameter change that I need to make to get
> the output I expect?

As the job file is written, it will not aggregate results from a single
"instance" of the server. You would want group_reporting=1 to do that.
However, that will still give you one set of outputs per connection, not
one for all of them. Right now fio does not support collecting outputs
from all connections, a higher level group reporting if you will.

-- 
Jens Axboe

