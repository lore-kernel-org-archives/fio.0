Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA10C61DA4
	for <fio@archiver.kernel.org>; Thu, 23 Feb 2023 22:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjBWWqp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBWWqm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Feb 2023 17:46:42 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF956794
        for <fio@vger.kernel.org>; Thu, 23 Feb 2023 14:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677192401; x=1708728401;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=80ORyJEJnMdICDUgVQrvPiv1Th4xk+63bCsF+2UTMG4=;
  b=bBVF6MOAZgXlwPw5LxOTuUB8bQryKz9ckOHL/jHEq2RQzWBAiig36p9A
   HpU1dtoVvZNWUUwxK/j27AuTNJmkcbKAHvoGrmHwVxBGgoR2whV5yfaHv
   Q6dfUfXAwct2LGU4QjsBDgq/ENMQYQPBNATRAs8Eib3qbqPsRW9mKPbjF
   Er8XLMypedd28RaBRH+dbmHkRGREfGNwdypbxVytx/T/gd4Pe79RRmru9
   tkJnHVOLnGUqmY8/iQNJQWWlhOEq+QibBEWSvyK+BHaT7mS1lfb3CFhHs
   orcZKP7YiZuaIMBmFkBgl4Vm2VSCTCJcCvo2XPqr7/sp2S+dNce5gyf+1
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,322,1669046400"; 
   d="scan'208";a="224040998"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2023 06:46:40 +0800
IronPort-SDR: h3eBKXWaRt1UyK1LJIiJcz+nlaR43fLjsXXJfIaDj4CZ/faXuzpvn2ZFSHdnUaM5uEq/vPqGxi
 Wc/q30CZJdY6fnAZu9npf/ZVw6vsgVkCefw5jsrlQvLraqojgyrRdVlEcpMo+jlTCKsHci2Tku
 zxf4ocz5bs94te0C5UHOY2/1UWHGCZ9lVJUU48EBemhjvNbBUokBoh19f0lk7gtpsjqIHRyqX0
 zsWFQ7PSSFRytv4GcxVWWzbxoDQwQ8EXqM2k7/mkknjsnPAD8SSX0+QVXtzYFQrM+VcUgHxNW6
 3LU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Feb 2023 13:57:52 -0800
IronPort-SDR: PCI+u1eXYZW7I0Ub/xgnbNtHnchIDLcy6xAKhMqD9HktmEjetlHNqDdcnI/MdWAy1RE4E/TUWg
 UF5R96rDEUWj+z4Eh+7NM8aDtz7OVn+ds8a8qPSB1WQApjaBQ4+eCpgBakPGsE2JA+3WRnYoOp
 cfGoVVTnd1ZnNLEQ2dOnLJv8DAiuKVLZhWgZIHHpdTN2/jT3d8M8Usldrh+iUeTiTWa3Ch0aUs
 PfAsSwAOPNWNW9LeCqmzyr1nJS5eyOmBNYCpXgU3flFnArzL4ymYB8dnJMgPLDb3S9b+SdaZcq
 jGw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Feb 2023 14:46:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PN7S01KxGz1RvTr
        for <fio@vger.kernel.org>; Thu, 23 Feb 2023 14:46:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677192399; x=1679784400; bh=80ORyJEJnMdICDUgVQrvPiv1Th4xk+63bCs
        F+2UTMG4=; b=XtgH1uqDXZ9CWTB2SLu+ENk6iXl32QYebNA9w7dS1ELOlLeuY+t
        m3+Mf2GbSkFtze50GOt0krqKXrWWY6uikm7HaKA4Gt2ZUL267DMHTZf/Qg4JEGir
        VjAVE3vaTq3ej+ppCygyJ0O+kiMsbv08dubuDp6HweeC22dboNYFK1fSOxpIuYRO
        yyQWFQG8sCZafycGPP189kaFLb+NNBi4tqF7YBbuwaAp98VcyX8bQByIIMBzYznW
        k+ygXHtdqKdcHhHRmUilttPDPSLhq0TcwzMP/DoYvaq13nWaco816UgA9Za/4B+E
        NDLBat5JraHgDwsu0ory7/cM3HEWowF8mgg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VE3ixGDSIM06 for <fio@vger.kernel.org>;
        Thu, 23 Feb 2023 14:46:39 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PN7Ry2xj3z1RvLy;
        Thu, 23 Feb 2023 14:46:38 -0800 (PST)
Message-ID: <52dfb03e-66ef-0f37-1e18-a153ccc8ff9f@opensource.wdc.com>
Date:   Fri, 24 Feb 2023 07:46:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv3] fio: add fdp support for io_uring_cmd nvme engine
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, vincentfu@gmail.com,
        Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230223185508.3527294-1-kbusch@meta.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230223185508.3527294-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/24/23 03:55, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> identifiers in write commands. The user can enabled this with the new
> "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> jobs will cycle through all the namespace's available placement
> identifiers for write commands. The user can limit which placement
> identifiers can be used with additional parameter, "fdp_pli=<list,>",
> which can be used to separate write intensive jobs from less intensive
> ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

[...]

> +static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
> +			struct fio_ruhs_info *ruhs)
> +{
> +	int ret = -EINVAL;
> +
> +	if (td->io_ops && td->io_ops->fdp_fetch_ruhs)
> +		ret = td->io_ops->fdp_fetch_ruhs(td, f, ruhs);
> +	else
> +		log_err("%s: engine (%s) lacks fetch ruhs.\n",
> +			f->file_name, td->io_ops->name);
> +	if (ret < 0) {
> +		td_verror(td, errno, "fdp fetch ruhs failed");
> +		log_err("%s: fdp fetch ruhs failed (%d).\n",
> +			f->file_name, errno);

Nit: for the !td->io_ops->fdp_fetch_ruhs case, this error message will also be
displayed. You could reverse the earlier if and return earlier to avoid that and
make the error messages clearer. Not a big deal though :)

> +	}
> +
> +	return ret;
> +}
> +
> +static int init_ruh_info(struct thread_data *td, struct fio_file *f)
> +{
> +	struct fio_ruhs_info *ruhs, *tmp;
> +	int i, ret;
> +
> +	ruhs = calloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
> +	if (!ruhs)
> +		return -ENOMEM;
> +
> +	ret = fdp_ruh_info(td, f, ruhs);
> +	if (ret) {
> +		log_info("fio: ruh info failed for %s (%d).\n",
> +			 f->file_name, -ret);
> +		goto out;
> +	}
> +
> +	if (ruhs->nr_ruhs > 128)
> +		ruhs->nr_ruhs = 128;
> +
> +	if (td->o.fdp_nrpli == 0) {
> +		f->ruhs_info = ruhs;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < td->o.fdp_nrpli; i++) {
> +		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	tmp = calloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));

Nit: since you checked the calloc above, you could check this one too.

> +	tmp->nr_ruhs = td->o.fdp_nrpli;
> +	for (i = 0; i < td->o.fdp_nrpli; i++)
> +		tmp->plis[i] = ruhs->plis[td->o.fdp_plis[i]];
> +	f->ruhs_info = tmp;
> +out:
> +	free(ruhs);
> +	return ret;
> +}

Apart from these 2 nits, looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

