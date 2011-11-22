Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1KVIfy (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Nov 2011 03:35:54 -0500
Message-ID: <4ECB5EE7.7020804@kernel.dk>
Date: Tue, 22 Nov 2011 09:35:51 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use the reentrant getmntent_r instead of getmntent
References: <1321945003-14786-1-git-send-email-gaoyang.zyh@taobao.com>
In-Reply-To: <1321945003-14786-1-git-send-email-gaoyang.zyh@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: fio@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>

On 2011-11-22 07:56, Zhu Yanhai wrote:
> The function find_cgroup_mnt() could be called under multithread scenario, so
> we should use the reentrant edition getmntent_r() instead of getmntent().
> 
> E.g, without this fix the output for below job file is wrong.
> 
> [root@localhost blkio-test]# cat small-read-file
> [global]
> ioengine=sync
> direct=1
> rw=read
> bs=4k
> filename=/dev/sdb
> time_based
> runtime=60
> cgroup=small
> cgroup_weight=500
> numjobs=32
> group_reporting
> thread
> 
> [file1]
> 
> Then fio randomly says:
> [cut here]
> Starting 32 threads
> fio: cgroup blkio does not appear to be mounted
> fio: cgroup blkio does not appear to be mounted
> fio: cgroup blkio does not appear to be mounted
> ---
>  cgroup.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/cgroup.c b/cgroup.c
> index f36683a..4f02ecd 100644
> --- a/cgroup.c
> +++ b/cgroup.c
> @@ -22,7 +22,8 @@ struct cgroup_member {
>  static char *find_cgroup_mnt(struct thread_data *td)
>  {
>  	char *mntpoint = NULL;
> -	struct mntent *mnt;
> +	struct mntent *mnt, dummy;
> +	char buf[256] = {0};
>  	FILE *f;
>  
>  	f = setmntent("/proc/mounts", "r");
> @@ -31,7 +32,7 @@ static char *find_cgroup_mnt(struct thread_data *td)
>  		return NULL;
>  	}
>  
> -	while ((mnt = getmntent(f)) != NULL) {
> +	while ((mnt = getmntent_r(f, &dummy, buf, 256)) != NULL) {
>  		if (!strcmp(mnt->mnt_type, "cgroup") &&
>  		    strstr(mnt->mnt_opts, "blkio"))
>  			break;

Thanks applied, with a small change to use sizeof(buf) instead of 256 in
both places.

-- 
Jens Axboe

