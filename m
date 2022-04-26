Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047D2C433FE
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355508AbiDZVel (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355487AbiDZVei (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:34:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CE6255B9
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:31:26 -0700 (PDT)
Received: from [192.168.88.87] (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 020897E77D;
        Tue, 26 Apr 2022 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008685;
        bh=3LzE8C95PLV/+rKJ187lBXmNVk3IybQXyfystODe/Vg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KHAJ+4qa1ztY7Tfr8Tc7gu24FjIw6iy5oO7ygnHVBUm19dtVUuzJrfIRnAjl8ma8J
         feVo8oNkNIeKgBi12AkM9Grbp0oQEgz5Del3s9gfzB6EW/nxX2ysoqmXGeO8EJ99DS
         gKdhg9ivXwXLGpLjwXjnt2ORKKyHp8CCWgE77sMilsEQA2+A7LBqD1h0tLGv45b41e
         rkpHHcpCATepo6BSbxh7tFxNvQ247pw53byq6Njisc3vz/e7SZVRCkVf4MpLEOixL6
         52nyNTfhSuwnaDUmJTawGCEL2Zpetg+JiKf2atURP9Hz5C6/euvsNL7poVtagBMDP7
         yNakwLofneRZQ==
Message-ID: <d3814982-afc4-2688-a02b-44c3926c939b@gnuweeb.org>
Date:   Wed, 27 Apr 2022 04:31:12 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1 4/6] engines/net: Replace `malloc()`+`memset()` with
 `calloc()`
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
 <20220426212044.78898-5-ammarfaizi2@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220426212044.78898-5-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/22 4:20 AM, Ammar Faizi wrote:
> diff --git a/engines/net.c b/engines/net.c
> index c6cec584..8a898748 100644
> --- a/engines/net.c
> +++ b/engines/net.c
> @@ -1363,6 +1363,10 @@ static int fio_netio_setup(struct thread_data *td)
>   {
>   	struct netio_data *nd;
>   
> +	nd = calloc(1, sizeof(*nd));
> +	if (!nd)
> +		return 1;

This is also a wrong calloc() placement, will fix that in v2. I will
make sure to self-review carefully before send this time.

>   	if (!td->files_index) {
>   		add_file(td, td->o.filename ?: "net", 0, 0);
>   		td->o.nr_files = td->o.nr_files ?: 1;
> @@ -1370,9 +1374,6 @@ static int fio_netio_setup(struct thread_data *td)
>   	}
>   
>   	if (!td->io_ops_data) {
> -		nd = malloc(sizeof(*nd));
> -
> -		memset(nd, 0, sizeof(*nd));
>   		nd->listenfd = -1;
>   		nd->pipes[0] = nd->pipes[1] = -1;
>   		td->io_ops_data = nd;
> @@ -1391,7 +1392,8 @@ static int fio_netio_setup_splice(struct thread_data *td)
>   {
>   	struct netio_data *nd;
>   
> -	fio_netio_setup(td);
> +	if (fio_netio_setup(td))
> +		return 1;
>   
>   	nd = td->io_ops_data;
>   	if (nd) {


-- 
Ammar Faizi
