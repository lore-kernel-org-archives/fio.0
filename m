Return-Path: <axboe@kernel.dk>
Date: Fri, 4 Apr 2014 21:24:14 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Mixing command line and job file parameters
Message-ID: <20140405032414.GB18464@kernel.dk>
References: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com>
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Apr 04 2014, Carl Zwanzig wrote:
> Hello,
> 
> This has been bugging me for a while... it appears that we have a
> choice of using either cmd line parameters xor a job file (but not
> combining the two) to fully specify a job. 
>
> For instance:
> fio --runtime=20 derf.cfg
> fio: time_based requires a runtime/timeout setting
> file__0: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.1.6.1
> [...]
> where derf.cfg starts otherwise fully specified the job, just doesn't
> have the runtime.
> 
> There are ways around this for some cases by using environment
> variables (e.g. "RT=20 fio def.cfg" and runtime=${RT}) but those can
> get clunky and only allows value substitutions, not additional
> directives. In my current case, I'd like to have the config file
> supply default values for certain parameters and override them as
> needed from the command line (e.g. runtime=20 unless I say otherwise).
> Right now, I already have 6 or 7 env vars passed in to the job file
> and that's too many. 
> 
> Is there any way to do this without really hacking up the parsing
> code? I'm currently looking at init.c, where it looks like the cmd
> line is parsed first then the job file(s), but I lose the mental
> thread when I get into parse_jobs_ini(). Ideally, any fio options on
> the command line before a --name= would be stuck at the end of the
> global thread data (*td_parent?), similar to including a directive
> multiple times.

Should be fairly easy to fix - right now the transition would imply a
job barrier, which is why it doesn't work. We could just assume [global]
state for that.

-- 
Jens Axboe


