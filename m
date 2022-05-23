Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E64DC433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 19:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiEWTnZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 15:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiEWTmO (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 15:42:14 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE2511468
        for <fio@vger.kernel.org>; Mon, 23 May 2022 12:38:28 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220523193822epoutp02f867c7a8de7d4b3190c8a22c6cdcdd97~x0ybjq3ZJ2847428474epoutp02_
        for <fio@vger.kernel.org>; Mon, 23 May 2022 19:38:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220523193822epoutp02f867c7a8de7d4b3190c8a22c6cdcdd97~x0ybjq3ZJ2847428474epoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653334702;
        bh=5avVdFMZnZy1y8cBHxygb/zvlNX4pZG2EKABWkgZfWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q3YcpOrcBC2rUCrDozfqUfiD1Ne2CyjqW0n5YDWTWJoTtGk0/f2Eoj9qtBubAopC/
         uoxjrFjhaupX+14P/jReXAaVJS8ueOhMZwHN9AnqszsWhPJUHuGucZ/8iTsKI5W/Kn
         uOvAaIm7CEXTyUojWqTjxE4SDHBaI4O+MWubigu8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220523193821epcas5p26bafcb5c4b03e59824185403e26ff1b9~x0yacVEqC0575205752epcas5p2d;
        Mon, 23 May 2022 19:38:21 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L6SL26BCrz4x9Pp; Mon, 23 May
        2022 19:38:18 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.FA.09762.AA2EB826; Tue, 24 May 2022 04:38:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220523182517epcas5p47e406b71925ad571c7f1c6eb6c56706b~xzyoVvYbs0955509555epcas5p4e;
        Mon, 23 May 2022 18:25:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523182517epsmtrp2e484f9dd22f56eb4453f4c8cc0b15e3d~xzyoVGv7H1255112551epsmtrp2k;
        Mon, 23 May 2022 18:25:17 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-8e-628be2aadc71
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.E5.08924.D81DB826; Tue, 24 May 2022 03:25:17 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220523182516epsmtip1de0625696e92ab681bdff610a8902b6e~xzynbsSie3007130071epsmtip1m;
        Mon, 23 May 2022 18:25:16 +0000 (GMT)
Date:   Mon, 23 May 2022 23:50:03 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 3/7] engines/io_uring: add new I/O engine for uring
 passthrough support
