Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56724 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaA0Uqg (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jan 2014 15:46:36 -0500
Date: Mon, 27 Jan 2014 20:46:31 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: fio 2.1.4 intermittently crashes on windows
Message-ID: <20140127204630.GA1150@sucs.org>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
 <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>
 <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
 <20140109063709.GA1704@sucs.org>
 <94D0CD8314A33A4D9D801C0FE68B4029548744AD@G4W3202.americas.hpqcorp.net>
 <20140110052116.GA19356@sucs.org>
 <52CF8F08.40605@cran.org.uk>
 <94D0CD8314A33A4D9D801C0FE68B402954874EEC@G4W3202.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402954874EEC@G4W3202.americas.hpqcorp.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Jan 10, 2014 at 04:46:05PM +0000, Elliott, Robert (Server Storage) wrote:
 
> 3. The assert does not trigger, and the same crash occurs as before.
> 
> C:\Users\Administrator\fio>c:\cygwin64\bin\gdb -args "c:/program files/fio/fio.exe" --filename=rob.tmp --size=128m --direct=1 --rw=randread --refill_buffers --norandommap --randrepeat=0 --bs=4k --iodepth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest --time_based
> Jobs: 0 (f=0)
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000064943236 in pthread_mutex_unlock ()
>    from /cygdrive/c/program files/fio/libwinpthread-1.dll

I've finally had time to reproduce this on a Windows 7 box. I use a
different command line:

./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname

The problem appears to be that the mutex is being destroyed while it is
still being held by a different thread. Adding return; to the first line
of fio_mutex_remove in mutex.c papers over the problem...

-- 
Sitsofe | http://sucs.org/~sits/
