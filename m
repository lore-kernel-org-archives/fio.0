Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80449C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiBCBJ7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:09:59 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6613 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348647AbiBCBJ7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643850599; x=1675386599;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WF+Jt3jEnFPJcGoRPHDW9Basc2a+5mj/hl1vaWn96ZA=;
  b=UKHfD8khfVpps9fZMQYGAIDNDNNpFHvp13DJByc4ayNX7fvEAtjR+Ye3
   WpcprAYPxsI9nVC1/zI7IQl3+6VKaSXWv20dkpOCCMcr1ev+EojaXh1CX
   MFSgHi79241m0eEDVv3jqnpT3tUxkEWINYE1VSH8NVlOVJDOvly4FsSSL
   QdYVjWZ8mbD2z+sp1e+FzUzOTPZ8uLb6bBRrtiYyarUw9WbrJwf9+SUMT
   ho8XKt8k/m47RDRBbA680SJjk2/7XKwL/xkRKr7Z1za0vTc/D208zrVxR
   uXwryfhPLnvwA57qb0033eZShDL1RKXpzNadyB+Y9omiLd4YVa9M3z6DE
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="190971172"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 08:52:40 +0800
IronPort-SDR: WBmwJsEpnEi6w/BCXkylBDKA1xO+g7TlfRgOTcrFSn5jM3bIm5oz6pvTHdNEBOlHXV54Ime5sp
 xBnBvn5OG1RTpkqyA7N488SZnOCBwOiM6yP/nGfI760XtcYGkshdoFxaIwUWIoHEY/k0HyEU78
 iF4IfrNTl12zP8C5r5K2EO54pGZ2cV61SD0Vt7eBZ4OOmdlwwI/irXX2o/2g7iUtzGpbKeTzoY
 70KEaHQ7hy+sBH3RWSeRDxIO6d1wkTriX+slQr0q/wiMKI4wqqvoXSJPwf42Zwwj/nAM2faMUa
 3sD3KPL4ZHy/VeojA8kyf6oR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:25:49 -0800
IronPort-SDR: 0fbnx6mV3CYFTa6PLfBT6puTXtKym8G6dWK+XBjOf7VYE5eDc549lEjtDIk8O+2Mz+13N0hBf6
 EqbxBZ3xdEEM5X1PdJyvTbS/E9hbHZ5s9EddwEgWIoouUKGuH6uYWxMiV/Eo6cKrEAhbmcwFps
 IE1bdOoL5faA809QHMK5mGYHReg68+M1lpy7SSeoFy72pALVkQQT9vI5xnXeUEawn2VAibbyEj
 qnKTyvA0mB8uIA+8jR9LDPhMq627S+R6YZK5rySgwpV8+hvylOsm6u2TaW0UBeDcmTZI5lu1Pz
 u28=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:52:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0WX0NHRz1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 16:52:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643849559; x=1646441560; bh=WF+Jt3jEnFPJcGoRPHDW9Basc2a+5mj/hl1
        vaWn96ZA=; b=myjn/qz6pU71z37PcLGGp46LSoSl5h+ucs1NcLSbi5RZ5C/C7GJ
        So2ccU0t3CCnUYaFH2f0uDU6/6e63dg9BIkjHHPIgGLEJk/uPGQzxVqqWYRzcFWh
        cNWeZQ+y7ZHGkrjCsgIF9cLiUrw05vvpIG7k8MF7rfr2dLogJUnqfAbst81siCxo
        k1sy3zmzKJk30oKz2lElcPhC7dcH+8gL+IdFLpANkz+CU20uomoznZhNbNcKj9G6
        W0TEaRDcaMxBrMBtQO496WGob0HTPUgKbzxMSCCoK0FF/EhVrQzXNcTNhCe4wKOi
        UttiVij3MRg2e4icm6KC7oSF6A+wbkQzDMg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ve0-4w2AYFfq for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 16:52:39 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0WW08BRz1Rwrw;
        Wed,  2 Feb 2022 16:52:38 -0800 (PST)
Message-ID: <dbfbe83c-137f-3c9c-433d-35ab16fea80c@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 09:52:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 04/17] client/server: convert ss_data to use an offset
 instead of fixed position
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-5-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-5-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Store the location of the ss_data in the payload itself, rather than
> assuming that it is always located at a fixed location, directly after
> the cmd_ts_pdu data.
> 
> This is done as a cleanup patch in order to be able to handle
> clat_prio_stats, which just like ss_data, may or may not be part of the
> payload.
> 
> Server version is intentionally not incremented, as it will be incremented
> in a later patch in the series. No need to bump it twice for the same patch
> series.

This comment should be added to the previous patch commit message too
(as it added the ioprio field to the stats).

> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  client.c | 10 ++++++----
>  server.c | 59 ++++++++++++++++++++++++++++++++++++++++++--------------
>  stat.h   | 14 ++++++++++++--
>  3 files changed, 62 insertions(+), 21 deletions(-)
> 
> diff --git a/client.c b/client.c
> index 381af054..e51138ee 100644
> --- a/client.c
> +++ b/client.c
> @@ -1761,7 +1761,6 @@ int fio_handle_client(struct fio_client *client)
>  {
>  	struct client_ops *ops = client->ops;
>  	struct fio_net_cmd *cmd;
> -	int size;
>  
>  	dprint(FD_NET, "client: handle %s\n", client->hostname);
>  
> @@ -1795,14 +1794,17 @@ int fio_handle_client(struct fio_client *client)
>  		}
>  	case FIO_NET_CMD_TS: {
>  		struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
> +		uint64_t offset;
>  
>  		dprint(FD_NET, "client: ts->ss_state = %u\n", (unsigned int) le32_to_cpu(p->ts.ss_state));
>  		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
>  			dprint(FD_NET, "client: received steadystate ring buffers\n");
>  
> -			size = le64_to_cpu(p->ts.ss_dur);
> -			p->ts.ss_iops_data = (uint64_t *) ((struct cmd_ts_pdu *)cmd->payload + 1);
> -			p->ts.ss_bw_data = p->ts.ss_iops_data + size;
> +			offset = le64_to_cpu(p->ts.ss_iops_data_offset);
> +			p->ts.ss_iops_data = (uint64_t *)((char *)p + offset);
> +
> +			offset = le64_to_cpu(p->ts.ss_bw_data_offset);
> +			p->ts.ss_bw_data = (uint64_t *)((char *)p + offset);
>  		}
>  
>  		convert_ts(&p->ts, &p->ts);
> diff --git a/server.c b/server.c
> index af94cd78..4ddf682b 100644
> --- a/server.c
> +++ b/server.c
> @@ -1465,8 +1465,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  {
>  	struct cmd_ts_pdu p;
>  	int i, j, k;
> -	void *ss_buf;
> -	uint64_t *ss_iops, *ss_bw;
> +	size_t ss_extra_size = 0;
> +	size_t extended_buf_size = 0;
> +	void *extended_buf;
> +	void *extended_buf_wp;
>  
>  	dprint(FD_NET, "server sending end stats\n");
>  
> @@ -1590,26 +1592,53 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  	convert_gs(&p.rs, rs);
>  
>  	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
> -	if (ts->ss_state & FIO_SS_DATA) {
> -		dprint(FD_NET, "server sending steadystate ring buffers\n");
> +	if (ts->ss_state & FIO_SS_DATA)
> +		ss_extra_size = 2 * ts->ss_dur * sizeof(uint64_t);
>  
> -		ss_buf = malloc(sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t));
> +	extended_buf_size += ss_extra_size;
> +	if (!extended_buf_size) {
> +		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
> +		return;
> +	}
>  
> -		memcpy(ss_buf, &p, sizeof(p));
> +	extended_buf_size += sizeof(p);
> +	extended_buf = calloc(1, extended_buf_size);
> +	if (!extended_buf) {
> +		log_err("fio: failed to alloc FIO_NET_CMD_TS buffer\n");

nit: s/alloc/allocate
Let's write proper English :)

> +		return;
> +	}
> +
> +	memcpy(extended_buf, &p, sizeof(p));
> +	extended_buf_wp = (struct cmd_ts_pdu *)extended_buf + 1;
>  
> -		ss_iops = (uint64_t *) ((struct cmd_ts_pdu *)ss_buf + 1);
> -		ss_bw = ss_iops + (int) ts->ss_dur;
> -		for (i = 0; i < ts->ss_dur; i++) {
> +	if (ss_extra_size) {
> +		uint64_t *ss_iops, *ss_bw;
> +		uint64_t offset;
> +		struct cmd_ts_pdu *ptr = extended_buf;
> +
> +		dprint(FD_NET, "server sending steadystate ring buffers\n");
> +
> +		/* ss iops */
> +		ss_iops = (uint64_t *) extended_buf_wp;
> +		for (i = 0; i < ts->ss_dur; i++)
>  			ss_iops[i] = cpu_to_le64(ts->ss_iops_data[i]);
> -			ss_bw[i] = cpu_to_le64(ts->ss_bw_data[i]);
> -		}
>  
> -		fio_net_queue_cmd(FIO_NET_CMD_TS, ss_buf, sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t), NULL, SK_F_COPY);
> +		offset = (char *)extended_buf_wp - (char *)extended_buf;
> +		ptr->ts.ss_iops_data_offset = cpu_to_le64(offset);
> +		extended_buf_wp = ss_iops + (int) ts->ss_dur;
> +
> +		/* ss bw */
> +		ss_bw = extended_buf_wp;
> +		for (i = 0; i < ts->ss_dur; i++)
> +			ss_bw[i] = cpu_to_le64(ts->ss_bw_data[i]);
>  
> -		free(ss_buf);
> +		offset = (char *)extended_buf_wp - (char *)extended_buf;
> +		ptr->ts.ss_bw_data_offset = cpu_to_le64(offset);
> +		extended_buf_wp = ss_bw + (int) ts->ss_dur;
>  	}
> -	else
> -		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
> +
> +	fio_net_queue_cmd(FIO_NET_CMD_TS, extended_buf, extended_buf_size, NULL, SK_F_COPY);
> +	free(extended_buf);
>  }
>  
>  void fio_server_send_gs(struct group_run_stats *rs)
> diff --git a/stat.h b/stat.h
> index 3ce821a7..711df24a 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -262,12 +262,22 @@ struct thread_stat {
>  
>  	union {
>  		uint64_t *ss_iops_data;
> -		uint64_t pad4;
> +		/*
> +		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
> +		 * be stored at this offset from the start of the payload.
> +		 * (The union is also needed to pad this field on 32-bit.)
> +		 */
> +		uint64_t ss_iops_data_offset;

Nit: May be keep the pad4 field last ?

>  	};
>  
>  	union {
>  		uint64_t *ss_bw_data;
> -		uint64_t pad5;
> +		/*
> +		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
> +		 * be stored at this offset from the start of the payload.
> +		 * (The union is also needed to pad this field on 32-bit.)
> +		 */
> +		uint64_t ss_bw_data_offset;

Same.

>  	};
>  
>  	uint64_t cachehit;

Apart from the above nits, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
