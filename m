Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55548 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2CaX2c (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Mar 2012 19:28:32 -0400
Message-ID: <4F779318.8020603@kernel.dk>
Date: Sat, 31 Mar 2012 16:28:24 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: units for latency in --minimal mode
References: <CB9B5F1E.12E9%lucian@fb.com>
In-Reply-To: <CB9B5F1E.12E9%lucian@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lucian Grijincu <lucian@fb.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-03-30 13:01, Lucian Grijincu wrote:
> While describing the output format, the HOWTO says:
> 
> slat= [...] This
>    value can be in milliseconds or microseconds, fio will choose
>    the most appropriate base and print that. In the example
>    above, milliseconds is the best scale.
> 
> Does this apply to --minimal mode too?

No, the minimal output is always in usecs. Feel free to send me a patch
to improve the HOWTO wording there, you are not the first to ask :-)

-- 
Jens Axboe

