Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51873
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab3DJHA2 (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Apr 2013 03:00:28 -0400
Date: Wed, 10 Apr 2013 09:00:07 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Recent changes (gfio)
Message-ID: <20130410070007.GS12244@kernel.dk>
References: <20130410040002.998E920551@kernel.dk>
 <516508C4.6040804@cesnet.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516508C4.6040804@cesnet.cz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org

On Wed, Apr 10 2013, Jiri Horky wrote:
> Hi Jens,
> 
> On 04/10/2013 06:00 AM, Jens Axboe wrote:
> >  git://git.kernel.dk/fio.git gfio
> I think the instruction should say "branch gfio" ( -b gfio), since only "git
> clone git://git.kernel.dk/fio.git gfio" will get normal fio sources. Maybe
> this was obvious to others but it took me some time to realize that it is
> under the same git tree (i.e. not "gfio.git"), but on a different branch.

Good point, it's not super clear as-is. I will update it! Thanks for
letting me know.

-- 
Jens Axboe