Message-ID: <20220523182003.GA16572@test-zns>
MIME-Version: 1.0
In-Reply-To: <be576bfa-49e8-aa05-5163-6133e9137695@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTS3fVo+4kg1cNOhZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIztg+awFrwX3nihs/frI3MB4w6WLk
        5JAQMJHY/PI1axcjF4eQwG5GiXsfF7NAOJ8YJVZu3M0I4XxmlGjp+sAE0/L47jqoql2MEifu
        XIOqesYoMfvnQ1aQKhYBVYn2Y59YQGw2AW2JV29vMIPYIgIKEj2/V7KB2MwCsRLPtzWATRUG
        sn+vvAdWzyugK3H2bzOULShxcuYTMJtTwFZiw9rnYPNFBZQlDmw7zgSyWELgHrvExcZVQEM5
        gBwXiemLyiAuFZZ4dXwLO4QtJfH53V42CDtbovHRXyi7RGLnre3MELa9xMU9f5lAxjALZEhM
        f+kGEZaVmHpqHRPEyXwSvb+fQAOCV2LHPBhbVeLvvdssELa0xM13V6FsD4mdB7rBThYS+MYo
        sXOW0wRG+VlIPpuFsG0W2AYdiQW7P7FBhKUllv/jgDA1Jdbv0l/AyLqKUTK1oDg3PbXYtMA4
        L7UcHt3J+bmbGMHJUct7B+OjBx/0DjEycTAeYpTgYFYS4d2e2JEkxJuSWFmVWpQfX1Sak1p8
        iNEUGFETmaVEk/OB6TmvJN7QxNLAxMzMzMTS2MxQSZxX4H9jkpBAemJJanZqakFqEUwfEwen
        VANT7+oD3affN6/7YJocuibRnz+2Q0Ln8/+2c0/rzAu/F+seSf3Bd636yt45z04ktPwxsj59
        P1Mhz1bk8O3Tn7be1QruzOuwFuSdsyg1KTzz54QdxsxTmRcmi/4/fn593cSa/scnSxOql3yd
        nfuxr/9z59mrjOt0zbyqc1TiOWsDxYy3HO7hdrrqUftpx/Et8x4f+HjdcG7tDtGni9QYzkgs
        P/Wu9VB5Zca+2dXCM64a6qYoXrXm9E/6d9yDO0bc5XA4X9D34z4dCsXT/zhPdHuWdML8pApv
        vfS+VWlfHKos+Kp2ZxT9Lvj56sCEw7ztEluZo3+l13w7FlRgtffGyv+/A5xCTm9wb/TK0pm2
        R+GKEktxRqKhFnNRcSIAhuFrWBcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSnG7vxe4kg9alehZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK+HPmNmPB
        fMeKeddnMjcwzjTqYuTkkBAwkXh8dx1LFyMXh5DADkaJZRN+MHUxcgAlpCUWrk+EqBGWWPnv
        OTuILSTwhFHi+J14EJtFQFWi/dgnFhCbTUBb4tXbG8wgtoiAgkTP75VsIDazQKzE820NTCC2
        MJD9e+U9sHpeAV2Js3+bofZ+Y5TYteo2K0RCUOLkzCcsEM1aEjf+vQS7hxnonuX/OEDCnAK2
        EhvWPgcrFxVQljiw7TjTBEbBWUi6ZyHpnoXQvYCReRWjZGpBcW56brFhgVFearlecWJucWle
        ul5yfu4mRnBYa2ntYNyz6oPeIUYmDsZDjBIczEoivNsTO5KEeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYJLbN/Ga87vwH/u/XKiMLuT7WDvhyJuJKesr
        5CMKFjfJfdTVY2JMOe+u+thHf+9UdvG1PDEf3rxW+7MqtNkxYvWxw+e39AQsKf/T+7XVu+v/
        5VjlrOcrsuaGbW6YrTbNzq28kMtg9bma+Zz3slqV5htfOPF1s3jIdhbJjv8Nz9a+K7pbvuW6
        0v3AeTcTRKoqZPZ9ZX791XCjX/bJ2DNTr7xdtXDCI6mNB3/urJpaGiyTO0X0peCG6o1uMvwv
        j/Dzbzl73tDuj06ZzcqYvDL1N5s05tUcu261fdpdE+2fDxOXHP3add5sX/6mZyH6+qrpvns9
        uC5y+zouVt7ye7LCqo78+RcnVQbJP9osdX6ZotJkJZbijERDLeai4kQAG/Uw/9oCAAA=
X-CMS-MailID: 20220523182517epcas5p47e406b71925ad571c7f1c6eb6c56706b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_14f0e_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07@epcas5p4.samsung.com>
        <20220523131039.17697-4-ankit.kumar@samsung.com>
        <be576bfa-49e8-aa05-5163-6133e9137695@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_14f0e_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, May 23, 2022 at 10:44:50AM -0600, Jens Axboe wrote:
