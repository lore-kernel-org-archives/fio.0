Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0KHND5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Nov 2010 08:03:57 -0500
Message-ID: <4CD7F53E.1050201@fusionio.com>
Date: Mon, 08 Nov 2010 14:03:58 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: RFC: Data pattern buffer filling race condition fix
References: <201011061035.18709.bvanassche@acm.org> <4CD690DF.6090807@fusionio.com> <AANLkTimVcMvOH55xZvTFHxbZHesTXoyi=Y3bRqnALLTS@mail.gmail.com>
In-Reply-To: <AANLkTimVcMvOH55xZvTFHxbZHesTXoyi=Y3bRqnALLTS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Radha Ramachandran <radha@google.com>

On 2010-11-07 13:58, Bart Van Assche wrote:
> On Sun, Nov 7, 2010 at 12:43 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> On 2010-11-06 10:35, Bart Van Assche wrote:
>>> On multicore non-x86 CPUs fio has been observed to frequently reports false
>>> data verification failures with I/O engine libaio and I/O depths above one.
>>> This is because of a race condition in the function fill_pattern(). The code
>>> in that function only works correct if all CPUs of a multicore system
>>> observe store instructions in the order they were issued. That is the case for
>>> multicore x86 systems but not for all other CPU families, such as e.g. the
>>> POWER CPU family.
>>>
>>> As far as I can see this bug was introduced via commit
>>> cbe8d7561cf6d81d741d87eb7940db2a111d2144 (July 14, 2010).
>>>
>>> I'm posting this patch as an RFC since the fix is GCC-specific.
>>
>> ppc is notorious for its weaker memory ordering. I do have a ppc test
>> box, but haven't used it in a while. But it used to find bugs
>> immediately for race conditions, that x86 would never trigger. So since
>> you are pin pointing that particular commit, you are convinced that this
>> bug manifests itself due to bad ordering between the filled buffer and
>> the fill length?
> 
> I haven't done a full bisect, but fio version 1.41.6 (Jul 9, 2010) + a
> backport of the PowerPC version of get_cpu_clock() (commit
> 5f39d8f797fcf01bd94b89ef7ed2bdb76deb2601 from August 10, 2010) was working
> fine. And it is easy to see how reordered writes will cause commit
> cbe8d7561cf6d81d741d87eb7940db2a111d2144 to make fio behave incorrectly.
> 
>>> diff --git a/verify.c b/verify.c
>>> index ea1a911..3826198 100644
>>> --- a/verify.c
>>> +++ b/verify.c
>>> @@ -31,18 +31,27 @@ void fill_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u
>>>               fill_random_buf(p, len);
>>>               break;
>>>       case 1:
>>> +#ifdef __GNUC__
>>> +             __sync_synchronize();
>>> +#endif
>>
>> You should be able to use the fio included write_barrier() and
>> read_barrier(), which are hooked to the architectures. Then you don't
>> need to use GNUC additions.
> 
> This patch also works for me on PowerPC:
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> diff --git a/verify.c b/verify.c
> index ea1a911..c5b2fbe 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -31,18 +31,21 @@ void fill_pattern(struct thread_data *td, void *p,
> unsigned int len, struct io_u
>  		fill_random_buf(p, len);
>  		break;
>  	case 1:
> +		write_barrier();
>  		if (io_u->buf_filled_len >= len) {
>  			dprint(FD_VERIFY, "using already filled verify pattern b=0 len=%u\n", len);
>  			return;
>  		}
>  		dprint(FD_VERIFY, "fill verify pattern b=0 len=%u\n", len);
>  		memset(p, td->o.verify_pattern[0], len);
> +		write_barrier();
>  		io_u->buf_filled_len = len;
>  		break;

Forgive me, but I'm still a little confused. This second write_barrier()
is now protecting against the order of the fill and the length
assignment. IOW, if you see the new length, you are guaranteed to also
see the new content. This means that the first memory barrier should be
a read_barrier().

And ditto for the other case.

Can you verify whether that works as expected and send an updated patch?

-- 
Jens Axboe

