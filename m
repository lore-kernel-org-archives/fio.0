Return-Path: <castor@egocast.org>
MIME-Version: 1.0
In-Reply-To: <530CCDE3.80109@kernel.dk>
References: <CALKLVuJOou3sLCgnKyfpUaB52M_4L+Xq6_U7ft1YFss_B-+xoQ@mail.gmail.com>
	<530CCDE3.80109@kernel.dk>
Date: Tue, 25 Feb 2014 09:34:32 -0800
Message-ID: <CALKLVuLGe6U6xFzOPDQJDnUTUUQjQxSCRDqoeueAfFsQG6wKDQ@mail.gmail.com>
Subject: Re: numerical option parsing broken in engine options
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Indirectly.  If the external engine has an option which is a
FIO_OPT_INT, and I give it a value like  '4k', then we'll eventually
call fio_get_kb_base while pointing to the engine options area instead
of the options / thread_data area.

On Tue, Feb 25, 2014 at 9:07 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-02-24 17:51, Castor Fu wrote:
>>
>> I was debugging some problems with parsing fio jobs, and found
>> options.c:fio_get_kb_base is broken for external engines... The
>> parameter
>> 'data' is either 0, td, or td->eo.  If it's td->eo it's not really
>> going to work.
>>
>> The cleaner fix is probably to unwind passing 'data' so far down the
>> stack, but it
>> touches a lot of functions, so I thought I'd send this out now.
>>
>> unsigned int fio_get_kb_base(void *data)
>> {
>>          struct thread_options *o = data;
>>          unsigned int kb_base = 0;
>>
>>          if (o)
>>                  kb_base = o->kb_base;
>>          if (!kb_base)
>>                  kb_base = 1024;
>>
>>          return kb_base;
>> }
>>
>>
>> If I replace
>>     if(o)
>> by
>>       if (o && (data - (void *) threads) % sizeof(threads[0]) == 0)
>>
>> then it behaves as I expect when engine options use the 'k', etc.
>
>
> Not sure I follow... Are you calling fio_get_kb_base() from the external
> engine?
>
> --
> Jens Axboe
>

