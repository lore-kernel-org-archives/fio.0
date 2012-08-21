Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:15618 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab2HULxU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 07:53:20 -0400
Message-ID: <503376AD.5020602@cran.org.uk>
Date: Tue, 21 Aug 2012 12:53:17 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Rate problems (Windows)
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com> <CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com> <503230E9.2000406@kernel.dk> <CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com> <503373F4.80000@cran.org.uk> <CAHaS=Qz74ZHJCkFc4r-syfBM5q+nbzNZS9UYedr5E1nFbZwLcQ@mail.gmail.com>
In-Reply-To: <CAHaS=Qz74ZHJCkFc4r-syfBM5q+nbzNZS9UYedr5E1nFbZwLcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 21/08/2012 12:44, Greg Sullivan wrote:
> A dedicated disk. It has some files on it, but not much. There are no
> other processes accessing the disk.  Are you not able to reproduce the
> problem?

I saw the problem last week on an old installation of Server 2008 R2 on 
a disk that was over 40% fragmented and had other traffic to it but now, 
on Windows 8 the IOPS stay between 39 and 40.

-- 
Bruce
