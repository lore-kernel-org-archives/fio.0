Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46952
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831Ab3CGLgh (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 7 Mar 2013 06:36:37 -0500
Date: Thu, 7 Mar 2013 12:36:17 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: reporting two fio bug fix when ramp_time / rate_iops options is
 specified
Message-ID: <20130307113617.GK1059@kernel.dk>
References: <11224344.275311362618539121.JavaMail.weblogic@epv6ml11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11224344.275311362618539121.JavaMail.weblogic@epv6ml11>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: SEOKYOUNG KO <seokyoung.ko@samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Mar 07 2013, SEOKYOUNG KO wrote:
> hi.
> we detected two problems related to logging latencies.
> then we have analyzed the problems and fixed some fio codes.

Thanks for the detailed analysis (and fixes!), I have applied both patches.

-- 
Jens Axboe

