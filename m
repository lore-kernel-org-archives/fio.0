Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34787 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAIHEQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Jan 2014 02:04:16 -0500
Date: Thu, 9 Jan 2014 06:37:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: fio 2.1.4 intermittently crashes on windows
Message-ID: <20140109063709.GA1704@sucs.org>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
 <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>
 <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Todd Dworshak <todd.dworshak@avid.com>, 'Bruce Cran' <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Jan 09, 2014 at 01:07:56AM +0000, Elliott, Robert (Server Storage) wrote:
> I've seen something similar:
> - 2.1.4 on a Windows Server 2008 R2 system: crash
> 
> This is this error for 2.1.4 on Windows Server 2008 R2: 

<snip>

> (gdb) f 2
> #2  0x0000000000421599 in fio_mutex_up (mutex=0x2f5b10) at mutex.c:151
> 151     mutex.c: No such file or directory.
> (gdb) p mutex
> $1 = (struct fio_mutex *) 0x2f5b10
> (gdb) p *mutex
> $2 = {lock = 0x1bab1f00d, cond = 0x100000000, value = 0, waiters = 0, magic = 172}

This is crazy - the magic value is 172 rather than 1297437765 but the
fio_mutex_up() function is protected by an assert that checks to see if
the mutex's magic number is wrong. Could you can insert something like
the following after line 149:
assert(mutex->magic == FIO_MUTEX_MAGIC);
to prove that the value has not been stomped on before
pthread_cond_signal is run?

-- 
Sitsofe | http://sucs.org/~sits/
