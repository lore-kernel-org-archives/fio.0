Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51727 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAJFVT (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jan 2014 00:21:19 -0500
Date: Fri, 10 Jan 2014 05:21:17 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: fio 2.1.4 intermittently crashes on windows
Message-ID: <20140110052116.GA19356@sucs.org>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
 <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>
 <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
 <20140109063709.GA1704@sucs.org>
 <94D0CD8314A33A4D9D801C0FE68B4029548744AD@G4W3202.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548744AD@G4W3202.americas.hpqcorp.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: fio@vger.kernel.org

On Fri, Jan 10, 2014 at 12:37:33AM +0000, Elliott, Robert (Server Storage) wrote:
> I installed Cygwin gcc, mingwg64*, make, and a few other packages...
> 
> The built fio.exe ends up complaining about a missing libpthread1-1.dll.  
> 
> Where do I find that?  README says where to get pthreadGC2.dll, but
> that's apparently not the right file any more.  Browsing up on that
> FTP site doesn't show it nearby.

You're right - the README is out of date. If you (re)run your Cygwin
setup exe then you can use its package browser to install
mingw[...]-winpthreads .

-- 
Sitsofe | http://sucs.org/~sits/
