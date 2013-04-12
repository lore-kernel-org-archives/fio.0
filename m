Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38089
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab3DLMRZ (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 08:17:25 -0400
Date: Fri, 12 Apr 2013 14:17:00 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unable to Configure latest build
Message-ID: <20130412121700.GR12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <20130412081324.GL12244@kernel.dk>
 <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
 <20130412084236.GM12244@kernel.dk>
 <CANUChTzQ8yhoyD5v8ZetpqDe_9TWmskeR=wi_o4nYHLSUb8Puw@mail.gmail.com>
 <20130412094630.GO12244@kernel.dk>
 <20130412111318.GP12244@kernel.dk>
 <CANUChTxzB1TshHFZ5dgbNiG-8sWR2xLQabosrGaOBzQTmc8TJw@mail.gmail.com>
 <20130412113453.GQ12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412113453.GQ12244@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Apr 12 2013, Jens Axboe wrote:
> On Fri, Apr 12 2013, Gavin Martin wrote:
> > On 12 April 2013 12:13, Jens Axboe <axboe@kernel.dk> wrote:
> > > On Fri, Apr 12 2013, Jens Axboe wrote:
> > >> But sounds like it would be a good idea to turn zlib into a soft
> > >> requirement.
> > >
> > > The below does that, I have committed it. Please test.
> > >
> > >
> > > diff --git a/client.c b/client.c
> > > index eb695ff..13e84f6 100644
> > > --- a/client.c
> > > +++ b/client.c
> > 
> > Hi Jens,
> > 
> > Tested the above (with ./configure) and it does work now without the
> > zlib-devel package installed.  Don't you need that if the
> > --enable-gfio argument is used?  Just as a quick test I ran
> > ./configure --enable-gfio, and it didn't fail because of not finding
> > zlib?
> > 
> > Sorry to be a pain, I'm not sure if it was just my install or if
> > others would have the same problem?
> 
> gfio should still work fine. It's only use for the io log transfers for
> gfio, and that will now go out without compression if both ends don't
> have zlib support.

There was a missing one-liner in gclient.c. There's no zlib usage in
there, it's all in the generic client/server code in server.c and
client.c. It compiles and works fine with that one-liner.

http://git.kernel.dk/?p=fio.git;a=commit;h=aa79e6aa308868fef1437fd6783cdd354a6e9bdb

-- 
Jens Axboe

