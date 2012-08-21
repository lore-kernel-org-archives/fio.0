Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:47718 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab2HULln (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 07:41:43 -0400
Message-ID: <503373F4.80000@cran.org.uk>
Date: Tue, 21 Aug 2012 12:41:40 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Rate problems (Windows)
References: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com> <CAHaS=QxJeWf-YvKkLktR45W2g-dRhEcXgM=7napOxb8ct7pKEg@mail.gmail.com> <503230E9.2000406@kernel.dk> <CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com>
In-Reply-To: <CAHaS=QzK4xhuu4vgqOQfNtLaVJE6kbsHtCj1A-BCCTFs=0eTYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 21/08/2012 12:35, Greg Sullivan wrote:
> I have now done a basic test of the rate functionality on Ubuntu, and
> it seems to be working fine. I am more confident now that there is
> indeed a problem when running fio on Windows.

Are you running the test on a new filesystem on a separate disk, or in a 
directory on a disk that's got lots of other files on it?

-- 
Bruce Cran
