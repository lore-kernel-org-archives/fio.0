Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3GVPDV (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 11:03:21 -0400
Date: Mon, 22 Jul 2013 09:03:19 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/5] net: Add UDP multicast support
Message-ID: <20130722150319.GM32755@kernel.dk>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
 <20130720030726.GA28005@kernel.dk>
 <20130722145456.GA3509@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722145456.GA3509@sbohrermbp13-local.rgmadvisors.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: fio@vger.kernel.org, tomk@rgmadvisors.com

On Mon, Jul 22 2013, Shawn Bohrer wrote:
> On Fri, Jul 19, 2013 at 09:07:26PM -0600, Jens Axboe wrote:
> > On Fri, Jul 19 2013, Shawn Bohrer wrote:
> > > Allow UDP readers to listen to UDP multicast traffic if hostname is set
> > > to a valid UDP multicast address.
> > 
> > Looks good! Can I get you to include a sample job file as well, plus
> > update the fio.1 man page in parallel with the HOWTO too?
> 
> Hi Jens,
> 
> Take a closer look, patches 1,2,3 already update fio.1 and HOWTO.  I'll
> send a follow up patch with an example job file.

Indeed, looks like I need my vision checked instead. Thanks, I'll apply
1-3 and the job file patch you sent as well.

-- 
Jens Axboe

