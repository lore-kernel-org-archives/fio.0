Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44801 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2EBL4O (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 May 2012 07:56:14 -0400
Message-ID: <4FA120C2.6080205@kernel.dk>
Date: Wed, 02 May 2012 13:55:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Tell fio to only lay out files
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com> <4FA11FC5.4030202@thomas-krenn.com>
In-Reply-To: <4FA11FC5.4030202@thomas-krenn.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 05/02/2012 01:51 PM, Georg Sch=EF=BF=BDnberger wrote:
> Thanks for your fast patch, I really appreciate that :-)
> The create_only option now helps me to start with a consistent cache
> state for every test run.

Did you test it? I'll add the option to the man page and HOWTO and
commit, then.

--=20
Jens Axboe

