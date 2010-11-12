Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:40321 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab0KLOrT (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Nov 2010 09:47:19 -0500
Date: Fri, 12 Nov 2010 15:38:40 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101112143840.GT28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <20101110185826.GJ28050@sebastiankayser.de> <C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com> <20101110195214.GK28050@sebastiankayser.de> <4CDAFAC5.9070608@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CDAFAC5.9070608@fusionio.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2010-11-10 20:52, Sebastian Kayser wrote:
> > * John Cagle <jcagle@gmail.com> wrote:
> >> If the disk is 2TB, then your 100GB test is only using 5% of it-- thus
> >> your observed IOPS will be a lot better than expected due to
> >> short-stroking.  Right?
> > 
> > I don't know. The inital 80 IOPS (observed over about 2 full minutes)
> > made me believe that 100GB would have covered a high enough percentage
> > to at least eliminate track-to-track seeks. Are short-stroked seeks also
> > that much faster compared to average seek times? And where would the
> > steady increase in IOPS during the test come from?
> > 
> > But you are definitly right when it comes to the test setup. I just
> > started a test with size=1800g. Looking foward to what that will show.
> 
> If you have the full device, you could just test on that instead of
> using a filesystem and file. Just to get more 'raw' performance.

Thanks. This also turned out to be much more feasible for "quick" test
turn-around. As soon as I ran the tests with size=1800g it took ages to
prepare the test file (~30 MB/s towards the iSCSI target) and one disk
even quit on me over night.

When staying within the realm of file based testing, can fio determine
and display the progress (think: progress bar or percentage) when it
prepares the test file?

Sebastian
