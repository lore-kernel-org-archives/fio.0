Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44333 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbbBZVV4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Feb 2015 16:21:56 -0500
Received: by qcvs11 with SMTP id s11so10838389qcv.11
        for <fio@vger.kernel.org>; Thu, 26 Feb 2015 13:21:55 -0800 (PST)
Message-ID: <54EF8E70.1000504@gmail.com>
Date: Thu, 26 Feb 2015 15:21:52 -0600
From: Mark Nelson <mark.a.nelson@gmail.com>
MIME-Version: 1.0
Subject: Re: suggestion:  patch to make per-thread IOPS more accurate
References: <596106035.8980737.1421443175599.JavaMail.zimbra@redhat.com> <54B982D7.1070503@kernel.dk> <159806365.11854527.1422052704407.JavaMail.zimbra@redhat.com> <1745095866.10478940.1424039625224.JavaMail.zimbra@redhat.com>
In-Reply-To: <1745095866.10478940.1424039625224.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ben England <bengland@redhat.com>, fio@vger.kernel.org

Hi Ben,

I confess that I'm not using JSON output myself, but I think this would 
be really beneficial when there are a lot of clients (like VMs).

Jens, would this be an acceptable change?  I think I'd appreciate this 
if I switch over to using the JSON output.

Mark

On 02/15/2015 04:33 PM, Ben England wrote:
> The following small patch to stat.c (using fio 2.2.4 from github) outputs IOPS field in JSON format as a floating point number instead of an integer.  This improves accuracy in case where fio --client runs use lots of threads with single-digit IOPS per thread.  It seems to work, here's a snippet of output from a short fio run with rate_iops=10 in the job file.
>
>       "write" : {
>          "io_bytes" : 6464,
>          "bw" : 646,
>          "iops" : 10.10,
>          "runtime" : 10000,
>
> Why the patch: IOPS number is rounded to integer in stats.c calls to num2str().  This doesn't sound like much of a problem because in many use cases, with large IOPS number the error is negligible.  But in this use case where we have many threads (we would like to get into the thousands eventually), the IOPS/thread may be quite low and integer rounding can introduce significant error.  For example, if we are doing 5,000 IOPS over 1,000 threads, average throughput is 5 IOPS and potential error is ~20%, but some threads could have much higher error in IOPS because of integer format.
>
> background: fio's --client option could prove *extremely* useful for work where we inject I/O workload from tens, hundreds or even thousands of VMs to an OpenStack, container or other virtualization environment.  I really like this feature combined with "fio --server --daemonize=/var/run/fio-svr.pid" command run on workload generators, because it means that we don't have to use ssh/pdsh to start up a connection and launch the workload generator on each host.  ssh is problematic for this, I have to throttle it because it locks up if you have too many concurrent ssh sessions starting up.  pdsh is better but still has limits because you actually have to start each thread up from scratch, sometimes in competition with the workload you want to measure.
>
> --- stat.c.sav	2015-01-23 16:22:14.566717417 -0500
> +++ stat.c	2015-01-23 16:49:53.287962156 -0500
> @@ -674,7 +674,8 @@
>   		struct group_run_stats *rs, int ddir, struct json_object *parent)
>   {
>   	unsigned long min, max;
> -	unsigned long long bw, iops;
> +	unsigned long long bw;
> +	double iops;
>   	unsigned int *ovals = NULL;
>   	double mean, dev;
>   	unsigned int len, minv, maxv;
> @@ -698,12 +699,12 @@
>   		uint64_t runt = ts->runtime[ddir];
>
>   		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
> -		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
> +		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
>   	}
>
>   	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir] >> 10);
>   	json_object_add_value_int(dir_object, "bw", bw);
> -	json_object_add_value_int(dir_object, "iops", iops);
> +	json_object_add_value_float(dir_object, "iops", iops);
>   	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
>   	json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
>   	json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
