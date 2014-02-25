Return-Path: <axboe@kernel.dk>
Message-ID: <530CF0DE.2090807@kernel.dk>
Date: Tue, 25 Feb 2014 11:37:02 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: numerical option parsing broken in engine options
References: <CALKLVuJOou3sLCgnKyfpUaB52M_4L+Xq6_U7ft1YFss_B-+xoQ@mail.gmail.com>	<530CCDE3.80109@kernel.dk> <CALKLVuLGe6U6xFzOPDQJDnUTUUQjQxSCRDqoeueAfFsQG6wKDQ@mail.gmail.com> <530CE664.5020004@kernel.dk> <530CEC6C.2020501@kernel.dk>
In-Reply-To: <530CEC6C.2020501@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Castor Fu <castor@egocast.org>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-02-25 11:18, Jens Axboe wrote:
> On 2014-02-25 10:52, Jens Axboe wrote:
>> On 2014-02-25 09:34, Castor Fu wrote:
>>> Indirectly.  If the external engine has an option which is a
>>> FIO_OPT_INT, and I give it a value like  '4k', then we'll eventually
>>> call fio_get_kb_base while pointing to the engine options area instead
>>> of the options / thread_data area.
>>
>> Ah I see now, yes that is definitely an issue... Let me think about this
>> a bit. td->eo as data only works for the engine itself, it's not pretty
>> that the parser ends up thinking it's td.
>
> So the issue is really that a non static function makes assumptions
> about what 'data' is at this point. That's just not going to work.
> Internal use cases are fine, since they know what *data is, but it wont
> work for fio_get_kb_base().
>
> So we definitely need some way of knowing if 'data' is our regular
> options or not...

This is the best short term fix I could come up with...

http://git.kernel.dk/?p=fio.git;a=commit;h=cb1402d674fb7694d1b09d7ef4aeb3d4506f23f0

It'd be nice if kb_base always worked as expected, however. So I'll keep 
mulling over this and see if we can't come up with something better. We 
might just have to have two sets of private, or a private container so 
we can always pass in the right thing.

-- 
Jens Axboe


