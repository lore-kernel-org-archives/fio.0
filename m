Return-Path: <fio-owner@vger.kernel.org>
Received: from serv4.rootleveltech.com ([198.176.28.4]:44327 "EHLO
	serv4.rootleveltech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497AbbBZOq2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Feb 2015 09:46:28 -0500
Message-ID: <54EF31C0.9030502@voicenet.com>
Date: Thu, 26 Feb 2015 09:46:24 -0500
From: thoms <thoms@voicenet.com>
Reply-To: thoms@voicenet.com
MIME-Version: 1.0
Subject: Re: Stonewalled ?
References: <54EE9B5D.3040208@voicenet.com> <A7A1D348E34E024BBC74480FB93A2EAB10942DEB@DAGN05C-E6.exg6.exghost.com>
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB10942DEB@DAGN05C-E6.exg6.exghost.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


On 02/26/2015 02:11 AM, Carl Zwanzig wrote:
> (sorry about top-posting here)
>
> For things like this, I'd use an external script specifying all params on each command line, and not use a job file at all. Order of execution is guaranteed and there's no limit to the number of jobs. (When fio evaluates the job file it creates all the jobs, but then doesn't let them all start at once.)
>
> z!
> ________

I'm prepared to do that, it's just messy for my particular situation. 
Not having looked through the code, I was under the impression that
"stonewall" changed the semantics of that behavior.  Understood...

Thanks for the insight.  Much appreciated...


> ________________________________
> From: fio-owner@vger.kernel.org [fio-owner@vger.kernel.org] on behalf of thoms [thoms@voicenet.com]
> Sent: Wednesday, February 25, 2015 8:04 PM
> To: fio@vger.kernel.org
> Subject: Stonewalled ?
>
> Hi folks,
>
> I'm running fio-2.2.5 on a Linux x86_64 platform.  This is the first
> time I've had to create a job file with an extremely large number of job
> sections within the same file (hundreds of jobs).  I need each job to
> run sequentially and have included "stonewall" within each section.
> When I execute the job file, I get this error:
>
>   error: maximum number of jobs (2048) reached.
>
> When I reduce the number of job sections in the file to under 200, the
> job runs sequentially as expected.
>
> My understanding of "stonewall" is that it should serialize the running
> of each job within a file (or files).  The implication is that fio
> shouldn't be evaluating a subsequent job section until after the current
> job has fully completed.  But in this case, fio appears to be looking
> ahead and ignoring the "stonewall" directive until it exhausts
> resources. This behavior also occurs within the current git commit.
>
> Is this a feature or a bug, and is there another way to tell fio to
> execute each job sequentially (top to bottom) as it encounters them in
> the file?
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