> On 5/23/22 7:10 AM, Ankit Kumar wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> > 
> > Add a new I/O engine (io_uring_cmd) for sending uring passthrough
> > commands. The new I/O engine will be built only if its support is
> > present in the kernel. It will also use most of the existing
> > helpers from the I/O engine io_uring. The I/O preparation,
> > completion, file open, file close and post init paths are going to
> > differ and hence io_uring_cmd will have its own helper for them.
> > 
> > Add a new io_uring_cmd engine specific flag to support nvme
> > passthrough commands. Filename name for this specific option
> > must specify nvme-ns generic character device (dev/ngXnY).
> > This provides io_uring_cmd I/O engine a bandwidth to support
> > various passthrough commands in future.
> > 
> > The engine_pos and engine_data fields in struct fio_file are
> > separated now. This will help I/O engine io_uring_cmd to store
> > specific data as well as keep track of register files.
> > 
> > The supported io_uring_cmd options are:
> >  * registerfiles
> >  * sqthread_poll
> >  * sqthread_poll_cpu
> >  * cmd_type
> 
> This looks way better than the earlier versions.
> 
> > co-authored-By: Anuj Gupta <anuj20.g@samsung.com>
> > co-authored-By: Ankit Kumar <ankit.kumar@samsung.com>
> 
> Since the patch is attributed to Anuj as the author, that co-authored-by
> should be a Signed-off-by from Anuf.
>
Thanks, Will update it
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index 1e15647e..75248624 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -25,6 +25,17 @@
> >  #include "../os/linux/io_uring.h"
> >  #include "cmdprio.h"
> >  
> > +#ifdef CONFIG_LIBNVME
> > +#include <sys/stat.h>
> > +#include <nvme/ioctl.h>
> > +#endif
> > +
> > +#ifdef CONFIG_URING_CMD
> > +enum uring_cmd_type {
> > +	FIO_URING_CMD_NVME = 1,
> > +};
> > +#endif
> 
> Can you briefly describe why we need the libnvme dependency? What does
> libnvme get us here? Would it be too cumbersome to do it without
> libnvme?
> 
> In general, fio tries to not rely on external libraries unless there's a
> strong reason to do so.
> 
Our idea of having libnvme dependency was ease of maintaing the code
base as libnvme provides all the necessary structures, definitions and
helper functions.
But yes libnvme won't be necessary if we maintain all the nvme
structures and send passthru commands.
> > @@ -270,6 +289,23 @@ static struct fio_option options[] = {
> >  		.category = FIO_OPT_C_ENGINE,
> >  		.group	= FIO_OPT_G_IOURING,
> >  	},
> > +#ifdef CONFIG_URING_CMD
> > +	{
> > +		.name	= "cmd_type",
> > +		.lname	= "Uring cmd type",
> > +		.type	= FIO_OPT_STR,
> > +		.off1	= offsetof(struct ioring_options, cmd_type),
> > +		.help	= "Specify uring-cmd type",
> > +		.posval = {
> > +			  { .ival = "nvme",
> > +			    .oval = FIO_URING_CMD_NVME,
> > +			    .help = "Issue nvme-uring-cmd",
> > +			  },
> > +		},
> > +		.category = FIO_OPT_C_ENGINE,
> > +		.group	= FIO_OPT_G_IOURING,
> > +	},
> > +#endif
> >  	{
> >  		.name	= NULL,
> >  	},
> 
> Options should always be visible regardless of availability, they should
> just error if not available at runtime.
> 
> > @@ -373,6 +409,61 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_URING_CMD
> > +static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
> > +{
> > +	struct ioring_data *ld = td->io_ops_data;
> > +	struct ioring_options *o = td->eo;
> > +	struct fio_file *f = io_u->file;
> > +	struct io_uring_sqe *sqe;
> > +
> > +	/* nvme_uring_cmd case */
> > +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> > +#ifdef CONFIG_LIBNVME
> > +		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
> > +		struct nvme_uring_cmd *cmd;
> > +		unsigned long long slba;
> > +		unsigned long long nlb;
> > +
> > +		sqe = &ld->sqes[(io_u->index) << 1];
> > +
> > +		if (o->registerfiles) {
> > +			sqe->fd = f->engine_pos;
> > +			sqe->flags = IOSQE_FIXED_FILE;
> > +		} else {
> > +			sqe->fd = f->fd;
> > +		}
> > +		sqe->opcode = IORING_OP_URING_CMD;
> > +		sqe->user_data = (unsigned long) io_u;
> > +		sqe->cmd_op = NVME_URING_CMD_IO;
> > +
> > +		slba = io_u->offset / data->lba_size;
> > +		nlb = (io_u->xfer_buflen / data->lba_size) - 1;
> > +
> > +		cmd = (struct nvme_uring_cmd *)sqe->cmd;
> > +		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> > +
> > +		/* cdw10 and cdw11 represent starting lba */
> > +		cmd->cdw10 = slba & 0xffffffff;
> > +		cmd->cdw11 = slba >> 32;
> > +		/* cdw12 represent number of lba's for read/write */
> > +		cmd->cdw12 = nlb;
> > +		cmd->addr = (__u64)io_u->xfer_buf;
> > +		cmd->data_len = io_u->xfer_buflen;
> > +		cmd->nsid = data->nsid;
> > +
> > +		if (io_u->ddir == DDIR_READ)
> > +			cmd->opcode = nvme_cmd_read;
> > +		if (io_u->ddir == DDIR_WRITE)
> > +			cmd->opcode = nvme_cmd_write;
> > +
> > +		return 0;
> > +#endif
> > +	}
> > +	return -EINVAL;
> > +}
> > +#endif
> 
> The nested ifdefs don't do much here for readability. Would be cleaner
> as:
> 
> #ifdef CONFIG_URING_CMD
> static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
> {
> #ifndef CONFIG_LIBNVME
> 	return -EINVAL;
> #else
> 	struct ioring_data *ld = td->io_ops_data;
> 	struct ioring_options *o = td->eo;
> 	struct fio_file *f = io_u->file;
> 	struct io_uring_sqe *sqe;
> 
> 	/* nvme_uring_cmd case */
> 	if (o->cmd_type != FIO_URING_CMD_NVME)
> 		return -EINVAL;
> 
> 	...
> #endif /* CONFIG_LIBNVME */
> }
> #endif /* CONFIG_URING_CMD */
> 
Ack
> > +#ifdef CONFIG_URING_CMD
> > +static int fio_ioring_cmd_queue_init(struct thread_data *td)
> > +{
> > +	struct ioring_data *ld = td->io_ops_data;
> > +	struct ioring_options *o = td->eo;
> > +	int depth = td->o.iodepth;
> > +	struct io_uring_params p;
> > +	int ret;
> > +
> > +	memset(&p, 0, sizeof(p));
> > +
> > +	if (o->hipri && o->cmd_type == FIO_URING_CMD_NVME) {
> > +		log_err("fio: nvme_uring_cmd doesn't support hipri\n");
> > +		return ENOTSUP;
> > +	}
> > +	if (o->hipri)
> > +		p.flags |= IORING_SETUP_IOPOLL;
> > +	if (o->sqpoll_thread) {
> > +		p.flags |= IORING_SETUP_SQPOLL;
> > +		if (o->sqpoll_set) {
> > +			p.flags |= IORING_SETUP_SQ_AFF;
> > +			p.sq_thread_cpu = o->sqpoll_cpu;
> > +		}
> > +	}
> > +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> > +		p.flags |= IORING_SETUP_SQE128;
> > +		p.flags |= IORING_SETUP_CQE32;
> > +	}
> > +
> > +	/*
> > +	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
> > +	 * than that.
> > +	 */
> > +	p.flags |= IORING_SETUP_CQSIZE;
> > +	p.cq_entries = depth;
> > +
> > +retry:
> > +	ret = syscall(__NR_io_uring_setup, depth, &p);
> > +	if (ret < 0) {
> > +		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
> > +			p.flags &= ~IORING_SETUP_CQSIZE;
> > +			goto retry;
> > +		}
> > +		return ret;
> > +	}
> > +
> > +	ld->ring_fd = ret;
> > +
> > +	fio_ioring_probe(td);
> > +
> > +	if (o->fixedbufs) {
> > +		log_err("fio: io_uring_cmd doesn't support fixedbufs\n");
> > +		return ENOTSUP;
> > +	}
> > +	return fio_ioring_mmap(ld, &p);
> 
> This is a limitation of the current implementation, which means that
> once the kernel does support that, your fio still won't work until you
> update it.
> 
> In other words, this should just fail at runtime if someone attempts to
> use it.
> 
> In general, cleanup all the ifdef mess, it's all over the place. It
> makes it really hard to maintain, way too easy to make a change that
> works on your setup and breaks if you don't have eg libnvme. Rather than
> do it in the middle of functions, have stubs that just return an error
> if the right options aren't available. That makes the actual functional
> functions easier to read too, rather than having ifdefs sprinkled
> everywhere.
> 
> -- 
> Jens Axboe
> 
> 
Thanks for reviewing it quickly, we will cleanup all the ifdef mess.
We will remove the libnvme dependency and have a separate file
(engines/nvme_uring.c similar to engines/cmdprio.c) for all the
necessary structures and helper functions.

------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_14f0e_
Content-Type: text/plain; charset="utf-8"


------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_14f0e_--
