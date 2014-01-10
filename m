Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:34960 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAJGL2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jan 2014 01:11:28 -0500
Message-ID: <52CF8F08.40605@cran.org.uk>
Date: Thu, 09 Jan 2014 23:11:20 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: fio 2.1.4 intermittently crashes on windows
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com> <52BE337F.10106@cran.org.uk> <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com> <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net> <20140109063709.GA1704@sucs.org> <94D0CD8314A33A4D9D801C0FE68B4029548744AD@G4W3202.americas.hpqcorp.net> <20140110052116.GA19356@sucs.org>
In-Reply-To: <20140110052116.GA19356@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: fio@vger.kernel.org


On 1/9/2014 10:21 PM, Sitsofe Wheeler wrote:
> On Fri, Jan 10, 2014 at 12:37:33AM +0000, Elliott, Robert (Server Storage) wrote:
>> I installed Cygwin gcc, mingwg64*, make, and a few other packages...
>>
>> The built fio.exe ends up complaining about a missing libpthread1-1.dll.
>>
>> Where do I find that?  README says where to get pthreadGC2.dll, but
>> that's apparently not the right file any more.  Browsing up on that
>> FTP site doesn't show it nearby.
> You're right - the README is out of date. If you (re)run your Cygwin
> setup exe then you can use its package browser to install
> mingw[...]-winpthreads .


Sorry - Cygwin switched from pthreads-win32 to winpthreads a couple of 
months ago and I forgot to update the README during the last set of 
changesets.

-- 
Bruce Cran
