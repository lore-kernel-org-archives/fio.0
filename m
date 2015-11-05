Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:55683 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbbKEPuz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 5 Nov 2015 10:50:55 -0500
Received: from exchange01.nbg.teamix.net (unknown [IPv6:2001:67c:14c:64:306c:b60d:93de:8b04])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mailout.teamix.de (Postfix) with ESMTPS id E412C382BD
	for <fio@vger.kernel.org>; Thu,  5 Nov 2015 16:50:51 +0100 (CET)
Received: from merkaba.localnet (unknown [10.41.2.16])	(using TLSv1 with
 cipher DHE-RSA-AES256-SHA (256/256 bits))	(No client certificate requested)
	by rproxy.teamix.net (Postfix) with ESMTPSA id DE2217A0AA	for
 <fio@vger.kernel.org>; Thu,  5 Nov 2015 16:50:46 +0100 (CET)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: preliminary fio and gfio 2.2.10 Debian packages (UPDATE)
Date: Thu, 5 Nov 2015 16:50:45 +0100
Message-ID: <2036958.mgmILGfCe2@merkaba>
In-Reply-To: <2025885.N9lTbm2gWF@merkaba>
References: <2025885.N9lTbm2gWF@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

﻿Am Donnerstag, 5. November 2015, 16:30:53 CET schrieb Martin Steigerwald:
> Hi!
> 
> For the first time I let it build a gfio package with the graphical
> frontend.
> 
> This is still subject to review and in part based on guess work on how this
> is supposed to work.
> 
> 
> But as the gfio binary starts up into a GTK+ window and appears something
> useful once I figured out where to click things, I thought I share it here
> nonetheless:
> 
> http://people.teamix.net/~ms/debian/sid/fio/
> 
> http://people.teamix.net/~ms/debian/sid/fio/fio_2.2.10-1.dsc
> 
> Its also up in version control on alioth and github¹.

Just updated this to avoid unnecessary dependencies on gfio:

25d8aee9dae8f13fd6eb9f5071b0e71c03bba1ba and upload time 16:47.

> If you try it out, please give feedback.
> 
> [1] http://github.com/teamix/fio-debian


-- 
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller

teamix Support Hotline: +49 911 30999-112
 
 *** Besuchen Sie uns vom 16.-19.11.2015 auf der NetApp Insight im CityCube in Berlin auf Stand A5. ***

