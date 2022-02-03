Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475E4C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348732AbiBCBoj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:44:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21493 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiBCBoi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643852679; x=1675388679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B5v1KE+z24jkXHRhLL0JV57Of3VJvpXfbl25umFldjE=;
  b=dH+9K/sNgpv7KOD1+E0lhwMRJ8k++oxjjeO3dqaD5xNn/mS4kKPtZZVw
   cR70fXv0w12+fgkG3oU/E4geb4iF+tBGZY/dv2IKdt/UrdLcfazXk68fT
   h2iOdb9AGgdOjaH2tSh+/2O9OtrJbwt6eM3YWb3Ct5GDPzQG6m/lXRZAB
   SYjewXRmTtcbIh1AhrkzGLFwM5+Vc92lHJh1aQDPoGuKuyQZtNRcU23qN
   9IRgnhhkg1Pb3o5VnEyWgNln+qvv4tGmwPvQMSLutLWv49yFpt7kghzUZ
   Tjm0f8QnShW/pjttoa4eoIeTZSbOdFj8FbEboqzbt7Exi15+i/6MqEyfp
   A==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="193017208"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:44:39 +0800
IronPort-SDR: cUgi0wRQSMF+Ly88yRb2v/yhpFBKhpI+SQLdp6qzQws49ENrNJy0LB2f9UrV42Rk9m+6/lTbpV
 WrRIz4shUWGvrKfRjQykE9S2a8/0uO0J79bbffGuq2SzXTQS201sbwM8EefTPyBHf+vmropV0t
 /z5Z79nLKV6K7ns2sdUaNaTMQJrkar7FgZNAlN0a9ovaGJUcF1AQLdY/OJpFjYHt37pml/5AJh
 304r14NLRNW+LEoM2UxteGRnm/qYIC9YQyA6mWo8Nvsp5t+itaWxqXJ/Cymkw7d9LZEfSdozVJ
 MussBWXp/7uxTkdGv0xYdzuz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:17:47 -0800
IronPort-SDR: 5KU7JPzIc30L2/Fezk3JmSt2vMOPhO9Rfx5jCPpjAlByfrokfweXm/2EkfIIjtyGdBt0AAbaNs
 SEdKoIDXWP0DBRoU84vBAEjAV2uHCB5lEdW0zvvHJ1tYHhgcrpfEqycAgfAIHqEwFL+F9JXahl
 tnjTWkWnoo+qLeqZWj95KcxrO+dlTMJtOIumOGto6PKYq4hZPnip8xLVUDtw+aFEqR3wjkDryJ
 h+7CsOnIUFNo0b/uwGbPbg7VGY7Sy79zyo7RDIXASJqaIBpM+TzkqUL4J+fcYyGHSJYJX8xdpO
 fZA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:44:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1gV2hSqz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:44:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643852677; x=1646444678; bh=B5v1KE+z24jkXHRhLL0JV57Of3VJvpXfbl2
        5umFldjE=; b=Hu9ShQcNm2X/KSLU9VrjVAjxEPXb+KZwd6OQB1drLtzdR/UMQcZ
        iD3hJrfyuUy7YX7gu4BxL7R4rA4WZC5mtX8LEvv9Urt5oXUbcri67vtmKvR3ZyZ6
        ciECuu2T6/EGGRx2PUIEVN1VwLSJsiqgIzC9M6XlEV0v90z8YM/RQkmN/G4XfDfl
        msdNtMmyOS2P9t+M2N+if9neZyQFWH3FcVQ6NrwlZuFLH0IVlxxQoLbD5KTqLkye
        EoaEg1X9+Ll67pzlvKmhGd45zdy0MS5Ix0fdqu/k4J4GXlEojONYEYH0z5EiNXdM
        YqjtZoWzA46NyrHWy+B5H2dINTdWcXF1BNg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id k58cZkE5LxBG for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:44:37 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1gT3ZGTz1Rwrw;
        Wed,  2 Feb 2022 17:44:37 -0800 (PST)
