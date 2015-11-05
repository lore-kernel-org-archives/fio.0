Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:55665 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031333AbbKEPgP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 5 Nov 2015 10:36:15 -0500
Received: from exchange01.nbg.teamix.net (unknown [IPv6:2001:67c:14c:64:306c:b60d:93de:8b04])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mailout.teamix.de (Postfix) with ESMTPS id 06C3A382BD
	for <fio@vger.kernel.org>; Thu,  5 Nov 2015 16:30:54 +0100 (CET)
Received: from merkaba.localnet (unknown [10.41.2.16])	(using TLSv1 with
 cipher DHE-RSA-AES256-SHA (256/256 bits))	(No client certificate requested)
	by rproxy.teamix.net (Postfix) with ESMTPSA id BC4DA7A0AA	for
 <fio@vger.kernel.org>; Thu,  5 Nov 2015 16:30:54 +0100 (CET)
From: Martin Steigerwald <ms@teamix.de>
Subject: preliminary fio and gfio 2.2.10 Debian packages
Date: Thu, 5 Nov 2015 16:30:53 +0100
Message-ID: <2025885.N9lTbm2gWF@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

﻿Hi!

For the first time I let it build a gfio package with the graphical frontend.

This is still subject to review and in part based on guess work on how this is 
supposed to work.


But as the gfio binary starts up into a GTK+ window and appears something 
useful once I figured out where to click things, I thought I share it here 
nonetheless:

http://people.teamix.net/~ms/debian/sid/fio/

http://people.teamix.net/~ms/debian/sid/fio/fio_2.2.10-1.dsc

Its also up in version control on alioth and github¹.


If you try it out, please give feedback.

[1] http://github.com/teamix/fio-debian

Thanks,


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

