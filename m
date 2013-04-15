Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54154
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934427Ab3DOI3m (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 15 Apr 2013 04:29:42 -0400
Date: Mon, 15 Apr 2013 10:29:10 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unit Prefixes
Message-ID: <20130415082910.GZ12244@kernel.dk>
References: <CAKCZDgnCkwNGFVrWE706Z4S4MYra+XfeOqSV80n-QhDnoVPBuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgnCkwNGFVrWE706Z4S4MYra+XfeOqSV80n-QhDnoVPBuQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Apr 15 2013, Aaron Carroll wrote:
> I just noticed that the binary/decimal unit prefixes are around the
> wrong way, in that [KMG]iB is treated as base-10, and [kMG]B as
> base-2.
> 
> Is this intentional?

Is this a new "feature" (eg did it come in from the gfio merge), or has
it always been so?

-- 
Jens Axboe

