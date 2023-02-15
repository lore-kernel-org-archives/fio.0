Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE86C636D4
	for <fio@archiver.kernel.org>; Wed, 15 Feb 2023 23:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBOXVR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Feb 2023 18:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBOXVQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2023 18:21:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54742BE4
        for <fio@vger.kernel.org>; Wed, 15 Feb 2023 15:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3CE9B82255
        for <fio@vger.kernel.org>; Wed, 15 Feb 2023 23:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B3C433EF;
        Wed, 15 Feb 2023 23:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676503272;
        bh=zJ8ucsFzw+xoHSry4iSL9eg4nQ0aXH05JODBIRHe2Y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sA+q1BmLAVF2Rhp1ddQTjSRos4eVjx0WopOTYYUn5kMd+kJkwcLEcOO8sZR3ZlXBf
         V/uHzvpUYI5Ky31r3KDkyqeNGS/wsksIZ296zbbQUCVXufSuATVoXBjLkS7SkmwmnO
         iTEUyOZ9jIe/E5rqc9HWIa3xS9p7hCPpWsaCX5VgbDrT2AktjLDV15DZfUMbSEupot
         99u6EE2dHhfBsL5PGHibMoQqxVQf68n3588ve+co+/lEGGmVQ5aWGNUpBqLlLi2soI
         0/8xTshbGgCMzpBMzhB0AGDmlClfEoPw+Wnr2XexZ6nbkU5u2CDPXG3Gb4VWGu6LNW
         utl6Kah/rPC9g==
Date:   Wed, 15 Feb 2023 16:21:08 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
        axboe@kernel.dk, its@irrelevant.dk, vincentfu@gmail.com,
        damien.lemoal@opensource.wdc.com
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Message-ID: <Y+1o5OloTOaQ8VXI@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20230209171249epcas5p34771bbde03c3eda8ecfba1e164a16086@epcas5p3.samsung.com>
 <20230209171236.1113887-1-kbusch@meta.com>
 <20230210062911.GA6390@green5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210062911.GA6390@green5>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Feb 10, 2023 at 11:59:11AM +0530, Ankit Kumar wrote:
> > +.. option:: fdp=bool : [io_uring_cmd]
> > +
> > +	Enable Flexible Data Placement mode for write commands.
> > +
> > +.. option:: fdp_pli=int[,int][,int] : [io_uring_cmd]
> I think it probably should just be "fdp_pli=str"
> Kind of similar to the fio "option cpus_allowed=str"
...
> > +	Select which Placement ID Index/Indicies this job is allowed to use for
> > +	writes. By default, the job will cycle through all available Placement
> > +	IDs, so use this to isolate these identifiers to specific jobs..
> Maybe we can also add one line description something like this:
> If you want fio to use placement identifier only at indices 0,2 and 5 specify
> ``fdp_pli=0,2,5``.

Sure, definitely don't need to be sequential. Also, like cpus_allowed, perhaps
ranges are desirable (ex: 0-2,5).

> > +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> > +			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
> > +{
> > +	struct nvme_data *data = FILE_ENG_DATA(f);
> > +	int fd, ret;
> > +
> > +	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
> > +	if (fd < 0)
> > +		return -errno;
> > +
> > +	ret = nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs);
> > +	if (ret) {
> > +		log_err("%s: nvme_fdp_reclaim_unit_handle_status failed, err=%d\n",
> > +			f->file_name, ret);
> > +		errno = ENOTSUP;
> > +	}
> > +
> > +	close(fd);
> > +	return -errno;
> should be "return ret;"

The return needs to be a negative number, and 'ret' can sometimes be positive
or negative.

> > +/*
> > + * Maximum number of RUHS to fetch
> > + * TODO: Revisit this so that we can work with more than 1024 RUH's
> > + */
> For me, I will send a fix once these changes get merged.

Could you help clarify some spec confusion on my side? The Namespace Management
command allows you to specify at most 128 placement handles when you create the
namespace, so why would we need more than that? Under what conditions could the
namespaces' IO Mgmt Recv RUH Status ever return more than 128 descriptors?

And speaking of that, since 128 is the largest value, it seems odd the spec
folks gave this field two bytes.
