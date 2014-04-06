Return-Path: <axboe@kernel.dk>
Message-ID: <53417D88.2080308@kernel.dk>
Date: Sun, 06 Apr 2014 10:15:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mixing command line and job file parameters
References: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com> <20140405032414.GB18464@kernel.dk> <533F8189.7080103@kernel.dk>
In-Reply-To: <533F8189.7080103@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-04-04 22:07, Jens Axboe wrote:
> On 2014-04-04 21:24, Jens Axboe wrote:
>> On Fri, Apr 04 2014, Carl Zwanzig wrote:
>>> Hello,
>>>
>>> This has been bugging me for a while... it appears that we have a
>>> choice of using either cmd line parameters xor a job file (but not
>>> combining the two) to fully specify a job.
>>>
>>> For instance:
>>> fio --runtime=20 derf.cfg
>>> fio: time_based requires a runtime/timeout setting
>>> file__0: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
>>> iodepth=32
>>> fio-2.1.6.1
>>> [...]
>>> where derf.cfg starts otherwise fully specified the job, just doesn't
>>> have the runtime.
>>>
>>> There are ways around this for some cases by using environment
>>> variables (e.g. "RT=20 fio def.cfg" and runtime=${RT}) but those can
>>> get clunky and only allows value substitutions, not additional
>>> directives. In my current case, I'd like to have the config file
>>> supply default values for certain parameters and override them as
>>> needed from the command line (e.g. runtime=20 unless I say otherwise).
>>> Right now, I already have 6 or 7 env vars passed in to the job file
>>> and that's too many.
>>>
>>> Is there any way to do this without really hacking up the parsing
>>> code? I'm currently looking at init.c, where it looks like the cmd
>>> line is parsed first then the job file(s), but I lose the mental
>>> thread when I get into parse_jobs_ini(). Ideally, any fio options on
>>> the command line before a --name= would be stuck at the end of the
>>> global thread data (*td_parent?), similar to including a directive
>>> multiple times.
>>
>> Should be fairly easy to fix - right now the transition would imply a
>> job barrier, which is why it doesn't work. We could just assume [global]
>> state for that.
>
> Took a quick look. The code basically looks like this:
>
> job_files = parse_cmd_line(argc, argv, type);
>
> if (job_files > 0) {
>          for (i = 0; i < job_files; i++) {
>                   if (fill_def_thread())
>                           [...]
>
> (init.c:2019)
>
> So fio does parse the command line options, and unless they are
> sectioned and form a job, they basically go into the default thread
> options and hence are considered as part of the [global] section for the
> next job file. If you comment out that fill_def_thread() part, it should
> work.
>
> It becomes more complicated if you expect this to work:
>
> fio --some_option=1 jobfile.fio --some_other_option=2 jobfile2.fio
>
> which I'd be surprised if that works.
>
> Fio clears the default options between each job file, since they are
> considered independent, instead of leaking set [global] option between
> job files. That part should remain. But it would be nice to make any
> previous command line options be part of the next job file. The full fix
> will be larger than just commenting out those two lines, but it should
> not be a lot of work.

Committed a minor fix that allows the basic usage, ala:

$ fio --option_foo=1 --option_bar=2 jobfile.fio

to work as expected. The two command line options will be considered 
part of the global section of jobfile.fio.

http://git.kernel.dk/?p=fio.git;a=commit;h=bc4f5ef67d26ef98f4822d5f798cb8c4e2d2fce5

-- 
Jens Axboe


