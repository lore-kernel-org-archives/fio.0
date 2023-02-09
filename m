Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C24C636CC
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 01:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjBIBAZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 20:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjBIBAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 20:00:21 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720FB23320
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 17:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675904417; x=1707440417;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=hDLyWv66PkvwHV4SSDoHT7Ux9WYP6lqlzaV7wVpNxAw=;
  b=q/Iyrj7pGHRxIYV7zNsq4Q1PFtYra41Ii0kToaRBHMfoBbzz+F4jgo6K
   9XoIJ9iRQITOLsIUeRPnP7q0avbO1vLTXdbFldQfnLsill1FTuBV38YfS
   L26PqLlSDXjZEvd+pAQjxTsH1xOOjPVDx5sra54ZUsYW5yp6AvZN0xwR0
   2OfjbzZWfkfDP//AWft5V8lCr8sV/HZiYiLYSKLbmhKB4nRaeaIXyQzZs
   Y2zO+DJOOCGY2ltxvi4zGn4MRJmAEWNtd3yXmRDMPYzBcZNSNDqLBgnL/
   /U1zdB6uAcbn1PFF0HbMzQ172XtlF27ShuBJVZxqG2Qhi7Aq38qVuQGF/
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="221169305"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 09:00:16 +0800
IronPort-SDR: pORpQyl0RqGauybKt4+s47bUSnlppiQNNE07grvZ59zLbtoI0sRdNOBimfEOo6xmIfUbXoFKvB
 FFAJ4KA5KrlAAt9rqBo0SdRPfltkR56qnL1f5CP54B+QkF+RKqqQns3MDglQpIonvEtZJFkyca
 4vDa7y06wCURgOAz9L8z3en4MkJe4xjAAuYEmW756UdSmLTCNLM5hzqrXLETJyR7zv3WUDkhNC
 JFyvMfB3D27iDF1IT/GUC6d/HxCOXoHhhGlCOpM9MxGw8P0bCCgQDKPr2QFu4D7SzLdzihQAN2
 ahA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 16:11:46 -0800
IronPort-SDR: sHq3rUeAU2KyB7Q6eReVECJmfWQXkVMt1+m2bN8u27CBI7g2Bxmn38an/lvVpRK1shMNB5Bd9f
 2bOcT62x93IFK24Cp4+2VHxRW9vz4q6Yj2RzGbvjpyFUJmcgsKNZdRj6EK5TC+zmAkh5F9chbu
 hD7/F+n0flIevfRzb637Ar/deSFkOIQmBe8i/nyHZpHtvULlZd6wCR3L4Y7mOUT0aAVqANJHuE
 UAqNZF2g5K5FvSz6zMGGhVKjBJSg9oEm9byljtMmbiYG8etEH35ejMo/YLB1qaoZY6L/PkRupV
 GmU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 17:00:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PBz74323hz1Rwrq
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 17:00:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1675904415; x=1678496416; bh=hDLyWv66PkvwHV4SSDoHT7Ux9WYP6lqlzaV
        7wVpNxAw=; b=W5ypeBFqRuGdmwF4+J62A2MzkViZadgLe8wPz79KUbqDWxrp9hj
        eCDlZdQbTUgL5z4vfzb0+oYlBuIblITWEaQf1zwZFCrREmKfIcQgVxdw6in7HCCc
        1DeFH3XUvuzDophHlqFYI7BEYxdkU2h9ewcpUchzaNkQ/Jpa0qal+z5pwlILptKi
        6VFsgte5WGP6FxUoai2vfqyygZal8zFuHp4LUSguuIyArW8aXTU91341QQV82aDv
        L1asQSrvcIXtiCLot3+3i3+QeiketcZKItneuA28ZGnlRDzxtL0XA++rpQk+K/lG
        2ypk9/WKrFjF46QI3b/LfpssQlPHzEpGjRw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id naSZxkS4ruXG for <fio@vger.kernel.org>;
        Wed,  8 Feb 2023 17:00:15 -0800 (PST)
Received: from [10.225.163.102] (unknown [10.225.163.102])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PBz7256nzz1RvLy;
        Wed,  8 Feb 2023 17:00:14 -0800 (PST)
Message-ID: <572794b4-ebf2-bacb-55d9-4d13f6ec0514@opensource.wdc.com>
Date:   Thu, 9 Feb 2023 10:00:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230208222023.895024-1-kbusch@meta.com>
 <29a27af4-f74a-5e80-f1f0-41fcd4fb6d4f@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <29a27af4-f74a-5e80-f1f0-41fcd4fb6d4f@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 09:59, Damien Le Moal wrote:
> On 2/9/23 07:20, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> NVMe TP4146 creates a new feature called Flexible Data Placement. This
>> feature allows a host to tell the device how to group write data through
>> the use of "Placement Identifiers" in write commands.
>>
>> Add support for using placement identifiers in write commands. The user
>> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
>> ioengine. By default, the fio jobs will cycle through all the namespace's
>> available placement identifiers for write commands. The user can limit
>> which placement identifiers can be used with additional parameter,
>> "fdp_plis=<list,>", which can be used to separate write intensive jobs
>> from less intenstive ones.
>>
>> Setting up your namespace for FDP is outside the scope of 'fio', so this
>> assumes the namespace is already properly configured for the mode.
>>
>> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
>> Signed-off-by: Keith Busch <kbusch@kernel.org>
> 
> [...]

>> diff --git a/file.h b/file.h
>> index da1b8947..deb36e02 100644
>> --- a/file.h
>> +++ b/file.h
>> @@ -12,6 +12,7 @@
>>  
>>  /* Forward declarations */
>>  struct zoned_block_device_info;
>> +struct fdp_ruh_info;
>>  
>>  /*
>>   * The type of object we are working on
>> @@ -101,6 +102,8 @@ struct fio_file {
>>  	uint64_t file_offset;
>>  	uint64_t io_size;
>>  
>> +	struct fio_ruhs_info *ruhs_info;
> 
> white line before declaration can be removed I think.

My bad. This is not a function :)


-- 
Damien Le Moal
Western Digital Research

