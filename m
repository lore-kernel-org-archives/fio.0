Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966550Ab3HHUzV (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Aug 2013 16:55:21 -0400
Message-ID: <52040589.2050803@kernel.dk>
Date: Thu, 08 Aug 2013 14:54:33 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How to control the number of random I/O's acrossing the whole
 file/device?
References: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com> <CA+S_sg4ROD-+qdBKz9VMwMcOn4OrpOTBh9sF=gQEbfT54HZCXw@mail.gmail.com>
In-Reply-To: <CA+S_sg4ROD-+qdBKz9VMwMcOn4OrpOTBh9sF=gQEbfT54HZCXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: jiahua@gmail.com
Cc: fio@vger.kernel.org

On 08/07/2013 12:57 PM, Jiahua wrote:
> Sorry to bother you again! Can anyone shed some light here? Or can you
> give a pointer into the code where I should look at to implement the
> feature I want?
> 
> Thanks,
> Jiahua
> 
> On Tue, Aug 6, 2013 at 4:19 PM, Jiahua <jiahua@gmail.com> wrote:
>> Hi all,
>>
>> What I want is to touch a file/device randomly but up to a given
>> number of times. I tried the "size=" option but it also limits the
>> file size. Is there a way to do that instead of time_based, which is
>> approximate to my requirement?

Not sure what you as asking here. size= will generally specify the
region that fio will operate on. If you want to touch it multiple times,
you could do time_based and/or loops. The region will still be governed
by size= (or default to the existing total size of the file/device, if
not given).

-- 
Jens Axboe

