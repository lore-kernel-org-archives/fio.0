Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:61856 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab3L1CMR (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Dec 2013 21:12:17 -0500
Message-ID: <52BE337F.10106@cran.org.uk>
Date: Fri, 27 Dec 2013 19:12:15 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: fio 2.1.4 intermittently crashes on windows
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
In-Reply-To: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Todd Dworshak <todd.dworshak@avid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 12/27/2013 6:42 PM, Todd Dworshak wrote:
> I am having trouble with fio intermittently crashing on Windows 7.
>
> Version is fio 2.1.4 64 bit, downloaded from Windows build site.
>
> Has anyone else seen this?  If I give it fewer files in the job description, it seems to be less prone to crashing.  Since it crashes in pthreads, it looks like this may be some kind of threading bug.

I'll try to replicate the problem here, but in the meantime it would be 
useful if you could try running fio under the Cygwin build of gdb to 
capture a stack trace in fio.exe.

-- 
Bruce
