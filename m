Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E65C433EF
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 15:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC5D360EFE
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 15:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhJKPRt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhJKPRt (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 11:17:49 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F5DC061570
        for <fio@vger.kernel.org>; Mon, 11 Oct 2021 08:15:49 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n7so11346881iod.0
        for <fio@vger.kernel.org>; Mon, 11 Oct 2021 08:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cNJtJ08m6c26Rmp/5rq7B+67fO0EgaXp+AyCySxh+pA=;
        b=zoUEsnbi1bk3Y4YeMS1mKf7IrlW3iizTyaSInlksCICx+ykbwWDTdzqFZQPotFyPTV
         Oe/7jaQ467tn3n2ESqSTFmi+qnCQpSHlj7srRlCqtkdzA1WaHLTqPdcOYshHKtk2EKFS
         6MC5eQYqkhWel9htxB5EPUyOivCKckUCBzvM2CBa+A6xV0M2jrNA4ieFIzMAzL/fYPf/
         eW44BS4dXJtCmUaDtJdVpNRhnE1Tt72mioa5o5Ly3wB6WZvxbQV818pHNHtv4hZ3wz8P
         7iRMCBd0Ggw1RG/tWikpQ8a9eyJq+fRrzwdByWV+PG8OGKiIgdJW6EF5v4TU7G6FwOj3
         7dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cNJtJ08m6c26Rmp/5rq7B+67fO0EgaXp+AyCySxh+pA=;
        b=Q4eTyE2QdnHFmnAFdD/9zLp4MIGFKJfMUnqXisuLqNdU7sb6Nq6pznfsPiZtVcIfHK
         xdy57mYSHzyt/8hruDaoO22+ttl53AOWv1GSvHuzw2w3UrBc9GIDxqJAVG4G8vid/gUc
         nRyK6JjHccHrj19JKtahvl/n/+Mn6doSxDRZbaUnGTQ+upz5we8MDeCc063KUbmh5gxW
         2X1o62WF+VnUYSojfvaWY14liX6r3yKCG5JfTypGvc7QG1rFTQ0+sh9nOCZl80jF//R+
         pWa/SeZ5Vo79KK44XlKkts6rOxHsAwRT+kGOPkLjn6OFqP36B2LWMkLIQUwyeGptVpuB
         0yEg==
X-Gm-Message-State: AOAM530WxnXuixmcrOg9El/pEifMq5jaAbnCW8XYapgUkoa1daUmOemf
        hyfYzAR3GmvPItJfKsDZGvggzfqmxZH7Uw==
X-Google-Smtp-Source: ABdhPJw8azZKjqSFA4FVisVPEoIsUxaZIYpT+dOZTB55uyiuShCMtFznn4kY6h5zQMnLLhFvfys2pQ==
X-Received: by 2002:a6b:c38d:: with SMTP id t135mr20011558iof.99.1633965348265;
        Mon, 11 Oct 2021 08:15:48 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q11sm4311815ilg.85.2021.10.11.08.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 08:15:47 -0700 (PDT)
Subject: Re: [PATCH] fio: make sure io_u->file isn't NULL before using it
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     fio@vger.kernel.org
References: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <20211011102739.10429-1-lhenriques@suse.de>
 <42aee776-323c-634f-d950-9792de7724d2@kernel.dk> <YWQ/s44zyPC/ULBi@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e5cc8d8e-e1ba-a97f-b761-c697bdf136b4@kernel.dk>
Date:   Mon, 11 Oct 2021 09:15:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YWQ/s44zyPC/ULBi@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/11/21 7:44 AM, Luís Henriques wrote:
> On Mon, Oct 11, 2021 at 06:58:52AM -0600, Jens Axboe wrote:
>> On 10/11/21 4:27 AM, Luís Henriques wrote:
>>> While running fstests generic/095 against ext4 on a zram device I started
>>> seeing fio crashing.  Fix it by making sure io_u->file isn't NULL before
>>> accessing it.
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>  io_u.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_u.c b/io_u.c
>>> index 5289b5d1d9c6..b8e715d4118c 100644
>>> --- a/io_u.c
>>> +++ b/io_u.c
>>> @@ -2009,7 +2009,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
>>>  			io_u->xfer_buf += bytes;
>>>  			io_u->offset += bytes;
>>>  			td->ts.short_io_u[io_u->ddir]++;
>>> -			if (io_u->offset < io_u->file->real_file_size) {
>>> +			if (io_u->file &&
>>> +			    (io_u->offset < io_u->file->real_file_size)) {
>>>  				requeue_io_u(td, io_u_ptr);
>>>  				return;
>>>  			}
>>
>> This will prevent the crash, but I'm wondering why io_u-> == NULL for this case.
>> It really should be a valid file.
>>
>> Can you let me know exactly how you're reproducing this? Then I'll give it
>> a whirl too.
> 
> Sure, here's my recipe for reproducing this bug:
> 
>  # modprobe zram num_devices=2
>  # echo 1G > /sys/block/zram0/disksize 
>  # echo 1G > /sys/block/zram1/disksize 
>  # mkfs.ext4 /dev/zram0
>  # mkfs.ext4 /dev/zram1
> 
>  # ./check generic/095

I know you fixed the issue in the test by now, but any chance you can try
this one and see if it correctly reports full residual instead of trying
to requeue and crash?


diff --git a/io_u.c b/io_u.c
index 5289b5d1d9c6..586a4befdce0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2004,7 +2004,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		 * Make sure we notice short IO from here, and requeue them
 		 * appropriately!
 		 */
-		if (io_u->resid) {
+		if (bytes && io_u->resid) {
 			io_u->xfer_buflen = io_u->resid;
 			io_u->xfer_buf += bytes;
 			io_u->offset += bytes;

-- 
Jens Axboe

