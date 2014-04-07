Return-Path: <axboe@kernel.dk>
Message-ID: <53430FB4.1090904@kernel.dk>
Date: Mon, 07 Apr 2014 14:51:00 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mixing command line and job file parameters
References: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com> <20140405032414.GB18464@kernel.dk> <533F8189.7080103@kernel.dk> <53417D88.2080308@kernel.dk> <A7A1D348E34E024BBC74480FB93A2EAB1086777F@DAGN05B-E6.exg6.exghost.com> <53430A03.2040503@kernel.dk>
In-Reply-To: <53430A03.2040503@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/07/2014 02:26 PM, Jens Axboe wrote:
> On 04/07/2014 02:24 PM, Carl Zwanzig wrote:
>> Hi,
>>
>> (Jens- Thanks for the speedy work on this.)
>>
>> I just pulled from git and built (fio-2.1.7-29-gbc4f5).
>>
>> The patch will supply the parameter if it was missing from the config:
>>
>> works:
>> ./fio --runtime=10 derf.cfg  (derf.cfg has "time_based" but no "runtime")
>>
>> will throws "no runtime" error:
>> ./fio derf.cfg
>>
>> but will not replace an existing parameter as would happen if it's
>> twice in the cfg file.  Also tried forcing global "./fio --name=global
>> --runtime=10 derf.cfg", but no luck, either.
>>
>> I'll try poking around the area of the changes. (I have 7-8 parameters
>> that I want to individually override, and using env vars has gotten
>> ugly and needs a helper script.)
>
> Yep, it wont replace an existing parameter. It will basically work like
> the option appears before any of the others in the global section,
> similar to if you have:
>
> timeout=10s
> foo=1
> bar=89
> timeout=20s
>
> the last timeout= will override the first one. To make that work would
> be more involved, I'm afraid.

So the way to make this would... Right now, the options associated with 
each thread/process looks like this:

struct thread_options {
	char *string_option;
	unsigned int uint_option;
	[...]
};

and so forth. We could change that to be more ala:

typedef struct fio_char_opt {
         char *option;
         bool was_set;
};

typedef struct fio_uint_opt {
         unsigned int option;
         bool was_set;
};

and so forth. When we parse an option, we'd set the ->was_set flag to 
true. I have been thinking about doing this before, since there are a 
few option hacks in fio where we deliberately add an option callback 
just to know if an option was set or not. This is done for options where 
checking for 0 isn't the valid check for "was set or not", and it'd be 
nice to get rid of those. Both because it would make the code cleaner, 
but also because the callback variants make life harder for the 
client/server job parsing.

With this infrastructure in place, it'd be easy enough to track and 
support overloading of options like the command line and job file mix.

-- 
Jens Axboe


