Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:22118 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGJMZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 7 May 2014 05:12:25 -0400
Message-ID: <5369F8ED.4070807@enovance.com>
Date: Wed, 07 May 2014 11:12:13 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Fio giving iops results that are equal to RAM speeds
References: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl> <5369E886.1030100@enovance.com> <BLU436-SMTP1086A621DD12787F2EECD40E54E0@phx.gbl> <5369EE78.3060705@enovance.com> <BLU436-SMTP218F8CEFE3A8ED088644478E54E0@phx.gbl>
In-Reply-To: <BLU436-SMTP218F8CEFE3A8ED088644478E54E0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kim Holmebakken <kim.holmebakken@hotmail.com>
Cc: fio@vger.kernel.org


Le 07/05/2014 10:58, Kim Holmebakken a =EF=BF=BDcrit :
> I tried running with the size=3D24G since the memory on the server is at =

> 12GB, this reduced the iops, however the MB/s is now reduced from=20
> 2000+ MB/s, and now running on 850 MB/s
>
> Still i think this might be a bit high?=20

If you do random IOs there is still a great chance of having cache hits.=20
This number have to be put in comparison with the network bandwidth.

If you have a 1Gbit connection ... 850 is clearly hitting lot of cache.
