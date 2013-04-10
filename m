Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3DJHIO (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Apr 2013 03:08:14 -0400
Date: Wed, 10 Apr 2013 09:07:53 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Recent changes (gfio)
Message-ID: <20130410070753.GT12244@kernel.dk>
References: <20130410040002.998E920551@kernel.dk>
 <516508C4.6040804@cesnet.cz>
 <20130410070007.GS12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410070007.GS12244@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org

On Wed, Apr 10 2013, Jens Axboe wrote:
> On Wed, Apr 10 2013, Jiri Horky wrote:
> > Hi Jens,
> > 
> > On 04/10/2013 06:00 AM, Jens Axboe wrote:
> > >  git://git.kernel.dk/fio.git gfio
> > I think the instruction should say "branch gfio" ( -b gfio), since only "git
> > clone git://git.kernel.dk/fio.git gfio" will get normal fio sources. Maybe
> > this was obvious to others but it took me some time to realize that it is
> > under the same git tree (i.e. not "gfio.git"), but on a different branch.
> 
> Good point, it's not super clear as-is. I will update it! Thanks for
> letting me know.

Just checked the script, and that particular line comes out of git
request-pull. Not terribly useful...

I'll augment the script.

-- 
Jens Axboe

