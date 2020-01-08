Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37750 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAHUKR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Jan 2020 15:10:17 -0500
Received: by mail-pg1-f174.google.com with SMTP id q127so2084732pga.4
        for <fio@vger.kernel.org>; Wed, 08 Jan 2020 12:10:16 -0800 (PST)
Date: Wed, 8 Jan 2020 20:10:14 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: SNIA Jobfile
Message-ID: <20200108201014.GZ11244@42.do-not-panic.com>
References: <000001d5b855$e52cff40$af86fdc0$@rwlabs.com>
 <9515e08a-39ca-3d69-cf9c-c51dc3dd4169@kernel.dk>
 <CALjAwxie1_93xqOwS2_zZAt2+nhmPvYtkdjPcr2+DdUY_GeD+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxie1_93xqOwS2_zZAt2+nhmPvYtkdjPcr2+DdUY_GeD+w@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Chris Ramseyer <chris@rwlabs.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sun, Dec 29, 2019 at 09:14:27PM +0000, Sitsofe Wheeler wrote:
> Hi,
> 
> On Sun, 22 Dec 2019 at 15:14, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 12/21/19 4:25 PM, Chris Ramseyer wrote:
> > >
> > > Do you have a jobfile already built for the latest SNIA enterprise SSD
> > > test or know where I can download one?
> 
> I'm not sure what the "SNIA enterprise SSD test" is in the scenario.
> If you mean the "(SSS) Performance Test Specification (PTS)" (what a
> name) then someone posted something about that to the list a few
> months back (https://www.spinics.net/lists/fio/msg07882.html ) but fio
> doesn't do the whole thing by itself.

Indeed, fio-tests [0] supports this. In particular check out the
Provisioning section [1]. To avoid any possible trademark issues
I named the SNIA IOPS test "Buddy Holly". Patches welcomed for
other tests, or enhancements!

[0] https://github.com/mcgrof/fio-tests

  Luis