Message-ID: <474faac3-ef2a-79db-98d8-764c269a6d6d@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:44:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 15/17] gfio: drop support for high/low priority latency
 results
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-16-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-16-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> High/low priority latencies have been replaced by a per prio array.
> This allows us to have latency results for more than just two priorities.
> 
> Unfortunately this currently means that we have to drop the support for
> visualizing the high/low priority latencies.
> 
> If someone wants to know the per prio latency results, both the regular
> output and the json output contain this information.
> 
> The GUI could be extended to support the new per priority format at a
> later time, if anyone has a huge need for this feature.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  gclient.c | 55 ++++---------------------------------------------------
>  1 file changed, 4 insertions(+), 51 deletions(-)
> 
> diff --git a/gclient.c b/gclient.c
> index ac063536..c59bcfe2 100644
> --- a/gclient.c
> +++ b/gclient.c
> @@ -1155,21 +1155,18 @@ out:
>  #define GFIO_CLAT	1
>  #define GFIO_SLAT	2
>  #define GFIO_LAT	4
> -#define GFIO_HILAT	8
> -#define GFIO_LOLAT	16
>  
>  static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
>  				  struct group_run_stats *rs,
>  				  struct thread_stat *ts, int ddir)
>  {
>  	const char *ddir_label[3] = { "Read", "Write", "Trim" };
> -	const char *hilat, *lolat;
>  	GtkWidget *frame, *label, *box, *vbox, *main_vbox;
> -	unsigned long long min[5], max[5];
> +	unsigned long long min[3], max[3];
>  	unsigned long runt;
>  	unsigned long long bw, iops;
>  	unsigned int flags = 0;
> -	double mean[5], dev[5];
> +	double mean[3], dev[3];
>  	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
>  	char tmp[128];
>  	int i2p;
> @@ -1268,14 +1265,6 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
>  		flags |= GFIO_CLAT;
>  	if (calc_lat(&ts->lat_stat[ddir], &min[2], &max[2], &mean[2], &dev[2]))
>  		flags |= GFIO_LAT;
> -	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min[3], &max[3], &mean[3], &dev[3])) {
> -		flags |= GFIO_HILAT;
> -		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min[4], &max[4], &mean[4], &dev[4]))
> -			flags |= GFIO_LOLAT;
> -		/* we only want to print low priority statistics if other IOs were
> -		 * submitted with the priority bit set
> -		 */
> -	}
>  
>  	if (flags) {
>  		frame = gtk_frame_new("Latency");
> @@ -1284,24 +1273,12 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
>  		vbox = gtk_vbox_new(FALSE, 3);
>  		gtk_container_add(GTK_CONTAINER(frame), vbox);
>  
> -		if (ts->lat_percentiles) {
> -			hilat = "High priority total latency";
> -			lolat = "Low priority total latency";
> -		} else {
> -			hilat = "High priority completion latency";
> -			lolat = "Low priority completion latency";
> -		}
> -
>  		if (flags & GFIO_SLAT)
>  			gfio_show_lat(vbox, "Submission latency", min[0], max[0], mean[0], dev[0]);
>  		if (flags & GFIO_CLAT)
>  			gfio_show_lat(vbox, "Completion latency", min[1], max[1], mean[1], dev[1]);
>  		if (flags & GFIO_LAT)
>  			gfio_show_lat(vbox, "Total latency", min[2], max[2], mean[2], dev[2]);
> -		if (flags & GFIO_HILAT)
> -			gfio_show_lat(vbox, hilat, min[3], max[3], mean[3], dev[3]);
> -		if (flags & GFIO_LOLAT)
> -			gfio_show_lat(vbox, lolat, min[4], max[4], mean[4], dev[4]);
>  	}
>  
>  	if (ts->slat_percentiles && flags & GFIO_SLAT)
> @@ -1309,40 +1286,16 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
>  				ts->io_u_plat[FIO_SLAT][ddir],
>  				ts->slat_stat[ddir].samples,
>  				"Submission");
> -	if (ts->clat_percentiles && flags & GFIO_CLAT) {
> +	if (ts->clat_percentiles && flags & GFIO_CLAT)
>  		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
>  				ts->io_u_plat[FIO_CLAT][ddir],
>  				ts->clat_stat[ddir].samples,
>  				"Completion");
> -		if (!ts->lat_percentiles) {
> -			if (flags & GFIO_HILAT)
> -				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
> -						ts->io_u_plat_high_prio[ddir],
> -						ts->clat_high_prio_stat[ddir].samples,
> -						"High priority completion");
> -			if (flags & GFIO_LOLAT)
> -				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
> -						ts->io_u_plat_low_prio[ddir],
> -						ts->clat_low_prio_stat[ddir].samples,
> -						"Low priority completion");
> -		}
> -	}
> -	if (ts->lat_percentiles && flags & GFIO_LAT) {
> +	if (ts->lat_percentiles && flags & GFIO_LAT)
>  		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
>  				ts->io_u_plat[FIO_LAT][ddir],
>  				ts->lat_stat[ddir].samples,
>  				"Total");
> -		if (flags & GFIO_HILAT)
> -			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
> -					ts->io_u_plat_high_prio[ddir],
> -					ts->clat_high_prio_stat[ddir].samples,
> -					"High priority total");
> -		if (flags & GFIO_LOLAT)
> -			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
> -					ts->io_u_plat_low_prio[ddir],
> -					ts->clat_low_prio_stat[ddir].samples,
> -					"Low priority total");
> -	}
>  
>  	free(io_p);
>  	free(bw_p);

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
