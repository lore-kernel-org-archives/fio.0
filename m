Return-Path: <fio-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43280 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaAPVI0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Jan 2014 16:08:26 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E2A817C06B0
	for <fio@vger.kernel.org>; Thu, 16 Jan 2014 14:01:34 -0700 (MST)
Message-ID: <52D84861.3010804@fusionio.com>
Date: Thu, 16 Jan 2014 14:00:17 -0700
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <20140111050002.05C7E231C8@kernel.dk> <CALKLVu+yF1smDDX__NbszKpCrfNTHStArMBWD6j8HL5hwZ0q0Q@mail.gmail.com>
In-Reply-To: <CALKLVu+yF1smDDX__NbszKpCrfNTHStArMBWD6j8HL5hwZ0q0Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Castor Fu <castor@egocast.org>
Cc: fio@vger.kernel.org

On 01/16/2014 01:07 PM, Castor Fu wrote:
> 
> 
> 
> On Fri, Jan 10, 2014 at 9:00 PM, Jens Axboe <jaxboe@fusionio.com
> <mailto:jaxboe@fusionio.com>> wrote:
> 
> 
> 
>     Jens Axboe (1):
>           Add option to manually seed the random generators
> 
> 
> Hi Jens:  Have you seen the work on counter-based random number
> generators?  They might be applicable here.
> 
> The basic idea is that if you encrypt the value of a a counter, you can
> get usefully random
> bits. You can do something like use some of the bits for thread number,
> file number, etc.
> and be able to generate the expected state without cycling through the RNG.

I know about these, you end up using some of the same techniques on data
reliability on flash as well. But I don't think it applies very well
here, as fio isn't really interested in fast-forwarding to a specific
sequence. The above change is just meant to be able to specifically seed
the random generator so you can control the sequence. You don't care
about the specific sequence at all, just whether or not it's different
with seed X vs seed Y, and that seed X will always generate the same
sequence.

-- 
Jens Axboe

