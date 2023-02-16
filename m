Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653D6C636CC
	for <fio@archiver.kernel.org>; Thu, 16 Feb 2023 06:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBPGJs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Feb 2023 01:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjBPGJr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Feb 2023 01:09:47 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8690747413
        for <fio@vger.kernel.org>; Wed, 15 Feb 2023 22:09:41 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230216060938epoutp046a8bfde69abe577ad55f924da024dfc0~EOSHXoFFM3242732427epoutp04D
        for <fio@vger.kernel.org>; Thu, 16 Feb 2023 06:09:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230216060938epoutp046a8bfde69abe577ad55f924da024dfc0~EOSHXoFFM3242732427epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676527778;
        bh=sjpuJbeoIuXkepnklEAPSk+EOqEy7D+MqXUVdmt1eBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NnNBjfAjak5w7MuyK+j0q2+6Sg0DjUiFW2ddy4YgokGjtf0d9fJm0QApNjECTuacJ
         cLeOOwNX2AiXPDosmUkgD+3b8iJvingPNz17vfXxDpdRHUgX1N1fFDoRgiFRzXtVD+
         hDW4W9R5M8DMy/o0gruaPe/v3XSLnivkdTYrVfUQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230216060938epcas5p4bb709a268f0a91c4897453388a33735b~EOSHBiHgA2385323853epcas5p44;
        Thu, 16 Feb 2023 06:09:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4PHPfm1M5fz4x9Q5; Thu, 16 Feb
        2023 06:09:36 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.43.06765.F98CDE36; Thu, 16 Feb 2023 15:09:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230216052839epcas5p2de29a585fe98ffeb5046b28a324e89b7~ENuVWboFD1763217632epcas5p2k;
        Thu, 16 Feb 2023 05:28:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230216052839epsmtrp18b11d5cb572480ea18bb04c74b2eab63~ENuVVxrcM0124001240epsmtrp11;
        Thu, 16 Feb 2023 05:28:39 +0000 (GMT)
X-AuditID: b6c32a4b-46dfa70000011a6d-a3-63edc89f927c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.57.17995.70FBDE36; Thu, 16 Feb 2023 14:28:39 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230216052838epsmtip2cb7faf8156ac261be4897e19a521a22f~ENuUR-GcC0149201492epsmtip2A;
        Thu, 16 Feb 2023 05:28:38 +0000 (GMT)
Date:   Thu, 16 Feb 2023 10:58:08 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     kbusch@meta.com, fio@vger.kernel.org, axboe@kernel.dk,
        its@irrelevant.dk, damien.lemoal@opensource.wdc.com
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Message-ID: <20230216052808.GA18350@green5>
MIME-Version: 1.0
In-Reply-To: <Y+1o5OloTOaQ8VXI@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmlu6CE2+TDa7vZLJYfbefzeL32fPM
        Fh9nvWC22H/wG6vFpEPXGC3OXF3I4sDmcW7HeXaPy2dLPTat6gTyLlZ47Gy9z+rxeZNcAFtU
        tk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BFKCmWJ
        OaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM
        61tamQo2S1VMX/uJvYHxk0gXIyeHhICJxK4ZW5i7GLk4hAR2M0o8brvJCuF8YpR4MnEvC0iV
        kMBnRomPj7hgOo7eOckIUbSLUeLL7dtQ7U8YJQ7272HqYuTgYBFQlVg9OQ+kgU1AW+LV2xvM
        ILaIgLLE3fkzWUFsZoECidY/78HiwgIeEn+/nGIDsXmB6m9MucgCYQtKnJz5BMzmFLCXuHd0
        Eli9KNCcA9uOM4HslRD4yS5xY04XC8R1LhIv56xmh7CFJV4d3wJlS0m87G+DsrMlNj38yQRh
        F0gcedHLDGHbS7Se6meGOC5D4m1nFxtEXFZi6ql1TBBxPone30+genkldsyDsVUl/t67DXWD
        tMTNd1ehbA+JL1+3M0EC6B6jxMUH+1gnMMrPQvLcLCT7IGwdiQW7PwHZHEC2tMTyfxwQpqbE
        +l36CxhZVzFKphYU56anFpsWGOellsMjPDk/dxMjOI1qee9gfPTgg94hRiYOxkOMEhzMSiK8
        m26+SRbiTUmsrEotyo8vKs1JLT7EaAqMq4nMUqLJ+cBEnlcSb2hiaWBiZmZmYmlsZqgkzqtu
        ezJZSCA9sSQ1OzW1ILUIpo+Jg1OqgalnmU/AvWNC11N0HjJ0ba2Zwqzp/zXz/spyjgvi/P94
        d+Z8mpl75AuD4LnQmlUcc/nVeadFmIdOz5ZZ6yiZV/paK2Vajsz/tKszdSqNP11KOXniBPMC
        r6NMt058OaV8sqxBt0wxg1MvZJ93uN/aehur7rUiN1jXCi9ftcwrdNe3UzUhR6dW24g33JFY
        Xy9aXbNKn/nqHKsnq5sc+I7k2zcnbDD9oh8ZYrU+hffMyp5fpS9vfffo5NrEEJC8NjyyVG22
        gfbmgFX3tkyfquB/kufP6ahtTqIPC788vpepr6H8+aLA9YrV2aEL9PrOf8wzPrD0RP9Kiccu
        5wqNfkqvnHi7bu2Fy/oOpUfdNl/VklJiKc5INNRiLipOBADmwIETLAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSvC77/rfJBh9e6FusvtvPZvH77Hlm
        i4+zXjBb7D/4jdVi0qFrjBZnri5kcWDzOLfjPLvH5bOlHptWdQJ5Fys8drbeZ/X4vEkugC2K
        yyYlNSezLLVI3y6BK2Ner2bBZ/GKtoOTmRoYTwt1MXJySAiYSBy9c5Kxi5GLQ0hgB6PEjHl9
        zF2MHEAJaYmF6xMhaoQlVv57zg5R84hR4s+BWawgNSwCqhKrJ+eB1LAJaEu8enuDGcQWEVCW
        uDt/JiuIzSxQINH65z1YXFjAQ+Lvl1NsIDYvUP2NKRdZIGY+YJT4/OkoVEJQ4uTMJywQzVoS
        N/69ZALZxQx0z/J/HCBhTgF7iXtHJ4HNFAXadWDbcaYJjIKzkHTPQtI9C6F7ASPzKkbJ1ILi
        3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4NDX0trBuGfVB71DjEwcjIcYJTiYlUR4N918kyzE
        m5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk5prm+A9/q2r
        5A8dO7ZjwnTTo9nlJ0RPLf9feMvxxn9vWdG/X7ZvnTvvgPkj6+0e9y/LaCuoLlvSHbi+ft4E
        js+Kyq96y1S6imWiAz8KHGxTuudvIbxyq7zanpkOjLdkH17fdzyIwfCra+qx494/bKdIe//Z
        fuxnl+OxU7vP+i9/Nim/6kmL1jpGPhPbqm9MPVPVAjY+uHp23wtbWcdZld73Omay6rxj8gq1
        Ond3vtccgbcfl4rtePZv/sUe0bfPvds62hIXcJbnPtT49XBv4eoJlr+lp5670+d4ftNepZDU
        per/tlu8ujXLaI3GXeFfAvemZej8aXg9e9X3RzVbdWK/fT7z1uzynIRljIejhH7JKbEUZyQa
        ajEXFScCAMpzeP7sAgAA
