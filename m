Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796FAC05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 00:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjBIA7H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 19:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBIA7G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 19:59:06 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F754222FF
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 16:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675904344; x=1707440344;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A42w5t/i72bKqSfoolTH30bNRUBtmqEtrsUIv95oR/0=;
  b=OGCjKazFNe1gFmoaa6auNxh3HedR0hRlENdxjB5VuVIHsu6VFfHfyQnb
   VHReQ3HpL79dhe5udsAEolUupCVsLzqturfziNg8DnScZEDBBGgcaJH8S
   4acqJpKVAlLarjyXRABgg09V2DDgD5bvrltHg0/Gr1Q9qipBaoIxG5nZS
   Txpqy/VAQ4Mtv2i019b6ykQjUdBjKqBXDWhDAq22tSYUyZbXcqLZXaPG6
   RxqiKAgj9d9UeUyr1HbK2e77iFleCiMNQghsUS3Hg1ik8BZyAJIl5cabs
   4TvILduvvumk2HDNzoYoRZiXQlu8l1n7iLgJFl62jgaf51QEbRpZKuubH
   w==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="222655530"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 08:59:03 +0800
IronPort-SDR: k7i3LYF2ziI3mgLtTBSAsJuGyK7oKtGOr6udnWFV9BPumTrnBpAL26jqAk1G0GBWghc0NfMQ2K
 RweLzQYl4pC0EIWTVpsN2IqmgD156DVAfIKFYJUhgAEDN0Fvybrt23Watfswg/p0e+pZSdIZE1
 SNBMfhiTqFl+IFaY3aktTr4uCsyAJaSgGm7FhWlzpglFC7QD1FPLM4YL8o4/TouGxhQDUEDqQl
 OlLobTYIupz8pu9d+9dFgcCUOHUNdGbpAdFCfomX4xhwG/TKvPU4zvxtSQXrdKyEBcwplcpBLW
 clk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 16:10:34 -0800
IronPort-SDR: gPY4GdAVi6JNf0eZ/6+GM627Jt4vawdY/HRIhDBUkdCpWZMNiWlwEBQaX0id1TLkfSqhJNJUbH
 ctEexbTxEBrCg5Cxd4Y9/80FgyiYf++IdEMWFo2oibokzi7VpABcvUZT4VBlTCCkIlTrF37szX
 9AxB0xDm+u9dEcVjT6bvhSEgz38rIfefXuOezBlXI1KtxglIva7YvxabpkXA8TaNXDKYGgUiYe
 I1+u3yN87+crGmcMzMPvZ1dBltQSEKAUWcPyZX/eMzE1foV1mWL+jiv0sZTul4W/eqwsiDgbuo
 AHc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 16:59:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PBz5g59XWz1RvTr
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 16:59:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1675904342; x=1678496343; bh=A42w5t/i72bKqSfoolTH30bNRUBtmqEtrsU
        Iv95oR/0=; b=MOtkaiIgh7/RdQ9ukzJ3tad7qfNz0QSRdF4VhxmkdCEjON85Ouu
        hWCTUMJv4j6OtUvCYPetNKulk6KdpuRuzpfmPRiTHlnk4CCVn2YUX7N442l40DTq
        gu6xrH21n/FZXxupUjoZp9uCGUE+FWtbNUJQqv3xPbERDncLnCHJrWQkvQW78ZiC
        aNxzg67N434pdbmOcO7/z/5cbArrwLjXVDXCcagIaEQbqn8rF59hJczqrE+EK+tt
        LUuZIWBwPZZHDzu00TzyIuuSNFe+5eV/iq63NRyr9I2CmplvmL25kIB6FbriEXpT
        JQsb984PDIoJVxE2nbABtH7du1eppqG/ocw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rlundgPGKrlx for <fio@vger.kernel.org>;
        Wed,  8 Feb 2023 16:59:02 -0800 (PST)
Received: from [10.225.163.102] (unknown [10.225.163.102])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PBz5d6bGTz1RvLy;
        Wed,  8 Feb 2023 16:59:01 -0800 (PST)
