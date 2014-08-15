Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.opengridcomputing.com ([72.48.136.20]:46136 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbaHOPbo (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 15 Aug 2014 11:31:44 -0400
From: "Steve Wise" <swise@opengridcomputing.com>
References: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>	<002d01cfb896$19657b40$4c3071c0$@opengridcomputing.com> <CAFTzLMM=-vUtz8NRZBn7W_whH0Kgw0fzX5R0VsppaO_4xxv85A@mail.gmail.com>
In-Reply-To: <CAFTzLMM=-vUtz8NRZBn7W_whH0Kgw0fzX5R0VsppaO_4xxv85A@mail.gmail.com>
Subject: RE: fio terse output for WRITE not working.
Date: Fri, 15 Aug 2014 10:31:48 -0500
Message-ID: <003501cfb89e$07474ad0$15d5e070$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Vasily Tarasov' <tarasov@vasily.name>
Cc: fio@vger.kernel.org



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Vasily
> Tarasov
> Sent: Friday, August 15, 2014 10:29 AM
> To: Steve Wise
> Cc: fio@vger.kernel.org
> Subject: Re: fio terse output for WRITE not working.
> 
> Hi Steve,
> 
> I found terse/minimal output to be quite unstable and inconsistent in
> fio. So, as suggested by Jens, I switched to json output
> (--output-format=json). It seems to be more stable and is also quite
> easy to parse.
> 
> Perhaps that's an option for you.
> 
> Vasily

I'll check out json.  Thanks Vasily.



