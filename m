Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55023 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1HERtY (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2011 13:49:24 -0400
Message-ID: <4E3C2D1F.2000200@fusionio.com>
Date: Fri, 5 Aug 2011 19:49:19 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fio_generate_plots with setable resolution
References: <201108051633.47905.Martin@lichtvoll.de>
In-Reply-To: <201108051633.47905.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 2011-08-05 16:33, Martin Steigerwald wrote:
> Hi!
> 
> Use
> 
> fio_generate_plots somename 1600 1200
> 
> or something like that.
> 
> Just quit and dirty ATM. On interest I can make up a patch for inclusion 
> in fio package *after* I finished my article ;).
> 
> Fonts tend to get small on hi resolutions. It seems gnuplot takes them as 
> pixel not points/dots (related to some dots per inch).

Thanks, applied with usage print updated (and 1024x768 default res, the
old 800x600 is pretty small).

-- 
Jens Axboe

