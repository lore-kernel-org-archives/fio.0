Return-Path: <axboe@kernel.dk>
Message-ID: <53430A03.2040503@kernel.dk>
Date: Mon, 07 Apr 2014 14:26:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mixing command line and job file parameters
References: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com> <20140405032414.GB18464@kernel.dk> <533F8189.7080103@kernel.dk> <53417D88.2080308@kernel.dk> <A7A1D348E34E024BBC74480FB93A2EAB1086777F@DAGN05B-E6.exg6.exghost.com>
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB1086777F@DAGN05B-E6.exg6.exghost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/07/2014 02:24 PM, Carl Zwanzig wrote:
> Hi,
>
> (Jens- Thanks for the speedy work on this.)
>
> I just pulled from git and built (fio-2.1.7-29-gbc4f5).
>
> The patch will supply the parameter if it was missing from the config:
>
> works:
> ./fio --runtime=10 derf.cfg  (derf.cfg has "time_based" but no "runtime")
>
> will throws "no runtime" error:
> ./fio derf.cfg
>
> but will not replace an existing parameter as would happen if it's twice in the cfg file.  Also tried forcing global "./fio --name=global --runtime=10 derf.cfg", but no luck, either.
>
> I'll try poking around the area of the changes. (I have 7-8 parameters that I want to individually override, and using env vars has gotten ugly and needs a helper script.)

Yep, it wont replace an existing parameter. It will basically work like 
the option appears before any of the others in the global section, 
similar to if you have:

timeout=10s
foo=1
bar=89
timeout=20s

the last timeout= will override the first one. To make that work would 
be more involved, I'm afraid.

-- 
Jens Axboe


