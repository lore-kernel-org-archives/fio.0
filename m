Return-Path: <axboe@kernel.dk>
Subject: Re: steadystate job termination
References: <BL2PR02MB19867DB3F155CE80CB07DEF08C980@BL2PR02MB1986.namprd02.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <92a78a95-06b0-de7c-f458-f93f53a51e52@kernel.dk>
Date: Fri, 16 Dec 2016 11:04:32 -0700
MIME-Version: 1.0
In-Reply-To: <BL2PR02MB19867DB3F155CE80CB07DEF08C980@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/12/2016 09:25 AM, Vincent Fu wrote:
> Jens, at https://bitbucket.org/vincentfu/fio-steadystate/commits/all is
> a repo where I have committed patches to fio's steady-state branch that
> address the following TODO items:
> 
> steadystate data is now transmitted over the wire in client/server mode
> steadystate summary data is included with --output-format=normal
> example steadystate job file added
> man page updated
> 
> Please let me know what feedback you have.
> 
> With respect to client/server mode, I successfully tested the job file
> below on x86-64 hardware using the following server platforms with each
> of the listed client operating systems:
> servers: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11
> clients: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11, Windows 8.1 x64
> 
> Vincent
> 
> [iops_slope]
> filename=/dev/zero
> time_based=1
> runtime=300s
> size=8M
> ss=iops_slope:0.5%
> ss_dur=5
> ss_ramp=2
> numjobs=4
> group_reporting
> 
> [bw_dev]
> stonewall
> filename=/dev/zero
> time_based=1
> runtime=300s
> size=8M
> ss=bw:4%
> ss_dur=5
> ss_ramp=2
> numjobs=2

Looks good enough to go in at this point, thanks Vincent! This is a cool
and useful feature.

I had some suggested cleanups in here:

http://git.kernel.dk/cgit/fio/commit/?h=steady-state

did you see those? Any that still apply?

-- 
Jens Axboe


