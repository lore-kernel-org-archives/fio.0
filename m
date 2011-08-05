Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55247 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1HEURV (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2011 16:17:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH] fio_generate_plots with setable resolution
Date: Fri, 5 Aug 2011 22:17:19 +0200
References: <201108051633.47905.Martin@lichtvoll.de> <4E3C2D1F.2000200@fusionio.com> (sfid-20110805_221405_659321_39745C02)
In-Reply-To: <4E3C2D1F.2000200@fusionio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108052217.19690.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: fio@vger.kernel.org

Am Freitag, 5. August 2011 schrieb Jens Axboe:
> On 2011-08-05 16:33, Martin Steigerwald wrote:
> > Hi!
> > 
> > Use
> > 
> > fio_generate_plots somename 1600 1200
> > 
> > or something like that.
> > 
> > Just quit and dirty ATM. On interest I can make up a patch for
> > inclusion in fio package *after* I finished my article ;).
> > 
> > Fonts tend to get small on hi resolutions. It seems gnuplot takes
> > them as pixel not points/dots (related to some dots per inch).
> 
> Thanks, applied with usage print updated (and 1024x768 default res, the
> old 800x600 is pretty small).

Thanks, needs a manpage update as well. Lets see maybe next week. 

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
