Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:39793
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab1HaVib (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Aug 2011 17:38:31 -0400
Message-ID: <4E5EA9D0.10109@kernel.dk>
Date: Wed, 31 Aug 2011 15:38:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio file test patterns
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com> <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com> <4E5E91D9.4000702@fusionio.com> <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com> <4E5EA5DF.5040609@fusionio.com>
In-Reply-To: <4E5EA5DF.5040609@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Fallik <bfallik@bamboom.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-31 15:21, Jens Axboe wrote:
>> I also have another (maybe related?) question.  Apologies if this
>> belongs in a separate thread, but are there any notes explaining why
>> fio lays out the files before starting sequential writes?  The
>> workload I was hoping to simulate is sustained, sequential writes to
>> disk.  I'm trying to answer the question "How many simultaneous
>> 200kBps writers can we support?"  Using my current jobs file, fio
>> starts by creating the files (e.g "foo0: Laying out IO file(s) (1
>> file(s) / 4MB)") before it starts processing.  However, creating the
>> files in advance accounts for a chunk of performance that doesn't seem
>> to be measured by fio.  Am I misunderstanding how to configure fio or
>> its intended usage?
> 
> You should be able to set overwrite=0 to avoid that. Are they random
> writes?

overwrite=0 is even default. I'm thinking the "Laying out IO file"
message is confusing, it wont actually write contents first unless you
ask it to (with eg overwrite=1).


-- 
Jens Axboe

