Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:51163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0KLR7e convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Nov 2010 12:59:34 -0500
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id oACHxXv5006861
	for <fio@vger.kernel.org>; Fri, 12 Nov 2010 09:59:33 -0800
Received: from iwn42 (iwn42.prod.google.com [10.241.68.106])
	by wpaz37.hot.corp.google.com with ESMTP id oACHwkPr026432
	for <fio@vger.kernel.org>; Fri, 12 Nov 2010 09:59:32 -0800
Received: by iwn42 with SMTP id 42so3906164iwn.34
        for <fio@vger.kernel.org>; Fri, 12 Nov 2010 09:59:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101112143840.GT28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de>
	<AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
	<20101110082223.GB14261@sebastiankayser.de>
	<4CDAA783.9050902@fusionio.com>
	<20101110171856.GI28050@sebastiankayser.de>
	<20101110185826.GJ28050@sebastiankayser.de>
	<C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com>
	<20101110195214.GK28050@sebastiankayser.de>
	<4CDAFAC5.9070608@fusionio.com>
	<20101112143840.GT28050@sebastiankayser.de>
Date: Fri, 12 Nov 2010 09:59:31 -0800
Message-ID: <AANLkTim2mPzJ7ip9A5M-JEAkLEj70EVq3ikn5HQXnuQH@mail.gmail.com>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
From: Shawn Lewis <shawnlewis@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On Fri, Nov 12, 2010 at 6:38 AM, Sebastian Kayser <sebastian@skayser.de> wr=
ote:
>
> * Jens Axboe <jaxboe@fusionio.com> wrote:
> > On 2010-11-10 20:52, Sebastian Kayser wrote:
> > > * John Cagle <jcagle@gmail.com> wrote:
> > >> If the disk is 2TB, then your 100GB test is only using 5% of it-- th=
us
> > >> your observed IOPS will be a lot better than expected due to
> > >> short-stroking. =EF=BF=BDRight?
> > >
> > > I don't know. The inital 80 IOPS (observed over about 2 full minutes)
> > > made me believe that 100GB would have covered a high enough percentage
> > > to at least eliminate track-to-track seeks. Are short-stroked seeks a=
lso
> > > that much faster compared to average seek times? And where would the
> > > steady increase in IOPS during the test come from?
> > >
> > > But you are definitly right when it comes to the test setup. I just
> > > started a test with size=3D1800g. Looking foward to what that will sh=
ow.
> >
> > If you have the full device, you could just test on that instead of
> > using a filesystem and file. Just to get more 'raw' performance.
>
> Thanks. This also turned out to be much more feasible for "quick" test
> turn-around. As soon as I ran the tests with size=3D1800g it took ages to
> prepare the test file (~30 MB/s towards the iSCSI target) and one disk
> even quit on me over night.
>
> When staying within the realm of file based testing, can fio determine
> and display the progress (think: progress bar or percentage) when it
> prepares the test file?
If you use a sequential write fio job to lay the file out you should
see the progress bar.
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
