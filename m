Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2EBMI2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 May 2012 08:08:28 -0400
Message-ID: <4FA123A3.5030801@kernel.dk>
Date: Wed, 02 May 2012 14:08:03 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Tell fio to only lay out files
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com> <4FA11FC5.4030202@thomas-krenn.com> <4FA120C2.6080205@kernel.dk> <4FA12358.7010204@thomas-krenn.com>
In-Reply-To: <4FA12358.7010204@thomas-krenn.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 05/02/2012 02:06 PM, Georg Sch=EF=BF=BDnberger wrote:
> I get the following error after applying the patch:
> $ patch -b -p1 < fio.patch
> ...make and install...
> $ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./tests
> --rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4 --group_reporting
> max value out of range: 4 (1 max)
> max value out of range: 4 (1 max)

You probably want to make clean first.

--=20
Jens Axboe

