Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:16860 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaEGI1n convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 7 May 2014 04:27:43 -0400
Message-ID: <5369EE78.3060705@enovance.com>
Date: Wed, 07 May 2014 10:27:36 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Fio giving iops results that are equal to RAM speeds
References: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl> <5369E886.1030100@enovance.com> <BLU436-SMTP1086A621DD12787F2EECD40E54E0@phx.gbl>
In-Reply-To: <BLU436-SMTP1086A621DD12787F2EECD40E54E0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kim Holmebakken <kim.holmebakken@hotmail.com>
Cc: fio@vger.kernel.org


Le 07/05/2014 10:19, Kim Holmebakken a =EF=BF=BDcrit :
> Also the direct=3D0 is for the fact that in the documentation to fio the =

> direct=3D parameter is not supported for zfs. And as a result the test=20
> will not complete(it does not even create the test files).=20

So you need to make a much more longer run to minimize the cache effect.=20
Running like twice the memory of the server could be an interesting=20
test. 128M on a cached FS is clearly not enough.

Erwan,