X-CMS-MailID: 20230216052839epcas5p2de29a585fe98ffeb5046b28a324e89b7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_6a974_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230209171249epcas5p34771bbde03c3eda8ecfba1e164a16086
References: <CGME20230209171249epcas5p34771bbde03c3eda8ecfba1e164a16086@epcas5p3.samsung.com>
        <20230209171236.1113887-1-kbusch@meta.com> <20230210062911.GA6390@green5>
        <Y+1o5OloTOaQ8VXI@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_6a974_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Feb 15, 2023 at 04:21:08PM -0700, Keith Busch wrote:
> On Fri, Feb 10, 2023 at 11:59:11AM +0530, Ankit Kumar wrote:
> > > +.. option:: fdp=bool : [io_uring_cmd]
> > > +
> > > +	Enable Flexible Data Placement mode for write commands.
> > > +
> > > +.. option:: fdp_pli=int[,int][,int] : [io_uring_cmd]
> > I think it probably should just be "fdp_pli=str"
> > Kind of similar to the fio "option cpus_allowed=str"
> ...
> > > +	Select which Placement ID Index/Indicies this job is allowed to use for
> > > +	writes. By default, the job will cycle through all available Placement
> > > +	IDs, so use this to isolate these identifiers to specific jobs..
> > Maybe we can also add one line description something like this:
> > If you want fio to use placement identifier only at indices 0,2 and 5 specify
> > ``fdp_pli=0,2,5``.
> 
> Sure, definitely don't need to be sequential. Also, like cpus_allowed, perhaps
> ranges are desirable (ex: 0-2,5).
> 
> > > +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> > > +			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
> > > +{
> > > +	struct nvme_data *data = FILE_ENG_DATA(f);
> > > +	int fd, ret;
> > > +
> > > +	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
> > > +	if (fd < 0)
> > > +		return -errno;
> > > +
> > > +	ret = nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs);
> > > +	if (ret) {
> > > +		log_err("%s: nvme_fdp_reclaim_unit_handle_status failed, err=%d\n",
> > > +			f->file_name, ret);
> > > +		errno = ENOTSUP;
> > > +	}
> > > +
> > > +	close(fd);
> > > +	return -errno;
> > should be "return ret;"
> 
> The return needs to be a negative number, and 'ret' can sometimes be positive
> or negative.

ok, in that case errno should be set to 0, before you call
nvme_fdp_reclaim_unit_handle_status.

As I see from the caller function (io_uring.c)

+	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
+	if (ret)
+		goto free;

Currently when I try I get:

/dev/ng0n1: fdp fetch ruhs failed (17).
fio: ruh info failed for /dev/ng0n1 (17).
fio: pid=0, err=17/file:fdp.c:35, func=fdp fetch ruhs failed, error=File exists

> 
> > > +/*
> > > + * Maximum number of RUHS to fetch
> > > + * TODO: Revisit this so that we can work with more than 1024 RUH's
> > > + */
> > For me, I will send a fix once these changes get merged.
> 
> Could you help clarify some spec confusion on my side? The Namespace Management
> command allows you to specify at most 128 placement handles when you create the
> namespace, so why would we need more than that? Under what conditions could the
> namespaces' IO Mgmt Recv RUH Status ever return more than 128 descriptors?

Frankly, I never thought of this. I have only tried with qemu setup which can
return more than 128 descriptors (I even got more than 1024).

In that case, should it just be limited to 128?

> 
> And speaking of that, since 128 is the largest value, it seems odd the spec
> folks gave this field two bytes.
> 

Certainly seems odd.

------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_6a974_
Content-Type: text/plain; charset="utf-8"


------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_6a974_--
