Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDB3C433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374A1611AD
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243109AbhKIGPQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:15:16 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10528 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbhKIGPQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:15:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636438350; x=1667974350;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RKn7HTvj/55aw9QkhyfeY0spy5AJNej1zGG0hbS8TlY=;
  b=HmE+PaDpo/y/b7ObjwXhHPqfmf5zzYBtT/8lHmUoCXwtbJgRRk6moTSk
   aiNmsmsd9no4aWfGN3SgF+a5/rbsIVoKOrXptiB/Fq4xSEKFenFEr1Aau
   2jfMUQvm+bb6STIGi/LSrHPKGMbgbxz/vC2xJ2P51rYmpAdnhtzvmfhjN
   GRCzEgy/MSBPBJnxcIjW/zoyrwlxfH2TuWDq5vcGtvwWffpXpoUWNxvIk
   CH1dDIhGreGfTrAjrL7a7oqOVA7W2+qUTOfP2Up3saVbZ6VxMgFsDdEt5
   riNbpslvk+7wQwpXeopBwTN4hFLBlMDTN3WHXEwJNcSbz9LVRzIj9grOw
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="184094525"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:12:29 +0800
IronPort-SDR: pYXp35/vKCzPQ9PwmT4OLJKQIZyvU2dTQAI7Og8habnJqkhYizJUb+qC/iRZwlGa9xzHrVDa36
 ChEI/jEEcsIWwY7Oq7PIHDkh3qwXd0IL0iDDHJnZksZZ796eKGYH+sCaD2mt9ndxV5dhr1p7Z3
 uMoNZ5Z/WhUGFRg5z5vdUaC0Q4sjYu4xQMA6STKDhS11Fl3APJwtZIQcYA6WkQXWFKDGa6XOtE
 o0UF85K5/LIguIZ0AsU3nNv6ZVpuNygFtvLkgZh0kyRw2m+ub01CUaei2EiThxYkQ1bfTdHHWh
 SoX/QnDAwJa3n9boWeN/q7BW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:46:09 -0800
IronPort-SDR: CVk1txWbUqmlTTYOB37GV+eU4DFtPMS+xyMlUrl13TW8ck3EJTBXoseOAA8iqSTqBJu5Mxzp3T
 zAZDuUzXkPC5HzgwbS6hEU/UgIbe1K9gHdyoPwt2G0SnsyaabfFvB46T6qcvTyLK3CYgY88Yr/
 cx4bNP2bd2/qBFOFzpIK4EbHe9LEFgnrHaC1pNEEEOHj5tlKYoRHVmddEIXnUY9giR9ylhLTGC
 ZsWv08PXLi8VJT7z4NOrnsk1id94fZDI2obOUjQ94a26KkkJGgCK/rLfHIvEA2Ni5/5CxWLpu8
 Tl0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:12:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpHhF2Wp1z1RtVm
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:12:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636438348; x=1639030349; bh=RKn7HTvj/55aw9QkhyfeY0spy5AJNej1zGG
        0hbS8TlY=; b=G9le/LaUz02C+SUNBY9z9hQvg9mTSE087s6FNypbDmaBGYbsTEt
        t31LIduqvHqoltk33yzxNcsyNlXakQCj8U2T9wTMlp9nbo+YtGUu0wwXgMR40px5
        Oh198dJitgKrIJPeLspQhhI0kn1u4Dws0gwDPPBQb9olajG6fTYej78KIGbYD7Ag
        cE+RwbdtbxxPTZ6elB7tBU16ZbJbR3wvQ1xK48iyNgbPlufQwyGA2x8xwFw/ERev
        Y6jTh4QyV3xX9OMLI3ZXOoYijWIRX3JiBNNt9/6gdzjQ6cBnBbtZV0MjCa2apxrF
        v7d3Yt5oFWVyDX6H6aF0V+n1XMPBAz5azEg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QGwx0gIxlYTS for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:12:28 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpHhD3Cgyz1RtVl;
        Mon,  8 Nov 2021 22:12:28 -0800 (PST)
Message-ID: <466f5348-a92b-5d09-69b3-529be2c643d9@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:12:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 3/8] cmdprio: do not allocate memory for unused data
 direction
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-4-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-4-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> All cmdprio options only support data directions read and write.
> However, each cmdprio option allocates memory for ddir trim as well,
> even though nothing is ever written to this memory.
> 
> Change this so that we don't allocate memory for something which is
> never used.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  engines/cmdprio.c |  4 ++--
>  engines/cmdprio.h | 13 ++++++++-----
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index f5b7342f..2c764e49 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -56,7 +56,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
>  
>  	if (parse_dryrun()) {
> -		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +		for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
>  			free(cmdprio->bssplit[i]);
>  			cmdprio->bssplit[i] = NULL;
>  			cmdprio->bssplit_nr[i] = 0;
> @@ -101,7 +101,7 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
>  	 * is not set, default to RT priority class.
>  	 */
> -	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
>  		if (cmdprio->percentage[i]) {
>  			if (!cmdprio->class[i])
>  				cmdprio->class[i] = IOPRIO_CLASS_RT;
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 33a8f5b9..d3265741 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -8,12 +8,15 @@
>  
>  #include "../fio.h"
>  
> +/* read and writes only, no trim */
> +#define CMDPRIO_RWDIR_CNT 2
> +
>  struct cmdprio {
> -	unsigned int percentage[DDIR_RWDIR_CNT];
> -	unsigned int class[DDIR_RWDIR_CNT];
> -	unsigned int level[DDIR_RWDIR_CNT];
> -	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
> -	struct bssplit *bssplit[DDIR_RWDIR_CNT];
> +	unsigned int percentage[CMDPRIO_RWDIR_CNT];
> +	unsigned int class[CMDPRIO_RWDIR_CNT];
> +	unsigned int level[CMDPRIO_RWDIR_CNT];
> +	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
> +	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
>  };
>  
>  int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> 


-- 
Damien Le Moal
Western Digital Research
