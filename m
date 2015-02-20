Return-Path: <fio-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:42799 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbBTUiy (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Feb 2015 15:38:54 -0500
Received: from zmail22.collab.prod.int.phx2.redhat.com (zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
	by mx6-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t1KKcsHJ011550
	for <fio@vger.kernel.org>; Fri, 20 Feb 2015 15:38:54 -0500
Date: Fri, 20 Feb 2015 15:38:53 -0500 (EST)
From: Andrew Theurer <atheurer@redhat.com>
Message-ID: <946456843.6361273.1424464733992.JavaMail.zimbra@redhat.com>
In-Reply-To: <2137206709.6359691.1424464503833.JavaMail.zimbra@redhat.com>
References: <2137206709.6359691.1424464503833.JavaMail.zimbra@redhat.com>
Subject: Re: suggestion: patch to make per-thread IOPS more accurate
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


> The following small patch to stat.c (using fio 2.2.4 from github) outputs
> IOPS field in JSON format as a floating point number instead of an integer.
> This improves accuracy in case where fio --client runs use lots of threads
> with single-digit IOPS per thread.  It seems to work, here's a snippet of
> output from a short fio run with rate_iops=10 in the job file.
> 
>      "write" : {
>         "io_bytes" : 6464,
>         "bw" : 646,
>         "iops" : 10.10,
>         "runtime" : 10000,

Thanks for this.  I have applied the patch, and it works fine for me.  Very useful when testing with many fio jobs on slower storage.

> Why the patch: IOPS number is rounded to integer in stats.c calls to
> num2str().  This doesn't sound like much of a problem because in many use
> cases, with large IOPS number the error is negligible.  But in this use case
> where we have many threads (we would like to get into the thousands
> eventually), the IOPS/thread may be quite low and integer rounding can
> introduce significant error.  For example, if we are doing 5,000 IOPS over
> 1,000 threads, average throughput is 5 IOPS and potential error is ~20%, but
> some threads could have much higher error in IOPS because of integer format.
> 
> background: fio's --client option could prove *extremely* useful for work
> where we inject I/O workload from tens, hundreds or even thousands of VMs to
> an OpenStack, container or other virtualization environment.  I really like
> this feature combined with "fio --server --daemonize=/var/run/fio-svr.pid"
> command run on workload generators, because it means that we don't have to
> use ssh/pdsh to start up a connection and launch the workload generator on
> each host.  ssh is problematic for this, I have to throttle it because it
> locks up if you have too many concurrent ssh sessions starting up.  pdsh is
> better but still has limits because you actually have to start each thread
> up from scratch, sometimes in competition with the workload you want to
> measure.
> 
> --- stat.c.sav	2015-01-23 16:22:14.566717417 -0500
> +++ stat.c	2015-01-23 16:49:53.287962156 -0500
> @@ -674,7 +674,8 @@
>  		struct group_run_stats *rs, int ddir, struct json_object *parent)
>  {
>  	unsigned long min, max;
> -	unsigned long long bw, iops;
> +	unsigned long long bw;
> +	double iops;
>  	unsigned int *ovals = NULL;
>  	double mean, dev;
>  	unsigned int len, minv, maxv;
> @@ -698,12 +699,12 @@
>  		uint64_t runt = ts->runtime[ddir];
>  
>  		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
> -		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
> +		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
>  	}
>  
>  	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir] >>
>  	10);
>  	json_object_add_value_int(dir_object, "bw", bw);
> -	json_object_add_value_int(dir_object, "iops", iops);
> +	json_object_add_value_float(dir_object, "iops", iops);
>  	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
>  	json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
>  	json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);

-Andrew
