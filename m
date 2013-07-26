Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54170 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3GZDKg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 23:10:36 -0400
Date: Thu, 25 Jul 2013 21:10:34 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Definition of IO depth distribution in the terse output
Message-ID: <20130726031034.GO29296@kernel.dk>
References: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: asomers@gmail.com
Cc: fio@vger.kernel.org

On Thu, Jul 25 2013, asomers@gmail.com wrote:
> The man page section for the terse output format describes the IO
> depth distribution fields as "<=1, 2, 4, 8, 16, 32, >=64".  Should the
> last entry be ">32" instead?  Similarly, in the section for IO latency
> distribution, should the final value be ">2000" instead of ">=2000"?

The bucket named 32 is 32 and up (but not including) 64. And so forth.

-- 
Jens Axboe