Message-ID: <29a27af4-f74a-5e80-f1f0-41fcd4fb6d4f@opensource.wdc.com>
Date:   Thu, 9 Feb 2023 09:59:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230208222023.895024-1-kbusch@meta.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230208222023.895024-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 07:20, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> NVMe TP4146 creates a new feature called Flexible Data Placement. This
> feature allows a host to tell the device how to group write data through
> the use of "Placement Identifiers" in write commands.
> 
> Add support for using placement identifiers in write commands. The user
> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
> ioengine. By default, the fio jobs will cycle through all the namespace's
> available placement identifiers for write commands. The user can limit
> which placement identifiers can be used with additional parameter,
> "fdp_plis=<list,>", which can be used to separate write intensive jobs
> from less intenstive ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

[...]

> +static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
> +                                 struct fio_ruhs_info *fruhs_info)
> +{
> +	struct nvme_fdp_ruh_status *ruhs;
> +	int bytes, ret, i;
> +
> +	bytes = sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc);
> +	ruhs = malloc(bytes);

if malloc() fails here (rare case), I expect that fio_nvme_iomgmt_ruhs()
will fail but the above memset() will crash the process. So maybe add a
"if (ruhs)" before it to gracefully fail ?

> +	memset(ruhs, 0, bytes);
> +
> +	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
> +	if (ret)
> +		goto free;
> +
> +        fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
> +        for (i = 0; i < fruhs_info->nr_ruhs; i++)
> +                fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
> +free:
> +	free(ruhs);
> +	return ret;
> +}

[...]

> diff --git a/file.h b/file.h
> index da1b8947..deb36e02 100644
> --- a/file.h
> +++ b/file.h
> @@ -12,6 +12,7 @@
>  
>  /* Forward declarations */
>  struct zoned_block_device_info;
> +struct fdp_ruh_info;
>  
>  /*
>   * The type of object we are working on
> @@ -101,6 +102,8 @@ struct fio_file {
>  	uint64_t file_offset;
>  	uint64_t io_size;
>  
> +	struct fio_ruhs_info *ruhs_info;

white line before declaration can be removed I think.

[...]

> diff --git a/io_u.h b/io_u.h
> index 206e24fe..13b26d37 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -117,6 +117,9 @@ struct io_u {
>  	 */
>  	int (*end_io)(struct thread_data *, struct io_u **);
>  
> +	uint32_t dtype;
> +	uint32_t dspec;

Nit: may be call these fdp_dtype and fdp_dspec to clarify these are for fdp ?


> diff --git a/ioengines.h b/ioengines.h
> index 2cb9743e..4a9284c0 100644
> --- a/ioengines.h
> +++ b/ioengines.h
> @@ -7,6 +7,7 @@
>  #include "flist.h"
>  #include "io_u.h"
>  #include "zbd_types.h"
> +#include "fdp.h"
>  
>  #define FIO_IOOPS_VERSION	31

Shouldn't this be increased given that you are changing the ioengine_ops
structure ?

> @@ -63,6 +64,9 @@ struct ioengine_ops {
>  				  unsigned int *);
>  	int (*finish_zone)(struct thread_data *, struct fio_file *,
>  			   uint64_t, uint64_t);
> +        int (*fdp_support)(struct thread_data *, struct fio_file *, bool *);
> +        int (*fetch_ruhs)(struct thread_data *, struct fio_file *,
> +                          struct fio_ruhs_info *);
>  	int option_struct_size;
>  	struct fio_option *options;
>  };

[...]

> diff --git a/thread_options.h b/thread_options.h
> index 74e7ea45..34eb4d3f 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -386,6 +386,12 @@ struct thread_options {
>  	fio_fp64_t zrt;
>  	fio_fp64_t zrf;
>  
> +	unsigned int fdp;
> +
> +#define FIO_MAX_PLIS 16
> +	unsigned int plis[FIO_MAX_PLIS];
> +	unsigned int nrpli;
> +

Nit: FDP_/fdp_ prefix for these too to clarify the usage ?

>  	unsigned int log_entries;
>  	unsigned int log_prio;
>  };
> @@ -698,6 +704,8 @@ struct thread_options_pack {
>  	uint32_t log_entries;
>  	uint32_t log_prio;
>  
> +	uint32_t fdp;
> +
>  	/*
>  	 * verify_pattern followed by buffer_pattern from the unpacked struct
>  	 */

-- 
Damien Le Moal
Western Digital Research

