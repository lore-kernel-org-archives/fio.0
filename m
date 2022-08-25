Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FEBC28D13
	for <fio@archiver.kernel.org>; Thu, 25 Aug 2022 12:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiHYMBt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Aug 2022 08:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiHYMBs (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Aug 2022 08:01:48 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5EC74341
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 05:01:45 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220825120140epoutp02a63efa39a903f6d43f79aa8cdfebe34f~OlMhK7Uvl3097230972epoutp02h
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 12:01:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220825120140epoutp02a63efa39a903f6d43f79aa8cdfebe34f~OlMhK7Uvl3097230972epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661428900;
        bh=ncHVA9xgqiq/R0r9O7GkqCFxi+lB3o3Kzc29m7RHwEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pxn7qgW+EO1yJI+7mD2IDzsbuNqJQ+bqEZhIu9c4+X5xu2AFJGAnmucT7x6xXiEJV
         PIt9mh60LRfUuHLuqEnxSPW9oOXAEXK0cOZDill7cfKy0aDA/4KIr5rvERfKdHUtIi
         DB6HTVEbfONBEtIin4PAHOmyYzHRCSO2p9gy+e8w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220825120139epcas5p4c60de76b019debdb093bdc7345981f34~OlMgO1hLf2891528915epcas5p4j;
        Thu, 25 Aug 2022 12:01:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MD1lj3LN7z4x9Pw; Thu, 25 Aug
        2022 12:01:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.FA.53458.F9467036; Thu, 25 Aug 2022 21:01:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220825113029epcas5p3dedc33f8c438e882ee7e0be948fb8af5~OkxSisDpz0742007420epcas5p3D;
        Thu, 25 Aug 2022 11:30:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220825113029epsmtrp2c5e4f0fe24386c7e35fe0c03e22d7116~OkxSiAcx01057710577epsmtrp2l;
        Thu, 25 Aug 2022 11:30:29 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-dd-6307649f5d9a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.79.14392.55D57036; Thu, 25 Aug 2022 20:30:29 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220825113028epsmtip14c20c9f3433ccde2c5042f09789099bb~OkxRnjuXi0810108101epsmtip1V;
        Thu, 25 Aug 2022 11:30:28 +0000 (GMT)
Date:   Thu, 25 Aug 2022 16:50:43 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org
Subject: Re: [PATCH 2/2] t/io_uring: add support for async-passthru
Message-ID: <20220825112043.GA4285@test-zns>
MIME-Version: 1.0
In-Reply-To: <b6ddee98-1bc0-4a5c-7446-3b0a0857a2a3@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTXXd+CnuywZqj6hZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj/ql1bAWTlSr6rq5kaWBs
        l+pi5OSQEDCRuL3sDVMXIxeHkMBuRolp3w8wQjifGCW2729hhnC+MUqc2nKPDabl3Mr7UIm9
        jBJHt02H6n/GKNE2+SwzSBWLgKrEiw/LmEBsNgF1iSPPW4HmcnCICJhK/P6iDxJmFnCV+HZs
        IthQYQFniSkN3YwgNq+AjsSLW0fYIWxBiZMzn7CA2JwCthK7tlwHi4sKKEsc2HYcbK+EwD12
        ibm7jzBBXOcicWPOaWYIW1ji1fEt7BC2lMTnd3uhPkiX+HH5KVR9gUTzsX2MELa9ROupfmaI
        4zIkHs5+xgoRl5WYemodE0ScT6L39xOoXl6JHfNgbCWJ9pVzoGwJib3nGqBsD4n1mzaywMP0
        ysxZLBMY5WcheW4Wkn0Qto7Egt2f2GYBw4tZQFpi+T8OCFNTYv0u/QWMrKsYJVMLinPTU4tN
        C4zyUsvhMZ6cn7uJEZwqtbx2MD588EHvECMTB+MhRgkOZiURXqtjLMlCvCmJlVWpRfnxRaU5
        qcWHGE2BcTWRWUo0OR+YrPNK4g1NLA1MzMzMTCyNzQyVxHmnaDMmCwmkJ5akZqemFqQWwfQx
        cXBKNTDJ8Fwqk7nYwB3c7qER51p3tHzGt/Na62ZPXuSwTfsv8+valU179ywWXNJ7MqdmBlvA
        6r+u9fPXnWpuqWw5u7Lxx6vqE3WBX9bLJjNYXntq9CB6otpezQUX7I+zvb9bzWU49y/j98xz
        BX/2zO9p4uIOe56nLzbdY966b5ZlIknr/2zuvbNmikS0+PWvUVP2Fh/XfPK6b8On0NypC0UN
        3+1UfXa8Jfvce4abW6uK95z08uYvmftl4Tzehssbnq3fxyiRzyG3rvS94jTXkuNdzrzHVueI
        74k/k7PmvUPh9FvdIquLX54wOh16kkvz+2SerjNyJ+vtXzLkrjyV8dHCbsY2g4ConFLd+u+W
        +5YzOHIuVWIpzkg01GIuKk4EAC48W7IeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnG5oLHuywcGpwhZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2P1
        7Fa2govyFfsWnGZqYHwg3sXIySEhYCJxbuV95i5GLg4hgd2MEm3ntjFBJCQkTr1cxghhC0us
        /PecHaLoCaPEvGUd7CAJFgFViRcfloE1sAmoSxx53grUwMEhImAq8fuLPkiYWcBV4tuxiWwg
        trCAs8SUhm6wmbwCOhIvbh2BmvmJUWLzwStQCUGJkzOfsEA0a0nc+PeSCWQms4C0xPJ/HCBh
        TgFbiV1broOdICqgLHFg23GmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAsO81HK94sTc
        4tK8dL3k/NxNjOAA19Lcwbh91Qe9Q4xMHIyHGCU4mJVEeK2OsSQL8aYkVlalFuXHF5XmpBYf
        YpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwOQt2btF6Y6jH4PIPVMulgm71Lu+3H38
        b9Of51teWTJML9i9xL7UK25BjuVsX9dV30Q/hzrFqGwX4J5cu5N9RuS93fzHqzX6J1cXTmWR
        2jHZVmiz3xHJFRXyPGtfKj/r2p97uuyQbFi31xqGKv26NZGxC4R8LifMF/454ZXt+SBW50WM
        L5j3PEmxOjVDffbft1GP80p6GU9oTq49/8GYo3wNV4zassRHB/aoJf2+PbvrwlvDvRqv8x/I
        6PfyrestWGDdf6/o6TnPrIOhTok1bV+KpzZxvswTZMn12LnnxMeuh+//vHlZUfUpL2vvvvu5
        bqZ1MvGb53klBlUpS7p82mmbdl/zoLeUnRPLHf/MdUosxRmJhlrMRcWJAJcGSdXfAgAA
X-CMS-MailID: 20220825113029epcas5p3dedc33f8c438e882ee7e0be948fb8af5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa4cb_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712
References: <20220824093109.308791-1-anuj20.g@samsung.com>
        <CGME20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712@epcas5p4.samsung.com>
        <20220824093109.308791-3-anuj20.g@samsung.com>
        <b6ddee98-1bc0-4a5c-7446-3b0a0857a2a3@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa4cb_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Aug 24, 2022 at 02:09:53PM -0600, Jens Axboe wrote:
> On 8/24/22 3:31 AM, Anuj Gupta wrote:
> > @@ -457,12 +509,13 @@ static unsigned file_depth(struct submitter *s)
> >  
> >  static void init_io(struct submitter *s, unsigned index)
> >  {
> > -	struct io_uring_sqe *sqe = &s->sqes[index];
> > +	struct io_uring_sqe *sqe = NULL;
> >  	unsigned long offset;
> >  	struct file *f;
> >  	long r;
> >  
> >  	if (do_nop) {
> > +		sqe = &s->sqes[index];
> >  		sqe->opcode = IORING_OP_NOP;
> >  		return;
> 
> I'd just leave the initial assignment rather than have two manual ones
> for the same thing, and then just have the 'pt' path override it.
>

right, makes sense

> > @@ -490,6 +543,41 @@ static void init_io(struct submitter *s, unsigned index)
> >  			f->cur_off = 0;
> >  	}
> >  
> > +	if (pt) {
> > +		struct nvme_uring_cmd *cmd;
> > +		unsigned long long slba;
> > +		unsigned long long nlb;
> > +
> > +		sqe = &s->sqes[index<<1];
> 
> 		sqe = &s->sqes[index << 1];
> 
> please.
>

acked

> > +		if (register_files) {
> > +			sqe->fd = f->fixed_fd;
> > +			sqe->flags = IOSQE_FIXED_FILE;
> > +		} else {
> > +			sqe->fd = f->real_fd;
> > +			sqe->flags = 0;
> > +		}
> > +		sqe->opcode = IORING_OP_URING_CMD;
> > +		sqe->user_data = (unsigned long) f->fileno;
> > +		if (stats)
> > +			sqe->user_data |= ((unsigned long)s->clock_index << 32);
> > +		sqe->cmd_op = NVME_URING_CMD_IO;
> > +		slba = offset / lbs;
> > +		nlb = bs/lbs - 1;
> 
> You have two expensive integer divisions here. Would make sense to turn
> lbs into a shift instead, those are a lot cheaper to do. And then you
> can put the expensive part in the setup part rather than have it in the
> fast path.
>

sure, will change division to shift here. Will see if I can move the expensive
nvme command formation part in the setup (to the submitter_init function)

> Another thing to consider is to make the pt path separate rather than
> need a bunch of 'if (pt) ... else ...' in here?
> 

right, for passthru we do things differently compared to existing path primarily during
"init_io" and "reap_events_uring". I think we can have a "init_io_pt" and "reap_events_uring_pt"
specific to passthru. But i think we can keep using the same "submitter_uring_fn" for both existing
path and passthru as that part should still remain the same

> > @@ -587,11 +690,14 @@ static int reap_events_uring(struct submitter *s)
> >  
> >  			f = &s->files[fileno];
> >  			f->pending_ios--;
> > -			if (cqe->res != bs) {
> > +			if (!pt && cqe->res != bs) {
> >  				printf("io: unexpected ret=%d\n", cqe->res);
> >  				if (polled && cqe->res == -EOPNOTSUPP)
> >  					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
> >  				return -1;
> > +			} else if (pt && cqe->res != 0) {
> > +				printf("io: unexpected ret=%d\n", cqe->res);
> > +				return -1;
> >  			}
> >  		}
> >  		if (stats) {
> 
> These two would be examples of things that would be cleaner with a
> separate path too.
> 
> > @@ -1306,11 +1428,12 @@ static void usage(char *argv, int status)
> >  		" -a <bool> : Use legacy aio, default %d\n"
> >  		" -S <bool> : Use sync IO (preadv2), default %d\n"
> >  		" -X <bool> : Use registered ring %d\n"
> > -		" -P <bool> : Automatically place on device home node %d\n",
> > +		" -P <bool> : Automatically place on device home node %d\n"
> > +		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
> >  		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
> >  		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
> >  		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
> > -		use_sync, register_ring, numa_placement);
> > +		use_sync, register_ring, numa_placement, pt);
> >  	exit(status);
> 
> Reminds me, should the nsid and lbs be in the submitter struct?
>

right, will make these two a part of submitter struct

> Thanks for doing this work!!
> 
> -- 
> Jens Axboe
> 

--
Anuj Gupta






------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa4cb_
Content-Type: text/plain; charset="utf-8"


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_aa4cb_--
