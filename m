Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34241
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab3ERGxv (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 18 May 2013 02:53:51 -0400
Date: Sat, 18 May 2013 08:53:41 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: output - aggregate read bandwitdh
Message-ID: <20130518065341.GJ19781@kernel.dk>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Sat, May 18 2013, Edoardo Comar wrote:
> I have a problem with fio built today from GIT
> running the jobfile below, the aggregate bandwidth for 'read' output by 
> the latest fio is excessive
> while it seems reasonable with an older fio version.
> 
> fio-2.0.13              READ: io=51500KB, aggrb=857KB/s,
> 
> fio-2.1-6-g4d01         READ: io=31057MB, aggrb=530017KB/s,
> 
> 
> You should easily reproduce this with the data below.
> I have reproduced it on my laptop (RHEL 6.4) as well as on other RHEL 
> systems.
> on my laptop 
>   READ: io=13028KB, aggrb=216KB/s,
> or
>    READ: io=33204MB, aggrb=566519KB/s,
> 
> running the same configuration 
> 
> I believe this to be a bug.

I wonder if this is a regression from 2.0.15 to 2.1. The gfio stuff got
merged in along the way, could definitely be an accounting issue
introduced there. I'll take a look.

-- 
Jens Axboe

