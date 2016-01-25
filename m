Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48626 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbcAYPap (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 25 Jan 2016 10:30:45 -0500
Subject: Re: [FIO][PATCH v1] powerpc: fix cpus_online() to get correct max CPU
 number for powerpc64
References: <1453727058-45619-1-git-send-email-dqzhang@linux.vnet.ibm.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <56A63F91.6090102@fb.com>
Date: Mon, 25 Jan 2016 08:30:25 -0700
MIME-Version: 1.0
In-Reply-To: <1453727058-45619-1-git-send-email-dqzhang@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Qing Zhang <dqzhang@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org, zhong@linux.vnet.ibm.com

On 01/25/2016 06:04 AM, Dan Qing Zhang wrote:
> This patch tries to fix cpus_online() for powerpc64 when running fio
> by using parameter "cpus_allowed", in order to obtain correct max CPU
> number on powerpc64 architecture.
>
> When changing SMT settings on powerpc architecture, the way of cpu
> numbering is changing as well. For example, when SMT=off, CPUs are
> numbered like 0,8,16,..., while when SMT=2, CPUs are numbered like
> 0,1,8,9,.... Therefore, sysconf(_SC_NPROCESSORS_ONLN) is not applied
> to get exact max CPU number on powerpc. And the max_cpu value can be
> correctly ontained by using sysconf(_SC_NPROCESSORS_CONF).

Thanks, applied. I have a general dislike for discontiguous CPU 
numbering, be it in the kernel or in user space :-)

-- 
Jens Axboe

