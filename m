Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab2JLR0A (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Oct 2012 13:26:00 -0400
Message-ID: <507852A0.8000206@kernel.dk>
Date: Fri, 12 Oct 2012 11:25:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mixed IO & Data Patterns with fio
References: <AC83A371D8ED1741AC9D5BEAF6551948B0DED3@sambx4.stec-inc.ad>
In-Reply-To: <AC83A371D8ED1741AC9D5BEAF6551948B0DED3@sambx4.stec-inc.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Keith Locke <klocke@stec-inc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-10-10 11:34, Keith Locke wrote:
> Hi,
> 
> First, I want to says that the fio utility is a fantastic tools.
> Second, I hope this is an appropriate method of contacting you, if not
> please advise.

Thanks! This is the preferred method, emailing me and the list at the
same time. Gives others a chance to pitch in as well.

> I have a couple of test requirements that I would appreciate guidance
> on how to perform with fio.
> 
>  
> 
> 1. 80/20 mix of random/sequential IO

There's really no easy way to do that currently, though it would be
pretty easy to add. Right now the only thing you could do in that area
is to set a random IO type with a sequential modifier. See the man page
or HOWTO for the postfix options for randread etc.

> 2. 80% Random, 10% '00', & 10% 'FF' mixture of data patterns

Ditto here, fio doesn't give you that granular control of buffer
contents. Again, would be easy to add though... The closest right now
would be to use the compression options, see buffer_compress_* in the
man page / HOWTO.

-- 
Jens Axboe

