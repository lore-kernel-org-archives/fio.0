Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([65.103.231.193]:49009 "EHLO muon.bsdio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732097AbfJQVVm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Oct 2019 17:21:42 -0400
Subject: Re: build issue
References: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <55a04137-7b12-0a73-494e-35d270ea25d4@bsdio.com>
Date: Thu, 17 Oct 2019 21:21:40 -0600
MIME-Version: 1.0
In-Reply-To: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Astolfo Rueda <astolfor@microsoft.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10/17/2019 2:34 PM, Astolfo Rueda wrote:
>      CC oslib/inet_aton.o
> /tmp/ccQfIUjv.s: Assembler messages:
> /tmp/ccQfIUjv.s:1188: Error: invalid register for .seh_savexmm
> make: *** [Makefile:376: filehash.o] Error 1
> make: *** Waiting for unfinished jobs....
> /tmp/ccZfFBQo.s: Assembler messages:
> /tmp/ccZfFBQo.s:3812: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3814: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3816: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3818: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3820: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3822: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3824: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3826: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3828: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3830: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3832: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3834: Error: invalid register for .seh_savexmm
> make: *** [Makefile:379: options.o] Error 1


I just built the latest git master on my Windows 10 machine without any 
problems, and the configure output looked the same too.

Can you check which commit you're building please (e.g. with "git show").

Also, could you post the output with "make V=1" to show the command line 
it's running?


Thanks.
Rebecca


