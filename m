Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:51690
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1JOMoe (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Oct 2011 08:44:34 -0400
Message-ID: <4E998031.7060807@kernel.dk>
Date: Sat, 15 Oct 2011 14:44:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.0 coming (was "Re: Recent changes")
References: <20111014040002.95902484001@kernel.dk> <4E97D492.8080305@kernel.dk> <DA4ADF0A-3461-46AD-B5B7-E24CBAF4D1E9@cran.org.uk> <4E993F9B.2030705@kernel.dk> <4E9942D3.5050702@kernel.dk>
In-Reply-To: <4E9942D3.5050702@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2011-10-15 10:22, Jens Axboe wrote:
> On 2011-10-15 10:08, Jens Axboe wrote:
>> On 2011-10-14 18:55, Bruce Cran wrote:
>>>
>>> On 14 Oct 2011, at 07:20, Jens Axboe wrote:
>>>
>>>> And folks running on non-linux, please try and build it at least (extra
>>>> brownie points for actually running it, too).
>>>
>>> It seems the latest version still has problems on non-Linux platforms when running in client/server mode:
>>>
>>>> ./fio -S
>>> fio: server listening on 0.0.0.0:8765
>>>
>>>> ./fio -C localhost examples/tiobench-example
>>> hostname=vfreebsd_amd64, be=0, 64-bit, os=FreeBSD, arch=x64-64, fio=1.99.7
>>
>> Can you try and add --debug=all before the -S and -C on both ends,
>> perhaps that'll give a clue as to what is going on. I'll see if I can
>> find a FreeBSD machine here for a test spin.
> 
> It's not OS specific, which did sound odd to me. Looks like the parser
> is broken for some comment types when being passed a buffer instead of a
> file.

Please try current -git, it should work now.

-- 
Jens Axboe

